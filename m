Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab1I1Wj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:39:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53727 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932127Ab1I1Wj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:39:56 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:31 2011
Message-Id: <20110928220131.468883156@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: [059/244] alarmtimers: Avoid possible denial of service with high freq periodic timers
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John Stultz <john.stultz@linaro.org>

commit 6af7e471e5a7746b8024d70b4363d3dfe41d36b8 upstream.

Its possible to jam up the alarm timers by setting very small interval
timers, which will cause the alarmtimer subsystem to spend all of its time
firing and restarting timers. This can effectivly lock up a box.

A deeper fix is needed, closely mimicking the hrtimer code, but for now
just cap the interval to 100us to avoid userland hanging the system.

CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/alarmtimer.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -481,6 +481,15 @@ static int alarm_timer_set(struct k_itim
 	if (!rtcdev)
 		return -ENOTSUPP;
 
+	/*
+	 * XXX HACK! Currently we can DOS a system if the interval
+	 * period on alarmtimers is too small. Cap the interval here
+	 * to 100us and solve this properly in a future patch! -jstultz
+	 */
+	if ((new_setting->it_interval.tv_sec == 0) &&
+			(new_setting->it_interval.tv_nsec < 100000))
+		new_setting->it_interval.tv_nsec = 100000;
+
 	if (old_setting)
 		alarm_timer_get(timr, old_setting);
 


