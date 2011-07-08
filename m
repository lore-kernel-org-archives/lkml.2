Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab1GHWWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 18:22:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:42927 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab1GHWWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 18:22:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=tH4YRbq0FAgqVWuhGJJVcopjDJoNMKnBpnXovW68O6ZdN98XgbhV21mUSg7yKNJhq
	6VFPQaNRzMcymC6L3J3Qg==
Date: Fri, 8 Jul 2011 15:22:09 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Dmitry Fink <finikk@gmail.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Dmitry Fink <dmitry.fink@palm.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 1/1] mmap: Don't count shmem pages as free in
 __vm_enough_memory
In-Reply-To: <1309721963-5577-1-git-send-email-dmitry.fink@palm.com>
Message-ID: <alpine.LSU.2.00.1107081433240.2840@sister.anvils>
References: <1309721963-5577-1-git-send-email-dmitry.fink@palm.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jul 2011, Dmitry Fink wrote:

> shmem pages can't be reclaimed and if they are swapped out
> that doesn't affect the overall available memory in the system,
> so don't count them along with the rest of the file backed pages.
> 
> Signed-off-by: Dmitry Fink <dmitry.fink@palm.com>

That's a good point.  You can add
Acked-by: Hugh Dickins <hughd@google.com>
if you'll let me burble on for a while...

1. Your block comment style differs from kernel coding style, and
   the nearby comments do follow kernel coding style: please adjust.

2. If you're wondering why this was missed for so long, it's simply
   that we didn't have that separate NR_SHMEM count until 2.6.32.

3. There's a danger that this change will fail some large mappings
   that were allowed before; but I guess we run that risk every
   time we release a larger kernel than before, so let's grant you
   the patch... but it might have to be reverted if anyone complains.

4. i915 GEM uses shmem pages that _can_ (sometimes) be freed under
   memory pressure; but then, on the other side, some of the pages
   counted as "free" may actually be locked or pinned in some way.

5. The OVERCOMMIT_GUESS estimation is at best something of a joke
   (a thousand concurrent tasks would each be allowed to make their
   own separate maximal mappings), and any change appears to dignify
   it somewhat; but you are right, so let's do it.

6. I was worried about additional overhead, and puzzled where the
   actual free pages get counted: ah, lower down, with a comment that
   nr_free_pages() is very expensive on large systems... and what does
   nr_free_pages() do?  It does global_page_state(NR_FREE_PAGES): so
   does that imply that your additional global_page_state(NR_SHMEM)
   will be expensive>?  No, the comment, and the peculiar placing of
   the nr_free_pages() call, date from when it was a loop over all
   zones (hence all nodes) in the system.  Now, tell me to go away
   and make a separate patch of my own if you wish, fair enough;
   but I suggest you tidy that up too (and clearer if it explicitly
   says global_page_state(NR_FREE_PAGES) rather than nr_free_pages()):

   free = global_page_state(NR_FREE_PAGES);
   free += global_page_state(NR_FILE_PAGES);
   etc.

7. There's an almost identical copy of this code in mm/nommu.c:
   please update that one too to keep them in synch.  I suppose it
   would be better to keep one copy of it somewhere else, but by
   now I've probably exhausted your patience, plus I've a nasty
   feeling that if I suggest somewhere, I'll be tricking you
   into a build error with this or that config.  Another time...

You can see why I don't like reviewing more than one-line changes,
can't you :-?

Thanks,
Hugh

> ---
>  mm/mmap.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index b88624f..3a34dc2 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -119,6 +119,13 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
>  		unsigned long n;
>  
>  		free = global_page_state(NR_FILE_PAGES);
> +
> +		/* shmem pages shouldn't be counted as free in this
> +		 * case, they can't be purged, only swapped out, and
> +		 * that won't affect the overall amount of available
> +		 * memory in the system. */
> +		free -= global_page_state(NR_SHMEM);
> +
>  		free += nr_swap_pages;
>  
>  		/*
> -- 
> 1.6.0.4
