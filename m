Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab1HCXqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:46:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33297 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937Ab1HCXZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:25:18 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:45 2011
Message-Id: <20110803221245.578845175@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:00:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Ben Greear <greearb@candelatech.com>
Subject: [015/102] rtc: handle errors correctly in rtc_irq_set_state()
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 2c4f57d12df7696d65b0247bfd57fd082a7719e6 upstream.

The code checks the correctness of the parameters, but unconditionally
arms/disarms the hrtimer.

The result is that a random task might arm/disarm rtc timer and surprise
the real owner by either generating events or by stopping them.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ben Greear <greearb@candelatech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/interface.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -656,6 +656,8 @@ int rtc_irq_set_state(struct rtc_device
 		err = -EBUSY;
 	if (rtc->irq_task != task)
 		err = -EACCES;
+	if (err)
+		goto out;
 
 	if (enabled) {
 		ktime_t period = ktime_set(0, NSEC_PER_SEC/rtc->irq_freq);
@@ -664,6 +666,7 @@ int rtc_irq_set_state(struct rtc_device
 		hrtimer_cancel(&rtc->pie_timer);
 	}
 	rtc->pie_enabled = enabled;
+out:
 	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
 
 	return err;


