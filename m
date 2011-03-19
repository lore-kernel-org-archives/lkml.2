Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab1CSThR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 15:37:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:43262 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757162Ab1CSThO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 15:37:14 -0400
Date: Sat, 19 Mar 2011 19:36:57 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tglx@linutronix.de,
        stefano.stabellini@eu.citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de,
        stefano.stabellini@eu.citrix.com
In-Reply-To: <alpine.DEB.2.00.1103171739050.3382@kaball-desktop>
References: <alpine.DEB.2.00.1103171739050.3382@kaball-desktop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Cleanup highmap after brk is concluded
Message-ID: <tip-e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e@git.kernel.org>
Git-Commit-ID: e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 19 Mar 2011 19:36:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e
Gitweb:     http://git.kernel.org/tip/e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 18 Feb 2011 11:30:30 +0000
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 19 Mar 2011 11:58:19 -0700

x86: Cleanup highmap after brk is concluded

Now cleanup_highmap actually is in two steps: one is early in head64.c
and only clears above _end; a second one is in init_memory_mapping() and
tries to clean from _brk_end to _end.
It should check if those boundaries are PMD_SIZE aligned but currently
does not.
Also init_memory_mapping() is called several times for numa or memory
hotplug, so we really should not handle initial kernel mappings there.

This patch moves cleanup_highmap() down after _brk_end is settled so
we can do everything in one step.
Also we honor max_pfn_mapped in the implementation of cleanup_highmap.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
LKML-Reference: <alpine.DEB.2.00.1103171739050.3382@kaball-desktop>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/head64.c |    3 ---
 arch/x86/kernel/setup.c  |   25 +++----------------------
 arch/x86/mm/init_64.c    |   11 ++++++-----
 3 files changed, 9 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 2d2673c..5655c22 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -77,9 +77,6 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	/* Make NULL pointers segfault */
 	zap_identity_mappings();
 
-	/* Cleanup the over mapped high alias */
-	cleanup_highmap();
-
 	max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
 
 	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b176f2b..4a52a5f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -294,30 +294,11 @@ static void __init init_gbpages(void)
 	else
 		direct_gbpages = 0;
 }
-
-static void __init cleanup_highmap_brk_end(void)
-{
-	pud_t *pud;
-	pmd_t *pmd;
-
-	mmu_cr4_features = read_cr4();
-
-	/*
-	 * _brk_end cannot change anymore, but it and _end may be
-	 * located on different 2M pages. cleanup_highmap(), however,
-	 * can only consider _end when it runs, so destroy any
-	 * mappings beyond _brk_end here.
-	 */
-	pud = pud_offset(pgd_offset_k(_brk_end), _brk_end);
-	pmd = pmd_offset(pud, _brk_end - 1);
-	while (++pmd <= pmd_offset(pud, (unsigned long)_end - 1))
-		pmd_clear(pmd);
-}
 #else
 static inline void init_gbpages(void)
 {
 }
-static inline void cleanup_highmap_brk_end(void)
+static void __init cleanup_highmap(void)
 {
 }
 #endif
@@ -330,8 +311,6 @@ static void __init reserve_brk(void)
 	/* Mark brk area as locked down and no longer taking any
 	   new allocations */
 	_brk_start = 0;
-
-	cleanup_highmap_brk_end();
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -950,6 +929,8 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	reserve_brk();
 
+	cleanup_highmap();
+
 	memblock.current_limit = get_max_mapped();
 	memblock_x86_fill();
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index a08a62c..7026505 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -51,6 +51,7 @@
 #include <asm/numa.h>
 #include <asm/cacheflush.h>
 #include <asm/init.h>
+#include <asm/setup.h>
 
 static int __init parse_direct_gbpages_off(char *arg)
 {
@@ -293,18 +294,18 @@ void __init init_extra_mapping_uc(unsigned long phys, unsigned long size)
  * to the compile time generated pmds. This results in invalid pmds up
  * to the point where we hit the physaddr 0 mapping.
  *
- * We limit the mappings to the region from _text to _end.  _end is
- * rounded up to the 2MB boundary. This catches the invalid pmds as
+ * We limit the mappings to the region from _text to _brk_end.  _brk_end
+ * is rounded up to the 2MB boundary. This catches the invalid pmds as
  * well, as they are located before _text:
  */
 void __init cleanup_highmap(void)
 {
 	unsigned long vaddr = __START_KERNEL_map;
-	unsigned long end = roundup((unsigned long)_end, PMD_SIZE) - 1;
+	unsigned long vaddr_end = __START_KERNEL_map + (max_pfn_mapped << PAGE_SHIFT);
+	unsigned long end = roundup((unsigned long)_brk_end, PMD_SIZE) - 1;
 	pmd_t *pmd = level2_kernel_pgt;
-	pmd_t *last_pmd = pmd + PTRS_PER_PMD;
 
-	for (; pmd < last_pmd; pmd++, vaddr += PMD_SIZE) {
+	for (; vaddr + PMD_SIZE - 1 < vaddr_end; pmd++, vaddr += PMD_SIZE) {
 		if (pmd_none(*pmd))
 			continue;
 		if (vaddr < (unsigned long) _text || vaddr > end)
