Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab1LWBk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 20:40:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761Ab1LWBky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 20:40:54 -0500
Date: Thu, 22 Dec 2011 20:40:43 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool and
 fix blkcg percpu alloc deadlock
Message-ID: <20111223014043.GC12738@redhat.com>
References: <1324590326-10135-1-git-send-email-tj@kernel.org>
 <20111222135925.de3221c8.akpm@linux-foundation.org>
 <20111222220911.GK17084@google.com>
 <20111222142058.41316ee0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222142058.41316ee0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 02:20:58PM -0800, Andrew Morton wrote:
> On Thu, 22 Dec 2011 14:09:11 -0800
> Tejun Heo <tj@kernel.org> wrote:
> 
> > Hello,
> > 
> > On Thu, Dec 22, 2011 at 01:59:25PM -0800, Andrew Morton wrote:
> > > How about we just delete those statistics and then this patchset?
> > > 
> > > Or how about we change those statistics to not do percpu allocations,
> > > then delete this patchset?
> > 
> > I'm not against above both
> 
> Don't just consider my suggestions - please try to come up with your own
> alternatives too!  If all else fails then this patch is a last resort.
> 
> > but apparently those percpu stats reduced
> > CPU overhead significantly.
> 
> Deleting them would save even more CPU.
> 

[..]
> Or make them runtime or compile-time configurable, so only the
> developers see the impact.

Some of the stats are already under debug option (DEBUG_BLK_CGROUP). But
rest seem to be useful ones to be put under debug option.

Making them run time configuration is an option. I am assuming that would
be a global option and not per cgroup per device option. If yes, then
again you have same problem where after enabling the stat, any new
group creation or new device creation will require allocation of per
cpu stat.

So I think we need to figure out a way to be able to allocation per cpu
stat dynamically.

> 
> Some specifics on which counters are causing the problems would help here.

Various kind of stats are collected. Current per cpu stats are.

- Number of sectors transferred.
- Number of bytes transferred.
- Number of IOs transferred.
- Number of IOs merged 

If a user has not put any throttling rules in the cgroup, then we do want
to collect the stats but don't want to take any locks. Otherwise on fast
devices, ex PCI-E based flash, it becomes a bottleneck.

So far we were taking request queue lock. I guess if we fall back to
non-per cpu stats, we should be able to get away with group's stat
lock (blkg->stats_lock) and access the group under rcu. So this will
be an improvement as lock will be per group and not per device but
I think it is still a problem for most of the users because most contended
group is root group.

Distributions are now shipping throttling logic enabled and by default
all IO goes through root group and for every IO submission we don't
want to take blkg->stats lock just to collect the stats.

That's why the need of per cpu data structures to make stat collection
lockless.

Thanks
Vivek
