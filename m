Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab1IOCC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 22:02:29 -0400
Received: from smtp-out.google.com ([216.239.44.51]:63429 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab1IOCC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 22:02:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=JRVlFPQiwxACj2p4HDaRh0a8rC43mJMTRKQE12uUpD88BjUBsRc5A4tQGrDOgh+C2
	OzMehsRMMmH4xgOOrlKFQ==
Date: Wed, 14 Sep 2011 19:00:57 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Shaohua Li <shaohua.li@intel.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Lin Ming <mlin@ss.pku.edu.cn>,
        Justin Piszcz <jpiszcz@lucidpixels.com>, Pawel Sikora <pluto@agmk.net>
Subject: Re: [BUG] infinite loop in find_get_pages()
In-Reply-To: <1316047519.29510.122.camel@sli10-conroe>
Message-ID: <alpine.LSU.2.00.1109141853470.7012@sister.anvils>
References: <1315941801.2565.19.camel@edumazet-laptop> <CA+55aFyG3-3_gqGjqUmsTAHWfmNLMdQVf4XqUZrDAGMBxgur=Q@mail.gmail.com> <CA+55aFz9DFFJyjMusVkUcBdCBX02RrmH0uCRASw0EQHC3SdaUA@mail.gmail.com> <1315983230.2565.28.camel@edumazet-laptop>
 <CANejiEXK524dgYZ+TSfqytZHE9CLjtP70cmvTPSNPR5zeDYkxw@mail.gmail.com> <CANejiEUe+uhsUMxc43cL7Y+vU=bV0pVx13N5LuS4r27YSKTZ-w@mail.gmail.com> <1315989783.2361.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <1315990519.29510.119.camel@sli10-conroe>
 <alpine.LSU.2.00.1109141337080.29178@sister.anvils> <1316033750.2835.2.camel@edumazet-laptop> <alpine.LSU.2.00.1109141427190.29355@sister.anvils> <CA+55aFyzjX9kkHZUVg=zZsOQjq1xoNBk2QvJjjnbUx3BOF5Fzg@mail.gmail.com>
 <1316047519.29510.122.camel@sli10-conroe>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Sep 2011, Shaohua Li wrote:
> On Thu, 2011-09-15 at 06:37 +0800, Linus Torvalds wrote:
> > On Wed, Sep 14, 2011 at 2:53 PM, Hugh Dickins <hughd@google.com> wrote:
> > >
> > > Thanks, Eric, though it may not be worth spending your time on it.
> > > It occurred to me over lunch that it may take painfully longer than
> > > expected to invalidate_mapping_pages() on a single-swapped-out-page
> > > 1TB sparse tmpfs file - all those "start += 1" restarts until it
> > > reaches the end.
> > 
> > So can we have a stop-gap patch to just fixes it for now? I assume
> > that would be Shaohua's patch with the "nr_found > nr_skip" change?
> > 
> > Can you guys send whatever patch is appropriate for now with a nice
> > changelog and the appropriate sign-offs, please? So that we can at
> > least close the issue...
> here is my patch if you want to close the issue at hand.

Right, it closes one of the hangs, but not whatever the 3.0 hang is,
and not the unlikely SHM_UNLOCK issue I factored in.  I cannot consider
those issues closed, but I am happy to be let off the hook of providing
another fix tomorrow - thanks!

> 
> Subject: mm: account skipped entries to avoid looping in find_get_pages
> 
> The found entries by find_get_pages() could be all swap entries. In
> this case we skip the entries, but make sure the skipped entries are
> accounted, so we don't keep looping.
> Using nr_found > nr_skip to simplify code as suggested by Eric.
> 
> Reported-and-tested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Acked-by: Hugh Dickins <hughd@google.com>

> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 645a080..7771871 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -827,13 +827,14 @@ unsigned find_get_pages(struct address_space *mapping, pgoff_t start,
>  {
>  	unsigned int i;
>  	unsigned int ret;
> -	unsigned int nr_found;
> +	unsigned int nr_found, nr_skip;
>  
>  	rcu_read_lock();
>  restart:
>  	nr_found = radix_tree_gang_lookup_slot(&mapping->page_tree,
>  				(void ***)pages, NULL, start, nr_pages);
>  	ret = 0;
> +	nr_skip = 0;
>  	for (i = 0; i < nr_found; i++) {
>  		struct page *page;
>  repeat:
> @@ -856,6 +857,7 @@ repeat:
>  			 * here as an exceptional entry: so skip over it -
>  			 * we only reach this from invalidate_mapping_pages().
>  			 */
> +			nr_skip++;
>  			continue;
>  		}
>  
> @@ -876,7 +878,7 @@ repeat:
>  	 * If all entries were removed before we could secure them,
>  	 * try again, because callers stop trying once 0 is returned.
>  	 */
> -	if (unlikely(!ret && nr_found))
> +	if (unlikely(!ret && nr_found > nr_skip))
>  		goto restart;
>  	rcu_read_unlock();
>  	return ret;
