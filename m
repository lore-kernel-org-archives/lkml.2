Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab1L3VBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 16:01:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34366 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab1L3VBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 16:01:34 -0500
Date: Fri, 30 Dec 2011 13:01:24 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [GIT PULL] futex fixlet
In-Reply-To: <CA+55aFzPfysGq+ihMioGXASs3ixn9RBOuju2UhygKY_qtoo_Ag@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1112301219590.1777@eggly.anvils>
References: <20111229210707.GA22300@elte.hu> <CA+55aFydsXqRg-QwfVBuUOSfpGQ24MjgWaK-z+3Qvgn-BHn6Tw@mail.gmail.com> <1325264878.30917.11.camel@twins> <CA+55aFzPfysGq+ihMioGXASs3ixn9RBOuju2UhygKY_qtoo_Ag@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Dec 2011, Linus Torvalds wrote:
> On Fri, Dec 30, 2011 at 9:07 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > So I _think_ you're completely right and we can simply kill the whole
> > thing, but I've been trying very hard to forget everything kernel
> > related for a week, and I really shouldn't kick-start my brain until
> > somewhere next week.
> 
> Ok.
> 
> Ingo, I'd suggest you put a patch like that into -next, and mark it
> for stable after it has gotten lots more testing.

Yes, we shouldn't rush in what we don't understand.  But mostly I agree
with you, and Peter, that we've gathered too much cargo-cult in here.

> 
> Something like the appended *totally* untested code. It compiles, but
> maybe there really is some "!page->mapping" case that could possibly
> matter.

I think there is such a case.  I located (Peter's reply to) 2008-04-08
lkml mail, in which Nick says

> What I'm worried about with this is invalidate or truncate races.
> With direct IO, it obviously doesn't matter because the only
> requirement is that the page existed at the address at some point
> during the syscall... 
> 
> So I'd really like you to not carry the page around in the key, but
> just continue using the same key we have now. Also, lock the page
> and ensure it hasn't been truncated before taking the inode from the
> key and incrementing its count (page lock's extra atomics should be
> more or less cancelled out by fewer mmap_sem atomic ops).

and rewrites what Peter posted earlier to include this fragment

> +       lock_page(page);
> +       if (!page->mapping) { /* PageAnon pages shouldn't get caught here */
> +               unlock_page(page);
> +               put_page(page);
> +               goto again;
> +       }

Right, it's standard procedure to check page->mapping after locking the
page, to make sure that it hasn't just been truncated (or invalidated).

(And since the PageAnon bit is actually kept inside page->mapping, it's
impossible to find a PageAnon with !page->mapping: which suits fine here.)

Now, I don't think truncation (or hole punching) is an issue: it would
be okay to return -EFAULT if we caught a moment when it was truncated.

But invalidation?  Someone doing an echo to /proc/sys/vm/drop_caches
at the wrong moment causing this futex path to fail?  The invalidate
used in drop_caches does back off if the page is mapped, but who's to
say that page reclaim didn't just unmap it independently.  And it can't
do much on shmem mappings, which would be the common shared futex case:
but we kept that general, so it could be a real filesystem mapping.

I believe that's why Nick put in the "goto again" that's caused
so much trouble.  But I'm not sure what's the best way forward.

My first thought was to fall back to the original pre-38d47c1b70
code in the !page->mapping case: we only want this page and its
page->mapping as a quick way to discover page->mapping->host.
So fall back to mmap_sem, find_extend_vma,
vma->vm_file->f_path.dentry->d_inode?

But the old code had its own problem, with VM_NONLINEAR mappings,
where you really need page->index to find the offset.  So the old
code had its own fallback to get_user_pages and looking up the page.
We don't really want to have a fallback to a fallback like that.

Oh, I've just had a slightly evil thought: although the !page->mapping
needs fallback to discover the inode, its page->index remains valid
until the page is actually freed (and we rely upon that thoughout
mm/truncate.c).

If we're not rushing for 3.2 final (this is no new regression),
I'd prefer to do such a patch later in the day if that's okay -
or by all means beat me to it.

Or am I just getting over-excited about invalidation?

Hugh

> 
> I can't see it, though - but we should definitely get some testing for
> this before I'd put it in a release. Since we do that
> "get_user_pages_fast()" and ask for a writable page, the result should
> be as stable as it will ever get. There is still the race with
> hugepage splitting, but at least that one has a comment.
> 
>  kernel/futex.c |   20 ++++++++++++--------
>  1 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index ea87f4d2f455..8d2ee2f66418 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -310,21 +310,25 @@ again:
>  	if (page != page_head) {
>  		get_page(page_head);
>  		put_page(page);
> +		/* Avoid "unused label" for non-THP config */
> +		if (0)
> +			goto again;
>  	}
>  #endif
>  
>  	lock_page(page_head);
> +
> +	/*
> +	 * If the page doesn't have a mapping associated with it,
> +	 * this is either an anonymous page that was accessed RO
> +	 * (so no COW etc) and we would just return EFAULT anyway,
> +	 * or some special case page (ZERO_PAGE, gate area, special
> +	 * mapping..).
> +	 */
>  	if (!page_head->mapping) {
>  		unlock_page(page_head);
>  		put_page(page_head);
> -		/*
> -		* ZERO_PAGE pages don't have a mapping. Avoid a busy loop
> -		* trying to find one. RW mapping would have COW'd (and thus
> -		* have a mapping) so this page is RO and won't ever change.
> -		*/
> -		if ((page_head == ZERO_PAGE(address)))
> -			return -EFAULT;
> -		goto again;
> +		return -EFAULT;
>  	}
>  
>  	/*
