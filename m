Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab1E3Njx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 09:39:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51024 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab1E3Njw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 09:39:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=pMpyAssyzoSqOnQMmi0pNFtdZmmKBughhxF89GAoH/J95Vhpys5hWvqg0IH73fAwWp
         hQihuh4mNNh+R09X5vmLHRN3Arg6rTLDxB+DqcsISe63aNFDDSgvEMn7gneBIcJoqNoR
         f6GsYDL7GMDe6uZ1ZggYpSpM2RINT5WBAUJ/k=
MIME-Version: 1.0
Date: Mon, 30 May 2011 21:39:50 +0800
Message-ID: <BANLkTimfOsJ91_PJdB5-H02EGS0S5eJ5cA@mail.gmail.com>
Subject: [PATCH] sched: fix rt_nr_migratory corruption raised in push_rt_task()
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When pushing, if a pushable task could not be pushed, it is dequeued with no
updating the rt_nr_migratory element of RT run-queue, then rt_nr_migratory is
corrupted, which is fixed by removing the dequeue operation.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---
 kernel/sched_rt.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 88725c9..496e06a 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1378,6 +1378,7 @@ static int push_rt_task(struct rq *rq)
 {
 	struct task_struct *next_task;
 	struct rq *lowest_rq;
+	int ret = 1;

 	if (!rq->rt.overloaded)
 		return 0;
@@ -1425,7 +1426,7 @@ retry:
 			 * since the other cpus will pull from us when they
 			 * are ready.
 			 */
-			dequeue_pushable_task(rq, next_task);
+			ret = 0;
 			goto out;
 		}

@@ -1452,7 +1453,7 @@ retry:
 out:
 	put_task_struct(next_task);

-	return 1;
+	return ret;
 }

 static void push_rt_tasks(struct rq *rq)
