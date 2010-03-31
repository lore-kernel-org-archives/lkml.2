Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535Ab0CaVkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 17:40:43 -0400
Received: from waste.org ([173.11.57.241]:34584 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246Ab0CaVkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 17:40:42 -0400
Subject: Re: [PATCH] proc: pagemap: Hold mmap_sem during page walk
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: San Mehat <san@google.com>, linux-kernel@vger.kernel.org,
       Brian Swetland <swetland@google.com>, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1003311036200.3707@i5.linux-foundation.org>
References: <1270056227-5442-1-git-send-email-san@google.com>
	 <alpine.LFD.2.00.1003311036200.3707@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Mar 2010 16:40:36 -0500
Message-ID: <1270071636.3552.978.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-31 at 10:54 -0700, Linus Torvalds wrote:
> 
> On Wed, 31 Mar 2010, San Mehat wrote:
> >
> > If the mmap_sem is not held while we walk_page_range(), then
> > it is possible for find_vma() to race with a remove_vma_list()
> > caused by do_munmap() (or others).
> 
> I think you've found a bug, but I also look at that code and say "that's 
> just totally insane".
> 
> Why does it do that initial "get_user_pages()" at all? It never _uses_ 
> that 'pages' array except to mark the pages dirty, but that's insane, 
> since as far as I can see the way it actually dirties the pages in 
> question is by doing a regular "put_user(pfn, pm->out);". And that will 
> dirty the pages in hardware (or put_user).
> 
> Also, I get the feeling that the _reason_ it is not doing that down_read() 
> is that it would dead-lock the whole system, exactly on that "put_user()", 
> if somebody else did a down_write() in another thread. In that case you 
> have:
> 
> 	thread#1		thread#2
> 	--------		--------
> 
> 	down_read()
> 	...
> 				down_write() - blocks
> 	...
> 	put_user();
> 	 .. page fault ..
> 	  down_read();	 **DEADLOCK **
> 
> 
> because our down_read() tries to be fair to the down_write().
> 
> So I think your patch would just create _different_ trouble.
> 
> I get the _feeling_ that the whole point of that 'pages' array was to not 
> do that put_user() at all, but write to the physical pages through that 
> array. But the code looks totally buggy.
> 
> I would seriously suggest that we consider removing the 'pagemap' 
> interface. The way that code looks, it's just broken.
> 
> Matt - give me a reason (which includes either a patch to fix this sh*t up 
> or telling me why I'm wrong, but _also_ includes a real independent reason 
> to keep that thing around regardless) to not remove it all.
> 
> The whole notion seems to be utterly misdesigned.

Linus, I must say your charm has really worn thin. I've just stuck a
post-it on my monitor saying "don't be Linus" to remind me not to be
rude to my contributors. 

If I recall correctly, the get_user_pages is there to force all the
output pages to be guaranteed present before we later fill them so that
the output needn't be double-buffered and the locking and recursion on
the page tables is significantly simpler and faster. put_user is then
actually easier than "writing to the physical pages through the array".

You're right that the SetPageDirty() at cleanup is redundant (but
harmless), and I probably copied that pattern from another user of
get_user_pages.

Earlier versions of the pagewalk code studiously avoided calling
find_vma and only looked at the page tables (with either caller doing
locking or accepting the non-atomicity) to avoid the sort of issue that
San has run into, but it looks like I forgot about that and let it sneak
back in when other folks added more hugepage support.

The deeper problem is that hugepages have various nasty layering
violations associated with them like being tied to vmas so until some
hugepage genius shows up and tells us how to do this cleanly, we'll
probably have to deal with the associated mmap_sem.

San, your patch is touching the wrong mm_sem, I think. The interesting
races are going to happen on the target mm, not current's (generally not
the same). Holding the mm_sem across the entire walk is also
prohibitive, it probably needs to be localized to individual find_vma
calls.

-- 
http://selenic.com : development and support for Mercurial and Linux


