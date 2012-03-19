Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab2CSW0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:26:35 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:2651 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757916Ab2CSW0c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:26:32 -0400
X-Server-Uuid: 72204117-5C29-4314-8910-60DB108979CB
From: "Michael J. Wang" <mjwang@broadcom.com>
To: "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>
cc: "Michael J. Wang" <mjwang@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "yong.zhang0@gmail.com" <yong.zhang0@gmail.com>
Subject: [PATCH 1/1] scheduler: minor improvement to
 pick_next_highest_task_rt in linux-3.3
Thread-Topic: [PATCH 1/1] scheduler: minor improvement to
 pick_next_highest_task_rt in linux-3.3
Thread-Index: Ac0GHwijHkYM9zt3RLiiFsMKptWd3Q==
Date: Mon, 19 Mar 2012 22:26:19 +0000
Message-ID: <2EF88150C0EF2C43A218742ED384C1BC0FC83D6B@IRVEXCHMB08.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.161.125]
MIME-Version: 1.0
X-WSS-ID: 63796B574GW6716511-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael J Wang <mjwang@broadcom.com>

Avoid extra work by continuing on to the next rt_rq if the highest prio task in current rt_rq is the same priority as our candidate task.

Signed-off-by: Michael J Wang <mjwang@broadcom.com>

---

More detailed explanation:  if next is not NULL, then we have found a candidate task, and its priority is next->prio.  Now we are looking for an even higher priority task in the other rt_rq's.  idx is the highest priority in the current candidate rt_rq.  In the current 3.3 code, if idx is equal to next->prio, we would start scanning the tasks in that rt_rq and replace the current candidate task with a task from that rt_rq.  But the new task would only have a priority that is equal to our previous candidate task, so we have not advanced our goal of finding a higher prio task.  So we should avoid the extra work by continuing on to the next rt_rq if idx is equal to next->prio.

--- linux-3.3/kernel/sched/rt.c.orig	2012-03-18 16:15:34.000000000 -0700
+++ linux-3.3/kernel/sched/rt.c	2012-03-19 14:52:54.585391702 -0700
@@ -1403,7 +1403,7 @@ static struct task_struct *pick_next_hig
 next_idx:
 		if (idx >= MAX_RT_PRIO)
 			continue;
-		if (next && next->prio < idx)
+		if (next && next->prio <= idx)
 			continue;
 		list_for_each_entry(rt_se, array->queue + idx, run_list) {
 			struct task_struct *p;






