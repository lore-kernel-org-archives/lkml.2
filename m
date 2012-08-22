Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab2HVAbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 20:31:32 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45779 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab2HVAbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 20:31:15 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Schwab <schwab@linux-m68k.org>
Subject: [PATCH 3/4] time: Avoid potential shift-overflow with large shift values
Date: Tue, 21 Aug 2012 20:30:48 -0400
Message-Id: <1345595449-34965-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345595449-34965-1-git-send-email-john.stultz@linaro.org>
References: <1345595449-34965-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082200-5112-0000-0000-00000B5276D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab noted that the 1 << tk->shift could overflow
if the shift value was greater then 30, since 1 would be
a 32bit long on 32bit architectures.

This patch uses 1ULL instead to ensure we don't overflow on
the shift.

This issue was introduced by 1e75fa8be9fb61e1af46b5b3b176347a4c958ca1

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Reported-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 1dbf80e..a5a9389 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1184,9 +1184,9 @@ static void update_wall_time(void)
 	* the vsyscall implementations are converted to use xtime_nsec
 	* (shifted nanoseconds), this can be killed.
 	*/
-	remainder = tk->xtime_nsec & ((1 << tk->shift) - 1);
+	remainder = tk->xtime_nsec & ((1ULL << tk->shift) - 1);
 	tk->xtime_nsec -= remainder;
-	tk->xtime_nsec += 1 << tk->shift;
+	tk->xtime_nsec += 1ULL << tk->shift;
 	tk->ntp_error += remainder << tk->ntp_error_shift;
 
 	/*
-- 
1.7.9.5

