Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab0EaMCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 08:02:32 -0400
Received: from ozlabs.org ([203.10.76.45]:41246 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880Ab0EaMCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 08:02:31 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Brandon Philips <brandon@ifup.org>
Subject: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module libcrc32c"
Date: Mon, 31 May 2010 21:32:27 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
References: <201005252300.07739.rjw@sisk.pl> <201005312130.17038.rusty@rustcorp.com.au> <201005312131.43238.rusty@rustcorp.com.au>
In-Reply-To: <201005312131.43238.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005312132.28631.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem: it's hard to avoid an init routine stumbling over a
request_module these days.  And it's not clear it's always a bad idea:
for example, a module like kvm with dynamic dependencies on kvm-intel
or kvm-amd would be neater if it could simply request_module the right
one.

In this particular case, it's libcrc32c:

	libcrc32c_mod_init
	 crypto_alloc_shash
	  crypto_alloc_tfm
	   crypto_find_alg
	    crypto_alg_mod_lookup
	     crypto_larval_lookup
	      request_module

If another module is waiting for libcrc32c to finish initializing
(ie. bne2 depends on libcrc32c) then it does so holding the module
lock, and our request_module() can't make progress until that is
released.

Waiting without the lock isn't all that hard: we just need to pass the
-EBUSY up the call chain so we can sleep where we don't hold the lock.
Error reporting is a bit trickier: we need to copy the name of the
unfinished module before releasing the lock.

Other notes:
1) This also fixes a theoretical issue where a weak dependency would allow
   symbol version mismatches to be ignored.
2) We rename use_module to ref_module to make life easier for the only
   external user (the out-of-tree ksplice patches).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Brandon Philips <brandon@ifup.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tim Abbot <tabbott@ksplice.com>
---
 kernel/module.c |   91 ++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 59 insertions(+), 32 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -559,40 +559,33 @@ static int already_uses(struct module *a
 }
 
 /* Module a uses b: caller needs module_mutex() */
-int use_module(struct module *a, struct module *b)
+int ref_module(struct module *a, struct module *b)
 {
 	struct module_use *use;
 	int no_warn, err;
 
-	if (b == NULL || already_uses(a, b)) return 1;
+	if (b == NULL || already_uses(a, b))
+		return 0;
 
 	/* If we're interrupted or time out, we fail. */
-	if (wait_event_interruptible_timeout(
-		    module_wq, (err = strong_try_module_get(b)) != -EBUSY,
-		    30 * HZ) <= 0) {
-		printk("%s: gave up waiting for init of module %s.\n",
-		       a->name, b->name);
-		return 0;
-	}
-
-	/* If strong_try_module_get() returned a different error, we fail. */
+	err = strong_try_module_get(b);
 	if (err)
-		return 0;
+		return err;
 
 	DEBUGP("Allocating new usage for %s.\n", a->name);
 	use = kmalloc(sizeof(*use), GFP_ATOMIC);
 	if (!use) {
 		printk("%s: out of memory loading\n", a->name);
 		module_put(b);
-		return 0;
+		return -ENOMEM;
 	}
 
 	use->module_which_uses = a;
 	list_add(&use->list, &b->modules_which_use_me);
 	no_warn = sysfs_create_link(b->holders_dir, &a->mkobj.kobj, a->name);
-	return 1;
+	return 0;
 }
-EXPORT_SYMBOL_GPL(use_module);
+EXPORT_SYMBOL_GPL(ref_module);
 
 /* Clear the unload stuff of the module. */
 static void module_unload_free(struct module *mod)
@@ -888,11 +881,11 @@ static inline void module_unload_free(st
 {
 }
 
-int use_module(struct module *a, struct module *b)
+int ref_module(struct module *a, struct module *b)
 {
-	return strong_try_module_get(b) == 0;
+	return strong_try_module_get(b);
 }
-EXPORT_SYMBOL_GPL(use_module);
+EXPORT_SYMBOL_GPL(ref_module);
 
 static inline void module_unload_init(struct module *mod)
 {
@@ -1057,26 +1050,58 @@ static inline int same_magic(const char 
 static const struct kernel_symbol *resolve_symbol(Elf_Shdr *sechdrs,
 						  unsigned int versindex,
 						  const char *name,
-						  struct module *mod)
+						  struct module *mod,
+						  char ownername[])
 {
 	struct module *owner;
 	const struct kernel_symbol *sym;
 	const unsigned long *crc;
+	int err;
 
 	mutex_lock(&module_mutex);
 	sym = find_symbol(name, &owner, &crc,
 			  !(mod->taints & (1 << TAINT_PROPRIETARY_MODULE)), true);
-	/* use_module can fail due to OOM,
-	   or module initialization or unloading */
-	if (sym) {
-		if (!check_version(sechdrs, versindex, name, mod, crc, owner)
-		    || !use_module(mod, owner))
-			sym = NULL;
+	if (!sym)
+		goto unlock;
+
+	if (!check_version(sechdrs, versindex, name, mod, crc, owner)) {
+		sym = ERR_PTR(-EINVAL);
+		goto getname;
 	}
+
+	err = ref_module(mod, owner);
+	if (err) {
+		sym = ERR_PTR(err);
+		goto getname;
+	}
+
+getname:
+	/* We must make copy under the lock if we failed to get ref. */
+	strncpy(ownername, module_name(owner), MODULE_NAME_LEN);
+unlock:
 	mutex_unlock(&module_mutex);
 	return sym;
 }
 
+static const struct kernel_symbol *resolve_symbol_wait(Elf_Shdr *sechdrs,
+						       unsigned int versindex,
+						       const char *name,
+						       struct module *mod)
+{
+	const struct kernel_symbol *ksym;
+	char ownername[MODULE_NAME_LEN];
+
+	if (wait_event_interruptible_timeout(module_wq,
+			IS_ERR(ksym = resolve_symbol(sechdrs, versindex, name,
+						     mod, ownername)) &&
+			PTR_ERR(ksym) == -EBUSY,
+					     30 * HZ) <= 0) {
+		printk(KERN_WARNING "%s: gave up waiting for init of module %s.\n",
+		       mod->name, ownername);
+	}
+	return ksym;
+}
+
 /*
  * /sys/module/foo/sections stuff
  * J. Corbet <corbet@lwn.net>
@@ -1578,21 +1603,23 @@ static int simplify_symbols(Elf_Shdr *se
 			break;
 
 		case SHN_UNDEF:
-			ksym = resolve_symbol(sechdrs, versindex,
-					      strtab + sym[i].st_name, mod);
+			ksym = resolve_symbol_wait(sechdrs, versindex,
+						   strtab + sym[i].st_name,
+						   mod);
 			/* Ok if resolved.  */
-			if (ksym) {
+			if (ksym && !IS_ERR(ksym)) {
 				sym[i].st_value = ksym->value;
 				break;
 			}
 
 			/* Ok if weak.  */
-			if (ELF_ST_BIND(sym[i].st_info) == STB_WEAK)
+			if (!ksym && ELF_ST_BIND(sym[i].st_info) == STB_WEAK)
 				break;
 
-			printk(KERN_WARNING "%s: Unknown symbol %s\n",
-			       mod->name, strtab + sym[i].st_name);
-			ret = -ENOENT;
+			printk(KERN_WARNING "%s: Unknown symbol %s (err %li)\n",
+			       mod->name, strtab + sym[i].st_name,
+			       PTR_ERR(ksym));
+			ret = PTR_ERR(ksym) ?: -ENOENT;
 			break;
 
 		default:
