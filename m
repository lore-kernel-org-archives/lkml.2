Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab0I3Fgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 01:36:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33303 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab0I3Fga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 01:36:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Pn2n72w3rQLk/1BOO8gqfjJaQ/8C99pRG0ZL2wbIomUbcr3ieq7dcGm2uwQo1o1y+r
         /aOxgU895G7EQaJB0yALOlUllD+avT5dkO6pAGl2qSgEdv8D28Akg8C58i8ViNkMojIz
         87HY4Q9G5uTBFVGTcXE6b1JizOpZR3FB3N43w=
Subject: Re: [PATCH 15/17] fs: inode per-cpu last_ino allocator
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100929215312.5fcb6976.akpm@linux-foundation.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	 <1285762729-17928-16-git-send-email-david@fromorbit.com>
	 <20100929215312.5fcb6976.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 07:36:22 +0200
Message-ID: <1285824982.5211.675.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 29 septembre 2010 à 21:53 -0700, Andrew Morton a écrit :
> On Wed, 29 Sep 2010 22:18:47 +1000 Dave Chinner <david@fromorbit.com> wrote:
> 
> > From: Eric Dumazet <dada1@cosmosbay.com>
> > 

Please note my new email address, thanks.

> > last_ino was converted to an atomic variable to allow the inode_lock
> > to go away. However, contended atomics do not scale on large
> > machines, and new_inode() triggers excessive contention in such
> > situations.
> > 
> > Solve this problem by providing to each cpu a per_cpu variable,
> > feeded by the shared last_ino, but once every 1024 allocations.
> > This reduces contention on the shared last_ino, and give same
> > spreading ino numbers than before (i.e. same wraparound after 2^32
> > allocations).
> > 
> > [npiggin: some extra commenting and use of defines]
> > 
> > ...
> >  
> > +#ifdef CONFIG_SMP
> > +#define LAST_INO_BATCH 1024
> > +/*
> > + * Each cpu owns a range of LAST_INO_BATCH numbers.
> > + * 'shared_last_ino' is dirtied only once out of LAST_INO_BATCH allocations,
> > + * to renew the exhausted range.
> > + *
> > + * This does not significantly increase overflow rate because every CPU can
> > + * consume at most LAST_INO_BATCH-1 unused inode numbers. So there is
> > + * NR_CPUS*(LAST_INO_BATCH-1) wastage. At 4096 and 1024, this is ~0.1% of the
> > + * 2^32 range, and is a worst-case. Even a 50% wastage would only increase
> > + * overflow rate by 2x, which does not seem too significant.
> > + *
> > + * On a 32bit, non LFS stat() call, glibc will generate an EOVERFLOW
> > + * error if st_ino won't fit in target struct field. Use 32bit counter
> > + * here to attempt to avoid that.
> > + */
> > +static DEFINE_PER_CPU(unsigned int, last_ino);
> > +static atomic_t shared_last_ino;
> > +
> > +static unsigned int last_ino_get(void)
> > +{
> > +	unsigned int *p = &get_cpu_var(last_ino);
> > +	unsigned int res = *p;
> > +
> > +	if (unlikely((res & (LAST_INO_BATCH-1)) == 0))
> > +		res = (unsigned int)atomic_add_return(LAST_INO_BATCH,
> > +				&shared_last_ino) - LAST_INO_BATCH;
> 
> May as well remove the "- LAST_INO_BATCH" there, I think.  It'll skew
> the results a tad at startup, but why does that matter?


Because on x86, atomic_add_return(val, ptr) uses xadd() + val

So, using "atomic_add_return(val, ptr) - val" removes one instruction ;)

> 
> > +	*p = ++res;
> > +	put_cpu_var(last_ino);
> > +	return res;
> > +}
> > +#else
> > +static unsigned int last_ino_get(void)
> > +{
> > +	static unsigned int last_ino;
> > +
> > +	return ++last_ino;
> > +}
> 
> This is racy with CONFIG_PREEMPT on some architectures, I suspect.  I'd
> suggest conversion to atomic_t with, of course, an explanatory comment ;)
> 

Thanks, I'll rework the patch !

I am pretty happy to see some interest on this patch serie,
eventually :)



