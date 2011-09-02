Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090Ab1IBCLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 22:11:12 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:39323 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933019Ab1IBCLM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 22:11:12 -0400
From: Philip Rakity <prakity@marvell.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 1 Sep 2011 19:11:16 -0700
Subject: [PATCH 2/2] power: max8925_power.c Check at probe time if power to
  set online
Thread-Topic: [PATCH 2/2] power: max8925_power.c Check at probe time if
 power to  set online
Thread-Index: AcxpFZTAVYjpB1tHQvuMVoiLAyW1dQ==
Message-ID: <D3390D73-F351-438B-8D25-928539495DC8@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interrupt for ac on/off can be missed during boot time.
Check if online by seeing if we have power.  We choose 0.5V
since this is high enough to avoid random reading from a
input that could be floating if no charger.

Signed-off-by: Philip Rakity <prakity@marvell.com>
Signed-off-by: Ted Bennett <tbennett@marvell.com>
---
 drivers/power/max8925_power.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
index b56c78a..31d84c4 100644
--- a/drivers/power/max8925_power.c
+++ b/drivers/power/max8925_power.c
@@ -495,9 +495,15 @@ static __devinit int max8925_init_charger(struct max8925_chip *chip,
 	REQUEST_IRQ(MAX8925_IRQ_VCHG_TOPOFF, "charger-topoff");
 	REQUEST_IRQ(MAX8925_IRQ_VCHG_TMR_FAULT, "charger-timer-expire");
 
-	info->ac_online = 0;
 	info->usb_online = 0;
 	info->bat_online = 0;
+
+	/* check for power - can miss interrupt at boot time */
+	if (start_measure(info, MEASURE_VCHG) * 2000 > 500000)
+		info->ac_online = 1;
+	else
+		info->ac_online = 0;
+
 	ret = max8925_reg_read(info->gpm, MAX8925_CHG_STATUS);
 	if (ret >= 0) {
 		/*
-- 
1.7.6


