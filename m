Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab1CCQ5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 11:57:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab1CCQ5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 11:57:34 -0500
Date: Thu, 3 Mar 2011 11:57:17 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Justin TerAvest <teravest@google.com>, Chad Talbott <ctalbott@google.com>,
        Nauman Rafique <nauman@google.com>, Divyesh Shah <dpshah@google.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>
Subject: Re: Per iocontext request descriptor limits (Was: Re: RFC: default
 group_isolation to 1, remove option)
Message-ID: <20110303165717.GA19527@redhat.com>
References: <AANLkTinXa4Zjg0zGbPQRZQi2QW_-0y+PBzQwcdjPLVKZ@mail.gmail.com>
 <20110301142002.GB25699@redhat.com>
 <4D6F0ED0.80804@kernel.dk>
 <20110303153007.GF16720@redhat.com>
 <4D6FB751.3010608@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6FB751.3010608@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 10:44:17AM -0500, Jens Axboe wrote:
> On 2011-03-03 10:30, Vivek Goyal wrote:
> > On Wed, Mar 02, 2011 at 10:45:20PM -0500, Jens Axboe wrote:
> >> On 2011-03-01 09:20, Vivek Goyal wrote:
> >>> I think creating per group request pool will complicate the
> >>> implementation further. (we have done that once in the past). Jens
> >>> once mentioned that he liked number of requests per iocontext limit
> >>> better than overall queue limit. So if we implement per iocontext
> >>> limit, it will get rid of need of doing anything extra for group
> >>> infrastructure.
> >>>
> >>> Jens, do you think per iocontext per queue limit on request
> >>> descriptors make sense and we can get rid of per queue overall limit? 
> >>
> >> Since we practically don't need a limit anymore to begin with (or so is
> >> the theory).
> > 
> > So what has changed that we don't need queue limits on nr_requests anymore?
> > If we get rid of queue limits then we need to get rid of bdi congestion
> > logic also and come up with some kind of ioc congestion logic so that
> > a thread which does not want to sleep while submitting the request needs to
> > checks it own ioc for being congested or not for a specific device/bdi. 
> 
> Right now congestion is a measure of request starvation on the OS side.
> It may make sense to keep the notion of a congested device when we are
> operating at the device limits. But as a blocking measure it should go
> away.

Ok, so keep q->nr_requests around to only figure out when a queue/device
is congested or not but a submitter does not actually block on a congested
device. A submitter will block only if it ioc->nr_requests are exceeding.

So keeping nontion of bdi congested will not hurt.

> 
> No recent change is causing us to be able to throw away the limit. It
> used to be that the vm got really unhappy with long queues, since you
> could have tons of memory dirty. This works a LOT better now. And one
> would hope that it does, since there are a number of drivers that don't
> have limts. So when I say "practically" don't need limits anymore, the
> hope is that we'll behave well enough with just per-ioc limits in place.

Ok. Understood.

> 
> >> then yes we can move to per-ioc limits instead and get rid
> >> of that queue state. We'd have to hold on to the ioc for the duration of
> >> the IO explicitly from the request then.
> > 
> > I think every request submitted on request queue already takes a reference
> > on ioc (set_request) and reference is not dropped till completion. So
> > ioc is anyway around till request completes.
> 
> That's only true for CFQ, it's not a block layer property. This would
> have to be explicitly done.

Oh yes. only CFQ set_request call takes reference and it does that 
because CFQ looks into ioc for ioprio, class and cfq queues are per
ioc. So yes, this notion shall have to be brought to block layer. 

> 
> >> I primarily like that implementation since it means we can make the IO
> >> completion lockless, at least on the block layer side. We still have
> >> state to complete in the schedulers that require that, but it's a good
> >> step at least.
> > 
> > Ok so in completion path the contention will move from queue_lock to
> > ioc lock or something like that. (We hope that there are no other
> > dependencies on queue here, devil lies in details :-))
> 
> Right, so it's spread out and in most cases the ioc will be completely
> uncontended since it's usually private to the process.

Ok, that makes sense. ioc is per process so lock contetion in completion
path goes down.

> 
> > The other potential issue with this approach is how will we handle the
> > case of flusher thread submitting IO. At some point of time we want to
> > account it to right cgroup.
> > 
> > Retrieving iocontext from bio will be hard as it will atleast require
> > on extra pointer in page_cgroup and I am not sure how feasible that is.
> > 
> > Or we could come up with the concept of group iocontext. With the help
> > of page cgroup we should be able to get to cgroup, retrieve the right
> > group iocontext and check the limit against that. But I guess this
> > get complicated. 
> > 
> > So if we move to ioc based limit, then for async IO, a reasonable way
> > would be to find the io context of submitting task and operate on that
> > even if that means increased page_cgroup size.
> 
> For now it's not a complicated effort, I already have a patch for this.
> If page tracking needs extra complexity, it'll have to remain in the
> page tracking code.

Great. I am hoping once you get some free time, you will cleanup and post
that patch.

Thanks
Vivek
