Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab1CHAGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 19:06:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab1CHAGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 19:06:04 -0500
Date: Mon, 7 Mar 2011 19:05:55 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Justin TerAvest <teravest@google.com>, Chad Talbott <ctalbott@google.com>,
        Nauman Rafique <nauman@google.com>, Divyesh Shah <dpshah@google.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: RFC: default group_isolation to 1, remove option
Message-ID: <20110308000555.GA22264@redhat.com>
References: <AANLkTinXa4Zjg0zGbPQRZQi2QW_-0y+PBzQwcdjPLVKZ@mail.gmail.com>
 <20110301142002.GB25699@redhat.com>
 <4D6F0ED0.80804@kernel.dk>
 <AANLkTin+TycqQxWGyxWOsuT+WOaEA0XhqFkJBMKe7-uY@mail.gmail.com>
 <4D753488.6090808@kernel.dk>
 <20110307202432.GH9540@redhat.com>
 <4D7540F6.3080303@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7540F6.3080303@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 09:32:54PM +0100, Jens Axboe wrote:
> On 2011-03-07 21:24, Vivek Goyal wrote:
> > On Mon, Mar 07, 2011 at 08:39:52PM +0100, Jens Axboe wrote:
> >> It's at least not my goal, it has nothing to do with isolation. Since we
> >> have ->make_request_fn() drivers operating completely without queuing
> >> limits, it may just be that we can drop the tracking completely on the
> >> request side. Either one is currently broken, or both will work that
> >> way. And if that is the case, then we don't have to do this ioc tracking
> >> at all. With the additional complication of now needing
> >> per-disk-per-process io contexts, that approach is looking a lot more
> >> tasty right now.
> > 
> > I am writting the code for per-disk-per-process io context and it is
> > significant amount of code and as code size is growing I am also wondering
> > if it worth the complication.
> 
> Yep, I don't think we should do that.
> 
> > Currently request queue blocks a process if device is congested. It might
> > happen that one process in a low weight cgroup is doing writes and has
> > consumed all available request descriptors (it is really easy to produce)
> > and now device is congested. Now any writes from high weight/prio cgroup
> > will not even be submitted on request queue and hence they can not be
> > given priority by CFQ.
> > 
> >>
> >> Or not get rid of limits completely, but do a lot more relaxed
> >> accounting at the queue level still. That will not require any
> >> additional tracking of io contexts etc, but still impose some limit on
> >> the number of queued IOs.
> > 
> > A lot more relaxed limit accounting should help a bit but it after a 
> > while it might happen that slow movers eat up lots of request descriptors
> > and making not much of progress.
> > 
> > Long back I had implemented this additional notion of q->nr_group_requests
> > where we defined per group number of requests allowed submitter will
> > be put to sleep. I also extended it to also export per bdi per group
> > congestion notion. So a flusher thread can look at the page and cgroup
> > of the page and determine if respective cgroup is congested or not. If
> > cgroup is congested, flusher thread can move to next inode so that it
> > is not put to sleep behind a slow mover.
> > 
> > Completely limitless queueu will solve the problem completely. But I guess
> > then we can get that complain back that flusher thread submitted too much
> > of IO to device.
> > 
> > So given then fact that per-ioc-per-disk accounting of request descriptors
> > makes the accounting complicated and also makes it hard for block IO
> > controller to use it, the other approach of implementing per group limit
> > and per-group-per-bdi congested might be reasonable. Having said that, the
> > patch I had written for per group descritor was also not necessarily very
> > simple.
> 
> So before all of this gets over designed a lot... If we get rid of the
> one remaining direct buffered writeback in bdp(), then only the flusher
> threads should be sending huge amounts of IO. So if we attack the
> problem from that end instead, have it do that accounting in the bdi.
> With that in place, I'm fairly confident that we can remove the request
> limits.
> 
> Basically just replace the congestion_wait() in there with a bit of
> accounting logic. Since it's per bdi anyway, we don't even have to
> maintain that state in the bdi itself. It can remain in the thread
> stack.

I am wondering if we can make use of per BDI_WRITEBACK per bdi state
to keep track of bdi state and do congestion_wait() accouting accordingly.
It is percpu so we will introduce some inaccuracy but I guess the goal here
is not to do very accurate nr_request accouting. That should atleast
remove nr_request accouting from queue.

For cgroup stuff, may be we can maintain some state in memory cgroups. For
example, some kind of per bdi writeback in progress from that memory cgroup.
If a BDI is congested then we can do some additional checks whether any
IO from this cgroup is in progress or not a particular BDI. If yes, we 
throttle the writeout otherwise we allow the thread to submit more IO.

So in practice q->nr_requests gets replaced with bdi->bdi_stat[BDI_WRITEBACK].
That way nr_request moves out of request queue. As bdi_stat is per cpu,
locking overhead should reduce overall. I think tricky part is how to
keep track of per cgroup per bdi stat. We need some kind of simple
approximation to allow IO from one cgroup to multiple bdi at the same
time.

Thanks
Vivek
