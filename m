Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973Ab0EYCDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 22:03:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757217Ab0EYCDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 22:03:53 -0400
Date: Mon, 24 May 2010 22:03:39 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] io-controller: Add new interfaces to trace
	backlogged group status
Message-ID: <20100525020339.GA8214@redhat.com>
References: <4BF64712.1070500@cn.fujitsu.com> <20100521131751.GA15302@redhat.com> <4BF9D265.70008@cn.fujitsu.com> <20100524212207.GC28685@redhat.com> <4BFB29DB.10507@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFB29DB.10507@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 09:37:31AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > On Mon, May 24, 2010 at 09:12:05AM +0800, Gui Jianfeng wrote:
> >> Vivek Goyal wrote:
> >>> On Fri, May 21, 2010 at 04:40:50PM +0800, Gui Jianfeng wrote:
> >>>> Hi,
> >>>>
> >>>> This series implements three new interfaces to keep track of tranferred bytes,
> >>>> elapsing time and io rate since group getting backlogged. If the group dequeues
> >>>> from service tree, these three interfaces will reset and shows zero.
> >>> Hi Gui,
> >>>
> >>> Can you give some details regarding how this functionality is useful? Why
> >>> would somebody be interested in only in stats of till group was
> >>> backlogged and not in total stats?
> >>>
> >>> Groups can come and go so fast and these stats will reset so many times
> >>> that I am not able to visualize how these stats will be useful.
> >> Hi Vivek,
> >>
> >> Currently, we assign weight to a group, but user still doesn't know how fast the
> >> group runs. With io rate interface, users can check the rate of a group at any
> >> moment, or to determine whether the weight assigned to a group is enough.
> >> bytes and time interface is just for debug purpose.
> > 
> > Gui,
> > 
> > I still don't understand that why blkio.sectors or blkio.io_service_bytes
> > or blkio.io_serviced interfaces are not good enough to determine at what
> > rate a group is doing IO.
> > 
> > I think we can very well write something in userspace like "iostat" to 
> > display the per group rate. Utility can read the any of the above files
> > say at the interfval of 1s, calculate the diff between the values and
> > display that as group effective rate.
> 
> Hi Vivek,
> 
> blkio.io_active_rate reflects the rate since group get backlogged, so the rate is a smooth 
> value. This value represents the actual rate a group runs. IMO, io rate calculated from
> user space is not accurate in following two scenarios:
> 
> 1 Userspace app chooses the interval of 1s, if 0.5s is backlogged and 0.5s is not, the 
>   rate calculated in this interval doesn't make sense.
> 

If you are not servicing groups for long time, anyway it is very bad for
latency. So that's why soft limit of 300ms of CFQ makes sense and
practically I am not sure you will be blocking groups for .5s.

Even if you do, then user just needs to choose a bigger interval and you
will see more smooth rates. Reduce the interval and you might see little
bursty rate.

And, why do you say that "io_active_rate" is smooth interface. IIUC, the
value of group rate will vary depending on time when I read the file.

Assume a group gets serviced for 30ms and then is put back in the queue
and is serviced again after 50ms. If I read the "io_active_rate"
immediately after group has been serviced I should see a high rate value
and if I read the same file after another 30ms I would see a reduced rate.

Point being that to get a better idea of average rate of group, we need
to observe byte transferred over a little longer period. If you sample
bytes transferred from a group over a very short interval then you can
expect bursty output. There is no way to avoid that?

> 2 Consider there're several groups are waiting for service, but most part of the interval
>   is just fall into the period that the group is under-service. such rate calculated by user
>   app isn't acurate, rate burst might occur.

Actually I think that whole notion of relying on time calculations of CFQ
is not very good. these are very approximate time calculations. There are
many situations where calculating time is not possible and we approximate
the slice_used to 1ms. So relying on that time for rate calculation is
much more inaccurate.

Hence I think calculating group's rate in user space makes much more
sense.

> 
> Further more, once max weight control is available, we can make use of such interface to realize
> how well this group works.

Again I don't understand with max BW controller, why can't we monitor the
group's BW in userspace accurately?

Vivek
