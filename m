Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031118Ab1EWVMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 17:12:01 -0400
Received: from smtp-out.google.com ([74.125.121.67]:38821 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030654Ab1EWVLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 17:11:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=DreKdlxnEdWOwnF1tuLIWB3gBn55hRdQxr15I4id5L+HNEYBGepJKD1BoD90VBaQmu
         Mb8KWRl4G08S+hzqA1cw==
Date: Mon, 23 May 2011 14:10:52 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Consistency of loops in mm/truncate.c?
In-Reply-To: <20110523134439.22582eee.akpm@linux-foundation.org>
Message-ID: <alpine.LSU.2.00.1105231357080.25080@sister.anvils>
References: <alpine.LSU.2.00.1105221526020.17400@sister.anvils> <20110523134439.22582eee.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011, Andrew Morton wrote:
> On Sun, 22 May 2011 15:27:41 -0700 (PDT)
> Hugh Dickins <hughd@google.com> wrote:
> > 
> > The advancement of index is hard to follow: we rely upon page->index
> > of an unlocked page persisting, yet we're ashamed of doing so, sometimes
> > reading it again once locked.  invalidate_mapping_pages() apologizes for
> > this, but I think we should now just document that page->index is not
> > modified until the page is freed.
> 
> That should be true under i_mutex and perhaps other external locking. 
> We could put some debug checks in there to catch any situation where
> ->index changed after the page was locked.

Okay, I'll look into doing that; and adding a comment in the
"page->mapping = NULL;" places in mm/filemap.c, explaining that
we do need to leave page->index untouched.

> 
> > invalidate_inode_pages2_range() has two sophistications not seen
> > elsewhere, which 7afadfdc says were folded in by akpm (along with
> > a page->index one):
> > 
> > - Don't look up more pages than we're going to use:
> >   seems a good thing for me to fold into truncate_inode_pages_range()
> >   and invalidate_mapping_pages() too.
> 
> I guess so.  I doubt if it makes a measurable performance difference
> (except maybe in the case of small direct-io's?) but consistency is
> good.

I guess it occasionally saves the radix_tree lookup from accessing a
few unnecessary cachelines; not a big win, but I think better to add
it where it's missing than remove it from the place you thought of it.

> 
> > - Check for the cursor wrapping at the end of the mapping:
> >   but with
> > 
> > #if BITS_PER_LONG==32
> > #define MAX_LFS_FILESIZE (((u64)PAGE_CACHE_SIZE << (BITS_PER_LONG-1))-1) 
> > #elif BITS_PER_LONG==64
> > #define MAX_LFS_FILESIZE 0x7fffffffffffffffUL
> > #endif
> > 
> >   I don't see how page->index + 1 would ever be 0, even if one or
> >   other of those "-1"s went away; so may I delete the "wrapped" case?
> 
> err yes, that seems bogus now and was bogus at the time.  I never
> trusted that s_maxbytes thing :)

Right, I was wondering this morning whether we can always rely upon
s_maxbytes: I was taking the SHMEM_MAX_INDEX check out of shmem_getpage(),
but maybe some cases need it to stay.  I'll do some more checking,
but hope to remove those wrapped checks.

Thanks for the confirmations,
Hugh
