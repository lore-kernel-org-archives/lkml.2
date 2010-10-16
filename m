Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab0JPHzQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:55:16 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:60460 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753170Ab0JPHzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:55:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFP1uEx5LcB2/2dsb2JhbAChMXK8eIVJBI9K
Date: Sat, 16 Oct 2010 18:55:10 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/17] fs: Convert nr_inodes to a per-cpu counter
Message-ID: <20101016075510.GH19147@amd>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-17-git-send-email-david@fromorbit.com>
 <20100929215322.ff635d3e.akpm@linux-foundation.org>
 <20100930061039.GX5665@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930061039.GX5665@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 04:10:39PM +1000, Dave Chinner wrote:
> On Wed, Sep 29, 2010 at 09:53:22PM -0700, Andrew Morton wrote:
> > On Wed, 29 Sep 2010 22:18:48 +1000 Dave Chinner <david@fromorbit.com> wrote:
> > 
> > > From: Eric Dumazet <dada1@cosmosbay.com>
> > > 
> > > The number of inodes allocated does not need to be tied to the
> > > addition or removal of an inode to/from a list. If we are not tied
> > > to a list lock, we could update the counters when inodes are
> > > initialised or destroyed, but to do that we need to convert the
> > > counters to be per-cpu (i.e. independent of a lock). This means that
> > > we have the freedom to change the list/locking implementation
> > > without needing to care about the counters.
> > > 
> > >
> > > ...
> > >
> > > +int get_nr_inodes(void)
> > > +{
> > > +	int i;
> > > +	int sum = 0;
> > > +	for_each_possible_cpu(i)
> > > +		sum += per_cpu(nr_inodes, i);
> > > +	return sum < 0 ? 0 : sum;
> > > +}
> > 
> > This reimplements percpu_counter_sum_positive(), rather poorly

Why is it poorly?


> > If one never intends to use the approximate percpu_counter_read() then
> > one could initialise the counter with a really large batch value, for a
> > very small performance gain.

I did that to start with, and I was just looking to shave off cycles
and icache size. this_cpu_inc on x86 on a local variable is really
tiny and fast. percpu_counter does a function call which is large
and clobbers memory and registers, several branches, several loads and
stores, etc.

When it is a simple dumb statistics counter but with a critical
fastpath, this_cpu_inc just seems to be so much better.


> > > +int get_nr_inodes_unused(void)
> > > +{
> > > +	return inodes_stat.nr_unused;
> > > +}
> > >
> > > ...
> > >
> > > @@ -407,6 +407,8 @@ extern struct files_stat_struct files_stat;
> > >  extern int get_max_files(void);
> > >  extern int sysctl_nr_open;
> > >  extern struct inodes_stat_t inodes_stat;
> > > +extern int get_nr_inodes(void);
> > > +extern int get_nr_inodes_unused(void);
> > 
> > These are pretty cruddy names.  Unfotunately we don't really have a vfs
> > or "inode" subsystem name to prefix them with.

Any ideas? inodes_stat_nr_unused()?

