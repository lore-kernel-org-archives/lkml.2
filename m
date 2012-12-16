Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab2LPJAc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 04:00:32 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57528 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2LPJAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 04:00:31 -0500
Date: Sun, 16 Dec 2012 10:00:26 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Michel Lespinasse <walken@google.com>, Hugh Dickins <hughd@google.com>,
        J??rn Engel <joern@logfs.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] mm: Downgrade mmap_sem before locking or populating
 on mmap
Message-ID: <20121216090026.GB21690@gmail.com>
References: <3b624af48f4ba4affd78466b73b6afe0e2f66549.1355463438.git.luto@amacapital.net>
 <2e91ea19fbd30fa17718cb293473ae207ee8fd0f.1355536006.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e91ea19fbd30fa17718cb293473ae207ee8fd0f.1355536006.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@amacapital.net> wrote:

> This is a serious cause of mmap_sem contention.  MAP_POPULATE
> and MCL_FUTURE, in particular, are disastrous in multithreaded programs.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
> 
> Changes from v1:
> 
> The non-unlocking versions of do_mmap_pgoff and mmap_region are still
> available for aio_setup_ring's benefit.  In theory, aio_setup_ring
> would do better with a lock-downgrading version, but that would be
> somewhat ugly and doesn't help my workload.
> 
>  arch/tile/mm/elf.c |  9 +++---
>  fs/aio.c           |  4 +++
>  include/linux/mm.h | 19 ++++++++++--
>  ipc/shm.c          |  6 ++--
>  mm/fremap.c        | 10 ++++--
>  mm/mmap.c          | 89 ++++++++++++++++++++++++++++++++++++++++++++++++------
>  mm/util.c          |  3 +-
>  7 files changed, 117 insertions(+), 23 deletions(-)

> +unsigned long mmap_region(struct file *file, unsigned long addr,
> +			  unsigned long len, unsigned long flags,
> +			  vm_flags_t vm_flags, unsigned long pgoff)
> +{
> +	return mmap_region_helper(file, addr, len, flags, vm_flags, pgoff, 0);
> +}
> +

That 0 really wants to be NULL ...

Also, with your patch applied there's no user of mmap_region() 
left anymore.

More fundamentally, while I agree with the optimization, 
couldn't we de-uglify it a bit more?

In particular, instead of this wrappery:

> +unsigned long mmap_region_unlock(struct file *file, unsigned long addr,
> +				 unsigned long len, unsigned long flags,
> +				 vm_flags_t vm_flags, unsigned long pgoff)
> +{
> +	int downgraded = 0;
> +	unsigned long ret = mmap_region_helper(file, addr, len,
> +		flags, vm_flags, pgoff, &downgraded);
> +
> +	if (downgraded)
> +		up_read(&current->mm->mmap_sem);
> +	else
> +		up_write(&current->mm->mmap_sem);
> +
> +	return ret;
> +}

1)

We could at minimum wrap up the conditional unlocking as:

	up_read_write(&mm->mmap_sem, read_locked);

With that I'd also suggest to rename 'downgraded' to 
'read_locked', which more clearly expresses the locking state.

2)

More aggressively, we could just make it the _rule_ that the mm 
lock gets downgraded to read in mmap_region_helper(), no matter 
what.

>From a quick look I *think* all the usage sites (including 
sys_aio_setup()) are fine with that unlocking - but I could be 
wrong.

There's a couple of shorter codepaths that would now see an 
extra op of downgrading:

	down_write(&mm->mmap_sem);
	...
	downgrade_write(&mm->mmap_sem);
	...
	up_read(&mm->mmap_sem);

with not much work done with the lock read-locked - but I think 
they are all fine and mostly affect error paths. So there's no 
real value in keeping the conditional nature of the unlocking I 
think.

That way all the usage sites could do a *much* cleaner pattern 
of:

	down_write(&mm->mmap_sem);
	...
	do_mmap_pgoff_downgrade_write(...);
	...
	up_read(&mm->mmap_sem);

... and that kind of cleanliness would instantly halve the size 
of your patch, it would improve all use sites, and would turn 
your patch into something I'd want to see applied straight away.

Thanks,

	Ingo
