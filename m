Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab2LQS7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 13:59:39 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61499 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab2LQS7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 13:59:37 -0500
Date: Mon, 17 Dec 2012 10:59:31 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com,
        Peter Zijlstra <pzijlstr@redhat.com>, peterz@infradead.org
Subject: Re: [PATCHSET] block: implement blkcg hierarchy support in cfq
Message-ID: <20121217185931.GB1844@htj.dyndns.org>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
 <20121217165228.GB7235@redhat.com>
 <20121217173800.GB2592@htj.dyndns.org>
 <20121217185014.GC7235@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121217185014.GC7235@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Vivek.

On Mon, Dec 17, 2012 at 01:50:14PM -0500, Vivek Goyal wrote:
> > > So weights of task (io_context) or blkcg weights don't fluctuate with
> > > task fork/exit. It is just the weight on service tree, which fluctuates.
> > 
> > Why would the weight on service tree fluctuate?
> 
> Because tasks come and go and get queued on service tree. I am referring
> to total_weight on service tree and not weight of individual entity. That
> will change only if ioprio of task changes or blkio.weight is updated.

Ah, okay.  Yeah, that's how the weight based distribution works after
all.  BTW, if you view the vfraction as the effective weight, the
total always remains close to 1 after the patches.

> > Hmmm?  blkio doesn't work like that *at all*.  Currently, it basically
> > treats the root cgroup as a leaf group, so I'm kinda lost why you're
> > talking about "changing the assumption" because the proposed patchset
> > maintains the existing behavior (at least for 1-level hierarchy) while
> > what you're suggesting would change the behavior fundamentally.
> 
> I am comparing the change of behavior w.r.t cpu controller. Initially
> we had implemented a full hierarchical controller (cpu like). It was
> lot of code and never went any where so we ended up writing flat
> controller. 

I see.  Yeah, but we have to change the behavior of either to make
them consistent.  I think introducing leaf weight is both more
desriable and also easier to do.

> > So, in terms of compatibility, I don't think there's a clear better
> > way here.  cpu and blkio are already doing things differently and we
> > need to pick one to unify the behavior and I think having separate
> > weight for tasks in internal node is a better one because
> > 
> > * Configuration lives in cgroup proper.  No need to somehow map
> >   per-schedule-entity attribute to cgroup weight, which is hairy and
> >   non-obvious.
> > 
> > * Different controllers deal with different scheduling-entities and it
> >   becomes very difficult to tell how the weight is actually being
> >   distributed.  It's just nasty.
> > 
> 
> Ok, so you want more preditability and don't want to rely on task
> prio or ioprio so that when you co-mount cpu and blkio, you don't
> have to worry about different behaviors and just by looking at cgroup
> configuration you can tell what % of resoruce a group will get. Makes
> sense.

Yeap, pretty much.

> > I don't think so.  We need some way of assigning weights between tasks
> > of an internal cgroup and children.  No such issue exists for
> > non-weight based controllers.  I don't see any reason to change that.
> 
> I am not sure about that. So the general idea is that how resources of
> a group are distributed among its children. I am not sure why are you
> dismissing this notion in max limit controllers.

The thing is that for weight based ones, it's essential.  You have to
decide the ratio somehow.  There's no default no-config way to fall
back to.  For limit-based ones, it isn't essential and none of the
current controllers implements such internal node limit.  It *could*
be useful but there hasn't been any direct call for such limits, so I
just don't see a good reason to push that.

> For example, if parent has 100MB/limit and it has 4 childs (T1, T2, T3 and G1),
> then either all children can get 25MB/s or T1/T2/T3 colectively get
> 50MB/s and G1 gets 50MB/s. So to me question of hidden group and
> its share w,r.t sibling entities is very much valid here too.

I'm not saying that there aren't any situations where such limit would
be useful, but I'd like to have stronger rationale before go
implementing new features.

> Having said that, what you are doing for CFQ, should make blk-throttle
> hierachical easier. We just need to queue all IO from all tasks of
> a group in a single entity and just round robin between this entity
> and sibling groups. Otherwise making throttling hierarchical will become
> tricky as we shall have to maintain per task queues in block throttling
> layer too.
> 
> Well, I don't mind treating all tasks as a sub-group and let that sub-group
> compete with sibling groups. Just want to make sure cpu controller guys
> are on-board.

Sure.

Thanks.

-- 
tejun
