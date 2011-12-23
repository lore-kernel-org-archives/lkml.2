Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab1LWO7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 09:59:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab1LWO7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 09:59:05 -0500
Date: Fri, 23 Dec 2011 09:58:56 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool and
 fix blkcg percpu alloc deadlock
Message-ID: <20111223145856.GB16818@redhat.com>
References: <20111222224117.GL17084@google.com>
 <20111222145426.5844df96.akpm@linux-foundation.org>
 <20111222230047.GN17084@google.com>
 <20111222151649.de57746f.akpm@linux-foundation.org>
 <20111222232433.GQ17084@google.com>
 <20111222154138.d6c583e3.akpm@linux-foundation.org>
 <20111223012112.GB12738@redhat.com>
 <20111222173820.3461be5d.akpm@linux-foundation.org>
 <20111223025411.GD12738@redhat.com>
 <20111222191144.78aec23a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222191144.78aec23a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 07:11:44PM -0800, Andrew Morton wrote:
> On Thu, 22 Dec 2011 21:54:11 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > On Thu, Dec 22, 2011 at 05:38:20PM -0800, Andrew Morton wrote:
> > > On Thu, 22 Dec 2011 20:21:12 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:
> > > 
> > > > On Thu, Dec 22, 2011 at 03:41:38PM -0800, Andrew Morton wrote:
> > > > > 
> > > > > If the code *does* correctly handle ->stats_cpu == NULL then we have
> > > > > options.
> > > > > 
> > > > > a) Give userspace a new procfs/debugfs file to start stats gathering
> > > > >    on a particular cgroup/request_queue pair.  Allocate the stats
> > > > >    memory in that.
> > > > > 
> > > > > b) Or allocate stats_cpu on the first call to blkio_read_stat_cpu()
> > > > >    and return zeroes for this first call.
> > > > 
> > > > But the purpose of stats is that they are gathered even if somebody
> > > > has not read them even once?
> > > 
> > > That's not a useful way of using stats.  The normal usage would be to
> > > record the stats then start the workload then monitor how the stats
> > > have changed as work proceeds.
> > 
> > I have atleast one example "iostat" which does not follow this. Its
> > first report shows the total stats since the system boot and each 
> > subsequent report covers time since previous report. With stats being
> > available since the cgroup creation time, one can think of extending
> > iostat tool to display per IO cgroup stats too.
> 
> If that's useful (dubious) then it can be addressed by creating the
> stats when a device is bound to the cgroup (below).
> 
> > Also we have a knob "reset_stats" to reset all the stats to zero. So
> > one can first reset stats, starts workload and then monitor it (if one
> > does not like stats since the cgroup creation time).
> > 
> > > 
> > > > So if I create a cgroup and put some
> > > > task into it which does some IO, I think stat collection should start
> > > > immediately without user taking any action.
> > > 
> > > If you really want to know the stats since cgroup creation then trigger
> > > the stats initialisation from userspace when creating the blkio_cgroup.
> > 
> > These per cpu stats are per cgroup per device. So if a workload in a
> > cgroup is doing IO to 4 devices, we allocate 4 percpu stat areas for
> > stats. So at cgroup creation time we just don't know how many of these
> > to create and also it does not cover the case of device hotplug after
> > cgroup creation.
> 
> Mark the cgroup as "needing stats" then allocate the stats (if needed)
> when a device is bound to the cgroup.  Rather than on first I/O.

This will work for the throttling case where a user has to specifically
put throttling rules for each device and that can be considered as binding
device to the cgroup. In that case we will not be collecting the stats
for which there are no rules for the device. I guess I can live with that.

But it still does not work for the case of CFQ where there might not
be any user initiated device binding to cgroup. User might just specify
a cgroup weight (like task ioprio) and binding to device is automatically
created on first IO to the device from the cgroup. User does not initiate
any specific binding.

> 
> > > 
> > > > Forcing the user to first
> > > > read a stat before the collection starts is kind of odd to me.
> > > 
> > > Well one could add a separate stats_enable knob.  Doing it
> > > automatically from read() would be for approximate-back-compatibility
> > > with existing behaviour.
> > > 
> > > Plus (again) this way we also avoid burdening non-stats-users with the
> > > overhead of stats.
> > 
> > Even if we do that we have the problem with hoplugged device. Assume a
> > cgroup created, stats enabled now a new devices shows up and some task
> > in the group does IO on that device. Now we need to create percpu data
> > area for that cgroup-device pair dynamically in IO path and we are back
> > to the same problem. 
> 
> Why do the allocation during I/O?  Can't it be done in the hotplug handler?
> 

Even if we can do it in hotplug handler it will be very wasteful of
memory. So if there are 100 IO cgroups in the system, upon every block
device hotplug, we will allocate per cpu memory for all the 100 cgroups,
irrespective of the fact whether they are doing IO to the device or not.

Now expand this to a system with 100 cgroups and 100 Luns. 10000
allocations for no reason. (Even if we do it for cgroups needing stats,
does not help much). Current scheme allocates memory for the group
only if a sepcific cgroup is doing IO to a specific block device. 

Thanks
Vivek
