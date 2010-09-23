Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab0IWFfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 01:35:20 -0400
Received: from imr4.ericy.com ([198.24.6.8]:50779 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942Ab0IWFfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 01:35:19 -0400
Date: Wed, 22 Sep 2010 22:33:48 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: "samu.p.onkalo@nokia.com" <samu.p.onkalo@nokia.com>
CC: "tiwai@suse.de" <tiwai@suse.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Eric.Piel@tremplin-utc.net" <Eric.Piel@tremplin-utc.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH resent] lis3: Fix Oops with NULL platform
 data
Message-ID: <20100923053348.GA11775@ericsson.com>
References: <s5htyli811o.wl%tiwai@suse.de>
 <62697B07E9803846BC582181BD6FB6B831300D2218@NOK-EUMSG-02.mgdnok.nokia.com>
 <s5h8w2t99gk.wl%tiwai@suse.de>
 <62697B07E9803846BC582181BD6FB6B835EF20D9D1@NOK-EUMSG-02.mgdnok.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <62697B07E9803846BC582181BD6FB6B835EF20D9D1@NOK-EUMSG-02.mgdnok.nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 01:06:22AM -0400, samu.p.onkalo@nokia.com wrote:
> Added lm-sensors list...
> 
> >-----Original Message-----
> >From: ext Takashi Iwai [mailto:tiwai@suse.de]
> >Sent: 22 September, 2010 16:47
> >To: Onkalo Samu.P (Nokia-MS/Tampere)
> >Cc: akpm@linux-foundation.org; Eric.Piel@tremplin-utc.net; linux-
> >kernel@vger.kernel.org
> >Subject: Re: [PATCH resent] lis3: Fix Oops with NULL platform data
> >
> >At Wed, 22 Sep 2010 13:56:15 +0200,
> ><samu.p.onkalo@nokia.com> wrote:
> >>
> >>
> >> Hi
> >>
> >> >-----Original Message-----
> >> >From: ext Takashi Iwai [mailto:tiwai@suse.de]
> >> >Sent: 22 September, 2010 14:34
> >> >To: Andrew Morton
> >> >Cc: Onkalo Samu.P (Nokia-MS/Tampere); Éric Piel; linux-
> >> >kernel@vger.kernel.org
> >> >Subject: [PATCH resent] lis3: Fix Oops with NULL platform data
> >> >
> >> >The recent addition of threaded irq handler causes a NULL dereference
> >> >when used with hp_accel driver, which has NULL pdata.
> >> >
> >> >Cc: <stable@kernel.org>
> >> >Signed-off-by: Takashi Iwai <tiwai@suse.de>
> >> >---
> >> >
> >> >This should go to 2.6.36 and 2.6.35-stable tree.
> >> >
> >> > drivers/hwmon/lis3lv02d.c |    6 ++++--
> >> > 1 files changed, 4 insertions(+), 2 deletions(-)
> >> >
> >> >diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
> >> >index 5e15967..1c266ec 100644
> >> >--- a/drivers/hwmon/lis3lv02d.c
> >> >+++ b/drivers/hwmon/lis3lv02d.c
> >> >@@ -354,7 +354,8 @@ static irqreturn_t
> >lis302dl_interrupt_thread1_8b(int
> >> >irq, void *data)
> >> >
> >> > 	struct lis3lv02d *lis3 = data;
> >> >
> >> >-	if ((lis3->pdata->irq_cfg & LIS3_IRQ1_MASK) == LIS3_IRQ1_CLICK)
> >> >+	if (lis3->pdata &&
> >> >+	    (lis3->pdata->irq_cfg & LIS3_IRQ1_MASK) == LIS3_IRQ1_CLICK)
> >> > 		lis302dl_interrupt_handle_click(lis3);
> >> > 	else
> >> > 		lis302dl_interrupt_handle_ff_wu(lis3);
> >> >@@ -367,7 +368,8 @@ static irqreturn_t
> >lis302dl_interrupt_thread2_8b(int
> >> >irq, void *data)
> >> >
> >> > 	struct lis3lv02d *lis3 = data;
> >> >
> >> >-	if ((lis3->pdata->irq_cfg & LIS3_IRQ2_MASK) == LIS3_IRQ2_CLICK)
> >> >+	if (lis3->pdata &&
> >> >+	    (lis3->pdata->irq_cfg & LIS3_IRQ2_MASK) == LIS3_IRQ2_CLICK)
> >> > 		lis302dl_interrupt_handle_click(lis3);
> >> > 	else
> >> > 		lis302dl_interrupt_handle_ff_wu(lis3);
> >>
> >> Yes, that will remove the kernel oops definitely, but I'm wondering if
> >> this thread should be executed at all if there is no pdata available.
> >
> >We may control the caller of request_threaded_irq(), instead.
> >The revised patch is below.  (With this patch, the patch for the new
> >LIS3CD chip must be revised, too.)
> >
> >> Eric, is it so that in laptops interrupts are used for free fall
> >detection
> >> and polled input device is for joystick?
> >
> >Yes, it's so for HP laptops.
> >
> >> Interrupts can (and are used) also for other purposes but in that case
> >> some additional configurations are done based on platform data.
> >>
> >> With this patch, there are just some additional input event refreshes
> >in
> >> top of polled device updates. It should really not matter. So,
> >>
> >> Acked-by: Samu Onkalo <samu.p.onkalo@nokia.com>
> >>
> >> -Samu
> >
> >
> >thanks,
> >
> >Takashi
> >
> >===
> >From 0e5bdc7516915e92fe471a77da36ecb75d995c0f Mon Sep 17 00:00:00 2001
> >From: Takashi Iwai <tiwai@suse.de>
> >Date: Wed, 22 Sep 2010 12:16:04 +0200
> >Subject: [PATCH] lis3: Fix Oops with NULL platform data
> >
> >The recent addition of threaded irq handler causes a NULL dereference
> >when used with hp_accel driver, which has NULL pdata.
> >
> >Signed-off-by: Takashi Iwai <tiwai@suse.de>
> >---
> >this version avoids the unnecessary thread_irq call instead of checking
> >pdata in the irq handler.
> >
> > drivers/hwmon/lis3lv02d.c |    4 ++--
> > 1 files changed, 2 insertions(+), 2 deletions(-)
> >
> >diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
> >index 5e15967..0a24177 100644
> >--- a/drivers/hwmon/lis3lv02d.c
> >+++ b/drivers/hwmon/lis3lv02d.c
> >@@ -301,7 +301,7 @@ static irqreturn_t lis302dl_interrupt(int irq, void
> >*dummy)
> > 	wake_up_interruptible(&lis3_dev.misc_wait);
> > 	kill_fasync(&lis3_dev.async_queue, SIGIO, POLL_IN);
> > out:
> >-	if (lis3_dev.whoami == WAI_8B && lis3_dev.idev &&
> >+	if (lis3_dev.pdata && lis3_dev.whoami == WAI_8B && lis3_dev.idev
> >&&
> > 	    lis3_dev.idev->input->users)
> > 		return IRQ_WAKE_THREAD;
> > 	return IRQ_HANDLED;
> >@@ -742,7 +742,7 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
> > 	 * io-apic is not configurable (and generates a warning) but I
> >keep it
> > 	 * in case of support for other hardware.
> > 	 */
> >-	if (dev->whoami == WAI_8B)
> >+	if (dev->pdata && dev->whoami == WAI_8B)
> > 		thread_fn = lis302dl_interrupt_thread1_8b;
> > 	else
> > 		thread_fn = NULL;
> >--
> 
> 
> With hp_accel.c irq-thread is not needed so this is ok from that point of view.
> On the other hand, wakeup / click flags are not configured without platformdata
> so there is no need to run irq-thread. If the pdata is not prodived at all
> there is no need to IRQ thread.
> 
> Acked-by: Samu Onkalo <samu.p.onkalo@nokia.com>
> 
Looks ok to me.

Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>

