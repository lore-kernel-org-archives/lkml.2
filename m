Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab2GWB4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:56:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54240 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753323Ab2GWBnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:00 -0400
Message-Id: <20120723010704.216878046@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:08:15 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [ 084/108] timekeeping: Add missing update call in timekeeping_resume()
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[John Stultz: Backported to 3.2]
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


