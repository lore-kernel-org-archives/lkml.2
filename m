Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab0EXKQC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 06:16:02 -0400
Received: from www.tglx.de ([62.245.132.106]:58650 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324Ab0EXKQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 06:16:00 -0400
Date: Mon, 24 May 2010 12:15:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT Pull V2] timer fixes for 2.6.35-rc1
In-Reply-To: <alpine.LFD.2.00.1005241153240.3506@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1005241213030.3775@localhost.localdomain>
References: <alpine.LFD.2.00.1005241153240.3506@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please discard the previous pull and take this one. I missed the timer
fix in the first place.


Please pull the latest timers-for-linus-urgent git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus-urgent

Thanks,

	tglx


------------------>
Jeff Chua (1):
      timers: Fix slack calculation for expired timers

Thomas Gleixner (1):
      timekeeping: Fix timezone update


 kernel/time.c  |    8 ++++----
 kernel/timer.c |    7 ++++---
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/time.c b/kernel/time.c
index 50612fa..848b1c2 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -132,10 +132,10 @@ SYSCALL_DEFINE2(gettimeofday, struct timeval __user *, tv,
  */
 static inline void warp_clock(void)
 {
-	struct timespec delta, adjust;
-	delta.tv_sec = sys_tz.tz_minuteswest * 60;
-	delta.tv_nsec = 0;
-	adjust = timespec_add_safe(current_kernel_time(), delta);
+	struct timespec adjust;
+
+	adjust = current_kernel_time();
+	adjust.tv_sec += sys_tz.tz_minuteswest * 60;
 	do_settimeofday(&adjust);
 }
 
diff --git a/kernel/timer.c b/kernel/timer.c
index 9199f3c..be394af 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -750,13 +750,14 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
 	unsigned long expires_limit, mask;
 	int bit;
 
-	expires_limit = expires + timer->slack;
+	expires_limit = expires;
 
-	if (timer->slack < 0) /* auto slack: use 0.4% */
+	if (timer->slack > -1)
+		expires_limit = expires + timer->slack;
+	else if (time_after(expires, jiffies)) /* auto slack: use 0.4% */
 		expires_limit = expires + (expires - jiffies)/256;
 
 	mask = expires ^ expires_limit;
-
 	if (mask == 0)
 		return expires;
 
