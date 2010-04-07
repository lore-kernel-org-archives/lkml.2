Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab0DGMsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 08:48:12 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:3559 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932534Ab0DGMsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 08:48:07 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i6bh2a8h87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0IBJN-01-9UE-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/12] x86/amd-iommu: warn when issuing command to uninitialized cmd buffer
Date: Wed, 7 Apr 2010 14:46:44 +0200
Message-ID: <1270644409-10123-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
References: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Apr 2010 12:46:56.0039 (UTC) FILETIME=[67C85370:01CAD650]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>

To catch future potential issues we can add a warning whenever we issue
a command before the command buffer is fully initialized.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    1 +
 arch/x86/kernel/amd_iommu.c            |    1 +
 arch/x86/kernel/amd_iommu_init.c       |    5 +++--
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 5e46e78..86a0ff0 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -141,6 +141,7 @@
 
 /* constants to configure the command buffer */
 #define CMD_BUFFER_SIZE    8192
+#define CMD_BUFFER_UNINITIALIZED 1
 #define CMD_BUFFER_ENTRIES 512
 #define MMIO_CMD_SIZE_SHIFT 56
 #define MMIO_CMD_SIZE_512 (0x9ULL << MMIO_CMD_SIZE_SHIFT)
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index b06f29e..71dfc0a 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -392,6 +392,7 @@ static int __iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
 	u32 tail, head;
 	u8 *target;
 
+	WARN_ON(iommu->cmd_buf_size & CMD_BUFFER_UNINITIALIZED);
 	tail = readl(iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
 	target = iommu->cmd_buf + tail;
 	memcpy_toio(target, cmd, sizeof(*cmd));
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 8975965..5edf41c 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -438,7 +438,7 @@ static u8 * __init alloc_command_buffer(struct amd_iommu *iommu)
 	if (cmd_buf == NULL)
 		return NULL;
 
-	iommu->cmd_buf_size = CMD_BUFFER_SIZE;
+	iommu->cmd_buf_size = CMD_BUFFER_SIZE | CMD_BUFFER_UNINITIALIZED;
 
 	return cmd_buf;
 }
@@ -474,12 +474,13 @@ static void iommu_enable_command_buffer(struct amd_iommu *iommu)
 		    &entry, sizeof(entry));
 
 	amd_iommu_reset_cmd_buffer(iommu);
+	iommu->cmd_buf_size &= ~(CMD_BUFFER_UNINITIALIZED);
 }
 
 static void __init free_command_buffer(struct amd_iommu *iommu)
 {
 	free_pages((unsigned long)iommu->cmd_buf,
-		   get_order(iommu->cmd_buf_size));
+		   get_order(iommu->cmd_buf_size & ~(CMD_BUFFER_UNINITIALIZED)));
 }
 
 /* allocates the memory where the IOMMU will log its events to */
-- 
1.7.0.4


