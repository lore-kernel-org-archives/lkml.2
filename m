Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab0JAUAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 16:00:32 -0400
Received: from mxout1.idt.com ([157.165.5.25]:43696 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017Ab0JAUAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 16:00:31 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Thomas Moll <thomas.moll@sysgo.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: [PATCH -mm] RapidIO: fix IDLE2 bits corruption
Date: Fri,  1 Oct 2010 15:55:23 -0400
Message-Id: <1285962923-29294-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RapidIO spec v.2.1 adds Idle Sequence 2 into LP-Serial Physical
Layer. The fix ensures that corresponding bits are not corrupted during
error handling.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Micha Nelissen <micha@neli.hopto.org>
---
 drivers/rapidio/rio.c    |    9 ++-------
 include/linux/rio_regs.h |    3 +--
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index 7f18a65..68cf0c9 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -871,15 +871,10 @@ int rio_inb_pwrite_handler(union rio_pw_msg *pw_msg)
 			rdev->em_efptr + RIO_EM_LTL_ERR_DETECT, 0);
 	}
 
-	/* Clear remaining error bits */
+	/* Clear remaining error bits and Port-Write Pending bit */
 	rio_mport_write_config_32(mport, destid, hopcount,
 			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(portnum),
-			err_status & RIO_PORT_N_ERR_STS_CLR_MASK);
-
-	/* Clear Port-Write Pending bit */
-	rio_mport_write_config_32(mport, destid, hopcount,
-			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(portnum),
-			RIO_PORT_N_ERR_STS_PW_PEND);
+			err_status);
 
 	return 0;
 }
diff --git a/include/linux/rio_regs.h b/include/linux/rio_regs.h
index a18b2e2..d63dcba 100644
--- a/include/linux/rio_regs.h
+++ b/include/linux/rio_regs.h
@@ -229,7 +229,7 @@
 #define  RIO_MNT_REQ_CMD_IS		0x04	/* Input-status command */
 #define RIO_PORT_N_MNT_RSP_CSR(x)	(0x0044 + x*0x20)	/* 0x0002 */
 #define  RIO_PORT_N_MNT_RSP_RVAL	0x80000000 /* Response Valid */
-#define  RIO_PORT_N_MNT_RSP_ASTAT	0x000003e0 /* ackID Status */
+#define  RIO_PORT_N_MNT_RSP_ASTAT	0x000007e0 /* ackID Status */
 #define  RIO_PORT_N_MNT_RSP_LSTAT	0x0000001f /* Link Status */
 #define RIO_PORT_N_ACK_STS_CSR(x)	(0x0048 + x*0x20)	/* 0x0002 */
 #define  RIO_PORT_N_ACK_CLEAR		0x80000000
@@ -243,7 +243,6 @@
 #define  RIO_PORT_N_ERR_STS_PORT_ERR	0x00000004
 #define  RIO_PORT_N_ERR_STS_PORT_OK	0x00000002
 #define  RIO_PORT_N_ERR_STS_PORT_UNINIT	0x00000001
-#define  RIO_PORT_N_ERR_STS_CLR_MASK	0x07120204
 #define RIO_PORT_N_CTL_CSR(x)		(0x005c + x*0x20)
 #define  RIO_PORT_N_CTL_PWIDTH		0xc0000000
 #define  RIO_PORT_N_CTL_PWIDTH_1	0x00000000
-- 
1.7.3.1

