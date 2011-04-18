Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab1DRJYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 05:24:13 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:44278 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab1DRJYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 05:24:04 -0400
Date: Mon, 18 Apr 2011 11:23:48 +0200
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: castet.matthieu@free.fr, sliakh.lkml@gmail.com, jiang@cs.ncsu.edu,
        rusty@rustcorp.com.au, mingo@elte.hu
Subject: Undoing module RONX protection
Message-ID: <20110418092348.GB7786@hal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

The following patch addresses both issues. Works on s390. Boot tested on x86.

Please comment,
Jan

---------

Use the proper function to reset the NX page protection and only reset pages
that were previously protected during module load. Export the missing
set_memory_x for s390.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 arch/s390/include/asm/cacheflush.h |    1 +
 arch/s390/mm/pageattr.c            |    6 ++++++
 kernel/module.c                    |   25 +++++++++++++------------
 3 files changed, 20 insertions(+), 12 deletions(-)

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
@@ -54,3 +54,9 @@ int set_memory_nx(unsigned long addr, in
 	return 0;
 }
 EXPORT_SYMBOL_GPL(set_memory_nx);
+
+int set_memory_x(unsigned long addr, int numpages)
+{
+	return 0;
+}
+EXPORT_SYMBOL_GPL(set_memory_x);
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
 
