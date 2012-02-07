Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab2BGScI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 13:32:08 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57663 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab2BGScG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 13:32:06 -0500
Date: Tue, 7 Feb 2012 10:31:36 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH BUGFIX] mm: fix find_get_page() for shmem exceptional
 entries
In-Reply-To: <4F31003E.2090901@openvz.org>
Message-ID: <alpine.LSU.2.00.1202071011450.1849@eggly.anvils>
References: <20120207103121.28345.28611.stgit@zurg> <4F31003E.2090901@openvz.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Feb 2012, Konstantin Khlebnikov wrote:

> Bug was added in commit v3.0-7291-g8079b1c (mm: clarify the radix_tree
> exceptional cases)
> So, v3.1 and v3.2 affected.
> 
> Konstantin Khlebnikov wrote:
> > It should return NULL, otherwise the caller will be very surprised.
> > 
> > Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>

Thanks for worrying about it, but Nak to this patch.

If you have found somewhere that is surprised by an exceptional entry
instead of a page, then indeed we shall need to fix that: I'm not
aware of any.

There are several places that are prepared for the possibility:
find_lock_page() (and your patch would be breaking shmem.c's use of
find_lock_page()), mincore_page(), memcontrol.c's mc_handle_file_pte().

Of the remaining calls to find_get_page(), my understanding is that
either they are filesystems operating upon their own pagecache, or
they involve using ->readpage() - that's one of the two reasons why
I gave shmem its own ->splice_read() and removed its ->readpage()
before switching over to use the exceptional entries.

Hugh

> > ---
> >   mm/filemap.c |    1 +
> >   1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 518223b..ca98cb5 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -693,6 +693,7 @@ repeat:
> >   			 * here as an exceptional entry: so return it without
> >   			 * attempting to raise page count.
> >   			 */
> > +			page = NULL;
> >   			goto out;
> >   		}
> >   		if (!page_cache_get_speculative(page))
