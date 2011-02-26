Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab1BZQXe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 11:23:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:40249 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab1BZQXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 11:23:32 -0500
Date: Sat, 26 Feb 2011 16:23:17 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20110223234956.677109139@linutronix.de>
References: <20110223234956.677109139@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] sched: Switch wait_task_inactive to schedule_hrtimeout()
Message-ID: <tip-8eb90c30e0e815a1308828352eabd03ca04229dd@git.kernel.org>
Git-Commit-ID: 8eb90c30e0e815a1308828352eabd03ca04229dd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 26 Feb 2011 16:23:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8eb90c30e0e815a1308828352eabd03ca04229dd
Gitweb:     http://git.kernel.org/tip/8eb90c30e0e815a1308828352eabd03ca04229dd
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 23 Feb 2011 23:52:21 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 25 Feb 2011 20:24:22 +0100

sched: Switch wait_task_inactive to schedule_hrtimeout()

When we force thread hard and soft interrupts the startup of ksoftirqd
would hang in kthread_bind() when wait_task_inactive() calls
schedule_timeout_uninterruptible() because there is no softirq yet
which will wake us up.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20110223234956.677109139@linutronix.de>
---
 kernel/sched.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 18d38e4..66ca5d9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2224,7 +2224,10 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		 * yield - it could be a while.
 		 */
 		if (unlikely(on_rq)) {
-			schedule_timeout_uninterruptible(1);
+			ktime_t to = ktime_set(0, NSEC_PER_SEC/HZ);
+
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_hrtimeout(&to, HRTIMER_MODE_REL);
 			continue;
 		}
 
