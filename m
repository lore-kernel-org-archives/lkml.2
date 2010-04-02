Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab0DBTO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:14:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:46719 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178Ab0DBTOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:14:22 -0400
Date: Fri, 2 Apr 2010 19:13:58 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix nr_uninterruptible count
Message-ID: <tip-cc87f76a601d2d256118f7bab15e35254356ae21@git.kernel.org>
Git-Commit-ID: cc87f76a601d2d256118f7bab15e35254356ae21
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:13:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc87f76a601d2d256118f7bab15e35254356ae21
Gitweb:     http://git.kernel.org/tip/cc87f76a601d2d256118f7bab15e35254356ae21
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 26 Mar 2010 12:22:14 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 20:12:04 +0200

sched: Fix nr_uninterruptible count

The cpuload calculation in calc_load_account_active() assumes
rq->nr_uninterruptible will not change on an offline cpu after
migrate_nr_uninterruptible(). However the recent migrate on wakeup
changes broke that and would result in decrementing the offline cpu's
rq->nr_uninterruptible.

Fix this by accounting the nr_uninterruptible on the waking cpu.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 51d336e..14c8d2a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2378,8 +2378,12 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	 *
 	 * First fix up the nr_uninterruptible count:
 	 */
-	if (task_contributes_to_load(p))
-		rq->nr_uninterruptible--;
+	if (task_contributes_to_load(p)) {
+		if (likely(cpu_online(orig_cpu)))
+			rq->nr_uninterruptible--;
+		else
+			this_rq()->nr_uninterruptible--;
+	}
 	p->state = TASK_WAKING;
 
 	if (p->sched_class->task_waking)
