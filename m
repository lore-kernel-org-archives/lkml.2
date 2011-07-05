Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab1GEVqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 17:46:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752179Ab1GEVqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 17:46:52 -0400
Date: Tue, 5 Jul 2011 14:46:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?Jean-Fran=E7ois?= Dagenais <dagenaisj@sonatest.com>
Cc: <linux-kernel@vger.kernel.org>, <johnpol@2ka.mipt.ru>,
        "Paul Parsons" <lost.distance@yahoo.com>
Subject: Re: [PATCH] w1: ds1wm: add a reset recovery parameter
Message-Id: <20110705144606.3cc66260.akpm@linux-foundation.org>
In-Reply-To: <4D9136CA-90AC-4DBB-9AD1-44062FFCF9D4@sonatest.com>
References: <345355.5665.qm@web29002.mail.ird.yahoo.com>
	<4D9136CA-90AC-4DBB-9AD1-44062FFCF9D4@sonatest.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jun 2011 09:17:58 -0400
Jean-Fran__ois Dagenais <dagenaisj@sonatest.com> wrote:

> This follows the regression on 3.0 reported by Paul Parsons regarding
> the removal of the msleep(1) in the ds1wm_reset() function. This
> sleep should not be required on normal circuitry provided the
> pull-ups on the bus are correctly adapted to the slaves.
> Unfortunately, this is not always the case. The sleep is restored
> but as a parameter to the probe function in the pdata.

A few things.

- When fixing a bug, please fully describe that bug in the changelog.
  So that others can determine whether your patch might fix a bug
  which they are observing.

  That's not so important when we're fixing a regression which was
  introduced since the most recent major kernel release, but it's good
  practice and who knows, someone might have backported the
  regression-introducing patch.

- The patch was missing your signed-off-by.  I added it.  Please
  ack this.

- It's conventional to give bug-reporters a hat tip via the
  Reported-by: tag.

Here's what I merged:


From: Jean-Fran_ois Dagenais <dagenaisj@sonatest.com>

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
Signed-off-by: Jean-Fran_ois Dagenais <dagenaisj@sonatest.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/asic3.c        |    1 +
 drivers/mfd/htc-pasic3.c   |    1 +
 drivers/w1/masters/ds1wm.c |    5 +++++
 include/linux/mfd/ds1wm.h  |    7 +++++++
 4 files changed, 14 insertions(+)

diff -puN drivers/mfd/asic3.c~w1-ds1wm-add-a-reset-recovery-parameter drivers/mfd/asic3.c
--- a/drivers/mfd/asic3.c~w1-ds1wm-add-a-reset-recovery-parameter
+++ a/drivers/mfd/asic3.c
@@ -619,6 +619,7 @@ static void asic3_clk_disable(struct asi
 /* MFD cells (SPI, PWM, LED, DS1WM, MMC) */
 static struct ds1wm_driver_data ds1wm_pdata = {
 	.active_high = 1,
+	.reset_recover_delay = 1,
 };
 
 static struct resource ds1wm_resources[] = {
diff -puN drivers/mfd/htc-pasic3.c~w1-ds1wm-add-a-reset-recovery-parameter drivers/mfd/htc-pasic3.c
--- a/drivers/mfd/htc-pasic3.c~w1-ds1wm-add-a-reset-recovery-parameter
+++ a/drivers/mfd/htc-pasic3.c
@@ -99,6 +99,7 @@ static int ds1wm_disable(struct platform
 
 static struct ds1wm_driver_data ds1wm_pdata = {
 	.active_high = 0,
+	.reset_recover_delay = 1,
 };
 
 static struct resource ds1wm_resources[] __initdata = {
diff -puN drivers/w1/masters/ds1wm.c~w1-ds1wm-add-a-reset-recovery-parameter drivers/w1/masters/ds1wm.c
--- a/drivers/w1/masters/ds1wm.c~w1-ds1wm-add-a-reset-recovery-parameter
+++ a/drivers/w1/masters/ds1wm.c
@@ -109,6 +109,7 @@ struct ds1wm_data {
 	/* byte to write that makes all intr disabled, */
 	/* considering active_state (IAS) (optimization) */
 	u8       int_en_reg_none;
+	unsigned int reset_recover_delay; /* see ds1wm.h */
 };
 
 static inline void ds1wm_write_register(struct ds1wm_data *ds1wm_data, u32 reg,
@@ -187,6 +188,9 @@ static int ds1wm_reset(struct ds1wm_data
 		return 1;
 	}
 
+	if(ds1wm_data->reset_recover_delay)
+		msleep(ds1wm_data->reset_recover_delay);
+
 	return 0;
 }
 
@@ -490,6 +494,7 @@ static int ds1wm_probe(struct platform_d
 	}
 	ds1wm_data->irq = res->start;
 	ds1wm_data->int_en_reg_none = (plat->active_high ? DS1WM_INTEN_IAS : 0);
+	ds1wm_data->reset_recover_delay = plat->reset_recover_delay;
 
 	if (res->flags & IORESOURCE_IRQ_HIGHEDGE)
 		irq_set_irq_type(ds1wm_data->irq, IRQ_TYPE_EDGE_RISING);
diff -puN include/linux/mfd/ds1wm.h~w1-ds1wm-add-a-reset-recovery-parameter include/linux/mfd/ds1wm.h
--- a/include/linux/mfd/ds1wm.h~w1-ds1wm-add-a-reset-recovery-parameter
+++ a/include/linux/mfd/ds1wm.h
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
_


