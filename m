Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab1CGUYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 15:24:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab1CGUYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 15:24:41 -0500
Date: Mon, 7 Mar 2011 15:24:32 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Justin TerAvest <teravest@google.com>, Chad Talbott <ctalbott@google.com>,
        Nauman Rafique <nauman@google.com>, Divyesh Shah <dpshah@google.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: RFC: default group_isolation to 1, remove option
Message-ID: <20110307202432.GH9540@redhat.com>
References: <AANLkTinXa4Zjg0zGbPQRZQi2QW_-0y+PBzQwcdjPLVKZ@mail.gmail.com>
 <20110301142002.GB25699@redhat.com>
 <4D6F0ED0.80804@kernel.dk>
 <AANLkTin+TycqQxWGyxWOsuT+WOaEA0XhqFkJBMKe7-uY@mail.gmail.com>
 <4D753488.6090808@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D753488.6090808@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 08:39:52PM +0100, Jens Axboe wrote:
> On 2011-03-07 19:20, Justin TerAvest wrote:
> > On Wed, Mar 2, 2011 at 7:45 PM, Jens Axboe <axboe@kernel.dk> wrote:
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
> >> the theory), then yes we can move to per-ioc limits instead and get rid
> >> of that queue state. We'd have to hold on to the ioc for the duration of
> >> the IO explicitly from the request then.
> >>
> >> I primarily like that implementation since it means we can make the IO
> >> completion lockless, at least on the block layer side. We still have
> >> state to complete in the schedulers that require that, but it's a good
> >> step at least.
> > 
> > So, the primary advantage of using per-ioc limits that we can make IO
> > completions lockless?
> 
> Primarily, yes. The rq pool and accounting is the only state left we
> have to touch from both queuing IO and completing it.
> 
> > I'm concerned that looking up the correct iocontext for a page will be
> > more complicated, and require more storage (than a css_id, anyway). I
> > think Vivek mentioned this too.
> 
> A contained cgroup, is that sharing an IO context across the processes?

Not necessarily. We can have tasks in an IO cgroup which are not sharing
io context. 

> 
> > I don't understand what the advantage is of offering isolation between
> > iocontexts within a cgroup; if the user wanted isolation, shouldn't
> > they just create multiple cgroups? It seems like per-cgroup limits
> > would work as well.
> 
> It's at least not my goal, it has nothing to do with isolation. Since we
> have ->make_request_fn() drivers operating completely without queuing
> limits, it may just be that we can drop the tracking completely on the
> request side. Either one is currently broken, or both will work that
> way. And if that is the case, then we don't have to do this ioc tracking
> at all. With the additional complication of now needing
> per-disk-per-process io contexts, that approach is looking a lot more
> tasty right now.

I am writting the code for per-disk-per-process io context and it is
significant amount of code and as code size is growing I am also wondering
if it worth the complication.

Currently request queue blocks a process if device is congested. It might
happen that one process in a low weight cgroup is doing writes and has
consumed all available request descriptors (it is really easy to produce)
and now device is congested. Now any writes from high weight/prio cgroup
will not even be submitted on request queue and hence they can not be
given priority by CFQ.

> 
> Or not get rid of limits completely, but do a lot more relaxed
> accounting at the queue level still. That will not require any
> additional tracking of io contexts etc, but still impose some limit on
> the number of queued IOs.

A lot more relaxed limit accounting should help a bit but it after a 
while it might happen that slow movers eat up lots of request descriptors
and making not much of progress.

Long back I had implemented this additional notion of q->nr_group_requests
where we defined per group number of requests allowed submitter will
be put to sleep. I also extended it to also export per bdi per group
congestion notion. So a flusher thread can look at the page and cgroup
of the page and determine if respective cgroup is congested or not. If
cgroup is congested, flusher thread can move to next inode so that it
is not put to sleep behind a slow mover.

Completely limitless queueu will solve the problem completely. But I guess
then we can get that complain back that flusher thread submitted too much
of IO to device.

So given then fact that per-ioc-per-disk accounting of request descriptors
makes the accounting complicated and also makes it hard for block IO
controller to use it, the other approach of implementing per group limit
and per-group-per-bdi congested might be reasonable. Having said that, the
patch I had written for per group descritor was also not necessarily very
simple.

Thanks
Vivek
