Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133Ab1LPQgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 11:36:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36132 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab1LPQge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 11:36:34 -0500
Message-ID: <1324053390.25554.50.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] module: struct module_ref should contains long fields
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Robin Holt <holt@sgi.com>
Date: Fri, 16 Dec 2011 17:36:30 +0100
In-Reply-To: <CAOS58YOJTaoB1xsJ4D56x1v+ZM5qsP3ojrJqsFAMJR2YUaHKxA@mail.gmail.com>
References: <1324012057.2562.23.camel@edumazet-laptop>
	 <20111216155408.GA31770@google.com>
	 <1324051285.25554.37.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CAOS58YOJTaoB1xsJ4D56x1v+ZM5qsP3ojrJqsFAMJR2YUaHKxA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 16 décembre 2011 à 08:05 -0800, Tejun Heo a écrit :
> Hello,
> 
> On Fri, Dec 16, 2011 at 8:01 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > Its percpu data, there is no need to waste a full cache line per cpu for
> > this.
> 
> Hmmm.... okay. I just don't like seeing arbitrary alignment there.
> Can you please add some comment explaining why the unusual alignment
> is used there?

Yep, thanks for the review !

[PATCH v2] module: struct module_ref should contains long fields

module_ref contains two "unsigned int" fields.

Thats now too small, since some machines can open more than 2^32 files.

Check commit 518de9b39e8 (fs: allow for more than 2^31 files) for
reference.

We can add an aligned(2 * sizeof(unsigned long)) attribute to force
alloc_percpu() allocating module_ref areas in single cache lines.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Tejun Heo <tj@kernel.org>
CC: Robin Holt <holt@sgi.com>
CC: David Miller <davem@davemloft.net>
---
V2: added kerneldoc to struct module_ref

 include/linux/module.h      |   21 ++++++++++++++++-----
 kernel/debug/kdb/kdb_main.c |    2 +-
 kernel/module.c             |    8 ++++----
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 3cb7839..4598bf0 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -205,6 +205,20 @@ enum module_state
 	MODULE_STATE_GOING,
 };
 
+/**
+ * struct module_ref - per cpu module reference counts
+ * @incs: number of module get on this cpu
+ * @decs: number of module put on this cpu
+ *
+ * We force an alignment on 8 or 16 bytes, so that alloc_percpu()
+ * put @incs/@decs in same cache line, with no extra memory cost,
+ * since alloc_percpu() is fine grained.
+ */
+struct module_ref {
+	unsigned long incs;
+	unsigned long decs;
+} __attribute((aligned(2 * sizeof(unsigned long))));
+
 struct module
 {
 	enum module_state state;
@@ -347,10 +361,7 @@ struct module
 	/* Destruction function. */
 	void (*exit)(void);
 
-	struct module_ref {
-		unsigned int incs;
-		unsigned int decs;
-	} __percpu *refptr;
+	struct module_ref __percpu *refptr;
 #endif
 
 #ifdef CONFIG_CONSTRUCTORS
@@ -434,7 +445,7 @@ extern void __module_put_and_exit(struct module *mod, long code)
 #define module_put_and_exit(code) __module_put_and_exit(THIS_MODULE, code);
 
 #ifdef CONFIG_MODULE_UNLOAD
-unsigned int module_refcount(struct module *mod);
+unsigned long module_refcount(struct module *mod);
 void __symbol_put(const char *symbol);
 #define symbol_put(x) __symbol_put(MODULE_SYMBOL_PREFIX #x)
 void symbol_put_addr(void *addr);
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 63786e7..e2ae734 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1982,7 +1982,7 @@ static int kdb_lsmod(int argc, const char **argv)
 		kdb_printf("%-20s%8u  0x%p ", mod->name,
 			   mod->core_size, (void *)mod);
 #ifdef CONFIG_MODULE_UNLOAD
-		kdb_printf("%4d ", module_refcount(mod));
+		kdb_printf("%4ld ", module_refcount(mod));
 #endif
 		if (mod->state == MODULE_STATE_GOING)
 			kdb_printf(" (Unloading)");
diff --git a/kernel/module.c b/kernel/module.c
index 178333c..ef05f7e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -726,9 +726,9 @@ static int try_stop_module(struct module *mod, int flags, int *forced)
 	}
 }
 
-unsigned int module_refcount(struct module *mod)
+unsigned long module_refcount(struct module *mod)
 {
-	unsigned int incs = 0, decs = 0;
+	unsigned long incs = 0, decs = 0;
 	int cpu;
 
 	for_each_possible_cpu(cpu)
@@ -854,7 +854,7 @@ static inline void print_unload_info(struct seq_file *m, struct module *mod)
 	struct module_use *use;
 	int printed_something = 0;
 
-	seq_printf(m, " %u ", module_refcount(mod));
+	seq_printf(m, " %lu ", module_refcount(mod));
 
 	/* Always include a trailing , so userspace can differentiate
            between this and the old multi-field proc format. */
@@ -904,7 +904,7 @@ EXPORT_SYMBOL_GPL(symbol_put_addr);
 static ssize_t show_refcnt(struct module_attribute *mattr,
 			   struct module_kobject *mk, char *buffer)
 {
-	return sprintf(buffer, "%u\n", module_refcount(mk->mod));
+	return sprintf(buffer, "%lu\n", module_refcount(mk->mod));
 }
 
 static struct module_attribute refcnt = {


