Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab1GLWJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 18:09:28 -0400
Received: from smtp-out.google.com ([74.125.121.67]:40464 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab1GLWJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 18:09:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=hwZn1ubzGzw4phHf73tryKw40TS+dBKt2qI0VrC7GoKrxwuyNsY2XdIGS16gWIYfj
	QWmOM5UrXb4Hgu37VJxyA==
Date: Tue, 12 Jul 2011 15:08:58 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/12] mm: let swap use exceptional entries
In-Reply-To: <20110618145254.1b333344.akpm@linux-foundation.org>
Message-ID: <alpine.LSU.2.00.1107121501100.2112@sister.anvils>
References: <alpine.LSU.2.00.1106140327550.29206@sister.anvils> <alpine.LSU.2.00.1106140342330.29206@sister.anvils> <20110618145254.1b333344.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Jun 2011, Andrew Morton wrote:
> On Tue, 14 Jun 2011 03:43:47 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:
> 
> > --- linux.orig/mm/filemap.c	2011-06-13 13:26:44.430284135 -0700
> > +++ linux/mm/filemap.c	2011-06-13 13:27:34.526532556 -0700
> > @@ -717,9 +717,12 @@ repeat:
> >  		page = radix_tree_deref_slot(pagep);
> >  		if (unlikely(!page))
> >  			goto out;
> > -		if (radix_tree_deref_retry(page))
> > +		if (radix_tree_exception(page)) {
> > +			if (radix_tree_exceptional_entry(page))
> > +				goto out;
> > +			/* radix_tree_deref_retry(page) */
> >  			goto repeat;
> > -
> > +		}
> >  		if (!page_cache_get_speculative(page))
> >  			goto repeat;
> 
> All the crap^Wnice changes made to filemap.c really need some comments,
> please.  Particularly when they're keyed off the bland-sounding
> "radix_tree_exception()".  Apparently they have something to do with
> swap, but how is the poor reader to know this?

The naming was intentionally bland, because other filesystems might
in future have other uses for such exceptional entries.

(I think the field size would generally defeat it, but you can,
for example, imagine a small filesystem wanting to save sector number
there when a page is evicted.)

But let's go bland when it's more familiar, and such uses materialize -
particularly since I only placed those checks in places where they're
needed now for shmem/tmpfs/swap.

I'll keep the bland naming, if that's okay, but send a patch adding
a line of comment in such places.  Mentioning shmem, tmpfs, swap.

> 
> Also, commenting out a function call might be meaningful information for
> Hugh-right-now, but for other people later on, they're just a big WTF.

Ah yes, I hadn't realized at all that those look like commented-out
function calls.  No, they're comments on what the else case is that
we have arrived at there.  I'll make those clearer too.

Hugh
