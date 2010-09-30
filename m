Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab0I3EwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 00:52:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752403Ab0I3EwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 00:52:09 -0400
Date: Wed, 29 Sep 2010 21:53:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/17] fs: inode per-cpu last_ino allocator
Message-Id: <20100929215312.5fcb6976.akpm@linux-foundation.org>
In-Reply-To: <1285762729-17928-16-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	<1285762729-17928-16-git-send-email-david@fromorbit.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 22:18:47 +1000 Dave Chinner <david@fromorbit.com> wrote:

> From: Eric Dumazet <dada1@cosmosbay.com>
> 
> last_ino was converted to an atomic variable to allow the inode_lock
> to go away. However, contended atomics do not scale on large
> machines, and new_inode() triggers excessive contention in such
> situations.
> 
> Solve this problem by providing to each cpu a per_cpu variable,
> feeded by the shared last_ino, but once every 1024 allocations.
> This reduces contention on the shared last_ino, and give same
> spreading ino numbers than before (i.e. same wraparound after 2^32
> allocations).
> 
> [npiggin: some extra commenting and use of defines]
> 
> ...
>  
> +#ifdef CONFIG_SMP
> +#define LAST_INO_BATCH 1024
> +/*
> + * Each cpu owns a range of LAST_INO_BATCH numbers.
> + * 'shared_last_ino' is dirtied only once out of LAST_INO_BATCH allocations,
> + * to renew the exhausted range.
> + *
> + * This does not significantly increase overflow rate because every CPU can
> + * consume at most LAST_INO_BATCH-1 unused inode numbers. So there is
> + * NR_CPUS*(LAST_INO_BATCH-1) wastage. At 4096 and 1024, this is ~0.1% of the
> + * 2^32 range, and is a worst-case. Even a 50% wastage would only increase
> + * overflow rate by 2x, which does not seem too significant.
> + *
> + * On a 32bit, non LFS stat() call, glibc will generate an EOVERFLOW
> + * error if st_ino won't fit in target struct field. Use 32bit counter
> + * here to attempt to avoid that.
> + */
> +static DEFINE_PER_CPU(unsigned int, last_ino);
> +static atomic_t shared_last_ino;
> +
> +static unsigned int last_ino_get(void)
> +{
> +	unsigned int *p = &get_cpu_var(last_ino);
> +	unsigned int res = *p;
> +
> +	if (unlikely((res & (LAST_INO_BATCH-1)) == 0))
> +		res = (unsigned int)atomic_add_return(LAST_INO_BATCH,
> +				&shared_last_ino) - LAST_INO_BATCH;

May as well remove the "- LAST_INO_BATCH" there, I think.  It'll skew
the results a tad at startup, but why does that matter?

> +	*p = ++res;
> +	put_cpu_var(last_ino);
> +	return res;
> +}
> +#else
> +static unsigned int last_ino_get(void)
> +{
> +	static unsigned int last_ino;
> +
> +	return ++last_ino;
> +}

This is racy with CONFIG_PREEMPT on some architectures, I suspect.  I'd
suggest conversion to atomic_t with, of course, an explanatory comment ;)


> +#endif

