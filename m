Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab0FXJsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 05:48:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51151 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab0FXJsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 05:48:19 -0400
From: Andi Kleen <andi@firstfloor.org>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 42/52] fs: icache per-cpu last_ino allocator
References: <20100624030212.676457061@suse.de>
	<20100624030732.402670838@suse.de>
Date: Thu, 24 Jun 2010 11:48:13 +0200
In-Reply-To: <20100624030732.402670838@suse.de> (npiggin@suse.de's message of
	"Thu, 24 Jun 2010 13:02:54 +1000")
Message-ID: <87tyosahia.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

npiggin@suse.de writes:

> From: Eric Dumazet <dada1@cosmosbay.com>
>
> new_inode() dirties a contended cache line to get increasing inode numbers.
>
> Solve this problem by providing to each cpu a per_cpu variable, feeded by the
> shared last_ino, but once every 1024 allocations.

Most file systems don't even need this because they 
allocate their own inode numbers, right?. So perhaps it could be turned
off for all of those, e.g. with a superblock flag.

I guess the main customer is sockets only.

> +#ifdef CONFIG_SMP
> +/*
> + * Each cpu owns a range of 1024 numbers.
> + * 'shared_last_ino' is dirtied only once out of 1024 allocations,
> + * to renew the exhausted range.
> + *
> + * On a 32bit, non LFS stat() call, glibc will generate an EOVERFLOW
> + * error if st_ino won't fit in target struct field. Use 32bit counter
> + * here to attempt to avoid that.

I don't understand how the 32bit counter should prevent that.

> + */
> +static DEFINE_PER_CPU(int, last_ino);
> +static atomic_t shared_last_ino;

With the 1024 skip, isn't overflow much more likely, just scaling
with the number of CPUs on a large CPU number systems, even if there
aren't that many new inodes?

> +static int last_ino_get(void)
> +{
> +	int *p = &get_cpu_var(last_ino);
> +	int res = *p;
> +
> +	if (unlikely((res & 1023) == 0))
> +		res = atomic_add_return(1024, &shared_last_ino) - 1024;

The magic numbers really want to be defines? 

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
