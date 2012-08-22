Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab2HVAbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 20:31:47 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:36732 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016Ab2HVAbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 20:31:44 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: [PATCH 4/4] time: Avoid making adjustments if we havne't accumulated anything
Date: Tue, 21 Aug 2012 20:30:49 -0400
Message-Id: <1345595449-34965-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345595449-34965-1-git-send-email-john.stultz@linaro.org>
References: <1345595449-34965-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082200-9360-0000-0000-000009B13FCC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If update_wall_time() is called and the current offset isn't
large enough to accumulate, avoid re-calling timekeeping_adjust
which may change the clock freq and can cause 1ns inconsistencies
with CLOCK_REALTIME_COARSE/CLOCK_MONOTONIC_COARSE.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index a5a9389..0c1485e 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1152,6 +1152,10 @@ static void update_wall_time(void)
 	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
 #endif
 
+	/* Check if there's really nothing to do */
+	if (offset < tk->cycle_interval)
+		goto out;
+
 	/*
 	 * With NO_HZ we may have to accumulate many cycle_intervals
 	 * (think "ticks") worth of time at once. To do this efficiently,
-- 
1.7.9.5

