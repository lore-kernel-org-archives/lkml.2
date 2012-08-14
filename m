Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2HNWkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 18:40:24 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:32708
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752048Ab2HNWj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 18:39:28 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M8RO9N-01-LYV-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: X86-ML <x86@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Tejun Heo <tj@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 4/4] x86: Fixup code testing if a pfn is direct mapped
Date: Tue, 14 Aug 2012 17:39:17 -0500
Message-ID: <1344983957-4996-5-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344983957-4996-1-git-send-email-jacob.shin@amd.com>
References: <1344983957-4996-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update code that previously assumed pfns [ 0 - max_low_pfn_mapped ) and
[ 4GB - max_pfn_mapped ) were always direct mapped, to now look up
pfn_mapped ranges instead.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/kernel/cpu/amd.c   |    6 +-----
 arch/x86/platform/efi/efi.c |    8 ++++----
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 9d92e19..554ccfc 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -677,11 +677,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		 */
 		if (!rdmsrl_safe(MSR_K8_TSEG_ADDR, &tseg)) {
 			printk(KERN_DEBUG "tseg: %010llx\n", tseg);
-			if ((tseg>>PMD_SHIFT) <
-				(max_low_pfn_mapped>>(PMD_SHIFT-PAGE_SHIFT)) ||
-				((tseg>>PMD_SHIFT) <
-				(max_pfn_mapped>>(PMD_SHIFT-PAGE_SHIFT)) &&
-				(tseg>>PMD_SHIFT) >= (1ULL<<(32 - PMD_SHIFT))))
+			if (pfn_is_mapped(tseg))
 				set_memory_4k((unsigned long)__va(tseg), 1);
 		}
 	}
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 2dc29f5..4810ab3 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -754,7 +754,7 @@ void __init efi_enter_virtual_mode(void)
 	efi_memory_desc_t *md, *prev_md = NULL;
 	efi_status_t status;
 	unsigned long size;
-	u64 end, systab, addr, npages, end_pfn;
+	u64 end, systab, addr, npages, start_pfn, end_pfn;
 	void *p, *va, *new_memmap = NULL;
 	int count = 0;
 
@@ -805,10 +805,10 @@ void __init efi_enter_virtual_mode(void)
 		size = md->num_pages << EFI_PAGE_SHIFT;
 		end = md->phys_addr + size;
 
+		start_pfn = PFN_DOWN(md->phys_addr);
 		end_pfn = PFN_UP(end);
-		if (end_pfn <= max_low_pfn_mapped
-		    || (end_pfn > (1UL << (32 - PAGE_SHIFT))
-			&& end_pfn <= max_pfn_mapped))
+
+		if (pfn_range_is_mapped(start_pfn, end_pfn))
 			va = __va(md->phys_addr);
 		else
 			va = efi_ioremap(md->phys_addr, size, md->type);
-- 
1.7.9.5


