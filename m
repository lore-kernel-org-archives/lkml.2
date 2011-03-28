Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab1C1MAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 08:00:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64275 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab1C1MAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 08:00:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IvirFu4amv3jUbbFqtnaQLdT8OnZWULAJv+CUFOuRgp0GwuBaSCUW9MV17M+RNBWoU
         um0IjpQUscHn2iekGvPmocQEcQ2+Od1BOBSD9URzzndHh7gid8t5szHloi4NmpueOFpo
         1hijTAflc6PdICSo8lWutftnLEewgUOt46Ojs=
From: Igor Plyatov <plyatov@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Igor Plyatov <plyatov@gmail.com>
Subject: [PATCH v3] ata: pata_at91.c bugfix for high master clock
Date: Mon, 28 Mar 2011 15:59:55 +0400
Message-Id: <1301313595-23156-1-git-send-email-plyatov@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AT91SAM9 microcontrollers with master clock higher then 105 MHz
and PIO0, have overflow of the NCS_RD_PULSE value in the MSB. This
lead to "NCS_RD_PULSE" pulse longer then "NRD_CYCLE" pulse and driver
does not detect ATA device.

Signed-off-by: Igor Plyatov <plyatov@gmail.com>
---
 drivers/ata/pata_at91.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
index d1aaeb5..3c2bf86 100644
--- a/drivers/ata/pata_at91.c
+++ b/drivers/ata/pata_at91.c
@@ -33,11 +33,12 @@
 
 
 #define DRV_NAME "pata_at91"
-#define DRV_VERSION "0.1"
+#define DRV_VERSION "0.2"
 
 #define CF_IDE_OFFSET	    0x00c00000
 #define CF_ALT_IDE_OFFSET   0x00e00000
 #define CF_IDE_RES_SIZE     0x08
+#define NCS_RD_PULSE_LIMIT  0x3f /* maximal value for pulse bitfields */
 
 struct at91_ide_info {
 	unsigned long mode;
@@ -110,6 +111,11 @@ static void set_smc_timing(struct device *dev,
 	/* (CS0, CS1, DIR, OE) <= (CFCE1, CFCE2, CFRNW, NCSX) timings */
 	ncs_read_setup = 1;
 	ncs_read_pulse = read_cycle - 2;
+	if (ncs_read_pulse > NCS_RD_PULSE_LIMIT) {
+		ncs_read_pulse = NCS_RD_PULSE_LIMIT;
+		dev_warn(dev, "ncs_read_pulse limited to maximal value %lu\n",
+			ncs_read_pulse);
+	}
 
 	/* Write timings same as read timings */
 	write_cycle = read_cycle;
-- 
1.7.1

