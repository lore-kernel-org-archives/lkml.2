Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab0IRTLJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:11:09 -0400
Received: from kroah.org ([198.145.64.141]:51782 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073Ab0IRTCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:18 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:01 2010
Message-Id: <20100918190001.466812569@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:59:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Mike Galbraith <efault@gmx.de>
Subject: [101/123] sched: Fix nr_uninterruptible count
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-fix-nr_uninterruptible-count.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit cc87f76a601d2d256118f7bab15e35254356ae21 upstream

The cpuload calculation in calc_load_account_active() assumes
rq->nr_uninterruptible will not change on an offline cpu after
migrate_nr_uninterruptible(). However the recent migrate on wakeup
changes broke that and would result in decrementing the offline cpu's
rq->nr_uninterruptible.

Fix this by accounting the nr_uninterruptible on the waking cpu.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2435,8 +2435,12 @@ static int try_to_wake_up(struct task_st
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


