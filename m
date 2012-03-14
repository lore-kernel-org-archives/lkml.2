Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760872Ab2CNX7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:59:15 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52700 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031186Ab2CNX7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:59:06 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2] time: Fix change_clocksource locking
Date: Wed, 14 Mar 2012 16:58:56 -0700
Message-Id: <1331769536-4602-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1331769536-4602-1-git-send-email-john.stultz@linaro.org>
References: <1331769536-4602-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031423-5112-0000-0000-000006309410
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change_clocksource() fails to grab locks or call timekeeping_update(),
which leaves a race window for time inconsistencies.

This adds proper locking and a call to timekeeping_update() to fix this.

CC: Andy Lutomirski <luto@amacapital.net>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 403c2a0..b53da5e 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -448,9 +448,12 @@ EXPORT_SYMBOL(timekeeping_inject_offset);
 static int change_clocksource(void *data)
 {
 	struct clocksource *new, *old;
+	unsigned long flags;
 
 	new = (struct clocksource *) data;
 
+	write_seqlock_irqsave(&timekeeper.lock, flags);
+
 	timekeeping_forward_now();
 	if (!new->enable || new->enable(new) == 0) {
 		old = timekeeper.clock;
@@ -458,6 +461,10 @@ static int change_clocksource(void *data)
 		if (old->disable)
 			old->disable(old);
 	}
+	timekeeping_update(true);
+
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+
 	return 0;
 }
 
-- 
1.7.3.2.146.gca209

