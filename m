Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab2DDNhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 09:37:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288Ab2DDNhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 09:37:12 -0400
Date: Wed, 4 Apr 2012 09:37:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shli@kernel.org>
Cc: Tao Ma <tm@tao.ma>, Tejun Heo <tj@kernel.org>, axboe@kernel.dk,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: IOPS based scheduler (Was: Re: [PATCH 18/21] blkcg: move
 blkio_group_conf->weight to cfq)
Message-ID: <20120404133705.GB12676@redhat.com>
References: <4F7A2217.2030201@tao.ma>
 <20120402221702.GA21017@dhcp-172-17-108-109.mtv.corp.google.com>
 <4F7A261A.9000200@tao.ma>
 <20120402222504.GA2672@redhat.com>
 <4F7A2B21.5000907@tao.ma>
 <20120403153736.GI5913@redhat.com>
 <4F7B2708.6080504@tao.ma>
 <20120403164959.GJ5913@redhat.com>
 <4F7B32AE.7050900@tao.ma>
 <CANejiEU1qAsvogozY3MjZnpcrbYZO4CkRE8s73WGPc_R5LKV9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANejiEU1qAsvogozY3MjZnpcrbYZO4CkRE8s73WGPc_R5LKV9g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 05:35:49AM -0700, Shaohua Li wrote:

[..]
> >> How iops_weight and switching different than CFQ group scheduling logic?
> >> I think shaohua was talking of using similar logic. What would you do
> >> fundamentally different so that without idling you will get service
> >> differentiation?
> > I am thinking of differentiate different groups with iops, so if there
> > are 3 groups(the weight are 100, 200, 300) we can let them submit 1 io,
> > 2 io and 3 io in a round-robin way. With a intel ssd, every io can be
> > finished within 100us. So the maximum latency for one io is about 600us,
> > still less than 1ms. But with cfq, if all the cgroups are busy, we have
> > to switch between these group in ms which means the maximum latency will
> > be 6ms. It is terrible for some applications since they use ssds now.
> Yes, with iops based scheduling, we do queue switching for every request.
> Doing the same thing between groups is quite straightforward. The only issue
> I found is this will introduce more process context switch, this isn't
> a big issue
> for io bound application, but depends. It cuts latency a lot, which I
> guess is more
> important for web 2.0 application.

In iops_mode(), expire each cfqq after dispatch of 1 or bunch of requests
and you should get the same behavior (with slice_idle=0 and group_idle=0).
So why write a new scheduler.

Only thing is that with above, current code will provide iops fairness only
for groups. We should be able to tweak queue scheduling to support iops
fairness also.

Anyway, we will end up doing that at some point of time. Supporting two
scheduling algorihtms for queue and groups is not sustainable. There are
already calls to make CFQ hierarchical and in that case both queue and
groups need to be on a single service tree and that means need to follow
same algorithm for scheduling.

Thanks
Vivek
