Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab2FOPUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 11:20:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932111Ab2FOPUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 11:20:13 -0400
Date: Fri, 15 Jun 2012 11:20:07 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: missing leap second patches in stable.
Message-ID: <20120615152007.GA11793@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	John Stultz <john.stultz@linaro.org>,
	Fedora Kernel Team <kernel-team@fedoraproject.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should these be in -stable ? Looks like all the other recent changes
in that area are present.  With the leap second just two weeks away,
it seems like they should be.

Looks like 6b43ae8a619d17c4935c3320d2ef9e92bdeed05d is in 3.4-stable,
(haven't checked earlier -stable trees).

Were there any other patches I missed ?

	Dave


commit dd48d708ff3e917f6d6b6c2b696c3f18c019feed
Author: Richard Cochran <richardcochran@gmail.com>
Date:   Thu Apr 26 14:11:32 2012 +0200

    ntp: Correct TAI offset during leap second
    
    When repeating a UTC time value during a leap second (when the UTC
    time should be 23:59:60), the TAI timescale should not stop. The kernel
    NTP code increments the TAI offset one second too late. This patch fixes
    the issue by incrementing the offset during the leap second itself.
    
    Signed-off-by: Richard Cochran <richardcochran@gmail.com>
    Signed-off-by: John Stultz <john.stultz@linaro.org>

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index f03fd83..e8c8671 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -412,6 +412,7 @@ int second_overflow(unsigned long secs)
                if (secs % 86400 == 0) {
                        leap = -1;
                        time_state = TIME_OOP;
+                       time_tai++;
                        printk(KERN_NOTICE
                                "Clock: inserting leap second 23:59:60 UTC\n");
                }
@@ -426,7 +427,6 @@ int second_overflow(unsigned long secs)
                }
                break;
        case TIME_OOP:
-               time_tai++;
                time_state = TIME_WAIT;
                break;



commit fad0c66c4bb836d57a5f125ecd38bed653ca863a
Author: John Stultz <john.stultz@linaro.org>
Date:   Wed May 30 10:54:57 2012 -0700

    timekeeping: Fix CLOCK_MONOTONIC inconsistency during leapsecond
    
    Commit 6b43ae8a61 (ntp: Fix leap-second hrtimer livelock) broke the
    leapsecond update of CLOCK_MONOTONIC. The missing leapsecond update to
    wall_to_monotonic causes discontinuities in CLOCK_MONOTONIC.
    
    Adjust wall_to_monotonic when NTP inserted a leapsecond.
    
    Reported-by: Richard Cochran <richardcochran@gmail.com>
    Signed-off-by: John Stultz <john.stultz@linaro.org>
    Tested-by: Richard Cochran <richardcochran@gmail.com>
    Cc: stable@kernel.org
    Link: http://lkml.kernel.org/r/1338400497-12420-1-git-send-email-john.stultz@linaro.org
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6e46cac..6f46a00 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -962,6 +962,7 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
                timekeeper.xtime.tv_sec++;
                leap = second_overflow(timekeeper.xtime.tv_sec);
                timekeeper.xtime.tv_sec += leap;
+               timekeeper.wall_to_monotonic.tv_sec -= leap;
        }
 
        /* Accumulate raw time */
@@ -1077,6 +1078,7 @@ static void update_wall_time(void)
                timekeeper.xtime.tv_sec++;
                leap = second_overflow(timekeeper.xtime.tv_sec);
                timekeeper.xtime.tv_sec += leap;
+               timekeeper.wall_to_monotonic.tv_sec -= leap;
        }
 
        timekeeping_update(false);

