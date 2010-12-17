Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab0LQBVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 20:21:42 -0500
Received: from smtp-out.google.com ([216.239.44.51]:22637 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab0LQBVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 20:21:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=kKg4aY3G6iDXFsC23wBPOL1tqRkkGdir39XyZyrKDwHV8nuv795yI+JZQuGoD+StFP
         9z+qclTeEEDCA8S0nC/A==
Date: Thu, 16 Dec 2010 17:21:30 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hughd@tigran.mtv.corp.google.com
To: Minchan Kim <minchan.kim@gmail.com>
cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: add replace_page_cache_page() function
In-Reply-To: <20101216220457.GA3450@barrios-desktop>
Message-ID: <alpine.LSU.2.00.1012161708260.3351@tigran.mtv.corp.google.com>
References: <E1PStc6-0006Cd-0Z@pomaz-ex.szeredi.hu> <AANLkTikXQmsgZ8Ea-GoQ4k2St6yCJj8Z3XthuBQ9u+EV@mail.gmail.com> <E1PTCV4-0007sR-SO@pomaz-ex.szeredi.hu> <20101216220457.GA3450@barrios-desktop>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010, Minchan Kim wrote:
> On Thu, Dec 16, 2010 at 12:59:58PM +0100, Miklos Szeredi wrote:
> > On Thu, 16 Dec 2010, Minchan Kim wrote:
> > > 
> > > Why do you release reference of old?
> > 
> > That's the page cache reference we release.  Just like we acquire the
> > page cache reference for "new" above.
> 
> I mean current page cache handling semantic and page reference counting semantic
> is separeated. For example, remove_from_page_cache doesn't drop the reference of page.
> That's because we need more works after drop the page from page cache.
> Look at shmem_writepage, truncate_complete_page.

I disagree with you there: I like the way Miklos made it symmetric,
I like the way delete_from_swap_cache drops the swap cache reference,
I dislike the way remove_from_page_cache does not - I did once try to
change that, but did a bad job, messed up reiserfs or reiser4 I forget
which, retreated in shame.

In both the examples you give, shmem_writepage and truncate_complete_page,
the caller has to be holding their own reference, in part because they
locked the page, and will need to unlock it before releasing their ref.
I think that would be true of any replace_page_cache_page caller.

> 
> You makes the general API and caller might need works before the old page 
> is free. So how about this?
> 
> err = replace_page_cache_page(oldpage, newpage, GFP_KERNEL);
> if (err) {
>         ...
> }
> 
> page_cache_release(oldpage); /* drop ref of page cache */
> 
> 
> > 
> > I suspect it's historic that page_cache_release() doesn't drop the
> > page cache ref.
> 
> Sorry I can't understand your words.

Me neither: I believe Miklos meant __remove_from_page_cache() rather
than page_cache_release() in that instance.

Hugh
