Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab3AJClZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 21:41:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230Ab3AJClY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 21:41:24 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Mike Galbraith <efault@gmx.de>
Subject: [PATCH] module, fix percpu reserved memory exhaustion
Date: Wed,  9 Jan 2013 21:41:08 -0500
Message-Id: <1357785669-31848-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty,

There is likely some subtlety of moving the module mutex that I'm unaware of.
What I can say is that this patch seems to resolve the problem for me, or at
least through 100+ reboots I have not seen the problem (I'm still testing
as I write this).

I'm more than willing to hear an alternative approach, or test an alternative
patch.

Thanks,

P.

----8<----

In recent Fedora releases (F17 & F18) some users have reported seeing
messages similar to

[   15.478121] Pid: 727, comm: systemd-udevd Tainted: GF 3.8.0-rc2+ #1
[   15.478121] Call Trace:
[   15.478131]  [<ffffffff81153001>] pcpu_alloc+0xa01/0xa60
[   15.478137]  [<ffffffff8163d8b0>] ? printk+0x61/0x63
[   15.478140]  [<ffffffff811532f3>] __alloc_reserved_percpu+0x13/0x20
[   15.478145]  [<ffffffff810c42e2>] load_module+0x1dc2/0x20b0
[   15.478150]  [<ffffffff8164b21e>] ? do_page_fault+0xe/0x10
[   15.478152]  [<ffffffff81647858>] ? page_fault+0x28/0x30
[   15.478155]  [<ffffffff810c46a7>] sys_init_module+0xd7/0x120
[   15.478159]  [<ffffffff8164f859>] system_call_fastpath+0x16/0x1b
[   15.478160] kvm: Could not allocate 304 bytes percpu data
[   15.478174] PERCPU: allocation failed, size=304 align=32, alloc from reserved chunk failed

during system boot.  In some cases, users have also reported seeing this
message along with a failed load of other modules.

As the message indicates, the reserved chunk of percpu memory (where
modules allocate their memory) is exhausted.  A debug printk inserted in
the code shows

[   15.478533] PRARIT size = 304 > chunk->contig_hint = 208

ie) the reserved chunk of percpu has only 208 bytes of available space.

What is happening is systemd is loading an instance of the kvm module for
each cpu found (see commit e9bda3b).  When the module load occurs the kernel
currently allocates the modules percpu data area prior to checking to see
if the module is already loaded or is in the process of being loaded.  If
the module is already loaded, or finishes load, the module loading code
releases the current instance's module's percpu data.

The problem is that these module loads race and it is possible that all of
the percpu reserved area is consumed by repeated loads of the same module
which results in the failure of other drivers to load.

This patch moves the module percpu allocation after the check for an
existing instance of the module.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Galbraith <efault@gmx.de>
---
 kernel/module.c |  124 ++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 85 insertions(+), 39 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 250092c..e7e9b57 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1929,6 +1929,27 @@ static int verify_export_symbols(struct module *mod)
 	return 0;
 }
 
+static void simplify_percpu_symbols(struct module *mod,
+				    const struct load_info *info)
+{
+	Elf_Shdr *symsec = &info->sechdrs[info->index.sym];
+	Elf_Sym *sym = (void *)symsec->sh_addr;
+	unsigned long secbase;
+	unsigned int i;
+
+	/*
+	 * No need for error checking in this function because
+	 * simplify_symbols has already been called.
+	 */
+	for (i = 1; i < symsec->sh_size / sizeof(Elf_Sym); i++) {
+		/* Divert to percpu allocation if a percpu var. */
+		if (sym[i].st_shndx == info->index.pcpu) {
+			secbase = (unsigned long)mod_percpu(mod);
+			sym[i].st_value += secbase;
+		}
+	}
+}
+
 /* Change all symbols so that st_value encodes the pointer directly. */
 static int simplify_symbols(struct module *mod, const struct load_info *info)
 {
@@ -1976,12 +1997,11 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 			break;
 
 		default:
-			/* Divert to percpu allocation if a percpu var. */
-			if (sym[i].st_shndx == info->index.pcpu)
-				secbase = (unsigned long)mod_percpu(mod);
-			else
+			/* percpu diverts handled in simplify_percpu_symbols */
+			if (sym[i].st_shndx != info->index.pcpu) {
 				secbase = info->sechdrs[sym[i].st_shndx].sh_addr;
-			sym[i].st_value += secbase;
+				sym[i].st_value += secbase;
+			}
 			break;
 		}
 	}
@@ -2899,11 +2919,29 @@ int __weak module_frob_arch_sections(Elf_Ehdr *hdr,
 	return 0;
 }
 
+static int allocate_percpu(struct module *mod, struct load_info *info)
+{
+	Elf_Shdr *pcpusec;
+	int err;
+
+	pcpusec = &info->sechdrs[info->index.pcpu];
+	if (pcpusec->sh_size) {
+		/* We have a special allocation for this section. */
+		pr_debug("module %s attempting to percpu with size %d\n",
+			 mod->name, pcpusec->sh_size);
+		err = percpu_modalloc(mod,
+				      pcpusec->sh_size, pcpusec->sh_addralign);
+		if (err)
+			return -ENOMEM;
+		pcpusec->sh_flags &= ~(unsigned long)SHF_ALLOC;
+	}
+	return 0;
+}
+
 static struct module *layout_and_allocate(struct load_info *info, int flags)
 {
 	/* Module within temporary copy. */
 	struct module *mod;
-	Elf_Shdr *pcpusec;
 	int err;
 
 	mod = setup_load_info(info, flags);
@@ -2920,16 +2958,6 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
 	if (err < 0)
 		goto out;
 
-	pcpusec = &info->sechdrs[info->index.pcpu];
-	if (pcpusec->sh_size) {
-		/* We have a special allocation for this section. */
-		err = percpu_modalloc(mod,
-				      pcpusec->sh_size, pcpusec->sh_addralign);
-		if (err)
-			goto out;
-		pcpusec->sh_flags &= ~(unsigned long)SHF_ALLOC;
-	}
-
 	/* Determine total sizes, and put offsets in sh_entsize.  For now
 	   this is done generically; there doesn't appear to be any
 	   special cases for the architectures. */
@@ -2955,7 +2983,6 @@ out:
 /* mod is no longer valid after this! */
 static void module_deallocate(struct module *mod, struct load_info *info)
 {
-	percpu_modfree(mod);
 	module_free(mod, mod->module_init);
 	module_free(mod, mod->module_core);
 }
@@ -3135,18 +3162,54 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	/* Set up MODINFO_ATTR fields */
 	setup_modinfo(mod, info);
 
-	/* Fix up syms, so that st_value is a pointer to location. */
+	/* Fix up non-percpu syms, so that st_value is a pointer to location. */
 	err = simplify_symbols(mod, info);
 	if (err < 0)
 		goto free_modinfo;
 
+	/*
+	 * This mutex protects against concurrent writers of the module
+	 * RCU list.  The code takes it pretty early because there are
+	 * several things that must be completed after checking for an
+	 * existing module, and before adding it to the RCU list.
+	 */
+	mutex_lock(&module_mutex);
+
+	/* Mark state as coming so strong_try_module_get() ignores us. */
+	mod->state = MODULE_STATE_COMING;
+
+	/* is another instance of this module already loading or loaded? */
+again:
+	if ((old = find_module(mod->name)) != NULL) {
+		if (old->state == MODULE_STATE_COMING) {
+			/* Wait in case it fails to load. */
+			mutex_unlock(&module_mutex);
+			err = wait_event_interruptible(module_wq,
+					       finished_loading(mod->name));
+			if (err)
+				goto free_modinfo;
+			mutex_lock(&module_mutex);
+			goto again;
+		}
+		err = -EEXIST;
+		goto unlock;
+	}
+
+	/* allocate this modules percpu reserved area */
+	err = allocate_percpu(mod, info);
+	if (err)
+		goto free_modinfo;
+
+	/* Fix up percpu syms, so that st_value is a pointer to location. */
+	simplify_percpu_symbols(mod, info);
+
 	err = apply_relocations(mod, info);
 	if (err < 0)
-		goto free_modinfo;
+		goto free_percpu;
 
 	err = post_relocation(mod, info);
 	if (err < 0)
-		goto free_modinfo;
+		goto free_percpu;
 
 	flush_module_icache(mod);
 
@@ -3157,31 +3220,12 @@ static int load_module(struct load_info *info, const char __user *uargs,
 		goto free_arch_cleanup;
 	}
 
-	/* Mark state as coming so strong_try_module_get() ignores us. */
-	mod->state = MODULE_STATE_COMING;
-
 	/* Now sew it into the lists so we can get lockdep and oops
 	 * info during argument parsing.  No one should access us, since
 	 * strong_try_module_get() will fail.
 	 * lockdep/oops can run asynchronous, so use the RCU list insertion
 	 * function to insert in a way safe to concurrent readers.
-	 * The mutex protects against concurrent writers.
 	 */
-again:
-	mutex_lock(&module_mutex);
-	if ((old = find_module(mod->name)) != NULL) {
-		if (old->state == MODULE_STATE_COMING) {
-			/* Wait in case it fails to load. */
-			mutex_unlock(&module_mutex);
-			err = wait_event_interruptible(module_wq,
-					       finished_loading(mod->name));
-			if (err)
-				goto free_arch_cleanup;
-			goto again;
-		}
-		err = -EEXIST;
-		goto unlock;
-	}
 
 	/* This has to be done once we're sure module name is unique. */
 	dynamic_debug_setup(info->debug, info->num_debug);
@@ -3228,6 +3272,8 @@ again:
 	kfree(mod->args);
  free_arch_cleanup:
 	module_arch_cleanup(mod);
+ free_percpu:
+	percpu_modfree(mod);
  free_modinfo:
 	free_modinfo(mod);
  free_unload:
-- 
1.7.9.3

