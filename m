Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab2IRBi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 21:38:59 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60506 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249Ab2IRBi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 21:38:57 -0400
From: John Stultz <john.stultz@linaro.org>
To: stable@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Prarit Bhargava <prarit@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] 2.6.34.y: time: Avoid making adjustments if we haven't accumulated anything
Date: Mon, 17 Sep 2012 21:38:46 -0400
Message-Id: <1347932327-33192-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347932327-33192-1-git-send-email-john.stultz@linaro.org>
References: <1347932327-33192-1-git-send-email-john.stultz@linaro.org>
x-cbid: 12091801-7182-0000-0000-000002A59BE9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 kernel/time/timekeeping.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 0d59077..bbdad71a 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -849,6 +849,10 @@ void update_wall_time(void)
 #else
 	offset = timekeeper.cycle_interval;
 #endif
+	/* Check if there's really nothing to do */
+	if (offset < timekeeper.cycle_interval)
+		return;
+
 	timekeeper.xtime_nsec = (s64)xtime.tv_nsec << timekeeper.shift;
 
 	/*
-- 
1.7.9.5

