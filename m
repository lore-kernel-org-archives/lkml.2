Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759865Ab1F0NT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 09:19:28 -0400
Received: from smarthost3.mail.uk.easynet.net ([212.135.6.13]:42602 "EHLO
	smarthost3.mail.uk.easynet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932133Ab1F0NRb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 09:17:31 -0400
thread-index: Acw0zJ7UBis36n6LQvyDELlBvoXt/Q==
References: <345355.5665.qm@web29002.mail.ird.yahoo.com>
In-Reply-To: <345355.5665.qm@web29002.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Message-ID: <4D9136CA-90AC-4DBB-9AD1-44062FFCF9D4@sonatest.com>
Content-Transfer-Encoding: 8BIT
Cc: <johnpol@2ka.mipt.ru>, "Paul Parsons" <lost.distance@yahoo.com>
From: =?iso-8859-1?Q?Jean-Fran=E7ois_Dagenais?= <dagenaisj@sonatest.com>
Content-Class: urn:content-classes:message
Importance: normal
Subject: [PATCH] w1: ds1wm: add a reset recovery parameter
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4841
Date: Mon, 27 Jun 2011 09:17:58 -0400
To: <linux-kernel@vger.kernel.org>
X-Mailer: Apple Mail (2.1084)
X-OriginalArrivalTime: 27 Jun 2011 13:17:52.0680 (UTC) FILETIME=[9EA9C280:01CC34CC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This follows the regression on 3.0 reported by Paul Parsons regarding
the removal of the msleep(1) in the ds1wm_reset() function. This
sleep should not be required on normal circuitry provided the
pull-ups on the bus are correctly adapted to the slaves.
Unfortunately, this is not always the case. The sleep is restored
but as a parameter to the probe function in the pdata.
---
 drivers/mfd/asic3.c        |    1 +
 drivers/mfd/htc-pasic3.c   |    1 +
 drivers/w1/masters/ds1wm.c |    5 +++++
 include/linux/mfd/ds1wm.h  |    7 +++++++
 4 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index c27fd1f..c71ae09 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -619,6 +619,7 @@ static void asic3_clk_disable(struct asic3 *asic, struct asic3_clk *clk)
 /* MFD cells (SPI, PWM, LED, DS1WM, MMC) */
 static struct ds1wm_driver_data ds1wm_pdata = {
 	.active_high = 1,
+	.reset_recover_delay = 1,
 };
 
 static struct resource ds1wm_resources[] = {
diff --git a/drivers/mfd/htc-pasic3.c b/drivers/mfd/htc-pasic3.c
index 2808bd1..04c7093 100644
--- a/drivers/mfd/htc-pasic3.c
+++ b/drivers/mfd/htc-pasic3.c
@@ -99,6 +99,7 @@ static int ds1wm_disable(struct platform_device *pdev)
 
 static struct ds1wm_driver_data ds1wm_pdata = {
 	.active_high = 0,
+	.reset_recover_delay = 1,
 };
 
 static struct resource ds1wm_resources[] __initdata = {
diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index ad57593..66bf82f 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -109,6 +109,7 @@ struct ds1wm_data {
 	/* byte to write that makes all intr disabled, */
 	/* considering active_state (IAS) (optimization) */
 	u8       int_en_reg_none;
+	unsigned int reset_recover_delay; /* see ds1wm.h */
 };
 
 static inline void ds1wm_write_register(struct ds1wm_data *ds1wm_data, u32 reg,
@@ -187,6 +188,9 @@ static int ds1wm_reset(struct ds1wm_data *ds1wm_data)
 		return 1;
 	}
 
+	if(ds1wm_data->reset_recover_delay)
+		msleep(ds1wm_data->reset_recover_delay);
+
 	return 0;
 }
 
@@ -490,6 +494,7 @@ static int ds1wm_probe(struct platform_device *pdev)
 	}
 	ds1wm_data->irq = res->start;
 	ds1wm_data->int_en_reg_none = (plat->active_high ? DS1WM_INTEN_IAS : 0);
+	ds1wm_data->reset_recover_delay = plat->reset_recover_delay;
 
 	if (res->flags & IORESOURCE_IRQ_HIGHEDGE)
 		irq_set_irq_type(ds1wm_data->irq, IRQ_TYPE_EDGE_RISING);
diff --git a/include/linux/mfd/ds1wm.h b/include/linux/mfd/ds1wm.h
index be469a3..068044f 100644
--- a/include/linux/mfd/ds1wm.h
+++ b/include/linux/mfd/ds1wm.h
@@ -3,4 +3,11 @@
 struct ds1wm_driver_data {
 	int active_high;
 	int clock_rate;
+	/* in milliseconds, the amount of time to */
+	/* sleep following a reset pulse. Zero    */
+	/* should work if your bus devices recover*/
+	/* time respects the 1-wire spec since the*/
+	/* ds1wm implements the precise timings of*/
+	/* a reset pulse/presence detect sequence.*/ 
+	unsigned int reset_recover_delay;
 };
-- 
1.7.5.4

Jean-Francois Dagenais 
Software Architect - B.Sc.A


Experience the new veo phased array flaw detector at www.sonatestveo.com.


Sonatest AP
2900 chemin des Quatre-Bourgeois
Bureau 305
Quebec City Quebec G1V 1Y4

T| +1 (418) 683 6222 x106   F| +1 (418) 683 7032   M|    W| www.sonatest.com



This message (and any associated files) is intended only for the use of linux-kernel@vger.kernel.org, johnpol@2ka.mipt.ru, lost.distance@yahoo.com and may contain information that is confidential, subject to copyright or constitutes a trade secret. If you are not the above recipient(s) you are hereby notified that any dissemination, copying or distribution of this message, or files associated with this message, is strictly prohibited. If you have received this message in error, please notify us immediately by replying to the message and deleting it from your computer. Any views or opinions presented are solely those of the author and do not necessarily represent those of the company.

Think green - help the environment by not printing this email.
