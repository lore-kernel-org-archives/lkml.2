Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab0LKUC5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 15:02:57 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:43406 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab0LKUCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 15:02:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=oVASk8FN4PP+3lW8BUZbQ7kurOP6sS4bUpIrCn0Q+u4BOEpvo9OPHS+DNLqJZgbMG8
         QVF2uDXivfSjBBQncyWgSJ4FvvZY3D+4ZVR4pCVYL9Hv6VNGjHPToMzQuE2WmNWkNbZn
         /pIxnLl+ncGvG6xQdov34FTDhkY6xYzu9p+F0=
From: Igor Plyatov <plyatov@gmail.com>
To: sshtylyov@mvista.com
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        geomatsi@gmail.com, nicolas.ferre@atmel.com, linux@maxim.org.za,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        christian.glindkamp@taskit.de, ryan@bluewatersys.com,
        pgsellmann@portner-elektronik.at, Igor Plyatov <plyatov@gmail.com>
Subject: [PATCH] ide: at91_ide.c bugfix for high master clock
Date: Sat, 11 Dec 2010 23:02:25 +0300
Message-Id: <1292097745-9680-1-git-send-email-plyatov@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AT91SAM9 microcontrollers with master clock higher then 105 MHz
and PIO0, have overflow of the NCS_RD_PULSE value in the MSB. This
lead to "NCS_RD_PULSE" pulse longer then "NRD_CYCLE" pulse and at91_ide
driver does not detect ATA device.
This patch must be applied on top of my patch for pata_at91 where the
same bug fixed.

Signed-off-by: Igor Plyatov <plyatov@gmail.com>
---
 drivers/ata/pata_at91.c |    2 +-
 drivers/ide/at91_ide.c  |   31 +++++++++++++++++++++----------
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
index 2e189be..a462405 100644
--- a/drivers/ata/pata_at91.c
+++ b/drivers/ata/pata_at91.c
@@ -113,7 +113,7 @@ static void set_smc_timing(struct device *dev,
 	ncs_read_pulse = read_cycle - 2;
 	if (ncs_read_pulse > NCS_RD_PULSE_LIMIT) {
 		ncs_read_pulse = NCS_RD_PULSE_LIMIT;
-		dev_dbg(dev, "ncs_read_pulse limited to maximal value %lu\n",
+		dev_warn(dev, "ncs_read_pulse limited to maximal value %lu\n",
 			ncs_read_pulse);
 	}
 
diff --git a/drivers/ide/at91_ide.c b/drivers/ide/at91_ide.c
index 000a78e..d9192e6 100644
--- a/drivers/ide/at91_ide.c
+++ b/drivers/ide/at91_ide.c
@@ -70,6 +70,7 @@ static void set_smc_timings(const u8 chipselect, const u16 cycle,
 			    const u16 setup, const u16 pulse,
 			    const u16 data_float, int use_iordy)
 {
+	u16 ncs_rd_pulse;
 	unsigned long mode = AT91_SMC_READMODE | AT91_SMC_WRITEMODE |
 			     AT91_SMC_BAT_SELECT;
 
@@ -81,19 +82,29 @@ static void set_smc_timings(const u8 chipselect, const u16 cycle,
 	if (data_float)
 		mode |= AT91_SMC_TDF_(data_float);
 
+	ncs_rd_pulse = cycle;
+	if (ncs_rd_pulse > 63) {
+		ncs_rd_pulse = 63;
+		pr_warn(DRV_NAME ": ncs_rd_pulse limited to maximal value %d\n",
+			ncs_rd_pulse);
+	}
+
 	at91_sys_write(AT91_SMC_MODE(chipselect), mode);
 
 	/* setup timings in SMC */
-	at91_sys_write(AT91_SMC_SETUP(chipselect), AT91_SMC_NWESETUP_(setup) |
-						   AT91_SMC_NCS_WRSETUP_(0) |
-						   AT91_SMC_NRDSETUP_(setup) |
-						   AT91_SMC_NCS_RDSETUP_(0));
-	at91_sys_write(AT91_SMC_PULSE(chipselect), AT91_SMC_NWEPULSE_(pulse) |
-						   AT91_SMC_NCS_WRPULSE_(cycle) |
-						   AT91_SMC_NRDPULSE_(pulse) |
-						   AT91_SMC_NCS_RDPULSE_(cycle));
-	at91_sys_write(AT91_SMC_CYCLE(chipselect), AT91_SMC_NWECYCLE_(cycle) |
-						   AT91_SMC_NRDCYCLE_(cycle));
+	at91_sys_write(AT91_SMC_SETUP(chipselect),
+			AT91_SMC_NWESETUP_(setup) |
+			AT91_SMC_NCS_WRSETUP_(0) |
+			AT91_SMC_NRDSETUP_(setup) |
+			AT91_SMC_NCS_RDSETUP_(0));
+	at91_sys_write(AT91_SMC_PULSE(chipselect),
+			AT91_SMC_NWEPULSE_(pulse) |
+			AT91_SMC_NCS_WRPULSE_(ncs_rd_pulse) |
+			AT91_SMC_NRDPULSE_(pulse) |
+			AT91_SMC_NCS_RDPULSE_(ncs_rd_pulse));
+	at91_sys_write(AT91_SMC_CYCLE(chipselect),
+			AT91_SMC_NWECYCLE_(cycle) |
+			AT91_SMC_NRDCYCLE_(cycle));
 }
 
 static unsigned int calc_mck_cycles(unsigned int ns, unsigned int mck_hz)
-- 
1.7.0.4

