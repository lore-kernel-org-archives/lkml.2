Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab2IDLln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 07:41:43 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:13968
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752375Ab2IDLll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 07:41:41 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839he5bhf0ah107ah1155h)
From: Shaohui Xie <Shaohui.Xie@freescale.com>
To: <jgarzik@pobox.com>, <linux-ide@vger.kernel.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Anju Bhartiya <Anju.Bhartiya@freescale.com>
Subject: [PATCH] sata_fsl: add workaround for data length mismatch on freescale V2 controller
Date: Tue, 4 Sep 2012 19:08:40 +0800
Message-ID: <1346756920-19128-1-git-send-email-Shaohui.Xie@freescale.com>
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
 drivers/ata/sata_fsl.c |   48 +++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index d6577b9..00a00cc 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -143,6 +143,7 @@ enum {
 	    FATAL_ERR_CRC_ERR_RX |
 	    FATAL_ERR_FIFO_OVRFL_TX | FATAL_ERR_FIFO_OVRFL_RX,
 
+	INT_ON_DATA_LENGTH_MISMATCH = (1 << 12),
 	INT_ON_FATAL_ERR = (1 << 5),
 	INT_ON_PHYRDY_CHG = (1 << 4),
 
@@ -283,6 +284,8 @@ struct sata_fsl_host_priv {
 	int irq;
 	int data_snoop;
 	struct device_attribute intr_coalescing;
+	u32 quirks;
+#define SATA_FSL_QUIRK_V2_ERRATA        (1 << 1)
 };
 
 static void fsl_sata_set_irq_coalescing(struct ata_host *host,
@@ -1180,26 +1183,58 @@ static void sata_fsl_host_intr(struct ata_port *ap)
 	void __iomem *hcr_base = host_priv->hcr_base;
 	u32 hstatus, done_mask = 0;
 	struct ata_queued_cmd *qc;
-	u32 SError;
+	u32 SError, tag, atapi_flag = 0;
+	u32 status_mask = INT_ON_ERROR;
 
 	hstatus = ioread32(hcr_base + HSTATUS);
 
 	sata_fsl_scr_read(&ap->link, SCR_ERROR, &SError);
 
+	/* Read command completed register */
+	done_mask = ioread32(hcr_base + CC);
+
+	if (host_priv->quirks & SATA_FSL_QUIRK_V2_ERRATA) {
+		if (unlikely(hstatus & INT_ON_DATA_LENGTH_MISMATCH)) {
+			for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
+				qc = ata_qc_from_tag(ap, tag);
+				if (qc && ata_is_atapi(qc->tf.protocol)) {
+					atapi_flag = 1;
+					break;
+				}
+			}
+		}
+	}
+
+	/* Workaround for data length mismatch errata */
+	if (atapi_flag) {
+		u32 Hcontrol;
+#define HCONTROL_CLEAR_ERROR	(1 << 27)
+		/* Set HControl[27] to clear error registers */
+		Hcontrol = ioread32(hcr_base + HCONTROL);
+		iowrite32(Hcontrol | HCONTROL_CLEAR_ERROR, hcr_base + HCONTROL);
+
+		/* Clear HControl[27] */
+		iowrite32(Hcontrol & (~HCONTROL_CLEAR_ERROR),
+						hcr_base + HCONTROL);
+
+		/* Clear SError[E] bit */
+		sata_fsl_scr_write(&ap->link, SCR_ERROR, SError);
+
+		/* Ignore fatal error and device error */
+		status_mask &= ~(INT_ON_SINGL_DEVICE_ERR | INT_ON_FATAL_ERR);
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
@@ -1437,6 +1472,9 @@ static int sata_fsl_probe(struct platform_device *ofdev)
 	else
 		host_priv->data_snoop = DATA_SNOOP_ENABLE_V1;
 
+	if (of_device_is_compatible(ofdev->dev.of_node, "fsl,pq-sata-v2"))
+		host_priv->quirks |= SATA_FSL_QUIRK_V2_ERRATA;
+
 	/* allocate host structure */
 	host = ata_host_alloc_pinfo(&ofdev->dev, ppi, SATA_FSL_MAX_PORTS);
 	if (!host) {
-- 
1.6.4


