Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab2FNX7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 19:59:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45611 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab2FNX7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:59:13 -0400
Message-Id: <20120614235624.601996263@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Richard Cochran <richardcochran@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 08/42] timekeeping: Fix CLOCK_MONOTONIC inconsistency during leapsecond
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <john.stultz@linaro.org>

commit fad0c66c4bb836d57a5f125ecd38bed653ca863a upstream.

Commit 6b43ae8a61 (ntp: Fix leap-second hrtimer livelock) broke the
leapsecond update of CLOCK_MONOTONIC. The missing leapsecond update to
wall_to_monotonic causes discontinuities in CLOCK_MONOTONIC.

Adjust wall_to_monotonic when NTP inserted a leapsecond.

Reported-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Tested-by: Richard Cochran <richardcochran@gmail.com>
Link: http://lkml.kernel.org/r/1338400497-12420-1-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/timekeeping.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -964,6 +964,7 @@ static cycle_t logarithmic_accumulation(
 		timekeeper.xtime.tv_sec++;
 		leap = second_overflow(timekeeper.xtime.tv_sec);
 		timekeeper.xtime.tv_sec += leap;
+		timekeeper.wall_to_monotonic.tv_sec -= leap;
 	}
 
 	/* Accumulate raw time */
@@ -1079,6 +1080,7 @@ static void update_wall_time(void)
 		timekeeper.xtime.tv_sec++;
 		leap = second_overflow(timekeeper.xtime.tv_sec);
 		timekeeper.xtime.tv_sec += leap;
+		timekeeper.wall_to_monotonic.tv_sec -= leap;
 	}
 
 	timekeeping_update(false);


