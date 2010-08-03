Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657Ab0HCUQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 16:16:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757554Ab0HCUQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 16:16:22 -0400
Date: Tue, 3 Aug 2010 16:15:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, Ryo Tsuruta <ryov@valinux.co.jp>,
        taka@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
        Andrea Righi <righi.andrea@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
        balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 00/11] blkiocg async support
Message-ID: <20100803201532.GF29355@redhat.com>
References: <4C369009.80503@ds.jp.nec.com>
 <20100802205834.GD24697@redhat.com>
 <4C582845.6070408@ds.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C582845.6070408@ds.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 10:31:33AM -0400, Munehiro Ikeda wrote:

[..]
> >Muuh,
> >
> >You will require one more piece and that is support for per cgroup request
> >descriptors on request queue. With writes, it is so easy to consume those
> >128 request descriptors.
> 
> Hi Vivek,
> 
> Yes.  Thank you for the comment.
> I have two concerns to do that.
> 
> (1) technical concern
> If there is fixed device-wide limitation and there are so many groups,
> the number of request descriptors distributed to each group can be too
> few.  My only idea for this is to make device-wide limitation flexible,
> but I'm not sure if it is the best or even can be allowed.
> 
> (2) implementation concern
> Now the limitation is done by generic block layer which doesn't know
> about grouping.  The idea in my head to solve this is to add a new
> interface on elevator_ops to ask IO scheduler if a new request can
> be allocated.
> 

Acutally it is good point. We already call into CFQ (cfq_may_queue()) for
doing some kind of determination regarding what is the urgency of request
allocation.

May be we can just keep track of how many outstanding requests are there
per group in CFQ. And inside CFQ always allow request allocation for the
active group. We can probably not allow this if a group has already got
many requests backlogged (say more than 16).

We might overshoot number of request descriptors on device wide limitation
but we do any way (allow upto 50% more requests descriptors etc).

So not introducing per group limit through sysfs and just doing some rough
internal calculations in CFQ and being little flexible with over allocation
of request descriptors, it might reduce complexity.

But it probably will not solve the problem of higher layer asking if queue
is congested or not. It might happen that request queue is overall congested
but a high priority group should not be affected by that and still be able
to submit requests. I think this primarily is used only in WRITE paths. So
READ path should still be fine.

Once WRITE support is in, we need to probably introduce additional
mechanism where we can queury per bdi per group congestion instead of
per bdi congestion. One group might be congested and but not the other
one. I had done that in my previous postings.

Thanks
Vivek 
