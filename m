Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab1ABH6c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:58:32 -0500
Received: from mail.windriver.com ([147.11.1.11]:35254 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab1ABHXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:03 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 090/260] sched: Fix nr_uninterruptible count
Date: Sun,  2 Jan 2011 02:16:26 -0500
Message-Id: <1293952756-15010-91-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:48.0899 (UTC) FILETIME=[B8277B30:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit cc87f76a601d2d256118f7bab15e35254356ae21 upstream.

The cpuload calculation in calc_load_account_active() assumes
rq->nr_uninterruptible will not change on an offline cpu after
migrate_nr_uninterruptible(). However the recent migrate on wakeup
changes broke that and would result in decrementing the offline cpu's
rq->nr_uninterruptible.

Fix this by accounting the nr_uninterruptible on the waking cpu.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/sched.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e542c1e..074c4d8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2388,8 +2388,12 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
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
-- 
1.7.3.3

