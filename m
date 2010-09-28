Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab0I1IRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 04:17:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:34317 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750873Ab0I1IRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 04:17:40 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/QTCxotMnQbCaJgl+Ff5ibUFpY64yZUGwbxyLDHy
	SFjqb5E72wCBJS
Subject: Re: broken behavior in cfs when moving threads between cgroups
From: Mike Galbraith <efault@gmx.de>
To: Dima Zavin <dmitriyz@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@google.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTinmQOYQAOPkQsZNhJBJtCss3ZtHN_a6h4fpamtz@mail.gmail.com>
References: <AANLkTinmQOYQAOPkQsZNhJBJtCss3ZtHN_a6h4fpamtz@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 28 Sep 2010 10:17:58 +0200
Message-Id: <1285661878.2795.70.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 23:07 -0700, Dima Zavin wrote:

> I'm not really sure how to fix #1 cleanly, since we don't have enough
> information (i.e. we don't know the previous group) inside
> moved_group_fair() to adjust the value. It has to be adjusted in
> sched_move_task(), but I don't see the right interface to do that. I
> included a hacky patch further down that accesses the sched_fair internals
> directly, which I know is wrong but illustrates what I think needs to be done.

I don't really see the relevance of an entity's lag in it's previous
group, so would tend toward entry at parity.

Maybe the move _should_ be treated as a fork, for the same reason we do
START_DEBIT, but if so, seems to me it's irrelevant whether the task is
currently sleeping or not, it's going to run for the first time in it's
new home just as any runnable task, and may do so very soon.  OTOH,
frequent moves with that hefty START_DEBIT price tag could hurt very
badly, and makes caring about previous lag seem pointless.

	-Mike

(untested)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 9b5b4f8..4dc6b2f 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3827,10 +3827,14 @@ static void set_curr_task_fair(struct rq *rq)
 static void moved_group_fair(struct task_struct *p, int on_rq)
 {
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+	struct sched_entity *se = &p->se;
+	u64 vruntime = 0;
 
 	update_curr(cfs_rq);
 	if (!on_rq)
-		place_entity(cfs_rq, &p->se, 1);
+		vruntime = cfs_rq->min_vruntime;
+
+	se->vruntime = vruntime;
 }
 #endif
 



