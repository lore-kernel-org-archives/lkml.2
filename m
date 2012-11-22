Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab2KVUnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:43:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964966Ab2KVS6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:46 -0500
Date: Wed, 21 Nov 2012 17:48:51 -0800
From: tip-bot for Jacob Shin <jacob.shin@amd.com>
Message-ID: <tip-dda56e134059b840631fdfd034784056b627c2a6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, jacob.shin@amd.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, jacob.shin@amd.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1353123563-3103-12-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-12-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm:
  Fixup code testing if a pfn is direct mapped
Git-Commit-ID: dda56e134059b840631fdfd034784056b627c2a6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 17:48:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dda56e134059b840631fdfd034784056b627c2a6
Gitweb:     http://git.kernel.org/tip/dda56e134059b840631fdfd034784056b627c2a6
Author:     Jacob Shin <jacob.shin@amd.com>
AuthorDate: Fri, 16 Nov 2012 19:38:48 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:09 -0800

x86, mm: Fixup code testing if a pfn is direct mapped

Update code that previously assumed pfns [ 0 - max_low_pfn_mapped ) and
[ 4GB - max_pfn_mapped ) were always direct mapped, to now look up
pfn_mapped ranges instead.

-v2: change applying sequence to keep git bisecting working.
     so add dummy pfn_range_is_mapped(). - Yinghai Lu

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Link: http://lkml.kernel.org/r/1353123563-3103-12-git-send-email-yinghai@kernel.org
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/page_types.h | 8 ++++++++
 arch/x86/kernel/cpu/amd.c         | 8 +++-----
 arch/x86/platform/efi/efi.c       | 7 +++----
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index e21fdd1..45aae6e 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -51,6 +51,14 @@ static inline phys_addr_t get_max_mapped(void)
 	return (phys_addr_t)max_pfn_mapped << PAGE_SHIFT;
 }
 
+static inline bool pfn_range_is_mapped(unsigned long start_pfn,
+					unsigned long end_pfn)
+{
+	return end_pfn <= max_low_pfn_mapped ||
+	       (end_pfn > (1UL << (32 - PAGE_SHIFT)) &&
+		end_pfn <= max_pfn_mapped);
+}
+
 extern unsigned long init_memory_mapping(unsigned long start,
 					 unsigned long end);
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index f7e98a2..9619ba6 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -676,12 +676,10 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		 * benefit in doing so.
 		 */
 		if (!rdmsrl_safe(MSR_K8_TSEG_ADDR, &tseg)) {
+			unsigned long pfn = tseg >> PAGE_SHIFT;
+
 			printk(KERN_DEBUG "tseg: %010llx\n", tseg);
-			if ((tseg>>PMD_SHIFT) <
-				(max_low_pfn_mapped>>(PMD_SHIFT-PAGE_SHIFT)) ||
-				((tseg>>PMD_SHIFT) <
-				(max_pfn_mapped>>(PMD_SHIFT-PAGE_SHIFT)) &&
-				(tseg>>PMD_SHIFT) >= (1ULL<<(32 - PMD_SHIFT))))
+			if (pfn_range_is_mapped(pfn, pfn + 1))
 				set_memory_4k((unsigned long)__va(tseg), 1);
 		}
 	}
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index ad44391..36e53f0 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -835,7 +835,7 @@ void __init efi_enter_virtual_mode(void)
 	efi_memory_desc_t *md, *prev_md = NULL;
 	efi_status_t status;
 	unsigned long size;
-	u64 end, systab, end_pfn;
+	u64 end, systab, start_pfn, end_pfn;
 	void *p, *va, *new_memmap = NULL;
 	int count = 0;
 
@@ -888,10 +888,9 @@ void __init efi_enter_virtual_mode(void)
 		size = md->num_pages << EFI_PAGE_SHIFT;
 		end = md->phys_addr + size;
 
+		start_pfn = PFN_DOWN(md->phys_addr);
 		end_pfn = PFN_UP(end);
-		if (end_pfn <= max_low_pfn_mapped
-		    || (end_pfn > (1UL << (32 - PAGE_SHIFT))
-			&& end_pfn <= max_pfn_mapped)) {
+		if (pfn_range_is_mapped(start_pfn, end_pfn)) {
 			va = __va(md->phys_addr);
 
 			if (!(md->attribute & EFI_MEMORY_WB))
