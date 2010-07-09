Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab0GIBOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 21:14:12 -0400
Received: from smtp-out.google.com ([74.125.121.35]:44554 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab0GIBOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 21:14:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=GslRtMThvBE2kemSpKcuKnkBHdvjlT9tnXY0C2I0wWiA/bLNa3BZpvNSuKjHZI16g
	/0k6EPbC8J1ZshqdqxlSg==
Date: Thu, 8 Jul 2010 18:13:55 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hughd@tigran.mtv.corp.google.com
To: Shaohua Li <shaohua.li@intel.com>
cc: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH]shmem: reduce one time of locking in pagefault
In-Reply-To: <1278465346.11107.8.camel@sli10-desk.sh.intel.com>
Message-ID: <alpine.DEB.1.00.1007081741290.1132@tigran.mtv.corp.google.com>
References: <1278465346.11107.8.camel@sli10-desk.sh.intel.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jul 2010, Shaohua Li wrote:

> I'm running a shmem pagefault test case (see attached file) under a 64 CPU
> system. Profile shows shmem_inode_info->lock is heavily contented and 100%
> CPUs time are trying to get the lock. In the pagefault (no swap) case,
> shmem_getpage gets the lock twice, the last one is avoidable if we prealloc a
> page so we could reduce one time of locking. This is what below patch does.

Right.  As usual, I'm rather unenthusiastic about a patch which has to
duplicate code paths to satisfy an artificial testcase; but I can see
the appeal.

We can ignore that you're making the swap path slower, that will be lost
in its noise.  I did like the way the old code checked the max_blocks
limit before it let you allocate the page: whereas you might have many
threads simultaneously over-allocating before reaching that check; but
I guess we can live with that.

> 
> The result of the test case:
> 2.6.35-rc3: ~20s
> 2.6.35-rc3 + patch: ~12s
> so this is 40% improvement.

Was that with or without Tim's shmem_sb_info max_blocks scalability
changes (that I've still not studied)?  Or max_blocks 0 (unlimited)?

I notice your test case lets each thread fault in from its own
disjoint part of the whole area.  Please also test with each thread
touching each page in the whole area at the same time: which I think
is just as likely a case, but not obvious to me how well it would
work with your changes - what numbers does it show?

> 
> One might argue if we could have better locking for shmem. But even shmem is lockless,
> the pagefault will soon have pagecache lock heavily contented because shmem must add
> new page to pagecache. So before we have better locking for pagecache, improving shmem
> locking doesn't have too much improvement. I did a similar pagefault test against
> a ramfs file, the test result is ~10.5s.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index f65f840..c5f2939 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
...
> @@ -1258,7 +1258,19 @@ repeat:
>  		if (error)
>  			goto failed;
>  		radix_tree_preload_end();
> +		if (sgp != SGP_READ) {

Don't you need to check that prealloc_page is not already set there?
There are several places in the swap path where it has to goto repeat.

> +			/* don't care if this successes */
> +			prealloc_page = shmem_alloc_page(gfp, info, idx);
> +			if (prealloc_page) {
> +				if (mem_cgroup_cache_charge(prealloc_page,
> +				    current->mm, GFP_KERNEL)) {
> +					page_cache_release(prealloc_page);
> +					prealloc_page = NULL;
> +				}
> +			}
> +		}
>  	}

Hugh
