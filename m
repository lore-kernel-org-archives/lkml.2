Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab2FDTxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 15:53:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46405 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab2FDTxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 15:53:18 -0400
Date: Mon, 4 Jun 2012 12:52:59 -0700
From: tip-bot for John Stultz <john.stultz@linaro.org>
Message-ID: <tip-fad0c66c4bb836d57a5f125ecd38bed653ca863a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, richardcochran@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, richardcochran@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1338400497-12420-1-git-send-email-john.stultz@linaro.org>
References: <1338400497-12420-1-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] timekeeping:
  Fix CLOCK_MONOTONIC inconsistency during leapsecond
Git-Commit-ID: fad0c66c4bb836d57a5f125ecd38bed653ca863a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 04 Jun 2012 12:53:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fad0c66c4bb836d57a5f125ecd38bed653ca863a
Gitweb:     http://git.kernel.org/tip/fad0c66c4bb836d57a5f125ecd38bed653ca863a
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Wed, 30 May 2012 10:54:57 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 4 Jun 2012 21:46:29 +0200

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
---
 kernel/time/timekeeping.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6e46cac..6f46a00 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -962,6 +962,7 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 		timekeeper.xtime.tv_sec++;
 		leap = second_overflow(timekeeper.xtime.tv_sec);
 		timekeeper.xtime.tv_sec += leap;
+		timekeeper.wall_to_monotonic.tv_sec -= leap;
 	}
 
 	/* Accumulate raw time */
@@ -1077,6 +1078,7 @@ static void update_wall_time(void)
 		timekeeper.xtime.tv_sec++;
 		leap = second_overflow(timekeeper.xtime.tv_sec);
 		timekeeper.xtime.tv_sec += leap;
+		timekeeper.wall_to_monotonic.tv_sec -= leap;
 	}
 
 	timekeeping_update(false);
