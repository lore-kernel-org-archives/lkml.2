Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab0JPJG7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 05:06:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110Ab0JPJG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 05:06:57 -0400
Date: Sat, 16 Oct 2010 02:07:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/17] fs: Convert nr_inodes to a per-cpu counter
Message-Id: <20101016020744.366bd9c6.akpm@linux-foundation.org>
In-Reply-To: <1287217748.2799.68.camel@edumazet-laptop>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	<1285762729-17928-17-git-send-email-david@fromorbit.com>
	<20100929215322.ff635d3e.akpm@linux-foundation.org>
	<20100930061039.GX5665@dastard>
	<20101016075510.GH19147@amd>
	<1287217748.2799.68.camel@edumazet-laptop>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Oct 2010 10:29:08 +0200 Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Le samedi 16 octobre 2010 __ 18:55 +1100, Nick Piggin a __crit :
> > On Thu, Sep 30, 2010 at 04:10:39PM +1000, Dave Chinner wrote:
> > > On Wed, Sep 29, 2010 at 09:53:22PM -0700, Andrew Morton wrote:
> > > > On Wed, 29 Sep 2010 22:18:48 +1000 Dave Chinner <david@fromorbit.com> wrote:
> > > > 
> > > > > From: Eric Dumazet <dada1@cosmosbay.com>
> > > > > 
> > > > > The number of inodes allocated does not need to be tied to the
> > > > > addition or removal of an inode to/from a list. If we are not tied
> > > > > to a list lock, we could update the counters when inodes are
> > > > > initialised or destroyed, but to do that we need to convert the
> > > > > counters to be per-cpu (i.e. independent of a lock). This means that
> > > > > we have the freedom to change the list/locking implementation
> > > > > without needing to care about the counters.
> > > > > 
> > > > >
> > > > > ...
> > > > >
> > > > > +int get_nr_inodes(void)
> > > > > +{
> > > > > +	int i;
> > > > > +	int sum = 0;
> > > > > +	for_each_possible_cpu(i)
> > > > > +		sum += per_cpu(nr_inodes, i);
> > > > > +	return sum < 0 ? 0 : sum;
> > > > > +}
> > > > 
> > > > This reimplements percpu_counter_sum_positive(), rather poorly
> > 
> > Why is it poorly?
> 
> Nick
> 
> Some people believe percpu_counter object is the right answer to such
> distributed counters, because the loop is done on 'online' cpus instead
> of 'possible' cpus. "It must be better if number of possible cpus is
> 4096 and only one or two cpus are online"...
> 
> But if we do this loop only on rare events, like
> "cat /proc/sys/fs/inode-nr", then the percpu_counter() is more
> expensive, because percpu_add() _is_ more expensive :
> 
> - Its a function call and lot of instructions/cycles per call, while
> this_cpu_inc(nr_inodes) is a single instruction, using no register on
> x86.

You want an inlined percpu_counter_inc() then write one!  Bonus points
for writing this_cpu_add_return() and doing it without a
preempt_disable().  It collapses to just a few instructions.

It's extremely poor form to say "oh X sucks so I'm going to implement
my own" without first addressing why X allegedly sucks.

> - Its possibly accessing a shared spinlock and counter when the percpu
> counter reaches the batch limit.

That's in the noise foor.

> To recap : nr_inodes is not a counter that needs to be estimated in real
> time, since we have not limit on number of inodes in the machine (limit
> is the memory allocator).
> 
> Unless someone can prove "cat /proc/sys/fs/inode-nr" must be performed
> thousand of times per second on their setup, the choice I made to scale
> nr_inodes is better over the 'obvious percpu_counter choice'
> 
> This choice was made to scale some counters in network stack some years
> ago, and this rocks.

And we get open-coded reimplementations of the same damn thing all over
the tree.

