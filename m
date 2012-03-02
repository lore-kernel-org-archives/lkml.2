Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab2CBHKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:10:33 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:33905
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752128Ab2CBHKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:10:32 -0500
X-SpamScore: 3
X-BigFish: VS3(zz853kzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Liu Gang <Gang.Liu@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <Alexandre.Bounine@idt.com>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <r58472@freescale.com>, <r61911@freescale.com>,
        Liu Gang <Gang.Liu@freescale.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] powerpc/srio: Fix the compile errors when building with 64bit
Date: Fri, 2 Mar 2012 15:08:47 +0800
Message-ID: <1330672127-22172-1-git-send-email-Gang.Liu@freescale.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the file "arch/powerpc/sysdev/fsl_rmu.c", there will be some compile
errors while using the corenet64_smp_defconfig:

.../fsl_rmu.c:315: error: cast from pointer to integer of different size
.../fsl_rmu.c:320: error: cast to pointer from integer of different size
.../fsl_rmu.c:320: error: cast to pointer from integer of different size
.../fsl_rmu.c:320: error: cast to pointer from integer of different size
.../fsl_rmu.c:330: error: cast to pointer from integer of different size
.../fsl_rmu.c:332: error: cast to pointer from integer of different size
.../fsl_rmu.c:339: error: cast to pointer from integer of different size
.../fsl_rmu.c:340: error: cast to pointer from integer of different size
.../fsl_rmu.c:341: error: cast to pointer from integer of different size
.../fsl_rmu.c:348: error: cast to pointer from integer of different size
.../fsl_rmu.c:348: error: cast to pointer from integer of different size
.../fsl_rmu.c:348: error: cast to pointer from integer of different size
.../fsl_rmu.c:659: error: cast from pointer to integer of different size
.../fsl_rmu.c:659: error: format '%8.8x' expects type 'unsigned int',
		   but argument 5 has type 'size_t'
.../fsl_rmu.c:985: error: cast from pointer to integer of different size
.../fsl_rmu.c:997: error: cast to pointer from integer of different size

Rewrote the corresponding code with the support of 64bit building.

Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/powerpc/sysdev/fsl_rmu.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_rmu.c b/arch/powerpc/sysdev/fsl_rmu.c
index 1548578..468011e 100644
--- a/arch/powerpc/sysdev/fsl_rmu.c
+++ b/arch/powerpc/sysdev/fsl_rmu.c
@@ -311,8 +311,8 @@ fsl_rio_dbell_handler(int irq, void *dev_instance)
 
 	/* XXX Need to check/dispatch until queue empty */
 	if (dsr & DOORBELL_DSR_DIQI) {
-		u32 dmsg =
-			(u32) fsl_dbell->dbell_ring.virt +
+		unsigned long dmsg =
+			(unsigned long) fsl_dbell->dbell_ring.virt +
 			(in_be32(&fsl_dbell->dbell_regs->dqdpar) & 0xfff);
 		struct rio_dbell *dbell;
 		int found = 0;
@@ -657,7 +657,8 @@ fsl_add_outb_message(struct rio_mport *mport, struct rio_dev *rdev, int mbox,
 	int ret = 0;
 
 	pr_debug("RIO: fsl_add_outb_message(): destid %4.4x mbox %d buffer " \
-		 "%8.8x len %8.8x\n", rdev->destid, mbox, (int)buffer, len);
+		 "%8.8lx len %8.8zx\n", rdev->destid, mbox,
+		(unsigned long)buffer, len);
 	if ((len < 8) || (len > RIO_MAX_MSG_SIZE)) {
 		ret = -EINVAL;
 		goto out;
@@ -972,7 +973,7 @@ out:
 void *fsl_get_inb_message(struct rio_mport *mport, int mbox)
 {
 	struct fsl_rmu *rmu = GET_RMM_HANDLE(mport);
-	u32 phys_buf, virt_buf;
+	unsigned long phys_buf, virt_buf;
 	void *buf = NULL;
 	int buf_idx;
 
@@ -982,7 +983,7 @@ void *fsl_get_inb_message(struct rio_mport *mport, int mbox)
 	if (phys_buf == in_be32(&rmu->msg_regs->ifqepar))
 		goto out2;
 
-	virt_buf = (u32) rmu->msg_rx_ring.virt + (phys_buf
+	virt_buf = (unsigned long) rmu->msg_rx_ring.virt + (phys_buf
 						- rmu->msg_rx_ring.phys);
 	buf_idx = (phys_buf - rmu->msg_rx_ring.phys) / RIO_MAX_MSG_SIZE;
 	buf = rmu->msg_rx_ring.virt_buffer[buf_idx];
-- 
1.7.0.4


