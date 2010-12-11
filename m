Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab0LKUpp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 15:45:45 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:33000 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab0LKUpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 15:45:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ns4HDLI3qe+w/NnVZVUo+f5QhUzEDUBI5q3ELNLnMVWvggjzP9w4Ildw/+w7Qkssy9
         NmqdTEEgUXpDsvL6rzSuTpdb2b+csKkxPZFlz5GBm63c9EJFZcBv978LpyUbX5LOfQbK
         nuvdCWMhSusLiNV0VWo0Li6R5RHvWXU49Q2bk=
From: Igor Plyatov <plyatov@gmail.com>
To: sshtylyov@mvista.com
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        geomatsi@gmail.com, nicolas.ferre@atmel.com, linux@maxim.org.za,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        christian.glindkamp@taskit.de, ryan@bluewatersys.com,
        pgsellmann@portner-elektronik.at, Igor Plyatov <plyatov@gmail.com>
Subject: [PATCH v2] ide: at91_ide.c bugfix for high master clock
Date: Sat, 11 Dec 2010 23:45:26 +0300
Message-Id: <1292100326-637-1-git-send-email-plyatov@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AT91SAM9 microcontrollers with master clock higher then 105 MHz
and PIO0, have overflow of the NCS_RD_PULSE value in the MSB. This
lead to "NCS_RD_PULSE" pulse longer then "NRD_CYCLE" pulse and driver
does not detect IDE device.

Signed-off-by: Igor Plyatov <plyatov@gmail.com>
---
 drivers/ide/at91_ide.c |   33 +++++++++++++++++++++++----------
 1 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/ide/at91_ide.c b/drivers/ide/at91_ide.c
index 000a78e..5f97710 100644
--- a/drivers/ide/at91_ide.c
+++ b/drivers/ide/at91_ide.c
@@ -36,6 +36,8 @@
 #define perr(fmt, args...) pr_err(DRV_NAME ": " fmt, ##args)
 #define pdbg(fmt, args...) pr_debug("%s " fmt, __func__, ##args)
 
+#define NCS_RD_PULSE_LIMIT  0x3f /* maximal value for pulse bitfields */
+
 /*
  * Access to IDE device is possible through EBI Static Memory Controller
  * with Compact Flash logic. For details see EBI and SMC datasheet sections
@@ -70,6 +72,7 @@ static void set_smc_timings(const u8 chipselect, const u16 cycle,
 			    const u16 setup, const u16 pulse,
 			    const u16 data_float, int use_iordy)
 {
+	u16 ncs_rd_pulse;
 	unsigned long mode = AT91_SMC_READMODE | AT91_SMC_WRITEMODE |
 			     AT91_SMC_BAT_SELECT;
 
@@ -81,19 +84,29 @@ static void set_smc_timings(const u8 chipselect, const u16 cycle,
 	if (data_float)
 		mode |= AT91_SMC_TDF_(data_float);
 
+	ncs_rd_pulse = cycle;
+	if (ncs_rd_pulse > NCS_RD_PULSE_LIMIT) {
+		ncs_rd_pulse = NCS_RD_PULSE_LIMIT;
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

