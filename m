Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab2HOTwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:52:01 -0400
Received: from mail.windriver.com ([147.11.1.11]:37022 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866Ab2HOTvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:54 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 112/165] time: Move common updates to a function
Date: Wed, 15 Aug 2012 15:47:36 -0400
Message-ID: <1345060109-9187-113-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit cc06268c6a87db156af2daed6e96a936b955cc82 upstream.

While not a bugfix itself, it allows following fixes to backport
in a more straightforward manner.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/time/timekeeping.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index f8d4877..adfa89d 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -166,6 +166,18 @@ static struct timespec total_sleep_time;
  */
 struct timespec raw_time;
 
+/* must hold write on xtime_lock */
+static void timekeeping_update(bool clearntp)
+{
+	if (clearntp) {
+		timekeeper.ntp_error = 0;
+		ntp_clear();
+	}
+	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
+}
+
+
+
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
 
@@ -330,10 +342,7 @@ int do_settimeofday(struct timespec *tv)
 
 	update_xtime_cache(0);
 
-	timekeeper.ntp_error = 0;
-	ntp_clear();
-
-	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
+	timekeeping_update(true);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -858,8 +867,7 @@ void update_wall_time(void)
 	nsecs = clocksource_cyc2ns(offset, timekeeper.mult, timekeeper.shift);
 	update_xtime_cache(nsecs);
 
-	/* check to see if there is a new clocksource to use */
-	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
+	timekeeping_update(false);
 }
 
 /**
-- 
1.7.12.rc2

