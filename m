Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab1EXAya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 20:54:30 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40909 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab1EXAy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 20:54:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDB0199.6030805@jp.fujitsu.com>
Date: Tue, 24 May 2011 09:53:45 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: Test for CFS Bandwidth Control V6
References: <20110323030326.789836913@google.com> <4DD5CE05.3030500@cn.fujitsu.com>
In-Reply-To: <4DD5CE05.3030500@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul and Xiao,

Please check/test a fix at the foot of this mail.

(2011/05/20 11:12), Xiao Guangrong wrote:
> Hi Paul,
> 
> I'm so sorry for sending this mail in the new thread, since i didn't
> receive your V6 patchset from LKML.
> 
> It seams the patchset can not be applied, since it's conflict between
> patch 3 and patch 5:
> 
> ========Quote========
(snip)
> ========End quote========

Maybe I've fixed it by hand, or git-am is so wonderful.

I believe Paul will do it right for next time.

> 
> I downloaded the patchset from Internet, i missed the newer version?
> 
> I have done some test after fixed the conflict by handle, below test can cause
> box crash:
> 
> ========Quote　cpu_hotlpug.sh ========
(snip)
> ======== End quote　cpu_hotlpug.sh ========
> 
> Sorry to disturb you if the bug is know.
> 
> Thanks!

Thank you for reporting it, Xiao!

I confirmed that running your test cause hung-up on my box.
And after some investigation, I found that this is an infinite loop
in migrate_task() due to miscalculation of rq->nr_running; when a
task is queued to throttled entity the nr_running is incremented at
the queuing and also the unthrottling.

I made a fix for this bug and it seems works well for me.
Could you try this patch and give us your feedback, Xiao?

Thanks,
H.Seto

---
 kernel/sched_fair.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3936393..544072f 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1537,7 +1537,7 @@ static void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	walk_tg_tree_from(cfs_rq->tg, tg_unthrottle_down, tg_nop,
 			  (void *)&udd);
 
-	if (!cfs_rq->load.weight)
+	if (!cfs_rq->h_nr_running)
 		return;
 
 	task_delta = cfs_rq->h_nr_running;
@@ -1843,10 +1843,9 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		cfs_rq->h_nr_running++;
 
 		/* end evaluation on throttled cfs_rq */
-		if (cfs_rq_throttled(cfs_rq)) {
-			se = NULL;
-			break;
-		}
+		if (cfs_rq_throttled(cfs_rq))
+			goto done;
+
 		flags = ENQUEUE_WAKEUP;
 	}
 
@@ -1855,14 +1854,14 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		cfs_rq->h_nr_running++;
 
 		if (cfs_rq_throttled(cfs_rq))
-			break;
+			goto done;
 
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
 	}
 
-	if (!se)
-		inc_nr_running(rq);
+	inc_nr_running(rq);
+done:
 	hrtick_update(rq);
 }
 
@@ -1885,10 +1884,9 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		cfs_rq->h_nr_running--;
 
 		/* end evaluation on throttled cfs_rq */
-		if (cfs_rq_throttled(cfs_rq)) {
-			se = NULL;
-			break;
-		}
+		if (cfs_rq_throttled(cfs_rq))
+			goto done;
+
 		/* Don't dequeue parent if it has other entities besides us */
 		if (cfs_rq->load.weight) {
 			 /* Avoid double update below. */
@@ -1910,14 +1908,14 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		cfs_rq->h_nr_running--;
 
 		if (cfs_rq_throttled(cfs_rq))
-			break;
+			goto done;
 
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
 	}
 
-	if (!se)
-		dec_nr_running(rq);
+	dec_nr_running(rq);
+done:
 	hrtick_update(rq);
 }
 
-- 
1.7.4.4


