Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab1D1KIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 06:08:24 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:35795 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab1D1KIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 06:08:23 -0400
Subject: Re: Undoing module RONX protection fix
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        castet.matthieu@free.fr, sliakh.lkml@gmail.com, jiang@cs.ncsu.edu,
        mingo@elte.hu
In-Reply-To: <87ipu0l1kt.fsf@rustcorp.com.au>
References: <20110418092348.GB7786@hal>
	 <20110418092801.GC3837@infradead.org> <874o5v6drb.fsf@rustcorp.com.au>
	 <20110421141949.GA10675@hal>  <87ipu0l1kt.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 12:08:20 +0200
Message-ID: <1303985300.3495.93.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 14:42 +0930, Rusty Russell wrote:
> On Thu, 21 Apr 2011 16:19:49 +0200, Jan Glauber <jang@linux.vnet.ibm.com> wrote:
> > On Mon, Apr 18, 2011 at 08:13:36PM +0930, Rusty Russell wrote:
> > > On Mon, 18 Apr 2011 11:23:48 +0200, Jan Glauber <jang@linux.vnet.ibm.com> wrote:
> > > > While debugging I stumbled over two problems in the code that protects module
> > > > pages.
> > > > 
> > > > First issue is that disabling the protection before freeing init or unload of
> > > > a module is not symmetric with the enablement. For instance, if pages are set
> > > > to RO the page range from module_core to module_core + core_ro_size is
> > > > protected. If a module is unloaded the page range from module_core to
> > > > module_core + core_size is set back to RW.
> > > > So pages that were not set to RO are also changed to RW.
> > > > This is not critical but IMHO it should be symmetric.
> > > > 
> > > > Second issue is that while set_memory_rw & set_memory_ro are used for
> > > > RO/RW changes only set_memory_nx is involved for NX/X. One would await that
> > > > the inverse function is called when the NX protection should be removed,
> > > > which is not the case here, unless I'm missing something.
> > > > 
> > > > The following patch addresses both issues. Works on s390. Boot tested on x86.
> > > > 
> > > > Please comment,
> > > 
> > > Applied, minus the S/390 EXPORT_SYMBOL which Christoph pointed out.  I
> > > turned your mail into the commit message, since it was clearer and more
> > > verbose.  I don't see why they would be different.
> > 
> > There's a bug in my patch which just killed one of my s390 machines.
> > Can you merge this with the previuos patch?
> 
> Hmm...
> 
> Applied, but that function is really kind of silly.  We should probably
> just split into unset_section_ro_nx() into unset_module_init_ro_nx() and
> unset_module_core_ro_nx().
> 
> (And why isn't that function static anyway?)
> 
> Patch appreciated :)
> Rusty.

How about this?

To be honest I don't like the inverse naming like in unset no-execute
too much, it makes me feel dizzy. But I wanted to keep the changes minimal.

Jan
------

Split the unprotect function into a function per section to make
the code more readable and add the missing static declaration.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 kernel/module.c |   47 ++++++++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1607,24 +1607,28 @@ static void set_section_ro_nx(void *base
 	}
 }
 
-/* Setting memory back to W+X before releasing it */
-void unset_section_ro_nx(struct module *mod, void *module_region)
+static void unset_module_core_ro_nx(struct module *mod)
 {
-	if (mod->module_core && mod->module_core == module_region) {
-		set_page_attributes(mod->module_core + mod->core_text_size,
-			mod->module_core + mod->core_size,
-			set_memory_x);
-		set_page_attributes(mod->module_core,
-			mod->module_core + mod->core_ro_size,
-			set_memory_rw);
-	} else if (mod->module_init && mod->module_init == module_region) {
-		set_page_attributes(mod->module_init + mod->init_text_size,
-			mod->module_init + mod->init_size,
-			set_memory_x);
-		set_page_attributes(mod->module_init,
-			mod->module_init + mod->init_ro_size,
-			set_memory_rw);
-	}
+	if (mod->module_core == NULL)
+		return;
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
+	if (mod->module_init == NULL)
+		return;
+	set_page_attributes(mod->module_init + mod->init_text_size,
+		mod->module_init + mod->init_size,
+		set_memory_x);
+	set_page_attributes(mod->module_init,
+		mod->module_init + mod->init_ro_size,
+		set_memory_rw);
 }
 
 /* Iterate through all modules and set each module's text as RW */
@@ -1670,7 +1674,8 @@ void set_all_modules_text_ro()
 }
 #else
 static inline void set_section_ro_nx(void *base, unsigned long text_size, unsigned long ro_size, unsigned long total_size) { }
-static inline void unset_section_ro_nx(struct module *mod, void *module_region) { }
+static void unset_module_core_ro_nx(struct module *mod) { }
+static void unset_module_init_ro_nx(struct module *mod) { }
 #endif
 
 /* Free a module, remove from lists, etc. */
@@ -1697,7 +1702,7 @@ static void free_module(struct module *m
 	destroy_params(mod->kp, mod->num_kp);
 
 	/* This may be NULL, but that's OK */
-	unset_section_ro_nx(mod, mod->module_init);
+	unset_module_init_ro_nx(mod);
 	module_free(mod, mod->module_init);
 	kfree(mod->args);
 	percpu_modfree(mod);
@@ -1706,7 +1711,7 @@ static void free_module(struct module *m
 	lockdep_free_key_range(mod->module_core, mod->core_size);
 
 	/* Finally, free the core (containing the module structure) */
-	unset_section_ro_nx(mod, mod->module_core);
+	unset_module_core_ro_nx(mod);
 	module_free(mod, mod->module_core);
 
 #ifdef CONFIG_MPU
@@ -2932,7 +2937,7 @@ SYSCALL_DEFINE3(init_module, void __user
 	mod->symtab = mod->core_symtab;
 	mod->strtab = mod->core_strtab;
 #endif
-	unset_section_ro_nx(mod, mod->module_init);
+	unset_module_init_ro_nx(mod);
 	module_free(mod, mod->module_init);
 	mod->module_init = NULL;
 	mod->init_size = 0;


