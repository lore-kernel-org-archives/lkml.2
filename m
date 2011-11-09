Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab1KIQvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:51:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab1KIQvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:51:19 -0500
Date: Wed, 9 Nov 2011 17:51:59 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
Cc: linux-kernel@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: iwlagn: memory corruption with WPA enterprise
Message-ID: <20111109165158.GA2254@redhat.com>
References: <20111029171554.GA16596@nomi.cz>
 <20111031160342.GB2225@redhat.com>
 <20111109155411.GA1669@nomi.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111109155411.GA1669@nomi.cz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi

On Wed, Nov 09, 2011 at 04:54:11PM +0100, Tomáš Janoušek wrote:
> On Mon, Oct 31, 2011 at 05:03:43PM +0100, Stanislaw Gruszka wrote:
> > You may try debugging patches I posted a while ago:
> > http://marc.info/?l=linux-mm&m=131914560820378&w=2
> > http://marc.info/?l=linux-mm&m=131914560820293&w=2
> > http://marc.info/?l=linux-mm&m=131914560820317&w=2
> > 
> > With a bit of luck, kernel should panic and dump call-trace when
> > bad code start to write at memory addresses where is not suppose
> > to.
> 
> Thanks for your suggestions. I did as you told me, applied those 3 patches on
> top of 3.1 + net-next (the one from 29 Oct 2011), enabled all those things in
> config and passed corrupt_dbg=1 on cmdline, but the problem happens without
> anything being written to dmesg.

I just discovered that CONFIG_DEBUG_PAGEALLOC does not work as expected.
It leave most of free pages unprotected, hence unintentional write to
them is not discovered. I'm attaching additional patch, which should
make detection actually work.

If kernel will does not boot with corrupt_dbg=1, you may try to catch
corruption without that option. Attached patch should make it possible,
however having corrupt_dbg=1 increase probability of the catch.

Thanks
Stanislaw


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-mm-remove-debug_pagealloc_enabled.patch"

>From 744ddd37f7d61c46e755a7304d791ba0542428a0 Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Wed, 9 Nov 2011 14:21:58 +0100
Subject: [PATCH 1/4] mm: remove debug_pagealloc_enabled

After we finish (no)bootmem, pages are passed to buddy allocator. Since
debug_pagealloc_enabled is not set, we do not protect pages, what is
not what we want with CONFIG_DEBUG_PAGEALLOC=y. That could be fixed by
calling enable_debug_pagealloc() before free_all_bootmem(), but actually
I do not see any reason why we need that global variable. Hence patch
remove it.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 arch/x86/mm/pageattr.c |    6 ------
 include/linux/mm.h     |   10 ----------
 init/main.c            |    5 -----
 mm/debug-pagealloc.c   |    3 ---
 4 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index f9e5267..5031eef 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1334,12 +1334,6 @@ void kernel_map_pages(struct page *page, int numpages, int enable)
 	}
 
 	/*
-	 * If page allocator is not up yet then do not call c_p_a():
-	 */
-	if (!debug_pagealloc_enabled)
-		return;
-
-	/*
 	 * The return value is ignored as the calls cannot fail.
 	 * Large pages for identity mappings are not used at boot time
 	 * and hence no memory allocations during large page split.
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3dc3a8c..0a22db1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1537,23 +1537,13 @@ static inline void vm_stat_account(struct mm_struct *mm,
 #endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
-extern int debug_pagealloc_enabled;
-
 extern void kernel_map_pages(struct page *page, int numpages, int enable);
-
-static inline void enable_debug_pagealloc(void)
-{
-	debug_pagealloc_enabled = 1;
-}
 #ifdef CONFIG_HIBERNATION
 extern bool kernel_page_present(struct page *page);
 #endif /* CONFIG_HIBERNATION */
 #else
 static inline void
 kernel_map_pages(struct page *page, int numpages, int enable) {}
-static inline void enable_debug_pagealloc(void)
-{
-}
 #ifdef CONFIG_HIBERNATION
 static inline bool kernel_page_present(struct page *page) { return true; }
 #endif /* CONFIG_HIBERNATION */
diff --git a/init/main.c b/init/main.c
index 217ed23..99c4ba3 100644
--- a/init/main.c
+++ b/init/main.c
@@ -282,10 +282,6 @@ static int __init unknown_bootoption(char *param, char *val)
 	return 0;
 }
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
-int __read_mostly debug_pagealloc_enabled = 0;
-#endif
-
 static int __init init_setup(char *str)
 {
 	unsigned int i;
@@ -597,7 +593,6 @@ asmlinkage void __init start_kernel(void)
 	}
 #endif
 	page_cgroup_init();
-	enable_debug_pagealloc();
 	debug_objects_mem_init();
 	kmemleak_init();
 	setup_per_cpu_pageset();
diff --git a/mm/debug-pagealloc.c b/mm/debug-pagealloc.c
index 7cea557..789ff70 100644
--- a/mm/debug-pagealloc.c
+++ b/mm/debug-pagealloc.c
@@ -95,9 +95,6 @@ static void unpoison_pages(struct page *page, int n)
 
 void kernel_map_pages(struct page *page, int numpages, int enable)
 {
-	if (!debug_pagealloc_enabled)
-		return;
-
 	if (enable)
 		unpoison_pages(page, numpages);
 	else
-- 
1.7.1


--ReaqsoxgOBHFXBhH--
