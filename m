Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab0DCB3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 21:29:35 -0400
Received: from sous-sol.org ([216.99.217.87]:45707 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755051Ab0DCB3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 21:29:02 -0400
Message-Id: <20100403012817.408728532@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Fri, 02 Apr 2010 18:27:53 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: nhorman@tuxdriver.com, nhorman@redhat.com, vgoyal@redhat.com,
       hbabu@us.ibm.com, ebiederm@xmission.com,
       iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] x86/amd-iommu: warn when issuing command to uninitialized cmd buffer
References: <20100403012751.834020949@sous-sol.org>
Content-Disposition: inline; filename=amd-warn-on-early-cmd-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To catch future potential issues we can add a warning whenever we issue
a command before the command buffer is fully initialized.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
Or not...this is just if you think it's useful ;-)

 arch/x86/include/asm/amd_iommu_types.h |    1 +
 arch/x86/kernel/amd_iommu.c            |    1 +
 arch/x86/kernel/amd_iommu_init.c       |    5 +++--
 3 files changed, 5 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -140,6 +140,7 @@
 
 /* constants to configure the command buffer */
 #define CMD_BUFFER_SIZE    8192
+#define CMD_BUFFER_UNINITIALIZED 1
 #define CMD_BUFFER_ENTRIES 512
 #define MMIO_CMD_SIZE_SHIFT 56
 #define MMIO_CMD_SIZE_512 (0x9ULL << MMIO_CMD_SIZE_SHIFT)
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -392,6 +392,7 @@ static int __iommu_queue_command(struct 
 	u32 tail, head;
 	u8 *target;
 
+	WARN_ON(iommu->cmd_buf_size & CMD_BUFFER_UNINITIALIZED);
 	tail = readl(iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
 	target = iommu->cmd_buf + tail;
 	memcpy_toio(target, cmd, sizeof(*cmd));
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -436,7 +436,7 @@ static u8 * __init alloc_command_buffer(
 	if (cmd_buf == NULL)
 		return NULL;
 
-	iommu->cmd_buf_size = CMD_BUFFER_SIZE;
+	iommu->cmd_buf_size = CMD_BUFFER_SIZE | CMD_BUFFER_UNINITIALIZED;
 
 	return cmd_buf;
 }
@@ -472,12 +472,13 @@ static void iommu_enable_command_buffer(
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

