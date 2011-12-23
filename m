Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab1LWBf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 20:35:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47191 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab1LWBfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 20:35:20 -0500
Date: Thu, 22 Dec 2011 17:38:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool and
 fix blkcg percpu alloc deadlock
Message-Id: <20111222173820.3461be5d.akpm@linux-foundation.org>
In-Reply-To: <20111223012112.GB12738@redhat.com>
References: <1324590326-10135-1-git-send-email-tj@kernel.org>
	<20111222135925.de3221c8.akpm@linux-foundation.org>
	<20111222220911.GK17084@google.com>
	<20111222142058.41316ee0.akpm@linux-foundation.org>
	<20111222224117.GL17084@google.com>
	<20111222145426.5844df96.akpm@linux-foundation.org>
	<20111222230047.GN17084@google.com>
	<20111222151649.de57746f.akpm@linux-foundation.org>
	<20111222232433.GQ17084@google.com>
	<20111222154138.d6c583e3.akpm@linux-foundation.org>
	<20111223012112.GB12738@redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Dec 2011 20:21:12 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:

> On Thu, Dec 22, 2011 at 03:41:38PM -0800, Andrew Morton wrote:
> > 
> > If the code *does* correctly handle ->stats_cpu == NULL then we have
> > options.
> > 
> > a) Give userspace a new procfs/debugfs file to start stats gathering
> >    on a particular cgroup/request_queue pair.  Allocate the stats
> >    memory in that.
> > 
> > b) Or allocate stats_cpu on the first call to blkio_read_stat_cpu()
> >    and return zeroes for this first call.
> 
> But the purpose of stats is that they are gathered even if somebody
> has not read them even once?

That's not a useful way of using stats.  The normal usage would be to
record the stats then start the workload then monitor how the stats
have changed as work proceeds.

> So if I create a cgroup and put some
> task into it which does some IO, I think stat collection should start
> immediately without user taking any action.

If you really want to know the stats since cgroup creation then trigger
the stats initialisation from userspace when creating the blkio_cgroup.

> Forcing the user to first
> read a stat before the collection starts is kind of odd to me.

Well one could add a separate stats_enable knob.  Doing it
automatically from read() would be for approximate-back-compatibility
with existing behaviour.

Plus (again) this way we also avoid burdening non-stats-users with the
overhead of stats.

> > 
> > c) Or change the low-level code to do
> >    blkio_group.want_stats_cpu=true, then test that at the top level
> >    after we've determined that blkio_group.stats_cpu is NULL.
> > 
> > d) Or, worse, punt the allocation into a workqueue thread.
> 
> I implemented a patch to punt the allocation using a worker thread. Tejun
> did not like it. I personally think that it is less intrusive to fix this
> specific problem.
> 
> https://lkml.org/lkml/2011/12/19/291

hm.

Look, the basic problem here is a highish-level design one.  We're
attempting to do a high-level heavyweight intialization operation in a
low-level place.  How do we fix that *properly*?  It has to be by
performing the heavyweight operation in an appropriate place.

> > 
> > Note that all these option will permit us to use GFP_KERNEL, which is
> > better.
> > 
> > Note that a) and b) means that users get control over whether these
> > stats are accumulated at all, so many won't incur needless memory and
> > CPU consumption.
> > 
> > I think I like b).  Fix the code so it doesn't oops when ->stats_cpu is
> > NULL, then turn on stats gathering the first time someone tries to read
> > the stats.
> > 
> > (Someone appears to have misspelled "throttle" as "throtl" for no
> > apparent reason about 1000 times.  Sigh.)
> 
> That someone would be me. I thought that throtl communicates the meaning
> and keeps the length of all the strings relatively short. But if it does
> not look good, I can change it.

It's unconventional.  We do usually avoid the odd abbreviations and
just spell the whole thing out.
