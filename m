Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab1HIKsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 06:48:14 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:46716 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752914Ab1HIKsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 06:48:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AroDAAkPQU55LbABgWdsb2JhbABCpzcVAQEWJiWBQAEBBTIBIyMQCAMOBgEDLhQlAyETxEIOhjgEmzyIRg
Date: Tue, 9 Aug 2011 20:48:04 +1000
From: Dave Chinner <david@fromorbit.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] dcache: convert dentry_stat.nr_unused to per-cpu
 counters
Message-ID: <20110809104804.GS3162@dastard>
References: <1312787021-11324-1-git-send-email-david@fromorbit.com>
 <1312787021-11324-2-git-send-email-david@fromorbit.com>
 <CAOJsxLEqNZYV-4qs3HM9EkX-C=KAzjuAXpDOaijykWaa4NSRbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOJsxLEqNZYV-4qs3HM9EkX-C=KAzjuAXpDOaijykWaa4NSRbg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 10:08:20AM +0300, Pekka Enberg wrote:
> On Mon, Aug 8, 2011 at 10:03 AM, Dave Chinner <david@fromorbit.com> wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > Before we split up the dcache_lru_lock, the unused dentry counter
> > needs to be made independent of the global dcache_lru_lock. Convert
> > it to per-cpu counters to do this.
> >
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/dcache.c |   17 ++++++++++++++---
> >  1 files changed, 14 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/dcache.c b/fs/dcache.c
> > index b05aac3..5e5208d 100644
> > --- a/fs/dcache.c
> > +++ b/fs/dcache.c
> > @@ -116,6 +116,7 @@ struct dentry_stat_t dentry_stat = {
> >  };
> >
> >  static DEFINE_PER_CPU(unsigned int, nr_dentry);
> > +static DEFINE_PER_CPU(unsigned int, nr_dentry_unused);
> >
> >  #if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
> >  static int get_nr_dentry(void)
> > @@ -127,10 +128,20 @@ static int get_nr_dentry(void)
> >        return sum < 0 ? 0 : sum;
> >  }
> >
> > +static int get_nr_dentry_unused(void)
> > +{
> > +       int i;
> > +       int sum = 0;
> > +       for_each_possible_cpu(i)
> > +               sum += per_cpu(nr_dentry_unused, i);
> > +       return sum < 0 ? 0 : sum;
> > +}
> 
> Why not use struct percpu_counter and percpu_counter_sum_positive() for this?

That's what I originally implemented for all these VFS per-cpu
counters. e.g:

cffbc8a fs: Convert nr_inodes and nr_unused to per-cpu counters

but then this happened:

commit 86c8749ede0c59e590de9267066932a26f1ce796
Author: Nick Piggin <npiggin@kernel.dk>
Date:   Fri Jan 7 17:49:18 2011 +1100

    vfs: revert per-cpu nr_unused counters for dentry and inodes
    
    The nr_unused counters count the number of objects on an LRU, and as such they
    are synchronized with LRU object insertion and removal and scanning, and
    protected under the LRU lock.
    
    Making it per-cpu does not actually get any concurrency improvements because o
    this lock, and summing the counter is much slower, and
    incrementing/decrementing it costs more code size and is slower too.
    
    These counters should stay per-LRU, which currently means global.
    
    Signed-off-by: Nick Piggin <npiggin@kernel.dk>

and then, because the per-cpu counters were actually necessary,
a couple of patches later in the series per-cpu counters were
re-introduced:

commit 3e880fb5e4bb6a012035e3edd0586ee2817c2e24
Author: Nick Piggin <npiggin@kernel.dk>
Date:   Fri Jan 7 17:49:19 2011 +1100

    fs: use fast counters for vfs caches
    
    percpu_counter library generates quite nasty code, so unless you need
    to dynamically allocate counters or take fast approximate value, a
    simple per cpu set of counters is much better.
    
    The percpu_counter can never be made to work as well, because it has an
    indirection from pointer to percpu memory, and it can't use direct
    this_cpu_inc interfaces because it doesn't use static PER_CPU data, so
    code will always be worse.

....

No point in making arguments about how using and improving the
generic counter helps everyone, the maintenance is lower as well,
or that we are summing the counters on every single shrinker call
(i.e. could be thousands of times a second) so we need fast
approximate values to be taken.

The change to per-sb LRUs actually takes away the need to sum the
VFS inode and dentry counters on every shrinker call, so now the use
of the roll-your-own counter structure makes a bit of sense because
they are only read when someone read /proc/sys/fs/dentry-state. It
sure as hell didn't make sense back when this code was merged,
though....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
