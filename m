Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab1BBWEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:04:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:50122 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753Ab1BBWEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:04:31 -0500
Date: Wed, 2 Feb 2011 22:04:13 GMT
From: tip-bot for Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, richardcochran@gmail.com, tglx@linutronix.de,
        richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, richardcochran@gmail.com, tglx@linutronix.de,
        richard.cochran@omicron.at
In-Reply-To: <20110201134320.688829863@linutronix.de>
References: <20110201134320.688829863@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] ntp: Add ADJ_SETOFFSET mode bit
Message-ID: <tip-094aa1881fdc1b8889b442eb3511b31f3ec2b762@git.kernel.org>
Git-Commit-ID: 094aa1881fdc1b8889b442eb3511b31f3ec2b762
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 22:04:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  094aa1881fdc1b8889b442eb3511b31f3ec2b762
Gitweb:     http://git.kernel.org/tip/094aa1881fdc1b8889b442eb3511b31f3ec2b762
Author:     Richard Cochran <richardcochran@gmail.com>
AuthorDate: Tue, 1 Feb 2011 13:52:20 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:18 +0100

ntp: Add ADJ_SETOFFSET mode bit

This patch adds a new mode bit into the timex structure. When set, the bit
instructs the kernel to add the given time value to the current time.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
Acked-by: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <20110201134320.688829863@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timex.h |    3 ++-
 kernel/time/ntp.c     |   11 +++++++++++
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/include/linux/timex.h b/include/linux/timex.h
index d23999f..aa60fe7 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -73,7 +73,7 @@ struct timex {
 	long tolerance;		/* clock frequency tolerance (ppm)
 				 * (read only)
 				 */
-	struct timeval time;	/* (read only) */
+	struct timeval time;	/* (read only, except for ADJ_SETOFFSET) */
 	long tick;		/* (modified) usecs between clock ticks */
 
 	long ppsfreq;           /* pps frequency (scaled ppm) (ro) */
@@ -102,6 +102,7 @@ struct timex {
 #define ADJ_STATUS		0x0010	/* clock status */
 #define ADJ_TIMECONST		0x0020	/* pll time constant */
 #define ADJ_TAI			0x0080	/* set TAI offset */
+#define ADJ_SETOFFSET		0x0100  /* add 'time' to current time */
 #define ADJ_MICRO		0x1000	/* select microsecond resolution */
 #define ADJ_NANO		0x2000	/* select nanosecond resolution */
 #define ADJ_TICK		0x4000	/* tick value */
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index ed8cfdf..5ac5932 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -648,6 +648,17 @@ int do_adjtimex(struct timex *txc)
 			hrtimer_cancel(&leap_timer);
 	}
 
+	if (txc->modes & ADJ_SETOFFSET) {
+		struct timespec delta;
+		if ((unsigned long)txc->time.tv_usec >= NSEC_PER_SEC)
+			return -EINVAL;
+		delta.tv_sec  = txc->time.tv_sec;
+		delta.tv_nsec = txc->time.tv_usec;
+		if (!(txc->modes & ADJ_NANO))
+			delta.tv_nsec *= 1000;
+		timekeeping_inject_offset(&delta);
+	}
+
 	getnstimeofday(&ts);
 
 	write_seqlock_irq(&xtime_lock);
