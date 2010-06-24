Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab0FXPwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 11:52:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862Ab0FXPwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 11:52:50 -0400
Date: Fri, 25 Jun 2010 01:52:43 +1000
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 42/52] fs: icache per-cpu last_ino allocator
Message-ID: <20100624155243.GI10441@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030732.402670838@suse.de>
 <87tyosahia.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tyosahia.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 11:48:13AM +0200, Andi Kleen wrote:
> npiggin@suse.de writes:
> 
> > From: Eric Dumazet <dada1@cosmosbay.com>
> >
> > new_inode() dirties a contended cache line to get increasing inode numbers.
> >
> > Solve this problem by providing to each cpu a per_cpu variable, feeded by the
> > shared last_ino, but once every 1024 allocations.
> 
> Most file systems don't even need this because they 
> allocate their own inode numbers, right?. So perhaps it could be turned
> off for all of those, e.g. with a superblock flag.

That's right. More or less it just requires alloc_inode to be exported,
adding more branches in new_inode would not be a good way to go.

But I didn't want to start microoptimisations in filesystems just yet.

 
> I guess the main customer is sockets only.

I guess. Sockets and ram based filesystems. Interestingly I don't know
really what it's for (in socket code it's mostly for reporting and
hashing it seems). It sure isn't guaranteed to be unique.

Anyway it's outside the scope of this patchset to change functionality
at all.

 
> > +#ifdef CONFIG_SMP
> > +/*
> > + * Each cpu owns a range of 1024 numbers.
> > + * 'shared_last_ino' is dirtied only once out of 1024 allocations,
> > + * to renew the exhausted range.
> > + *
> > + * On a 32bit, non LFS stat() call, glibc will generate an EOVERFLOW
> > + * error if st_ino won't fit in target struct field. Use 32bit counter
> > + * here to attempt to avoid that.
> 
> I don't understand how the 32bit counter should prevent that.
 
Well I think glibc will convert 64 bit stat struct to 32bit for
old apps. It detects if the ino can't fit in 32 bits.


> > +static DEFINE_PER_CPU(int, last_ino);
> > +static atomic_t shared_last_ino;
> 
> With the 1024 skip, isn't overflow much more likely, just scaling
> with the number of CPUs on a large CPU number systems, even if there
> aren't that many new inodes?

Well EOVERFLOW should never happen with only the low 32 significant
bits set in the inode. If you are worried about wrapping the counter,
then no I don't think it is much more likely.

Because each CPU will only reserve another 1024 inode interval after
it has already allocated 1024 numbers. So the most wastage you will
get is (1024-1)*NR_CPUS -- somewhere around 1/1000th of the available
range.

I guess overflow will be more common now because it will be possible
to allocate inodes much faster on such a huge machine :)

 
> > +static int last_ino_get(void)
> > +{
> > +	int *p = &get_cpu_var(last_ino);
> > +	int res = *p;
> > +
> > +	if (unlikely((res & 1023) == 0))
> > +		res = atomic_add_return(1024, &shared_last_ino) - 1024;
> 
> The magic numbers really want to be defines? 

Sure OK.

