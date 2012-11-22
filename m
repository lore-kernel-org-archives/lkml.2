Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964853Ab2KVS6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:58:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964860Ab2KVS6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:35 -0500
Date: Wed, 21 Nov 2012 17:55:06 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-960ddb4fe7832b559897e8b26ec805839b706905@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-18-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-18-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm:
  Align start address to correct big page size
Git-Commit-ID: 960ddb4fe7832b559897e8b26ec805839b706905
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 17:55:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  960ddb4fe7832b559897e8b26ec805839b706905
Gitweb:     http://git.kernel.org/tip/960ddb4fe7832b559897e8b26ec805839b706905
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:38:54 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:15 -0800

x86, mm: Align start address to correct big page size

We are going to use buffer in BRK to map small range just under memory top,
and use those new mapped ram to map ram range under it.

The ram range that will be mapped at first could be only page aligned,
but ranges around it are ram too, we could use bigger page to map it to
avoid small page size.

We will adjust page_size_mask in following patch:
	x86, mm: Use big page size for small memory range
to use big page size for small ram range.

Before that patch, this patch will make sure start address to be
aligned down according to bigger page size, otherwise entry in page
page will not have correct value.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-18-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init_32.c | 1 +
 arch/x86/mm/init_64.c | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 11a5800..27f7fc6 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -310,6 +310,7 @@ repeat:
 					__pgprot(PTE_IDENT_ATTR |
 						 _PAGE_PSE);
 
+				pfn &= PMD_MASK >> PAGE_SHIFT;
 				addr2 = (pfn + PTRS_PER_PTE-1) * PAGE_SIZE +
 					PAGE_OFFSET + PAGE_SIZE-1;
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 32c7e38..869372a 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -464,7 +464,7 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 			pages++;
 			spin_lock(&init_mm.page_table_lock);
 			set_pte((pte_t *)pmd,
-				pfn_pte(address >> PAGE_SHIFT,
+				pfn_pte((address & PMD_MASK) >> PAGE_SHIFT,
 					__pgprot(pgprot_val(prot) | _PAGE_PSE)));
 			spin_unlock(&init_mm.page_table_lock);
 			last_map_addr = next;
@@ -541,7 +541,8 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 			pages++;
 			spin_lock(&init_mm.page_table_lock);
 			set_pte((pte_t *)pud,
-				pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
+				pfn_pte((addr & PUD_MASK) >> PAGE_SHIFT,
+					PAGE_KERNEL_LARGE));
 			spin_unlock(&init_mm.page_table_lock);
 			last_map_addr = next;
 			continue;
