Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab1D3GNy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 02:13:54 -0400
Received: from ozlabs.org ([203.10.76.45]:52471 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab1D3GNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 02:13:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        castet.matthieu@free.fr, sliakh.lkml@gmail.com, jiang@cs.ncsu.edu,
        mingo@elte.hu
Subject: Re: Undoing module RONX protection fix
In-Reply-To: <20110429163500.GA5241@linux.vnet.ibm.com>
References: <20110418092348.GB7786@hal> <20110418092801.GC3837@infradead.org> <874o5v6drb.fsf@rustcorp.com.au> <20110421141949.GA10675@hal> <87ipu0l1kt.fsf@rustcorp.com.au> <1303985300.3495.93.camel@localhost.localdomain> <87tyditxo8.fsf@rustcorp.com.au> <20110428134321.GA10759@hal> <87hb9hd5zn.fsf@rustcorp.com.au> <20110429163500.GA5241@linux.vnet.ibm.com>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Sat, 30 Apr 2011 15:43:27 +0930
Message-ID: <87liyse06w.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011 18:35:00 +0200, Jan Glauber <jang@linux.vnet.ibm.com> wrote:
> Rusty, I'm not sure if I should resend a merged patch or not, going for the
> later so you can apply on top of what you might have. If you would appreciate a
> merged patch more please let me know...

Yeah, it was a bit messy.  I applied the third chunk of this, shuffled
it to the top, threw away the initial fix and fixed up the successors (I
use patch queues, so editing the diffs for this stuff makes it pretty
easy).

I've appended all three patches that resulted below (there's nothing
new, just so you can see the final presentation).

Thanks!
Rusty.
PS.  Don't let that stop you from doing more cleanups as discussed
though :)

From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: module: zero mod->init_ro_size after init is freed.

Reset mod->init_ro_size to zero after the init part of a module is unloaded. 
Otherwise we need to check if module->init is NULL in the unprotect functions
in the next patch.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2941,6 +2937,7 @@ SYSCALL_DEFINE3(init_module, void __user
 	module_free(mod, mod->module_init);
 	mod->module_init = NULL;
 	mod->init_size = 0;
+	mod->init_ro_size = 0;
 	mod->init_text_size = 0;
 	mutex_unlock(&module_mutex);
 
Subject: module: undo module RONX protection correctly.
From: Jan Glauber <jang@linux.vnet.ibm.com>

While debugging I stumbled over two problems in the code that protects module
pages.

First issue is that disabling the protection before freeing init or unload of
a module is not symmetric with the enablement. For instance, if pages are set
to RO the page range from module_core to module_core + core_ro_size is
protected. If a module is unloaded the page range from module_core to
module_core + core_size is set back to RW.
So pages that were not set to RO are also changed to RW.
This is not critical but IMHO it should be symmetric.

Second issue is that while set_memory_rw & set_memory_ro are used for
RO/RW changes only set_memory_nx is involved for NX/X. One would await that
the inverse function is called when the NX protection should be removed,
which is not the case here, unless I'm missing something.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/s390/include/asm/cacheflush.h |    1 +
 arch/s390/mm/pageattr.c            |    5 +++++
 kernel/module.c                    |   25 +++++++++++++------------
 3 files changed, 19 insertions(+), 12 deletions(-)

--- a/arch/s390/include/asm/cacheflush.h
+++ b/arch/s390/include/asm/cacheflush.h
@@ -11,5 +11,6 @@ void kernel_map_pages(struct page *page,
 int set_memory_ro(unsigned long addr, int numpages);
 int set_memory_rw(unsigned long addr, int numpages);
 int set_memory_nx(unsigned long addr, int numpages);
+int set_memory_x(unsigned long addr, int numpages);
 
 #endif /* _S390_CACHEFLUSH_H */
--- a/arch/s390/mm/pageattr.c
+++ b/arch/s390/mm/pageattr.c
@@ -54,3 +54,8 @@ int set_memory_nx(unsigned long addr, in
 	return 0;
 }
 EXPORT_SYMBOL_GPL(set_memory_nx);
+
+int set_memory_x(unsigned long addr, int numpages)
+{
+	return 0;
+}
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1607,22 +1607,23 @@ static void set_section_ro_nx(void *base
 	}
 }
 
-/* Setting memory back to RW+NX before releasing it */
+/* Setting memory back to W+X before releasing it */
 void unset_section_ro_nx(struct module *mod, void *module_region)
 {
-	unsigned long total_pages;
-
 	if (mod->module_core == module_region) {
-		/* Set core as NX+RW */
-		total_pages = MOD_NUMBER_OF_PAGES(mod->module_core, mod->core_size);
-		set_memory_nx((unsigned long)mod->module_core, total_pages);
-		set_memory_rw((unsigned long)mod->module_core, total_pages);
-
+		set_page_attributes(mod->module_core + mod->core_text_size,
+			mod->module_core + mod->core_size,
+			set_memory_x);
+		set_page_attributes(mod->module_core,
+			mod->module_core + mod->core_ro_size,
+			set_memory_rw);
 	} else if (mod->module_init == module_region) {
-		/* Set init as NX+RW */
-		total_pages = MOD_NUMBER_OF_PAGES(mod->module_init, mod->init_size);
-		set_memory_nx((unsigned long)mod->module_init, total_pages);
-		set_memory_rw((unsigned long)mod->module_init, total_pages);
+		set_page_attributes(mod->module_init + mod->init_text_size,
+			mod->module_init + mod->init_size,
+			set_memory_x);
+		set_page_attributes(mod->module_init,
+			mod->module_init + mod->init_ro_size,
+			set_memory_rw);
 	}
 }
 

Subject: module: split unset_section_ro_nx function.
From: Jan Glauber <jang@linux.vnet.ibm.com>

Split the unprotect function into a function per section to make
the code more readable and add the missing static declaration.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c |   43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1607,24 +1607,24 @@ static void set_section_ro_nx(void *base
 	}
 }
 
-/* Setting memory back to W+X before releasing it */
-void unset_section_ro_nx(struct module *mod, void *module_region)
+static void unset_module_core_ro_nx(struct module *mod)
 {
-	if (mod->module_core == module_region) {
-		set_page_attributes(mod->module_core + mod->core_text_size,
-			mod->module_core + mod->core_size,
-			set_memory_x);
-		set_page_attributes(mod->module_core,
-			mod->module_core + mod->core_ro_size,
-			set_memory_rw);
-	} else if (mod->module_init == module_region) {
-		set_page_attributes(mod->module_init + mod->init_text_size,
-			mod->module_init + mod->init_size,
-			set_memory_x);
-		set_page_attributes(mod->module_init,
-			mod->module_init + mod->init_ro_size,
-			set_memory_rw);
-	}
+	set_page_attributes(mod->module_core + mod->core_text_size,
+		mod->module_core + mod->core_size,
+		set_memory_x);
+	set_page_attributes(mod->module_core,
+		mod->module_core + mod->core_ro_size,
+		set_memory_rw);
+}
+
+static void unset_module_init_ro_nx(struct module *mod)
+{
+	set_page_attributes(mod->module_init + mod->init_text_size,
+		mod->module_init + mod->init_size,
+		set_memory_x);
+	set_page_attributes(mod->module_init,
+		mod->module_init + mod->init_ro_size,
+		set_memory_rw);
 }
 
 /* Iterate through all modules and set each module's text as RW */
@@ -1670,7 +1670,8 @@ void set_all_modules_text_ro(void)
 }
 #else
 static inline void set_section_ro_nx(void *base, unsigned long text_size, unsigned long ro_size, unsigned long total_size) { }
-static inline void unset_section_ro_nx(struct module *mod, void *module_region) { }
+static void unset_module_core_ro_nx(struct module *mod) { }
+static void unset_module_init_ro_nx(struct module *mod) { }
 #endif
 
 /* Free a module, remove from lists, etc. */
@@ -1697,7 +1698,7 @@ static void free_module(struct module *m
 	destroy_params(mod->kp, mod->num_kp);
 
 	/* This may be NULL, but that's OK */
-	unset_section_ro_nx(mod, mod->module_init);
+	unset_module_init_ro_nx(mod);
 	module_free(mod, mod->module_init);
 	kfree(mod->args);
 	percpu_modfree(mod);
@@ -1706,7 +1707,7 @@ static void free_module(struct module *m
 	lockdep_free_key_range(mod->module_core, mod->core_size);
 
 	/* Finally, free the core (containing the module structure) */
-	unset_section_ro_nx(mod, mod->module_core);
+	unset_module_core_ro_nx(mod);
 	module_free(mod, mod->module_core);
 
 #ifdef CONFIG_MPU
@@ -2932,7 +2933,7 @@ SYSCALL_DEFINE3(init_module, void __user
 	mod->symtab = mod->core_symtab;
 	mod->strtab = mod->core_strtab;
 #endif
-	unset_section_ro_nx(mod, mod->module_init);
+	unset_module_init_ro_nx(mod);
 	module_free(mod, mod->module_init);
 	mod->module_init = NULL;
 	mod->init_size = 0;
