Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab1DSVpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:45:14 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2935 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085Ab1DSVpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:45:12 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Jian Peng" <jipeng2005@gmail.com>
To: "Jeff Garzik" <jgarzik@pobox.com>, "Tejun Heo" <htejun@gmail.com>
cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jian Peng" <jipeng2005@gmail.com>
Subject: [PATCH 1/1] libata: ahci_start_engine compliant to AHCI spec
Date: Tue, 19 Apr 2011 14:44:59 -0700
Message-ID: <1303249499-11557-1-git-send-email-jipeng2005@gmail.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
X-WSS-ID: 61B0DCAC3GO5218745-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the end of section 10.1 of AHCI spec (rev 1.3), it states

Software shall not set PxCMD.ST to 1 until it is determined that a
functoinal device is present on the port as determined by
PxTFD.STS.BSY=0, PxTFD.STS.DRQ=0 and PxSSTS.DET=3h

Even though most AHCI host controller works without this additional
check, specific controller will fail without this.

Signed-off-by: Jian Peng <jipeng2005@gmail.com>
---
 drivers/ata/libahci.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 26d4523..39e0698 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -539,6 +539,12 @@ void ahci_start_engine(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
 	u32 tmp;
+	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
+
+	if (status & (ATA_BUSY | ATA_DRQ) ||
+	    ahci_scr_read(&ap->link, SCR_STATUS, &tmp) ||
+	    (tmp & 0x0f) != 0x03)
+		return;
 
 	/* start DMA */
 	tmp = readl(port_mmio + PORT_CMD);
-- 
1.7.4.1


