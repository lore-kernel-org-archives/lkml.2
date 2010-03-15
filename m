Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965321Ab0COQQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 12:16:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:53055 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965237Ab0COQQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 12:16:00 -0400
Date: Tue, 16 Mar 2010 03:15:32 +1100
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: john stultz <johnstul@us.ibm.com>, Christoph Hellwig <hch@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: Re: Nick's vfs-scalability patches ported to 2.6.33-rt
Message-ID: <20100315161531.GF2869@laptop>
References: <1267163608.2002.9.camel@work-vm>
 <20100226060109.GH9738@laptop>
 <1267659090.4317.67.camel@localhost.localdomain>
 <20100304033312.GO8653@laptop>
 <1267675511.4317.78.camel@localhost.localdomain>
 <1268189462.3339.12.camel@localhost.localdomain>
 <20100310090142.GA9529@infradead.org>
 <1268363312.3475.85.camel@localhost.localdomain>
 <20100312044112.GC4732@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100312044112.GC4732@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 03:41:12PM +1100, Dave Chinner wrote:
> On Thu, Mar 11, 2010 at 07:08:32PM -0800, john stultz wrote:
> > On Wed, 2010-03-10 at 04:01 -0500, Christoph Hellwig wrote:
> > > On Tue, Mar 09, 2010 at 06:51:02PM -0800, john stultz wrote:
> > > > So this all means that with Nick's patch set, we're no longer getting
> > > > bogged down in the vfs (at least at 8-way) at all. All the contention is
> > > > in the actual filesystem (ext2 in group_adjust_blocks, and ext3 in the
> > > > journal and block allocation code).
> > > 
> > > Can you check if you're running into any fs scaling limit with xfs?
> > 
> > 
> > Here's the charts from some limited testing:
> > http://sr71.net/~jstultz/dbench-scalability/graphs/2.6.33/xfs-dbench.png
> 
> What's the X-axis? Number of clients?

Yes I think so (either it's dbench clients, or CPUs).

 
> If so, I have previously tested XFS to make sure throughput is flat
> out to about 1000 clients, not 8. i.e I'm not interested in peak
> throughput from dbench (generally a meaningless number), I'm much
> more interested in sustaining that throughput under the sorts of
> loads a real fileserver would see...

dbench is simply one that is known bad for core vfs locks. If it is
run on top of tmpfs it gives relatively stable numbers, and on a
real filesystem on ramdisk it works OK too. Not sure if John was
running it on a ramdisk though.

It does emulate the syscall pattern coming from samba running netbench
test, so it's not _totally_ meaningless :)

In this case, we're mostly interested in it to see if there are
contended locks or cachelines left.

> 
> > They're not great.  And compared to ext3, the results are basically
> > flat.
> > http://sr71.net/~jstultz/dbench-scalability/graphs/2.6.33/ext3-dbench.png
> > 
> > Now, I've not done any real xfs work before, so if there is any tuning
> > needed for dbench, please let me know.
> 
> Dbench does lots of transactions which runs XFS into being log IO
> bound. Make sure you have at least a 128MB log and are using
> lazy-count=1 andperhaps even the logbsize=262144 mount option.  but
> in general it only takes 2-4 clients to reach maximum throughput on
> XFS....
> 
> > The odd bit is that perf doesn't show huge overheads in the xfs runs.
> > The spinlock contention is supposedly under 5%. So I'm not sure whats
> > causing the numbers to be so bad.
> 
> It's bound by sleeping locks or IO. call-graph based profiles
> triggered on context switches are the easiest way to find the
> contending lock.
> 
> Last time I did this (around 2.6.16, IIRC) it involved patching the
> kernel to put the sample point in the context switch code - can we
> do that now without patching the kernel?

lock profiling can track sleeping locks, profile=schedule and
profile=sleep still works OK too. Don't know if any useful tracing
stuff is there for locks yet.

