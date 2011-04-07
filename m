Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab1DGNaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 09:30:23 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:46252
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755383Ab1DGNaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 09:30:20 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJAAU8-01-CQH-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/9] x86/amd-iommu: Remove command buffer resetting logic
Date: Thu, 7 Apr 2011 15:30:00 +0200
Message-ID: <1302183004-4081-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302183004-4081-1-git-send-email-joerg.roedel@amd.com>
References: <1302183004-4081-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logic to reset the command buffer caused more problems
than it actually helped. The logic jumped in when the IOMMU
hardware doesn't execute commands anymore but the reasons
for this are usually not fixed by just resetting the command
buffer. So the code can be removed to reduce complexity.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    3 ---
 arch/x86/kernel/amd_iommu.c            |   20 +-------------------
 2 files changed, 1 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index e3509fc..878ae00 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -409,9 +409,6 @@ struct amd_iommu {
 	/* if one, we need to send a completion wait command */
 	bool need_sync;
 
-	/* becomes true if a command buffer reset is running */
-	bool reset_in_progress;
-
 	/* default dma_ops domain for that IOMMU */
 	struct dma_ops_domain *default_dom;
 
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 073c64b..0147c5c 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -58,7 +58,6 @@ struct iommu_cmd {
 	u32 data[4];
 };
 
-static void reset_iommu_command_buffer(struct amd_iommu *iommu);
 static void update_domain(struct protection_domain *domain);
 
 /****************************************************************************
@@ -323,8 +322,6 @@ static void iommu_print_event(struct amd_iommu *iommu, void *__evt)
 		break;
 	case EVENT_TYPE_ILL_CMD:
 		printk("ILLEGAL_COMMAND_ERROR address=0x%016llx]\n", address);
-		iommu->reset_in_progress = true;
-		reset_iommu_command_buffer(iommu);
 		dump_command(address);
 		break;
 	case EVENT_TYPE_CMD_HARD_ERR:
@@ -485,8 +482,7 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 
 	if (i == LOOP_TIMEOUT) {
 		pr_alert("AMD-Vi: Completion-Wait loop timed out\n");
-		iommu->reset_in_progress = true;
-		reset_iommu_command_buffer(iommu);
+		ret = -EIO;
 	}
 
 	return 0;
@@ -628,20 +624,6 @@ void amd_iommu_flush_all_domains(void)
 	spin_unlock_irqrestore(&amd_iommu_pd_lock, flags);
 }
 
-static void reset_iommu_command_buffer(struct amd_iommu *iommu)
-{
-	pr_err("AMD-Vi: Resetting IOMMU command buffer\n");
-
-	if (iommu->reset_in_progress)
-		panic("AMD-Vi: ILLEGAL_COMMAND_ERROR while resetting command buffer\n");
-
-	amd_iommu_reset_cmd_buffer(iommu);
-	amd_iommu_flush_all_devices();
-	amd_iommu_flush_all_domains();
-
-	iommu->reset_in_progress = false;
-}
-
 /****************************************************************************
  *
  * The functions below are used the create the page table mappings for
-- 
1.7.1


