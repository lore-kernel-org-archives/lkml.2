Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab2GASbc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:31:32 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:56487 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab2GASba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:31:30 -0400
From: John Stultz <johnstul@us.ibm.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Prarit Bhargava <prarit@redhat.com>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2] [RFC] Fix leapsecond triggered hrtimer/futex load spike issue
Date: Sun,  1 Jul 2012 14:30:01 -0400
Message-Id: <1341167401-31342-3-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341167401-31342-1-git-send-email-johnstul@us.ibm.com>
References: <1341167401-31342-1-git-send-email-johnstul@us.ibm.com>
x-cbid: 12070118-4242-0000-0000-0000022E32DE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As widely reported on the internet, some Linux systems after
the leapsecond was inserted are experiencing futex related load
spikes (usually connected to MySQL, Firefox, Thunderbird, Java, etc).

An apparent  workaround for this issue is running:
$ date -s "`date`"

Credit: http://www.sheeri.com/content/mysql-and-leap-second-high-cpu-and-fix

I believe this issue is due to the leapsecond being added without
calling clock_was_set() to notify the hrtimer subsystem of the
change. (Although I've not yet chased all the way down to the
hrtimer code to validate exactly what's going on there).

The workaround functions as it forces a clock_was_set()
call from settimeofday().

This fix adds the required clock_was_set() calls to where
we adjust for leapseconds.

NOTE: This fix *depends* on the previous fix, which allows
clock_was_set to be called from atomic context. Do not try
to apply just this patch.

CC: Prarit Bhargava <prarit@redhat.com>
CC: stable@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 kernel/time/timekeeping.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6f46a00..cc2991d 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -963,6 +963,8 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 		leap = second_overflow(timekeeper.xtime.tv_sec);
 		timekeeper.xtime.tv_sec += leap;
 		timekeeper.wall_to_monotonic.tv_sec -= leap;
+		if (leap)
+			clock_was_set();
 	}
 
 	/* Accumulate raw time */
@@ -1079,6 +1081,8 @@ static void update_wall_time(void)
 		leap = second_overflow(timekeeper.xtime.tv_sec);
 		timekeeper.xtime.tv_sec += leap;
 		timekeeper.wall_to_monotonic.tv_sec -= leap;
+		if (leap)
+			clock_was_set();
 	}
 
 	timekeeping_update(false);
-- 
1.7.9.5

