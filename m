Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab2DDRRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 13:17:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202Ab2DDRRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 13:17:20 -0400
Date: Wed, 4 Apr 2012 13:17:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tao Ma <tm@tao.ma>
Cc: Shaohua Li <shli@kernel.org>, Tejun Heo <tj@kernel.org>, axboe@kernel.dk,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: IOPS based scheduler (Was: Re: [PATCH 18/21] blkcg: move
 blkio_group_conf->weight to cfq)
Message-ID: <20120404171712.GG12676@redhat.com>
References: <20120402222504.GA2672@redhat.com>
 <4F7A2B21.5000907@tao.ma>
 <20120403153736.GI5913@redhat.com>
 <4F7B2708.6080504@tao.ma>
 <20120403164959.GJ5913@redhat.com>
 <4F7B32AE.7050900@tao.ma>
 <CANejiEU1qAsvogozY3MjZnpcrbYZO4CkRE8s73WGPc_R5LKV9g@mail.gmail.com>
 <20120404133705.GB12676@redhat.com>
 <4F7C7A91.8040707@tao.ma>
 <20120404165048.GF12676@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120404165048.GF12676@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 12:50:48PM -0400, Vivek Goyal wrote:
> On Thu, Apr 05, 2012 at 12:45:05AM +0800, Tao Ma wrote:
> 
> [..]
> > > In iops_mode(), expire each cfqq after dispatch of 1 or bunch of requests
> > > and you should get the same behavior (with slice_idle=0 and group_idle=0).
> > > So why write a new scheduler.
> > really? How could we config cfq to work like this? Or you mean we can
> > change the code for it?
> 
> You can just put a few lines of code to expire queue after 1-2 requests
> dispatched from the queue. Than run your workload with slice_idle=0
> and group_idle=0 and see what happens.

Can you apply following patch and test your workload with slice_idle=0,
group_idle=0 and quantum=64/128.

I expect that fast queue and group switching will take place. Even if your
workload is creating continuously backlogged queues, we will still
expire the queue after dispatching 5 requests from the queue and requeue
it.

I also expect that you should see service differentation at *group level*.
(And not at cfqq level), if your workload is creating continuously
backlogged groups. Otherwise it will effectively become round robin
scheduling.

If possible, send me small backtrace (5 seconds trace), of your workload
and that can help understand little better what is going on.

Thanks
Vivek


---
 block/cfq-iosched.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/block/cfq-iosched.c
===================================================================
--- linux-2.6.orig/block/cfq-iosched.c	2012-04-03 23:18:33.000000000 -0400
+++ linux-2.6/block/cfq-iosched.c	2012-04-05 00:02:07.517806185 -0400
@@ -655,8 +655,13 @@ cfq_set_prio_slice(struct cfq_data *cfqd
  */
 static inline bool cfq_slice_used(struct cfq_queue *cfqq)
 {
+	/* In iops mode, we really are not looking for time measurement */
+	if (iops_mode(cfqq->cfqd) && cfqq->slice_dispatch > 5)
+		return true;
+
 	if (cfq_cfqq_slice_new(cfqq))
 		return false;
+
 	if (time_before(jiffies, cfqq->slice_end))
 		return false;
 
