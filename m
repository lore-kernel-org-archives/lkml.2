Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab1AURwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:52:44 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:49053 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab1AURwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:52:42 -0500
From: Vernon Mauery <vernux@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Vernon Mauery <vernux@us.ibm.com>
Subject: [PATCH] Wait to remove active timer when rescheduling hrtimer
Date: Fri, 21 Jan 2011 09:52:30 -0800
Message-Id: <1295632350-10215-1-git-send-email-vernux@us.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current hrtimer implementation, when explicitly
removing a timer, the hrtimer_cancel function waits
until the timer is not currently running before actually
calling remove_hrtimer.  But in the __hrtimer_start_range_ns
function (called by hrtimer_start, among others), it
calls remove_hrtimer without checking to see if the
timer is currently running.  This doesn't seem to cause
much trouble in the vanilla kernel, but in the -RT
kernel, this causes a silent hang when exercising the
sch_htb module on a 10GbE interface.

Signed-off-by: Vernon Mauery <vernux@us.ibm.com>
---
 kernel/hrtimer.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0c8d7c0..c7e8ba0 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -935,6 +935,11 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	base = lock_hrtimer_base(timer, &flags);
 
 	/* Remove an active timer from the queue: */
+	while (hrtimer_callback_running(timer)) {
+		unlock_hrtimer_base(timer, &flags);
+		hrtimer_wait_for_timer(timer);
+		base = lock_hrtimer_base(timer, &flags);
+	}
 	ret = remove_hrtimer(timer, base);
 
 	/* Switch the timer base, if necessary: */
-- 
1.7.1

