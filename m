Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab1DRNq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:46:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab1DRNqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:46:04 -0400
Date: Mon, 18 Apr 2011 15:45:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/7] signal: retarget_shared_pending: optimize
	while_each_thread() loop
Message-ID: <20110418134518.GD15951@redhat.com>
References: <20110418134421.GA15951@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418134421.GA15951@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

retarget_shared_pending() blindly does recalc_sigpending_and_wake() for
every sub-thread, this is suboptimal. We can check t->blocked and stop
looping once every bit in shared_pending has the new target.

Note: we do not take task_is_stopped_or_traced(t) into account, we are
not trying to speed up the signal delivery or to avoid the unnecessary
(but harmless) signal_wake_up(0) in this unlikely case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/signal.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- sigprocmask/kernel/signal.c~3_optimize_retarget_loop	2011-04-17 21:08:05.000000000 +0200
+++ sigprocmask/kernel/signal.c	2011-04-17 21:28:21.000000000 +0200
@@ -2033,8 +2033,18 @@ static void retarget_shared_pending(stru
 
 	t = tsk;
 	while_each_thread(tsk, t) {
-		if (!signal_pending(t) && !(t->flags & PF_EXITING))
-			recalc_sigpending_and_wake(t);
+		if ((t->flags & PF_EXITING))
+			continue;
+		if (!has_pending_signals(&shared_pending, &t->blocked))
+			continue;
+
+		sigandsets(&shared_pending, &shared_pending, &t->blocked);
+
+		if (!signal_pending(t))
+			signal_wake_up(t, 0);
+
+		if (sigisemptyset(&shared_pending))
+			break;
 	}
 }
 

