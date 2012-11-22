Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab2KVUqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:46:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964949Ab2KVS6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:44 -0500
Date: Wed, 21 Nov 2012 17:49:53 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-8eb5779f6b9c7e390c92f451edaafc039e06e743@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-13-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-13-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: use pfn_range_is_mapped() with CPA
Git-Commit-ID: 8eb5779f6b9c7e390c92f451edaafc039e06e743
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 17:49:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8eb5779f6b9c7e390c92f451edaafc039e06e743
Gitweb:     http://git.kernel.org/tip/8eb5779f6b9c7e390c92f451edaafc039e06e743
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:38:49 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:09 -0800

x86, mm: use pfn_range_is_mapped() with CPA

We are going to map ram only, so under max_low_pfn_mapped,
between 4g and max_pfn_mapped does not mean mapped at all.

Use pfn_range_is_mapped() directly.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-13-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/pageattr.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index a718e0d..44acfcd 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -551,16 +551,10 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	for (i = 0; i < PTRS_PER_PTE; i++, pfn += pfninc)
 		set_pte(&pbase[i], pfn_pte(pfn, ref_prot));
 
-	if (address >= (unsigned long)__va(0) &&
-		address < (unsigned long)__va(max_low_pfn_mapped << PAGE_SHIFT))
+	if (pfn_range_is_mapped(PFN_DOWN(__pa(address)),
+				PFN_DOWN(__pa(address)) + 1))
 		split_page_count(level);
 
-#ifdef CONFIG_X86_64
-	if (address >= (unsigned long)__va(1UL<<32) &&
-		address < (unsigned long)__va(max_pfn_mapped << PAGE_SHIFT))
-		split_page_count(level);
-#endif
-
 	/*
 	 * Install the new, split up pagetable.
 	 *
@@ -729,13 +723,9 @@ static int cpa_process_alias(struct cpa_data *cpa)
 	unsigned long vaddr;
 	int ret;
 
-	if (cpa->pfn >= max_pfn_mapped)
+	if (!pfn_range_is_mapped(cpa->pfn, cpa->pfn + 1))
 		return 0;
 
-#ifdef CONFIG_X86_64
-	if (cpa->pfn >= max_low_pfn_mapped && cpa->pfn < (1UL<<(32-PAGE_SHIFT)))
-		return 0;
-#endif
 	/*
 	 * No need to redo, when the primary call touched the direct
 	 * mapping already:
