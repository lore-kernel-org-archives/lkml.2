Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab2JAXDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:03:11 -0400
Received: from 1wt.eu ([62.212.114.60]:35635 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933241Ab2JAXDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:03:08 -0400
Message-Id: <20121001225158.466422743@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:17 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Prarit Bhargava <prarit@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 020/180] 2.6.32.y: time: Avoid making adjustments if we havent accumulated anything
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <john.stultz@linaro.org>

This is a -stable backport of bf2ac312195155511a0f79325515cbb61929898a

If update_wall_time() is called and the current offset isn't large
enough to accumulate, avoid re-calling timekeeping_adjust which may
change the clock freq and can cause 1ns inconsistencies with
CLOCK_REALTIME_COARSE/CLOCK_MONOTONIC_COARSE.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1345595449-34965-5-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/time/timekeeping.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 85d51c4..b451c93 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -807,6 +807,10 @@ void update_wall_time(void)
 #else
 	offset = timekeeper.cycle_interval;
 #endif
+	/* Check if there's really nothing to do */
+	if (offset < timekeeper.cycle_interval)
+		return;
+
 	timekeeper.xtime_nsec = (s64)xtime.tv_nsec << timekeeper.shift;
 
 	/* normally this loop will run just once, however in the
-- 
1.7.2.1.45.g54fbc



