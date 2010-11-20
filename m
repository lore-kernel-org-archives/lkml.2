Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab0KTKy5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 05:54:57 -0500
Received: from canuck.infradead.org ([134.117.69.58]:52858 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab0KTKy4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 05:54:56 -0500
Subject: Re: [PATCH 5/5] sched: use the old min_vruntime when normalizing
 on dequeue
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Dima Zavin <dima@android.com>,
        Ingo Molnar <mingo@elte.hu>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
In-Reply-To: <1290218934-8544-6-git-send-email-john.stultz@linaro.org>
References: <1290218934-8544-1-git-send-email-john.stultz@linaro.org>
	 <1290218934-8544-6-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 20 Nov 2010 11:55:11 +0100
Message-ID: <1290250511.2118.7.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 18:08 -0800, John Stultz wrote:
> From: Dima Zavin <dima@android.com>
> 
> After pulling the thread off the run-queue during a cgroup change,
> the cfs_rq.min_vruntime gets recalculated. The dequeued thread's vruntime
> then gets normalized to this new value. This can then lead to the thread
> getting an unfair boost in the new group if the vruntime of the next
> task in the old run-queue was way further ahead.
> 
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Peter Zijlstra <peterz@infradead.org>
> Cc: Arve Hjønnevåg <arve@android.com>
> Signed-off-by: Dima Zavin <dima@android.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  kernel/sched_fair.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index f4f6a83..72f19ad 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -802,6 +802,8 @@ static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  static void
>  dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
>  {
> +	u64 min_vruntime;
> +
>  	/*
>  	 * Update run-time statistics of the 'current'.
>  	 */
> @@ -826,6 +828,8 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
>  	if (se != cfs_rq->curr)
>  		__dequeue_entity(cfs_rq, se);
>  	account_entity_dequeue(cfs_rq, se);
> +
> +	min_vruntime = cfs_rq->min_vruntime;
>  	update_min_vruntime(cfs_rq);
>  
>  	/*
> @@ -834,7 +838,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
>  	 * movement in our normalized position.
>  	 */
>  	if (!(flags & DEQUEUE_SLEEP))
> -		se->vruntime -= cfs_rq->min_vruntime;
> +		se->vruntime -= min_vruntime;
>  }

Right, so assuming the reasoning is right (my brain still needs to wake
up) the patch is weird, by not simply move the code bock up and avoid
the whole extra variable like so?

---
 kernel/sched_fair.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index d35f464..dfa28ef 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1003,8 +1003,6 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	se->on_rq = 0;
 	update_cfs_load(cfs_rq, 0);
 	account_entity_dequeue(cfs_rq, se);
-	update_min_vruntime(cfs_rq);
-	update_cfs_shares(cfs_rq, 0);
 
 	/*
 	 * Normalize the entity after updating the min_vruntime because the
@@ -1013,6 +1011,9 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 */
 	if (!(flags & DEQUEUE_SLEEP))
 		se->vruntime -= cfs_rq->min_vruntime;
+
+	update_min_vruntime(cfs_rq);
+	update_cfs_shares(cfs_rq, 0);
 }
 
 /*

