Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965121Ab2I1Ubj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:31:39 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:56440 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032890Ab2I1Ubc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:31:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        John Stultz <john.stultz@linaro.org>,
        Prarit Bhargava <prarit@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 187/218] time: Avoid making adjustments if we havent accumulated anything
Date: Fri, 28 Sep 2012 13:16:44 -0700
Message-Id: <20120928201522.985255719@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <john.stultz@linaro.org>

commit bf2ac312195155511a0f79325515cbb61929898a upstream.

If update_wall_time() is called and the current offset isn't large
enough to accumulate, avoid re-calling timekeeping_adjust which may
change the clock freq and can cause 1ns inconsistencies with
CLOCK_REALTIME_COARSE/CLOCK_MONOTONIC_COARSE.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1345595449-34965-5-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timekeeping.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1057,9 +1057,12 @@ static void update_wall_time(void)
 #else
 	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
 #endif
+	/* Check if there's really nothing to do */
+	if (offset < timekeeper.cycle_interval)
+		goto out;
+
 	timekeeper.xtime_nsec = (s64)timekeeper.xtime.tv_nsec <<
 						timekeeper.shift;
-
 	/*
 	 * With NO_HZ we may have to accumulate many cycle_intervals
 	 * (think "ticks") worth of time at once. To do this efficiently,


