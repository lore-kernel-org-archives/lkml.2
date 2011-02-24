Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab1BXArJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 19:47:09 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35448 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab1BXArH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 19:47:07 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 24 Feb 2011 09:40:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Greg Thelen <gthelen@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Ryo Tsuruta <ryov@valinux.co.jp>,
        Hirokazu Takahashi <taka@valinux.co.jp>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        containers@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/5] blk-throttle: writeback and swap IO control
Message-Id: <20110224094039.89c07bea.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110224001033.GF2526@redhat.com>
References: <1298394776-9957-1-git-send-email-arighi@develer.com>
	<20110222193403.GG28269@redhat.com>
	<20110222224141.GA23723@linux.develer.com>
	<20110223000358.GM28269@redhat.com>
	<20110223083206.GA2174@linux.develer.com>
	<20110223152354.GA2526@redhat.com>
	<20110223231410.GB1744@linux.develer.com>
	<20110224001033.GF2526@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011 19:10:33 -0500
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Thu, Feb 24, 2011 at 12:14:11AM +0100, Andrea Righi wrote:
> > On Wed, Feb 23, 2011 at 10:23:54AM -0500, Vivek Goyal wrote:
> > > > > Agreed. Granularity of per inode level might be accetable in many 
> > > > > cases. Again, I am worried faster group getting stuck behind slower
> > > > > group.
> > > > > 
> > > > > I am wondering if we are trying to solve the problem of ASYNC write throttling
> > > > > at wrong layer. Should ASYNC IO be throttled before we allow task to write to
> > > > > page cache. The way we throttle the process based on dirty ratio, can we
> > > > > just check for throttle limits also there or something like that.(I think
> > > > > that's what you had done in your initial throttling controller implementation?)
> > > > 
> > > > Right. This is exactly the same approach I've used in my old throttling
> > > > controller: throttle sync READs and WRITEs at the block layer and async
> > > > WRITEs when the task is dirtying memory pages.
> > > > 
> > > > This is probably the simplest way to resolve the problem of faster group
> > > > getting blocked by slower group, but the controller will be a little bit
> > > > more leaky, because the writeback IO will be never throttled and we'll
> > > > see some limited IO spikes during the writeback.
> > > 
> > > Yes writeback will not be throttled. Not sure how big a problem that is.
> > > 
> > > - We have controlled the input rate. So that should help a bit.
> > > - May be one can put some high limit on root cgroup to in blkio throttle
> > >   controller to limit overall WRITE rate of the system.
> > > - For SATA disks, try to use CFQ which can try to minimize the impact of
> > >   WRITE.
> > > 
> > > It will atleast provide consistent bandwindth experience to application.
> > 
> > Right.
> > 
> > > 
> > > >However, this is always
> > > > a better solution IMHO respect to the current implementation that is
> > > > affected by that kind of priority inversion problem.
> > > > 
> > > > I can try to add this logic to the current blk-throttle controller if
> > > > you think it is worth to test it.
> > > 
> > > At this point of time I have few concerns with this approach.
> > > 
> > > - Configuration issues. Asking user to plan for SYNC ans ASYNC IO
> > >   separately is inconvenient. One has to know the nature of workload.
> > > 
> > > - Most likely we will come up with global limits (atleast to begin with),
> > >   and not per device limit. That can lead to contention on one single
> > >   lock and scalability issues on big systems.
> > > 
> > > Having said that, this approach should reduce the kernel complexity a lot.
> > > So if we can do some intelligent locking to limit the overhead then it
> > > will boil down to reduced complexity in kernel vs ease of use to user. I 
> > > guess at this point of time I am inclined towards keeping it simple in
> > > kernel.
> > > 
> > 
> > BTW, with this approach probably we can even get rid of the page
> > tracking stuff for now.
> 
> Agreed.
> 
> > If we don't consider the swap IO, any other IO
> > operation from our point of view will happen directly from process
> > context (writes in memory + sync reads from the block device).
> 
> Why do we need to account for swap IO? Application never asked for swap
> IO. It is kernel's decision to move soem pages to swap to free up some
> memory. What's the point in charging those pages to application group
> and throttle accordingly?
> 

I think swap I/O should be controlled by memcg's dirty_ratio.
But, IIRC, NEC guy had a requirement for this...

I think some enterprise cusotmer may want to throttle the whole speed of
swapout I/O (not swapin)...so, they may be glad if they can limit throttle
the I/O against a disk partition or all I/O tagged as 'swapio' rather than
some cgroup name.

But I'm afraid slow swapout may consume much dirty_ratio and make things
worse ;)



> > 
> > However, I'm sure we'll need the page tracking also for the blkio
> > controller soon or later. This is an important information and also the
> > proportional bandwidth controller can take advantage of it.
> 
> Yes page tracking will be needed for CFQ proportional bandwidth ASYNC
> write support. But until and unless we implement memory cgroup dirty
> ratio and figure a way out to make writeback logic cgroup aware, till
> then I think page tracking stuff is not really useful.
> 

I think Greg Thelen is now preparing patches for dirty_ratio.

Thanks,
-Kame

