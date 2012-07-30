Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab2G3BJw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 21:09:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab2G3BJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 21:09:50 -0400
From: NeilBrown <neilb@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Mon, 30 Jul 2012 11:09:02 +1000
Subject: [PATCH 1/2] Input: gpio_keys: report a wakeup_event for a button
 press on a wake_up button.
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, NeilBrown <neilb@suse.de>
Message-ID: <20120730010901.22579.83689.stgit@notabene.brown>
In-Reply-To: <20120730010746.22579.52841.stgit@notabene.brown>
References: <20120730010746.22579.52841.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to avoid races with suspend, a wakeup event must register as
such by calling pm_wakeup_event() or pm_stay_awake().  This will ensure
that the current suspend cycle aborts.

When the user-space visible event is created in the interrupt handler
(gpio_keys_irq_isr), a simple pm_wakeup_event() with no delay is
sufficient as suspend will synchronise with all interrupt delivery.

When the user-space visible event is created later
(gpio_keys_gpio_isr), we need to bracket the event with
pm_stay_awake() and pm_relax().

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/input/keyboard/gpio_keys.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 62bfce4..ee6e525 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -346,6 +346,8 @@ static void gpio_keys_gpio_work_func(struct work_struct *work)
 		container_of(work, struct gpio_button_data, work);
 
 	gpio_keys_gpio_report_event(bdata);
+	if (bdata->button->wakeup)
+		pm_relax(bdata->input->dev.parent);
 }
 
 static void gpio_keys_gpio_timer(unsigned long _data)
@@ -361,6 +363,8 @@ static irqreturn_t gpio_keys_gpio_isr(int irq, void *dev_id)
 
 	BUG_ON(irq != bdata->irq);
 
+	if (bdata->button->wakeup)
+		pm_stay_awake(bdata->input->dev.parent);
 	if (bdata->timer_debounce)
 		mod_timer(&bdata->timer,
 			jiffies + msecs_to_jiffies(bdata->timer_debounce));
@@ -397,6 +401,9 @@ static irqreturn_t gpio_keys_irq_isr(int irq, void *dev_id)
 	spin_lock_irqsave(&bdata->lock, flags);
 
 	if (!bdata->key_pressed) {
+		if (bdata->button->wakeup)
+			pm_wakeup_event(bdata->input->dev.parent, 0);
+
 		input_event(input, EV_KEY, button->code, 1);
 		input_sync(input);
 


