Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab0D1PKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:10:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259Ab0D1PKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:10:05 -0400
Date: Wed, 28 Apr 2010 11:09:59 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: CFQ is broken for CONFIG_BLK_CGROUP=y, CFQ_GROUP_IOSCHED=n
Message-ID: <20100428150959.GA16033@redhat.com>
References: <877hnrg30c.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877hnrg30c.fsf@openvz.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 04:44:51PM +0400, Dmitry Monakhov wrote:
> 
> I've had an  oops on kernel boot due to NULL pointer deference
> linux-2.6-block/for-next HEAD:7eaed1226ab411ee5dc8c34fc0d8034e4c98e3c6
> I've enabled CONFIG_BLK_CGROUP, but not CFQ_GROUP_IOSCHED
> In this case cfq_ref_get_cfqg() defined as 
> static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg)
> {
>         return NULL;
> }
> So following call trace is simply NOOP
> cfq_set_request()
>  rq->elevator_private3 = cfq_ref_get_cfqg(cfqq->cfqg);
> 
> Which later result in OOPS on bio insertion
> cfq_insert_request
>  -> blkiocg_update_io_add_stats(&(RQ_CFQG(rq))->blkg,...)
>     -> spin_lock_irqsave(&blkg->stats_lock, flags);
> 
> Bad commit.
> >From 7f1dc8a2d2f45fc557b27fd56115338b1d34fc24 Mon Sep 17 00:00:00 2001
> From: Vivek Goyal <vgoyal@redhat.com>
> Date: Wed, 21 Apr 2010 17:44:16 +0200
> Subject: [PATCH] blkio: Fix blkio crash during rq stat update

Dmitry, this patch should fix the issue. Can you please give it a try.

Jens, I know you don't like this form of cfq_ref_get_cfqg(), but this
seems to be the simplest solution to fix it.

cfq-iosched: fix cfq crash with CFQ_GROUP_IOSCHED=n

Dmitry reported an oops with CFQ when booted with BLK_CGROUP=y and
CFQ_GROUP_IOSCHED=n. This patch fixes it.

We maintain a root group even if group ioscheduling is not enabled. Hence
don't store NULL in elevator_private3 in that case.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 286008c..5aa5364 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1002,10 +1002,9 @@ static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
 	return cfqg;
 }
 
-static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg)
+static inline void cfq_ref_get_cfqg(struct cfq_group *cfqg)
 {
 	atomic_inc(&cfqg->ref);
-	return cfqg;
 }
 
 static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
@@ -1092,10 +1091,7 @@ static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
 	return &cfqd->root_group;
 }
 
-static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg)
-{
-	return NULL;
-}
+static inline void cfq_ref_get_cfqg(struct cfq_group *cfqg) {}
 
 static inline void
 cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg) {
@@ -3574,7 +3570,8 @@ new_queue:
 
 	rq->elevator_private = cic;
 	rq->elevator_private2 = cfqq;
-	rq->elevator_private3 = cfq_ref_get_cfqg(cfqq->cfqg);
+	rq->elevator_private3 = cfqq->cfqg;
+	cfq_ref_get_cfqg(cfqq->cfqg);
 	return 0;
 
 queue_fail:
-- 
1.6.2.5

