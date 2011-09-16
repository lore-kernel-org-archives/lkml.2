Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab1IPIoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 04:44:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:57181 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab1IPIoV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 04:44:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,392,1312182000"; 
   d="scan'208";a="17758239"
Date: Fri, 16 Sep 2011 16:40:13 -0400
From: xingchao <xingchao.wang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "yong.zhang0@gmail.com" <yong.zhang0@gmail.com>,
        Paul Turner <pjt@google.com>
Subject: Re: [PATCH] cfs: remove unused 'if' condition checking
Message-ID: <20110916164013.0f08f0da@wang-bj-intel>
In-Reply-To: <1316162312.10174.2.camel@twins>
References: <1316194552-12019-1-git-send-email-xingchao.wang@intel.com>
	<1316162312.10174.2.camel@twins>
Organization: INTEL
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Sep 2011 16:38:32 +0800
Peter Zijlstra <peterz@infradead.org> wrote:

> Thanks, queued it as:
> 
> ---
> Subject: sched: Remove redundant test in check_preempt_tick()
> From: Wang Xingchao <xingchao.wang@intel.com>
> Date: Fri, 16 Sep 2011 13:35:52 -0400
> 
> The caller already checks for nr_running > 1, therefore we don't have
> to do so again.
> 
> Signed-off-by: Wang Xingchao <xingchao.wang@intel.com>
> Reviewed-by: Paul Turner <pjt@google.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link:
> http://lkml.kernel.org/r/1316194552-12019-1-git-send-email-xingchao.wang@intel.com
> --- kernel/sched_fair.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 1ca2cd4..fef0bfd 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1106,6 +1106,8 @@ static void
>  check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
>  {
>  	unsigned long ideal_runtime, delta_exec;
> +	struct sched_entity *se;
> +	s64 delta;
>  
>  	ideal_runtime = sched_slice(cfs_rq, curr);
>  	delta_exec = curr->sum_exec_runtime -
> curr->prev_sum_exec_runtime; @@ -1127,16 +1129,14 @@
> check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
> if (delta_exec < sysctl_sched_min_granularity) return;
>  
> -	if (cfs_rq->nr_running > 1) {
> -		struct sched_entity *se =
> __pick_first_entity(cfs_rq);
> -		s64 delta = curr->vruntime - se->vruntime;
> +	se = __pick_first_entity(cfs_rq);
> +	delta = curr->vruntime - se->vruntime;
>  
> -		if (delta < 0)
> -			return;
> +	if (delta < 0)
> +		return;
>  
> -		if (delta > ideal_runtime)
> -			resched_task(rq_of(cfs_rq)->curr);
> -	}
> +	if (delta > ideal_runtime)
> +		resched_task(rq_of(cfs_rq)->curr);
>  }
>  
>  static void

oh, so fast Peter, thank you. Then it's no need to take the V2 patch.

--xingchao

>From 3192939226ba274b5b9a32f07fc10025bb836ad3 Mon Sep 17 00:00:00 2001
From: Wang Xingchao <xingchao.wang@intel.com>
Date: Mon, 12 Sep 2011 14:30:16 +0800
Subject: [V2 PATCH] sched:remove extra nr_running check in
check_preempt_tick

nr_running must be more than 1, remove the checking.
We already test for nr_running > 1 in entity_tick(),
so it's no need to recheck it within check_preempt_tick().

Reviewed-by: Paul Turner <pjt@google.com>
Reviewed-by: yong.zhang0@gmail.com
Signed-off-by: Wang Xingchao <xingchao.wang@intel.com>
---
 kernel/sched_fair.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 1ca2cd4..fef0bfd 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1106,6 +1106,8 @@ static void
 check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 {
 	unsigned long ideal_runtime, delta_exec;
+	struct sched_entity *se;
+	s64 delta;
 
 	ideal_runtime = sched_slice(cfs_rq, curr);
 	delta_exec = curr->sum_exec_runtime -
curr->prev_sum_exec_runtime; @@ -1127,16 +1129,14 @@
check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr) if
(delta_exec < sysctl_sched_min_granularity) return;
 
-	if (cfs_rq->nr_running > 1) {
-		struct sched_entity *se = __pick_first_entity(cfs_rq);
-		s64 delta = curr->vruntime - se->vruntime;
+	se = __pick_first_entity(cfs_rq);
+	delta = curr->vruntime - se->vruntime;
 
-		if (delta < 0)
-			return;
+	if (delta < 0)
+		return;
 
-		if (delta > ideal_runtime)
-			resched_task(rq_of(cfs_rq)->curr);
-	}
+	if (delta > ideal_runtime)
+		resched_task(rq_of(cfs_rq)->curr);
 }
 
 static void
-- 
1.7.1
