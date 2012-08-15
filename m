Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320Ab2HOTxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:53:30 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63195 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab2HOTxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:53:25 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Linux PM list <linux-pm@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 119/165] timekeeping: Add missing update call in timekeeping_resume()
Date: Wed, 15 Aug 2012 15:47:43 -0400
Message-ID: <1345060109-9187-120-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 3e997130bd2e8c6f5aaa49d6e3161d4d29b43ab0 upstream.

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/time/timekeeping.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 0b4f6d1..156fd67 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -626,6 +626,7 @@ static int timekeeping_resume(struct sys_device *dev)
 	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
 	timekeeper.ntp_error = 0;
 	timekeeping_suspended = 0;
+	timekeeping_update(false);
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
 	touch_softlockup_watchdog();
-- 
1.7.12.rc2

