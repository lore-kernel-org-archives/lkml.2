Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab2LWJy7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 04:54:59 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:64582 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab2LWJy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 04:54:56 -0500
Date: Sun, 23 Dec 2012 01:54:50 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-input@vger.kernel.org
Subject: Re: [PATCH 17/25] wm97xx: don't use [delayed_]work_pending()
Message-ID: <20121223095450.GA17407@core.coreip.homeip.net>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-18-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356141435-17340-18-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Fri, Dec 21, 2012 at 05:57:07PM -0800, Tejun Heo wrote:
> There's no need to test whether a (delayed) work item in pending
> before queueing, flushing or cancelling it.  Most uses are unnecessary
> and quite a few of them are buggy.
> 
> Remove unnecessary pending tests from wm97xx.  Instead of testing
> work_pending(), use the return value of queue_work() to decide whether
> to disable IRQ or not.
> 
> Only compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> Cc: linux-input@vger.kernel.org
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
> Please let me know how this patch should be routed.  I can take it
> through the workqueue tree if necessary.
> 
> Thanks.
> 
>  drivers/input/touchscreen/wm97xx-core.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/wm97xx-core.c b/drivers/input/touchscreen/wm97xx-core.c
> index 5dbe73a..fd16c63 100644
> --- a/drivers/input/touchscreen/wm97xx-core.c
> +++ b/drivers/input/touchscreen/wm97xx-core.c
> @@ -363,10 +363,8 @@ static irqreturn_t wm97xx_pen_interrupt(int irq, void *dev_id)
>  {
>  	struct wm97xx *wm = dev_id;
>  
> -	if (!work_pending(&wm->pen_event_work)) {
> +	if (queue_work(wm->ts_workq, &wm->pen_event_work))
>  		wm->mach_ops->irq_enable(wm, 0);
> -		queue_work(wm->ts_workq, &wm->pen_event_work);
> -	}
>  

This is not 100% equivalent transformation as now we schedule first and
disable IRQ later... Anyway, I think the driver shoudl be converted to
threaded IRQ instead. Mark, does the patch below make any sense to you?

Thanks.

-- 
Dmitry


Input: wm97xx - switch to using threaded IRQ

Instead of manually disabling and enabling interrupts and scheduling work to
access the device, let's use threaded oneshot interrupt handler. It simplifies
things.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/touchscreen/wm97xx-core.c |   42 +++++--------------------------
 include/linux/wm97xx.h                  |    1 -
 2 files changed, 7 insertions(+), 36 deletions(-)

diff --git a/drivers/input/touchscreen/wm97xx-core.c b/drivers/input/touchscreen/wm97xx-core.c
index 5dbe73a..bf5eddf 100644
--- a/drivers/input/touchscreen/wm97xx-core.c
+++ b/drivers/input/touchscreen/wm97xx-core.c
@@ -289,11 +289,12 @@ void wm97xx_set_suspend_mode(struct wm97xx *wm, u16 mode)
 EXPORT_SYMBOL_GPL(wm97xx_set_suspend_mode);
 
 /*
- * Handle a pen down interrupt.
+ * Codec PENDOWN irq handler
+ *
  */
-static void wm97xx_pen_irq_worker(struct work_struct *work)
+static irqreturn_t wm97xx_pen_interrupt(int irq, void *dev_id)
 {
-	struct wm97xx *wm = container_of(work, struct wm97xx, pen_event_work);
+	struct wm97xx *wm = dev_id;
 	int pen_was_down = wm->pen_is_down;
 
 	/* do we need to enable the touch panel reader */
@@ -347,27 +348,6 @@ static void wm97xx_pen_irq_worker(struct work_struct *work)
 	if (!wm->pen_is_down && wm->mach_ops->acc_enabled)
 		wm->mach_ops->acc_pen_up(wm);
 
-	wm->mach_ops->irq_enable(wm, 1);
-}
-
-/*
- * Codec PENDOWN irq handler
- *
- * We have to disable the codec interrupt in the handler because it
- * can take up to 1ms to clear the interrupt source. We schedule a task
- * in a work queue to do the actual interaction with the chip.  The
- * interrupt is then enabled again in the slow handler when the source
- * has been cleared.
- */
-static irqreturn_t wm97xx_pen_interrupt(int irq, void *dev_id)
-{
-	struct wm97xx *wm = dev_id;
-
-	if (!work_pending(&wm->pen_event_work)) {
-		wm->mach_ops->irq_enable(wm, 0);
-		queue_work(wm->ts_workq, &wm->pen_event_work);
-	}
-
 	return IRQ_HANDLED;
 }
 
@@ -378,12 +358,9 @@ static int wm97xx_init_pen_irq(struct wm97xx *wm)
 {
 	u16 reg;
 
-	/* If an interrupt is supplied an IRQ enable operation must also be
-	 * provided. */
-	BUG_ON(!wm->mach_ops->irq_enable);
-
-	if (request_irq(wm->pen_irq, wm97xx_pen_interrupt, IRQF_SHARED,
-			"wm97xx-pen", wm)) {
+	if (request_threaded_irq(wm->pen_irq, NULL, wm97xx_pen_interrupt,
+				 IRQF_SHARED | IRQF_ONESHOT,
+				 "wm97xx-pen", wm)) {
 		dev_err(wm->dev,
 			"Failed to register pen down interrupt, polling");
 		wm->pen_irq = 0;
@@ -502,7 +479,6 @@ static int wm97xx_ts_input_open(struct input_dev *idev)
 	wm->codec->dig_enable(wm, 1);
 
 	INIT_DELAYED_WORK(&wm->ts_reader, wm97xx_ts_reader);
-	INIT_WORK(&wm->pen_event_work, wm97xx_pen_irq_worker);
 
 	wm->ts_reader_min_interval = HZ >= 100 ? HZ / 100 : 1;
 	if (wm->ts_reader_min_interval < 1)
@@ -553,10 +529,6 @@ static void wm97xx_ts_input_close(struct input_dev *idev)
 
 	wm->pen_is_down = 0;
 
-	/* Balance out interrupt disables/enables */
-	if (cancel_work_sync(&wm->pen_event_work))
-		wm->mach_ops->irq_enable(wm, 1);
-
 	/* ts_reader rearms itself so we need to explicitly stop it
 	 * before we destroy the workqueue.
 	 */
diff --git a/include/linux/wm97xx.h b/include/linux/wm97xx.h
index fd98bb9..12f793d 100644
--- a/include/linux/wm97xx.h
+++ b/include/linux/wm97xx.h
@@ -280,7 +280,6 @@ struct wm97xx {
 	unsigned long ts_reader_min_interval; /* Minimum interval */
 	unsigned int pen_irq;		/* Pen IRQ number in use */
 	struct workqueue_struct *ts_workq;
-	struct work_struct pen_event_work;
 	u16 acc_slot;			/* AC97 slot used for acc touch data */
 	u16 acc_rate;			/* acc touch data rate */
 	unsigned pen_is_down:1;		/* Pen is down */
