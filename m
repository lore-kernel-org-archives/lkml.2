Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab2FFPyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:54:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40233 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab2FFPyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:54:33 -0400
Date: Wed, 6 Jun 2012 08:54:17 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-7f1b43936f0ecad14770634c021cf4a929aec74d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, a.p.zijlstra@chello.nl, roland@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, rostedt@goodmis.org, roland@kernel.org,
        tglx@linutronix.de
In-Reply-To: <1337282386.4281.77.camel@twins>
References: <1337282386.4281.77.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/rt:
  Fix lockdep annotation within find_lock_lowest_rq()
Git-Commit-ID: 7f1b43936f0ecad14770634c021cf4a929aec74d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:54:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f1b43936f0ecad14770634c021cf4a929aec74d
Gitweb:     http://git.kernel.org/tip/7f1b43936f0ecad14770634c021cf4a929aec74d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 17 May 2012 21:19:46 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 16:52:26 +0200

sched/rt: Fix lockdep annotation within find_lock_lowest_rq()

Roland Dreier reported spurious, hard to trigger lockdep warnings
within the scheduler - without any real lockup.

This bit gives us the right clue:

> [89945.640512]  [<ffffffff8103fa1a>] double_lock_balance+0x5a/0x90
> [89945.640568]  [<ffffffff8104c546>] push_rt_task+0xc6/0x290

if you look at that code you'll find the double_lock_balance() in
question is the one in find_lock_lowest_rq() [yay for inlining].

Now find_lock_lowest_rq() has a bug.. it fails to use
double_unlock_balance() in one exit path, if this results in a retry in
push_rt_task() we'll call double_lock_balance() again, at which point
we'll run into said lockdep confusion.

Reported-by: Roland Dreier <roland@kernel.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337282386.4281.77.camel@twins
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/rt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 2a4e8df..573e1ca 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1562,7 +1562,7 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
 				     task_running(rq, task) ||
 				     !task->on_rq)) {
 
-				raw_spin_unlock(&lowest_rq->lock);
+				double_unlock_balance(rq, lowest_rq);
 				lowest_rq = NULL;
 				break;
 			}
