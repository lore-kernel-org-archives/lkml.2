Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab2GQHIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 03:08:17 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:55897 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab2GQHFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 03:05:47 -0400
From: John Stultz <johnstul@us.ibm.com>
To: stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 11/11] 3.2.x: timekeeping: Add missing update call in timekeeping_resume()
Date: Tue, 17 Jul 2012 03:05:24 -0400
Message-Id: <1342508724-14527-12-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342508724-14527-1-git-send-email-johnstul@us.ibm.com>
References: <1342508724-14527-1-git-send-email-johnstul@us.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071707-4242-0000-0000-000002583862
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

This is a backport of 3e997130bd2e8c6f5aaa49d6e3161d4d29b43ab0

The leap second rework unearthed another issue of inconsistent data.

On timekeeping_resume() the timekeeper data is updated, but nothing
calls timekeeping_update(), so now the update code in the timer
interrupt sees stale values.

This has been the case before those changes, but then the timer
interrupt was using stale data as well so this went unnoticed for quite
some time.

Add the missing update call, so all the data is consistent everywhere.

Reported-by: Andreas Schwab <schwab@linux-m68k.org>
Reported-and-tested-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Reported-and-tested-by: Martin Steigerwald <Martin@lichtvoll.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 kernel/time/timekeeping.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 4938c5e..03e67d4 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -699,6 +699,7 @@ static void timekeeping_resume(void)
 	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
 	timekeeper.ntp_error = 0;
 	timekeeping_suspended = 0;
+	timekeeping_update(false);
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
 	touch_softlockup_watchdog();
-- 
1.7.9.5

