Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab2ACWjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:39:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40080 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949Ab2ACWjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:39:24 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:21 2012
Message-Id: <20120103223321.257216175@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:32:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>,
        John Stultz <john.stultz@linaro.org>
Subject: [03/75] rtc: Expire alarms after the time is set.
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 93b2ec0128c431148b216b8f7337c1a52131ef03 upstream.

If the alarm time programming in the rtc is ever in the past, it won't fire,
and any other alarm will be queued after it so they won't fire either.

So any time that the alarm might be in the past, we need to trigger
the irq handler to ensure the old alarm is cleared and the timer queue
is fully in the future.

This can happen:
 - when we first initialise the alarm
 - when we set the time in the rtc.

so follow both of these by scheduling the timer work function.

Signed-off-by: NeilBrown <neilb@suse.de>
[Also catch set_mmss case -jstultz]
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/interface.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -72,6 +72,8 @@ int rtc_set_time(struct rtc_device *rtc,
 		err = -EINVAL;
 
 	mutex_unlock(&rtc->ops_lock);
+	/* A timer might have just expired */
+	schedule_work(&rtc->irqwork);
 	return err;
 }
 EXPORT_SYMBOL_GPL(rtc_set_time);
@@ -111,6 +113,8 @@ int rtc_set_mmss(struct rtc_device *rtc,
 		err = -EINVAL;
 
 	mutex_unlock(&rtc->ops_lock);
+	/* A timer might have just expired */
+	schedule_work(&rtc->irqwork);
 
 	return err;
 }
@@ -402,6 +406,8 @@ int rtc_initialize_alarm(struct rtc_devi
 		timerqueue_add(&rtc->timerqueue, &rtc->aie_timer.node);
 	}
 	mutex_unlock(&rtc->ops_lock);
+	/* maybe that was in the past.*/
+	schedule_work(&rtc->irqwork);
 	return err;
 }
 EXPORT_SYMBOL_GPL(rtc_initialize_alarm);


