Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab1E2AMj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 20:12:39 -0400
Received: from smtp-out.google.com ([216.239.44.51]:36553 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab1E2AMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 20:12:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=YaCpI8Qi4gfghGRTn9f6xK6FPKrpqNBm8HzXsUJah9cFTRKlhdWem1N6MjIBD278+N
         rcTR6tk2P4i/ZSYO/bAw==
Date: Sat, 28 May 2011 17:12:24 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: fix page_lock_anon_vma leaving mutex locked
In-Reply-To: <BANLkTinsq-XJGvRVmBa6kRp0RTj9NqGWtA@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1105281634440.14257@sister.anvils>
References: <alpine.LSU.2.00.1105281317090.13319@sister.anvils> <1306617270.2497.516.camel@laptop> <alpine.LSU.2.00.1105281437320.13942@sister.anvils> <BANLkTinsq-XJGvRVmBa6kRp0RTj9NqGWtA@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 May 2011, Linus Torvalds wrote:
> On Sat, May 28, 2011 at 3:02 PM, Hugh Dickins <hughd@google.com> wrote:
> >
> > But I'm replying before I've given it enough thought,
> > mainly to let you know that I am back on it now.
> 
> So I applied your other two patches as obvious, but not this one.

Thank you, that's right.

Though I think I'm arriving at the conclusion that this patch
is correct as is, despite the doubts that have arisen.

One argument is by induction: since we've noticed no problems before
Peter's patchset, and actually Peter's patchset plus my patch is not
really making any difference to this "anon_vma changing beneath you"
case, is it?

(I've not relooked at what the situation was before his final optimized
page_lock_anon_vma(): maybe that was fine, or maybe it could get into
decrementing a different refcount than had been incremented, if we
didn't have the protection of PageLocked against switching anon_vma.)

> 
> I'm wondering - wouldn't it be nicer to just re-check (after getting
> the anon_vma lock) that page->mapping still matches anon_mapping?

I toyed with that: it seemed a better idea than relying on the refcount,
which wasn't giving the guarantee we needed (the refcount is perfectly
good in other respects, it just isn't good for this particular check).

However, the problem (if there is one) goes a bit further than that:
if we don't actually have serialization against page->anon_vma (okay,
it's actually page->mapping, but simpler to express this way) being
changed at any instant, i.e. we're serving the page_referenced() without
PageLocked case, then what good is the "anon_vma" that page_lock_anon_vma()
returns?  If that can be freed and reused at any moment?

I believe that although it may no longer be the anon_vma that the page
is pointing to, it remains stable.  Because even if page->anon_vma is
updated, it will certainly have the same anon_vma->root as before
(see the first BUG_ON in __page_check_anon_rmap() for reassurance),
so the mutex locking holds good.

And the structure itself won't be freed: although the page is now
pointing to a less inclusive, more optimal anon_vma for reclaim to use,
the anon_vma which was originally pointed to remains on the same vma's
chains as it ever was, and only gets freed up when they're all gone.

So, when there's this race with moving anon_vma, page_lock_anon_vma()
may end up returning a less than optimal anon_vma, but it's still valid
as a good though longer list of vmas to look through.

The previous code would have broken horribly, wouldn't it, were that
not the case?

> 
> That said, I do agree with the "anon_vma_root" part of your patch. I
> just think you mixed up two independent issues with it: the fact that
> we may be unlocking a new root, and the precise check used to
> determine whether the anon_vma might have changed.

It's true that actually I first ran with just the page_mapped() instead
of refcount part of the patch; and was disappointed to find that did not
fix the hang on its own.  Had to spend a few minutes yesterday morning
actually thinking and remembering the root_anon_vma thing.

So to that extent they must be separable; but I'm finding it hard to
agree with putting in a broken half-patch.  And the page_mapped()
part of it is essential.

Let's add Rik to the Cc in case he's around and might comment too.

Hugh

> 
> So my gut feeling is that we should do the "anon_vma" root thing
> independently as a fix for the "maybe anon_vma->root changed" issue,
> and then as a separate patch decide on how to check whether anon_vma
> is still valid.
> 
> Hmm?
