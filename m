Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab2H2TFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 15:05:22 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:12185
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754554Ab2H2TFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 15:05:19 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VPS4(zzb922lzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah1155h)
X-WSS-ID: 0M9J6BC-01-8HU-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: X86-ML <x86@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 5/6] x86: Fixup code testing if a pfn is direct mapped
Date: Wed, 29 Aug 2012 14:04:05 -0500
Message-ID: <1346267046-6724-6-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346267046-6724-1-git-send-email-jacob.shin@amd.com>
References: <1346267046-6724-1-git-send-email-jacob.shin@amd.com>
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
index 92660eda..f1facde 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -776,7 +776,7 @@ void __init efi_enter_virtual_mode(void)
 	efi_memory_desc_t *md, *prev_md = NULL;
 	efi_status_t status;
 	unsigned long size;
-	u64 end, systab, addr, npages, end_pfn;
+	u64 end, systab, addr, npages, start_pfn, end_pfn;
 	void *p, *va, *new_memmap = NULL;
 	int count = 0;
 
@@ -827,10 +827,10 @@ void __init efi_enter_virtual_mode(void)
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


