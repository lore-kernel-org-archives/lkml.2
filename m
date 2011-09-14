Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338Ab1INUz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:55:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38261 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235Ab1INUzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:55:55 -0400
Subject: Re: [BUG] infinite loop in find_get_pages()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Lin Ming <mlin@ss.pku.edu.cn>,
        Justin Piszcz <jpiszcz@lucidpixels.com>, Pawel Sikora <pluto@agmk.net>
In-Reply-To: <alpine.LSU.2.00.1109141337080.29178@sister.anvils>
References: <1315941801.2565.19.camel@edumazet-laptop>
	 <CA+55aFyG3-3_gqGjqUmsTAHWfmNLMdQVf4XqUZrDAGMBxgur=Q@mail.gmail.com>
	 <CA+55aFz9DFFJyjMusVkUcBdCBX02RrmH0uCRASw0EQHC3SdaUA@mail.gmail.com>
	 <1315983230.2565.28.camel@edumazet-laptop>
	 <CANejiEXK524dgYZ+TSfqytZHE9CLjtP70cmvTPSNPR5zeDYkxw@mail.gmail.com>
	 <CANejiEUe+uhsUMxc43cL7Y+vU=bV0pVx13N5LuS4r27YSKTZ-w@mail.gmail.com>
	 <1315989783.2361.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1315990519.29510.119.camel@sli10-conroe>
	 <alpine.LSU.2.00.1109141337080.29178@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 22:55:50 +0200
Message-ID: <1316033750.2835.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 14 septembre 2011 à 13:38 -0700, Hugh Dickins a écrit :
> On Wed, 14 Sep 2011, Shaohua Li wrote:
> > On Wed, 2011-09-14 at 16:43 +0800, Eric Dumazet wrote:
> > > Le mercredi 14 septembre 2011 à 16:20 +0800, Shaohua Li a écrit :
> > > > 2011/9/14 Shaohua Li <shli@kernel.org>:
> > > > > it appears we didn't account skipped swap entry in find_get_pages().
> > > > > does the attached patch help?
> > > > I can easily reproduce the issue. Just cp files in tmpfs, trigger swap and
> > > > drop caches. The debug patch fixes it at my side.
> > > > Eric, please try it.
> > > > 
> > > 
> > > Hello Shaohua
> > > 
> > > I tried it with added traces :
> > > 
> > > 
> > > [  277.077855] mv used greatest stack depth: 3336 bytes left
> > > [  310.558012] nr_found=2 nr_skip=2
> > > [  310.558139] nr_found=14 nr_skip=14
> > > [  332.195162] nr_found=2 nr_skip=2
> > > [  332.195274] nr_found=14 nr_skip=14
> > > [  352.315273] nr_found=14 nr_skip=14
> > > [  372.673575] nr_found=14 nr_skip=14
> > > [  397.115463] nr_found=14 nr_skip=14
> > > [  403.391694] cc1 used greatest stack depth: 3184 bytes left
> > > [  404.761194] cc1 used greatest stack depth: 2640 bytes left
> > > [  417.306510] nr_found=14 nr_skip=14
> > > [  440.198051] nr_found=14 nr_skip=14
> > > 
> > > I also used :
> > > 
> > > -	if (unlikely(!ret && nr_found))
> > > +	if (unlikely(!ret && nr_found > nr_skip))
> > >  		goto restart;
> > nr_found > nr_skip is better
> > 
> > > It seems to fix the bug. I suspect it also aborts
> > > invalidate_mapping_pages() if we skip 14 pages, but existing comment
> > > states its OK :
> > > 
> > >         /*
> > >          * Note: this function may get called on a shmem/tmpfs mapping:
> > >          * pagevec_lookup() might then return 0 prematurely (because it
> > >          * got a gangful of swap entries); but it's hardly worth worrying
> > >          * about - it can rarely have anything to free from such a mapping
> > >          * (most pages are dirty), and already skips over any difficulties.
> > >          */
> > that might be a problem, let Hugh answer if it is.
> 
> Thanks to you all for suffering, reporting and investigating this.
> Yes, in 3.1-rc I have converted an extremely rare try-again-once
> into a too-easily stumbled-upon endless loop.
> 
> Would it be a problem to give up early on a shmem/tmpfs mapping in
> invalidate_mapping_pages()?  No, not really: it's rare for it to find
> anything it can throw away from tmpfs, because it cannot recognize the
> clean swapcache pages (getting it to work on those would be nice, and
> something I did look into once, but it's not a job for today), and
> entirely clean pages (readonly mmap'ed zeroes never touched) are uncommon.
> 
> However, I did independently run across scan_mapping_unevictable_pages()
> a few days ago: that uses pagevec_lookup() on shmem when doing SHM_UNLOCK,
> and although the normal case would be that everything then is in memory,
> I think it's not impossible for some to be swapped out (already swapped
> out at SHM_LOCK time, and not touched since), which should not stop it
> from doing its work on unswapped pages beyond.
> 
> My preferred patch is below: but it does add a cond_resched() into
> find_get_pages(), which is really below the level at which we usually
> do cond_resched().  All callers appear fine with it, and in practice
> it would be very^14 rare on anything other than shmem/tmpfs: so this
> being rc6 I'm reluctant to make matters worse with a might_sleep().
> 
> But I'm not signing this off yet, because I'm still mystified by the
> several reports of seemingly the same problem on 3.0.1 and 3.0.2,
> which I fear the patch below (even if adjusted to apply) will do
> nothing to help - there are no swap entries in radix_tree in 3.0.
> 
> My suspicion is that there's some path by which a page gets trapped
> in the radix_tree with page count 0.  While it's easy to imagine that
> THP's use of compaction and compaction's use of migration could have
> made a bug there more common, I do not see it.
> 
> I'd like to think about that a little more before finalizing the
> patch below - does it work, and does it look acceptable so far?
> Of course, the mods to truncate.c and vmscan.c are not essential
> parts of this fix, just things to tidy up while on the subject.
> Right now I must attend to some other stuff, will return tomorrow.
> 
> Hugh
> 

Hello Hugh

I am going to test this ASAP, but have one question below :

> ---
> 
>  mm/filemap.c  |   14 ++++++++++----
>  mm/truncate.c |    8 --------
>  mm/vmscan.c   |    2 +-
>  3 files changed, 11 insertions(+), 13 deletions(-)
> 
> --- 3.1-rc6/mm/filemap.c	2011-08-07 23:44:41.231928061 -0700
> +++ linux/mm/filemap.c	2011-09-14 12:24:26.431242155 -0700
> @@ -829,8 +829,8 @@ unsigned find_get_pages(struct address_s
>  	unsigned int ret;
>  	unsigned int nr_found;
>  
> -	rcu_read_lock();
>  restart:
> +	rcu_read_lock();
>  	nr_found = radix_tree_gang_lookup_slot(&mapping->page_tree,
>  				(void ***)pages, NULL, start, nr_pages);
>  	ret = 0;
> @@ -849,12 +849,15 @@ repeat:
>  				 * to root: none yet gotten, safe to restart.
>  				 */
>  				WARN_ON(start | i);
> +				rcu_read_unlock();
>  				goto restart;
>  			}
>  			/*
>  			 * Otherwise, shmem/tmpfs must be storing a swap entry
>  			 * here as an exceptional entry: so skip over it -
> -			 * we only reach this from invalidate_mapping_pages().
> +			 * we only reach this from invalidate_mapping_pages(),
> +			 * or SHM_UNLOCK's scan_mapping_unevictable_pages() -
> +			 * in each case it's correct to skip a swapped entry.
>  			 */
>  			continue;
>  		}
> @@ -871,14 +874,17 @@ repeat:
>  		pages[ret] = page;
>  		ret++;
>  	}
> +	rcu_read_unlock();
>  
>  	/*
>  	 * If all entries were removed before we could secure them,
>  	 * try again, because callers stop trying once 0 is returned.
>  	 */
> -	if (unlikely(!ret && nr_found))
> +	if (unlikely(!ret && nr_found)) {
> +		cond_resched();
> +		start += nr_found;

Isnt it possible to go out of initial window ?
start could be greater than 'end' ?

invalidate_mapping_pages()

does some capping (end - index)


>  	pagevec_init(&pvec, 0);
>  	while (index <= end && pagevec_lookup(&pvec, mapping, index,
>  			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {



