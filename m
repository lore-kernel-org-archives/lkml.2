Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab2GIJoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 05:44:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52370 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab2GIJoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 05:44:15 -0400
Date: Mon, 9 Jul 2012 02:43:56 -0700
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Message-ID: <tip-bb88e92477def647976cd3d6964af98beceba900@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        johnstul@us.ibm.com, jengelh@inai.de, tglx@linutronix.de,
        prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, jengelh@inai.de,
        prarit@redhat.com
In-Reply-To: <1341515538-5100-3-git-send-email-johnstul@us.ibm.com>
References: <1341515538-5100-3-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] time: Fix leapsecond triggered hrtimer/
 futex load spike issue
Git-Commit-ID: bb88e92477def647976cd3d6964af98beceba900
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 09 Jul 2012 02:44:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bb88e92477def647976cd3d6964af98beceba900
Gitweb:     http://git.kernel.org/tip/bb88e92477def647976cd3d6964af98beceba900
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Thu, 5 Jul 2012 15:12:17 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 9 Jul 2012 11:35:38 +0200

time: Fix leapsecond triggered hrtimer/futex load spike issue

As widely reported on the internet, some Linux systems after
the leapsecond was inserted are experiencing futex related load
spikes (usually connected to MySQL, Firefox, Thunderbird, Java, etc).

An apparent for this issue workaround is running:
$ date -s "`date`"

Credit: http://www.sheeri.com/content/mysql-and-leap-second-high-cpu-and-fix

I this issue is due to the leapsecond being added without
calling clock_was_set() to notify the hrtimer subsystem of the
change.

The workaround functions as it forces a clock_was_set()
call from settimeofday().

This fix adds the required clock_was_set() calls to where
we adjust for leapseconds.

NOTE: This fix *depends* on the previous fix, which allows
clock_was_set to be called from atomic context. Do not try
to apply just this patch.

Reported-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Acked-by: Prarit Bhargava <prarit@redhat.com>
CC: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1341515538-5100-3-git-send-email-johnstul@us.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

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
