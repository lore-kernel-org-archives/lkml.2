Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab1GHRHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 13:07:14 -0400
Received: from smtp-out.google.com ([74.125.121.67]:54535 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1GHRHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 13:07:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=Qz2A3Y/vC3yUTTHOFtLgDkMu1Rqr3kDsq7UmqfQKRvSrG/mSsjqHxhaXKfqu3CKXO
	WWQ8vt22CWOmrTgPJJahg==
Date: Fri, 8 Jul 2011 10:06:49 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 34/49] gma500: the GEM and GTT code is device
 independant
In-Reply-To: <20110708093859.299958df@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LSU.2.00.1107080917430.1781@sister.anvils>
References: <20110705141038.23872.55303.stgit@localhost.localdomain> <20110705144140.23872.86541.stgit@localhost.localdomain> <alpine.LSU.2.00.1107071742250.10362@sister.anvils> <20110708093859.299958df@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jul 2011, Alan Cox wrote:
> > As example, below is the patch where I updated drm/i915 to be ready
> > for the changeover.  They set __GFP_RECLAIMABLE on the mapping because
> > they've got a way to discard unpinned object pages when memory is tight;
> > and sometimes add in __GFP_NORETRY|__GFP_NOWARN when allocating.
> > 
> > I'm guessing you'd just want to use shmem_read_mapping_page() throughout,
> > after initializing mapping with the appropriate flags (GFP_HIGHUSER_MOVABLE
> > is fs/inode.c's default: maybe your pages aren't easily movable and you'd
> > better say GFP_HIGHUSER, or maybe you have reason to need GFP_KERNEL).
> 
> I need the pages in the low 4GB ideally and have no way to release them
> if they are pinned. For the usage pattern I have that's not a problem.

Maybe you'll want to use GFP_KERNEL | GFP_DMA32.

> 
> At the moment the 4G isn't a problem either as you can't attach enough
> memory to cause problems to any of these devices.
> 
> 
> What I don't entirely understand from your change is what stops another
> user task with the shmemfs file handle open from doing something else
> which changes the mapping flags, or is it guaranteed that only the
> mapping owner gets to play ?

My changes (which were directed to eliminating shmem_readpage, which
complicates shmem.c somewhat) haven't made any difference there: except
that, like you, I'm wary of letting people mess with gfp flags all over,
so preferred drm/i915 to set the right flags on the mapping initially,
then add in the __GFP_NORETRY | __GFP_NOWARN in the one place needed,
instead of using the _gfp()-modifying variant everywhere.

I don't think a user task has any interface to change the mapping flags,
does it?  But Linus freaked out a little 18 months ago when he noticed
drm/i915 fiddling with mapping flags via mapping_set_gfp_mask() (whose
declaration comments "This is non-atomic.  Only to be used before the
mapping is activated."), so gave them read_cache_page_gfp() instead.

I'd prefer we didn't have to support it, but i915 does have good use
for it: so long as they only play with transient flags such as NORETRY
(which will affect the allocation being made by the caller, but not
affect mapping itself or concurrent allocations to it from elsewhere).

But your question does make me worry about when a page is brought back
from swap.  The swapin readahead code is liable to read in several pages
with the same gfp mask as the page it's actually needing; but if adjacent
swap locations have been used for pages of objects with different gfp
needs, that could cause a problem.  (NUMA mempolicy gets ignored by
swapin in the same way.)

Your <4GB pages won't get swapped out while they're pinned.  But can
it happen that they'd be unpinned, swapped out, swapped back in >4GB
pages, then cause trouble for you when needed again?

I didn't care very deeply about the difference between __GFP_MOVABLE
and __GFP_RECLAIMABLE in the i915 case, but your 4GB requirement sounds
more important to get right (though you do say "ideally" above: if it's
just a matter of slowdown, maybe we can ignore it for now).

Hugh
