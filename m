Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab2IKDXC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 23:23:02 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:31129
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754916Ab2IKDW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 23:22:59 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202h1d1ahzz8275bhz2dh2a8h668h839he5bhf0ah107ah1288h12a5h12bdh1155h)
From: Shaohui Xie <Shaohui.Xie@freescale.com>
To: <jgarzik@pobox.com>, <linux-ide@vger.kernel.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Anju Bhartiya <Anju.Bhartiya@freescale.com>
Subject: [PATCH][v4] sata_fsl: add workaround for data length mismatch on freescale V2 controller
Date: Tue, 11 Sep 2012 10:48:53 +0800
Message-ID: <1347331734-6540-1-git-send-email-Shaohui.Xie@freescale.com>
X-Mailer: git-send-email 1.6.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The freescale V2 SATA controller checks if the received data length matches
the programmed length 'ttl', if not, it assumes that this is an error.
In ATAPI, the 'ttl' is based on max allocation length and not the actual
data transfer length, controller will raise 'DLM' (Data length Mismatch)
error bit in Hstatus register. Along with 'DLM', DE (Device error) and
FE (fatal Error) bits are also set in Hstatus register, 'E' (Internal Error)
bit is set in Serror register and CE (Command Error) and DE (Device error)
registers have the corresponding bit set. In this condition, we need to
clear errors in following way: in the service routine, based on 'DLM' flag,
HCONTROL[27] operation clears Hstatus, CE and DE registers, clear Serror
register.

Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
Signed-off-by: Anju Bhartiya <Anju.Bhartiya@freescale.com>
---
changes for v4:
1. put HCONTROL_CLEAR_ERROR to enum and rename it as CLEAR_ERROR;

changes for v3:
1. not using uppercase for variable names;
2. remove unnecessary parens;

changes for v2:
1. remove the using of quirk;
2. wrap errata codes in condition;


 drivers/ata/sata_fsl.c |   39 +++++++++++++++++++++++++++++++++++----
 1 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index d6577b9..124b2c1 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -123,6 +123,7 @@ enum {
 	ONLINE = (1 << 31),
 	GOING_OFFLINE = (1 << 30),
 	BIST_ERR = (1 << 29),
+	CLEAR_ERROR = (1 << 27),
 
 	FATAL_ERR_HC_MASTER_ERR = (1 << 18),
 	FATAL_ERR_PARITY_ERR_TX = (1 << 17),
@@ -143,6 +144,7 @@ enum {
 	    FATAL_ERR_CRC_ERR_RX |
 	    FATAL_ERR_FIFO_OVRFL_TX | FATAL_ERR_FIFO_OVRFL_RX,
 
+	INT_ON_DATA_LENGTH_MISMATCH = (1 << 12),
 	INT_ON_FATAL_ERR = (1 << 5),
 	INT_ON_PHYRDY_CHG = (1 << 4),
 
@@ -1181,25 +1183,54 @@ static void sata_fsl_host_intr(struct ata_port *ap)
 	u32 hstatus, done_mask = 0;
 	struct ata_queued_cmd *qc;
 	u32 SError;
+	u32 tag;
+	u32 status_mask = INT_ON_ERROR;
 
 	hstatus = ioread32(hcr_base + HSTATUS);
 
 	sata_fsl_scr_read(&ap->link, SCR_ERROR, &SError);
 
+	/* Read command completed register */
+	done_mask = ioread32(hcr_base + CC);
+
+	/* Workaround for data length mismatch errata */
+	if (unlikely(hstatus & INT_ON_DATA_LENGTH_MISMATCH)) {
+		for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
+			qc = ata_qc_from_tag(ap, tag);
+			if (qc && ata_is_atapi(qc->tf.protocol)) {
+				u32 hcontrol;
+				/* Set HControl[27] to clear error registers */
+				hcontrol = ioread32(hcr_base + HCONTROL);
+				iowrite32(hcontrol | CLEAR_ERROR,
+						hcr_base + HCONTROL);
+
+				/* Clear HControl[27] */
+				iowrite32(hcontrol & ~CLEAR_ERROR,
+						hcr_base + HCONTROL);
+
+				/* Clear SError[E] bit */
+				sata_fsl_scr_write(&ap->link, SCR_ERROR,
+						SError);
+
+				/* Ignore fatal error and device error */
+				status_mask &= ~(INT_ON_SINGL_DEVICE_ERR
+						| INT_ON_FATAL_ERR);
+				break;
+			}
+		}
+	}
+
 	if (unlikely(SError & 0xFFFF0000)) {
 		DPRINTK("serror @host_intr : 0x%x\n", SError);
 		sata_fsl_error_intr(ap);
 	}
 
-	if (unlikely(hstatus & INT_ON_ERROR)) {
+	if (unlikely(hstatus & status_mask)) {
 		DPRINTK("error interrupt!!\n");
 		sata_fsl_error_intr(ap);
 		return;
 	}
 
-	/* Read command completed register */
-	done_mask = ioread32(hcr_base + CC);
-
 	VPRINTK("Status of all queues :\n");
 	VPRINTK("done_mask/CC = 0x%x, CA = 0x%x, CE=0x%x,CQ=0x%x,apqa=0x%x\n",
 		done_mask,
-- 
1.6.4


