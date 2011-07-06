Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab1GFNQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 09:16:10 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42572 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab1GFNQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 09:16:08 -0400
From: "=?UTF-8?q?Jean-Fran=C3=A7ois=20Dagenais?=" <jeff.dagenais@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Jean-Fran=C3=A7ois=20Dagenais?= <dagenaisj@sonatest.com>,
        akpm@linux-foundation.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [patch v2] w1: ds1wm: add a reset recovery parameter
Date: Wed,  6 Jul 2011 09:15:55 -0400
Message-Id: <1309958155-7609-1-git-send-email-dagenaisj@sonatest.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This follows the regression reported by Paul Parsons regarding
the removal of the msleep(1) in the ds1wm_reset() function. This
sleep should not be required on normal circuitry provided the
pull-ups on the bus are correctly adapted to the slaves.
Unfortunately, this is not always the case. The sleep is restored
but as a parameter to the probe function in the pdata.

This fixes a regression on 3.0 reported by Paul Parsons regarding the
removal of the msleep(1) in the ds1wm_reset() function:

: The linux-3.0-rc4 DS1WM 1-wire driver is logging "bus error, retrying"
: error messages on an HP iPAQ hx4700 PDA (XScale-PXA270):
:
: <snip>
: Driver for 1-wire Dallas network protocol.
: DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
: 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
: ds1wm ds1wm: pass: 1 bus error, retrying
: ds1wm ds1wm: pass: 2 bus error, retrying
: ds1wm ds1wm: pass: 3 bus error, retrying
: ds1wm ds1wm: pass: 4 bus error, retrying
: ds1wm ds1wm: pass: 5 bus error, retrying
: ...
:
: The visible result is that the battery charging LED is erratic; sometimes
: it works, mostly it doesn't.
:
: The linux-2.6.39 DS1WM 1-wire driver worked OK.  I haven't tried 3.0-rc1,
: 3.0-rc2, or 3.0-rc3.

This sleep should not be required on normal circuitry provided the
pull-ups on the bus are correctly adapted to the slaves.  Unfortunately,
this is not always the case.  The sleep is restored but as a parameter to
the probe function in the pdata.

Reported-by: Paul Parsons <lost.distance@yahoo.com>
Tested-by: Paul Parsons <lost.distance@yahoo.com>
Signed-off-by: Jean-François Dagenais <dagenaisj@sonatest.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

