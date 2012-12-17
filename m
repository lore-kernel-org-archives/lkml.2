Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab2LQRiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 12:38:10 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42781 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab2LQRiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 12:38:08 -0500
Date: Mon, 17 Dec 2012 09:38:00 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com,
        Peter Zijlstra <pzijlstr@redhat.com>, peterz@infradead.org
Subject: Re: [PATCHSET] block: implement blkcg hierarchy support in cfq
Message-ID: <20121217173800.GB2592@htj.dyndns.org>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
 <20121217165228.GB7235@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121217165228.GB7235@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Mon, Dec 17, 2012 at 11:52:28AM -0500, Vivek Goyal wrote:
> I am wondering if blkio.task_group_weight[_device] will more sense. It
> is easier to think in terms of hidden task group of a cfqg instead of
> whether it is a leaf node or not.

As long as we stick to something consistent and short (one word
please), I don't think it'll matter all that much and the
"leaf_weight" stands for weight for the hidden leaf node.

> >   these tasks.  Another way to look at it is that each cfqg has a
> >   hidden leaf child node attached to it which hosts all tasks and
> >   leaf_weight controls the weight of that hidden node.
> > 
> >   Treating cfqqs and cfqgs as equals doesn't make much sense to me and
> >   is hairy - we need to establish ioprio to weight mapping and the
> >   weights fluctuate as processes fork and exit.
> 
> So weights of task (io_context) or blkcg weights don't fluctuate with
> task fork/exit. It is just the weight on service tree, which fluctuates.

Why would the weight on service tree fluctuate?

> > This becomes hairier
> >   when considering multiple controllers, Such mappings can't be
> >   established consistently across different controllers and the
> >   weights are given out differently - ie. blkcg give weights out to
> >   io_contexts while cpu to tasks, which may share io_contexts.  It's
> >   difficult to make sense of what's going on.
> 
> We already have that issue, isn't it. Cpu does task scheduling and
> CFQ does io_context scheduling. (Nobody seems to be complaining though).

We don't have that issue yet because cfq doesn't do hierarchical
weighting yet and people are not co-mounting cpu and blkio.

> I think we first need to have some kind of buy-in from cpu controller
> guys that yes in long term they will change it. Otherwise we don't want
> to be stuck in a situation where cpu and blkio behave entirely
> differently.

Sure, I was planning to work on that once blkio is in place but it's
not like we can be consistent in any other way and I don't think
making cpu support this behavior would be too difficult.  It's just
dealing with an extra leaf node after all.  Peter?

> In fact we need to revisit this idea that what makes more sense. To
> me treating task and group at same level is not necessarily bad as
> it gives more flexibility. And leave it to user to create another
> subgroup and launch all the tasks there if they want to emulate the
> behavior of a hidden sub-group.

We'll have to disagree here.

> If you look at it systemd already puts services in separate group. They
> always wanted to put user sessions also in a separate group. So
> effectively hierarhcy looks as follows (for cpu controller).
> 
> 			  root
> 		        / | \  \ 
> 		      T1 T2 usr system
> 
> So T1 and T2 here basically a kernel threds (All users sessions and
> services have been moved out to respective cgroups).
> 
> I think I am fine with not limiting kernel threads into a subgroup of
> their own. In fact I think there was a patch where we could not move
> kernel threads out of root cgroup. If that makes sense, then it does
> not make sense to limit kernel threads to a subgroup of their own
> by default (it is equivalent to moving these threads to a cgroup of
> their own).

How is that relevant to the discussion at hand?  That's about having
no limit for root cgroup.  For anything weight-based, you can't have
"no" weight.

> So though I don't mind the notion of this hidden cgroups but given
> the fact that we have implemented things other way and left it to
> user space to manage it based on their needs, I am not sure what's
> that fundamental reason that we should change that assumption now.

Hmmm?  blkio doesn't work like that *at all*.  Currently, it basically
treats the root cgroup as a leaf group, so I'm kinda lost why you're
talking about "changing the assumption" because the proposed patchset
maintains the existing behavior (at least for 1-level hierarchy) while
what you're suggesting would change the behavior fundamentally.

So, in terms of compatibility, I don't think there's a clear better
way here.  cpu and blkio are already doing things differently and we
need to pick one to unify the behavior and I think having separate
weight for tasks in internal node is a better one because

* Configuration lives in cgroup proper.  No need to somehow map
  per-schedule-entity attribute to cgroup weight, which is hairy and
  non-obvious.

* Different controllers deal with different scheduling-entities and it
  becomes very difficult to tell how the weight is actually being
  distributed.  It's just nasty.

> And even if we decide to do it, we need to have other controllers
> on board (especially cpu).

Only cpu actually.  That's the only other controller which implements
weight based control and I'm fairly sure we can implement such
behavior in cpu in backward compatible way.

> I think we will have similar issues with others components too. In blkio
> throttling support, we will have to put some kind of throttling limits
> on internal group too. I guess one can raise similar concerns for memory
> controller too where there are no internal limits on child task of a
> cgroup but there are limits on child group.

I don't think so.  We need some way of assigning weights between tasks
of an internal cgroup and children.  No such issue exists for
non-weight based controllers.  I don't see any reason to change that.

Thanks.

-- 
tejun
