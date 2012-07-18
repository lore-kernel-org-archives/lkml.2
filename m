Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab2GRAHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:07:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48276 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757534Ab2GRAFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:05:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        John Stultz <johnstul@us.ibm.com>, Jan Engelhardt <jengelh@inai.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 31/37] timekeeping: Fix leapsecond triggered load spike issue
Date: Tue, 17 Jul 2012 17:03:08 -0700
Message-Id: <20120717232433.995025566@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232431.399005532@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232431.399005532@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <johnstul@us.ibm.com>

This is a backport of 4873fa070ae84a4115f0b3c9dfabc224f1bc7c51

The timekeeping code misses an update of the hrtimer subsystem after a
leap second happened. Due to that timers based on CLOCK_REALTIME are
either expiring a second early or late depending on whether a leap
second has been inserted or deleted until an operation is initiated
which causes that update. Unless the update happens by some other
means this discrepancy between the timekeeping and the hrtimer data
stays forever and timers are expired either early or late.

The reported immediate workaround - $ data -s "`date`" - is causing a
call to clock_was_set() which updates the hrtimer data structures.
See: http://www.sheeri.com/content/mysql-and-leap-second-high-cpu-and-fix

Add the missing clock_was_set() call to update_wall_time() in case of
a leap second event. The actual update is deferred to softirq context
as the necessary smp function call cannot be invoked from hard
interrupt context.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Reported-by: Jan Engelhardt <jengelh@inai.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1341960205-56738-3-git-send-email-johnstul@us.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timekeeping.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -965,6 +965,8 @@ static cycle_t logarithmic_accumulation(
 		leap = second_overflow(timekeeper.xtime.tv_sec);
 		timekeeper.xtime.tv_sec += leap;
 		timekeeper.wall_to_monotonic.tv_sec -= leap;
+		if (leap)
+			clock_was_set_delayed();
 	}
 
 	/* Accumulate raw time */
@@ -1081,6 +1083,8 @@ static void update_wall_time(void)
 		leap = second_overflow(timekeeper.xtime.tv_sec);
 		timekeeper.xtime.tv_sec += leap;
 		timekeeper.wall_to_monotonic.tv_sec -= leap;
+		if (leap)
+			clock_was_set_delayed();
 	}
 
 	timekeeping_update(false);


