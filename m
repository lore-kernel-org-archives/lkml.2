Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739Ab1BPIvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:51:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:53800 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab1BPIvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:51:48 -0500
Date: Wed, 16 Feb 2011 08:51:33 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <4D1933E0.7090305@kernel.org>
References: <4D1933E0.7090305@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86-64: Move out cleanup higmap [_brk_end, _end) out of init_memory_mapping()
Message-ID: <tip-f005fe12b90c5b9fe180a09209a893e09affa8aa@git.kernel.org>
Git-Commit-ID: f005fe12b90c5b9fe180a09209a893e09affa8aa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Feb 2011 08:51:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f005fe12b90c5b9fe180a09209a893e09affa8aa
Gitweb:     http://git.kernel.org/tip/f005fe12b90c5b9fe180a09209a893e09affa8aa
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 27 Dec 2010 16:48:32 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 5 Jan 2011 14:03:45 +0100

x86-64: Move out cleanup higmap [_brk_end, _end) out of init_memory_mapping()

It is not related to init_memory_mapping(),  and init_memory_mapping() is
getting more bigger.

So make it as seperated function and call it from reserve_brk() and that is
point when _brk_end is concluded.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4D1933E0.7090305@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/setup.c |   24 ++++++++++++++++++++++++
 arch/x86/mm/init.c      |   19 -------------------
 2 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index fc0fe74..635185b 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -293,10 +293,32 @@ static void __init init_gbpages(void)
 	else
 		direct_gbpages = 0;
 }
+
+static void __init cleanup_highmap_brk_end(void)
+{
+	pud_t *pud;
+	pmd_t *pmd;
+
+	mmu_cr4_features = read_cr4();
+
+	/*
+	 * _brk_end cannot change anymore, but it and _end may be
+	 * located on different 2M pages. cleanup_highmap(), however,
+	 * can only consider _end when it runs, so destroy any
+	 * mappings beyond _brk_end here.
+	 */
+	pud = pud_offset(pgd_offset_k(_brk_end), _brk_end);
+	pmd = pmd_offset(pud, _brk_end - 1);
+	while (++pmd <= pmd_offset(pud, (unsigned long)_end - 1))
+		pmd_clear(pmd);
+}
 #else
 static inline void init_gbpages(void)
 {
 }
+static inline void cleanup_highmap_brk_end(void)
+{
+}
 #endif
 
 static void __init reserve_brk(void)
@@ -307,6 +329,8 @@ static void __init reserve_brk(void)
 	/* Mark brk area as locked down and no longer taking any
 	   new allocations */
 	_brk_start = 0;
+
+	cleanup_highmap_brk_end();
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index fa6fe75..35ee75d 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -270,25 +270,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	load_cr3(swapper_pg_dir);
 #endif
 
-#ifdef CONFIG_X86_64
-	if (!after_bootmem && !start) {
-		pud_t *pud;
-		pmd_t *pmd;
-
-		mmu_cr4_features = read_cr4();
-
-		/*
-		 * _brk_end cannot change anymore, but it and _end may be
-		 * located on different 2M pages. cleanup_highmap(), however,
-		 * can only consider _end when it runs, so destroy any
-		 * mappings beyond _brk_end here.
-		 */
-		pud = pud_offset(pgd_offset_k(_brk_end), _brk_end);
-		pmd = pmd_offset(pud, _brk_end - 1);
-		while (++pmd <= pmd_offset(pud, (unsigned long)_end - 1))
-			pmd_clear(pmd);
-	}
-#endif
 	__flush_tlb_all();
 
 	if (!after_bootmem && e820_table_end > e820_table_start)
