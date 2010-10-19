Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216Ab0JSKBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:01:43 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:54019 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758138Ab0JSKBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:01:42 -0400
Message-ID: <4CBD6C84.3020309@kernel.dk>
Date: Tue, 19 Oct 2010 12:01:40 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] Fix array overflow in CFQ
References: <1287479450-11447-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1287479450-11447-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-19 11:10, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> gcc 4.5 complains when compiling a recent rc with
> 
> linux/block/cfq-iosched.c: In function ‘cfq_dispatch_requests’:
> linux/block/cfq-iosched.c:2156:3: warning: array subscript is above array bounds
> 
> and it is right:
> 
>  slice = group_slice * count /
>                 max_t(unsigned, cfqg->busy_queues_avg[cfqd->serving_prio],
>                       cfq_group_busy_queues_wl(cfqd->serving_prio, cfqd, cfqg));
> 
> busy_queues_avg can be indexed by this enum
> 
> enum wl_prio_t {
>         BE_WORKLOAD = 0,
>         RT_WORKLOAD = 1,
>         IDLE_WORKLOAD = 2,
> };
> 
> in cfqd->serving_prio, but is only declared as
> 
> unsigned int busy_queues_avg[2];
> 
> which is clearly off by one. Fix this here.

Indeed, that is definitely buggy. ->service_trees[][] looks buggy, too.
WTF?!

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 9eba291..8ce9f52 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -160,6 +160,7 @@ enum wl_prio_t {
 	BE_WORKLOAD = 0,
 	RT_WORKLOAD = 1,
 	IDLE_WORKLOAD = 2,
+	CFQ_PRIO_NR,
 };
 
 /*
@@ -168,7 +169,8 @@ enum wl_prio_t {
 enum wl_type_t {
 	ASYNC_WORKLOAD = 0,
 	SYNC_NOIDLE_WORKLOAD = 1,
-	SYNC_WORKLOAD = 2
+	SYNC_WORKLOAD = 2,
+	CFQ_TYPE_NR,
 };
 
 /* This is per cgroup per device grouping structure */
@@ -185,12 +187,12 @@ struct cfq_group {
 	int nr_cfqq;
 
 	/* Per group busy queus average. Useful for workload slice calc. */
-	unsigned int busy_queues_avg[2];
+	unsigned int busy_queues_avg[CFQ_PRIO_NR];
 	/*
 	 * rr lists of queues with requests, onle rr for each priority class.
 	 * Counts are embedded in the cfq_rb_root
 	 */
-	struct cfq_rb_root service_trees[2][3];
+	struct cfq_rb_root service_trees[CFQ_PRIO_NR][CFQ_TYPE_NR];
 	struct cfq_rb_root service_tree_idle;
 
 	unsigned long saved_workload_slice;

-- 
Jens Axboe

