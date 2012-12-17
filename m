Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab2LQSuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 13:50:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612Ab2LQSuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 13:50:51 -0500
Date: Mon, 17 Dec 2012 13:50:14 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com,
        Peter Zijlstra <pzijlstr@redhat.com>, peterz@infradead.org
Subject: Re: [PATCHSET] block: implement blkcg hierarchy support in cfq
Message-ID: <20121217185014.GC7235@redhat.com>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
 <20121217165228.GB7235@redhat.com>
 <20121217173800.GB2592@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121217173800.GB2592@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 09:38:00AM -0800, Tejun Heo wrote:

[..]
> > >   Treating cfqqs and cfqgs as equals doesn't make much sense to me and
> > >   is hairy - we need to establish ioprio to weight mapping and the
> > >   weights fluctuate as processes fork and exit.
> > 
> > So weights of task (io_context) or blkcg weights don't fluctuate with
> > task fork/exit. It is just the weight on service tree, which fluctuates.
> 
> Why would the weight on service tree fluctuate?

Because tasks come and go and get queued on service tree. I am referring
to total_weight on service tree and not weight of individual entity. That
will change only if ioprio of task changes or blkio.weight is updated.

[..]
> > I think we first need to have some kind of buy-in from cpu controller
> > guys that yes in long term they will change it. Otherwise we don't want
> > to be stuck in a situation where cpu and blkio behave entirely
> > differently.
> 
> Sure, I was planning to work on that once blkio is in place but it's
> not like we can be consistent in any other way and I don't think
> making cpu support this behavior would be too difficult.  It's just
> dealing with an extra leaf node after all.  Peter?

I am not concerned about implementation. I am only worried about having
agreement that having a hidden group is a better thing to do as compared
to what we have now.

[..]
> > So though I don't mind the notion of this hidden cgroups but given
> > the fact that we have implemented things other way and left it to
> > user space to manage it based on their needs, I am not sure what's
> > that fundamental reason that we should change that assumption now.
> 
> Hmmm?  blkio doesn't work like that *at all*.  Currently, it basically
> treats the root cgroup as a leaf group, so I'm kinda lost why you're
> talking about "changing the assumption" because the proposed patchset
> maintains the existing behavior (at least for 1-level hierarchy) while
> what you're suggesting would change the behavior fundamentally.

I am comparing the change of behavior w.r.t cpu controller. Initially
we had implemented a full hierarchical controller (cpu like). It was
lot of code and never went any where so we ended up writing flat
controller. 

> 
> So, in terms of compatibility, I don't think there's a clear better
> way here.  cpu and blkio are already doing things differently and we
> need to pick one to unify the behavior and I think having separate
> weight for tasks in internal node is a better one because
> 
> * Configuration lives in cgroup proper.  No need to somehow map
>   per-schedule-entity attribute to cgroup weight, which is hairy and
>   non-obvious.
> 
> * Different controllers deal with different scheduling-entities and it
>   becomes very difficult to tell how the weight is actually being
>   distributed.  It's just nasty.
> 

Ok, so you want more preditability and don't want to rely on task
prio or ioprio so that when you co-mount cpu and blkio, you don't
have to worry about different behaviors and just by looking at cgroup
configuration you can tell what % of resoruce a group will get. Makes
sense.

[..]
> > I think we will have similar issues with others components too. In blkio
> > throttling support, we will have to put some kind of throttling limits
> > on internal group too. I guess one can raise similar concerns for memory
> > controller too where there are no internal limits on child task of a
> > cgroup but there are limits on child group.
> 
> I don't think so.  We need some way of assigning weights between tasks
> of an internal cgroup and children.  No such issue exists for
> non-weight based controllers.  I don't see any reason to change that.

I am not sure about that. So the general idea is that how resources of
a group are distributed among its children. I am not sure why are you
dismissing this notion in max limit controllers.

For example, if parent has 100MB/limit and it has 4 childs (T1, T2, T3 and G1),
then either all children can get 25MB/s or T1/T2/T3 colectively get
50MB/s and G1 gets 50MB/s. So to me question of hidden group and
its share w,r.t sibling entities is very much valid here too.

Having said that, what you are doing for CFQ, should make blk-throttle
hierachical easier. We just need to queue all IO from all tasks of
a group in a single entity and just round robin between this entity
and sibling groups. Otherwise making throttling hierarchical will become
tricky as we shall have to maintain per task queues in block throttling
layer too.

Well, I don't mind treating all tasks as a sub-group and let that sub-group
compete with sibling groups. Just want to make sure cpu controller guys
are on-board.

Thanks
Vivek
