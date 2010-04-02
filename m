Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab0DBBcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 21:32:16 -0400
Received: from sous-sol.org ([216.99.217.87]:39408 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754982Ab0DBBcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 21:32:14 -0400
Date: Thu, 1 Apr 2010 18:31:32 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Neil Horman <nhorman@tuxdriver.com>,
       Neil Horman <nhorman@redhat.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       iommu@lists.linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 2/2] x86/amd-iommu: warn when issuing command to
	uninitiailed cmd buffer
Message-ID: <20100402013132.GZ29241@sequoia.sous-sol.org>
References: <m1sk7guv5u.fsf@fess.ebiederm.org> <20100331202745.GE13406@hmsreliant.think-freely.org> <20100401142902.GF24846@8bytes.org> <20100401144736.GA14069@shamino.rdu.redhat.com> <20100401155643.GG24846@8bytes.org> <20100401171149.GH13603@shamino.rdu.redhat.com> <20100401201433.GK24846@8bytes.org> <20100402000012.GA8930@hmsreliant.think-freely.org> <20100402003034.GX29241@sequoia.sous-sol.org> <20100402012353.GY29241@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402012353.GY29241@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
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
 
+	WARN_ON(iommu->cmd_buf_size & CMD_BUFFER_UNINITIALIZED);;
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
@@ -453,6 +453,7 @@ void amd_iommu_reset_cmd_buffer(struct a
 	writel(0x00, iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
 
 	iommu_feature_enable(iommu, CONTROL_CMDBUF_EN);
+	iommu->cmd_buf_size &= ~(CMD_BUFFER_UNINITIALIZED);
 }
 
 /*
@@ -477,7 +478,7 @@ static void iommu_enable_command_buffer(
 static void __init free_command_buffer(struct amd_iommu *iommu)
 {
 	free_pages((unsigned long)iommu->cmd_buf,
-		   get_order(iommu->cmd_buf_size));
+		   get_order(iommu->cmd_buf_size & ~(CMD_BUFFER_UNINITIALIZED)));
 }
 
 /* allocates the memory where the IOMMU will log its events to */
