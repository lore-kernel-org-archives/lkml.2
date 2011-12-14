Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761Ab1LNRWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 12:22:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386Ab1LNRWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 12:22:39 -0500
Date: Wed, 14 Dec 2011 12:22:34 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Nate Custer <nate@cpanel.net>, kvm@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: kvm deadlock
Message-ID: <20111214172234.GB25484@redhat.com>
References: <54FC5923-2123-4BDD-A506-EA57DCE0C1F6@cpanel.net>
 <20111214122511.GD18317@amt.cnet>
 <4EE8A7ED.7060703@redhat.com>
 <4EE8C8EA.9070207@kernel.dk>
 <20111214170347.GA25484@redhat.com>
 <4EE8D863.5000701@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE8D863.5000701@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 06:09:55PM +0100, Jens Axboe wrote:
> On 2011-12-14 18:03, Vivek Goyal wrote:
> >>> I think the allocation in blkio_alloc_blkg_stats() should be moved out
> >>> of the I/O path into some init function. Copying Jens.
> >>
> >> That's completely buggy, basically you end up with a GFP_KERNEL
> >> allocation from the IO submit path. Vivek, per_cpu data needs to be set
> >> up at init time. You can't allocate it dynamically off the IO path.
> > 
> > Hi Jens,
> > 
> > I am wondering how does CFQ get away with blocking cfqq allocation in
> > IO submit path. I see that blk_queue_bio() will do following.
> > 
> > blk_queue_bio()
> >  get_request_wait()
> >   get_request(..,..,GFP_NOIO)
> >    blk_alloc_request()
> >     elv_set_request()
> >      cfq_set_request()
> >       ---> Can sleep and do memory allocation in IO submit path as
> >            GFP_NOIO has __GFP_WAIT.
> > 
> > So that means sleeping allocation from IO submit path is not necessarily
> > a problem?
> 

[..]
> __GFP_WAIT isn't the problem, you can block in the IO path. You cannot,
> however, recurse back into IO submission. That's why CFQ is using
> GFP_NOIO, implying that waiting is OK, but submitting new IO to satisfy
> the allocation is not.

Ok. Got it. So even if we implement mutex_is_locked() check, it does not
protect me from possiblity of per cpu allocation path recursing into
IO submission. That means, there needs to be a variant of per cpu
allocation which can take the allocation flags as parameter and honor
these flags.

> 
> > But in case of per cpu data allocation, we might be holding
> > pcpu_alloc_mutex() already at the time of calling pcpu allocation
> > again and that might lead to deadlock.  (As Avi mentioned). If yes,
> > then it is a problem.
> 
> It is both a problem and somewhat of a mess...
> 
> > Right now allocation of root group and associated stats happens at
> > queue initialization time. For non-root cgroups, group allocation and
> > associated per cpu stats allocation happens dynamically when the IO is
> > submitted. So in this case may be we are creating a new blkio cgroup
> > and then doing IO which leads to this warning.
> > 
> > I am not sure how to move this allocation to init path. These stats
> > are per group and groups are created dynamically as IO happens in
> > them. Only init path seems to be cgroup creation time. blkg is an
> > object which is contained in a parent object and at that time parent
> > object is not available. It is created dynamically at the IO time
> > (cfq_group, blkio_group etc).
> > 
> > Though it is little hackish but can we just delay the allocation of
> > stats if pcpu_alloc_mutex is held. We shall have to make
> > pcpu_alloc_mutex non static though. Delaying will just not capture the
> > stats for some time and sooner or later we will get regular IO with
> > pcpu_alloc_mutex not held and we can do per cpu allocation at that
> > time. I will write a a test patch.
> > 
> > Or may be there is a safer version of pcpu alloc which will return
> > without allocation if pcpu_alloc_mutex is already locked.
> 
> Both of these proposed solutions aren't really pretty. It would be
> cleaner and have better runtime for the fast path if you could alloc all
> of these when the non-root groups are setup. Why isn't it done that way
> right now?

Actually non-root group itself is setup when first IO happens in the
group. When an IO is submitted, we determine which cgroup does it belong
to, then we see if we have already setup the group. If not, then we
go on to alloc one. (Currently I use GFP_ATOMIC for group allocation).

So group allocation itself happens in IO path (like cfqq allocation),
hence per group per cpu stats are also allocated in that path.

We can't setup blkio groups at the cgroup creation time as at that time
we don't even know how many request queues are threre and on how many
of them cfq is being used.

Setup of root group at queue initialization time is easy. But we can't
setup all other cgroups at that time as it does not take care of future
cgroup creation. Also it will waste memory if cgroups are there but no
IO is happening in them.

Thanks
Vivek
