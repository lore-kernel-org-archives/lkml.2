Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab0CaR7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 13:59:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757829Ab0CaR7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 13:59:09 -0400
Date: Wed, 31 Mar 2010 10:54:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: San Mehat <san@google.com>
cc: linux-kernel@vger.kernel.org, Brian Swetland <swetland@google.com>,
       Matt Mackall <mpm@selenic.com>, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] proc: pagemap: Hold mmap_sem during page walk
In-Reply-To: <1270056227-5442-1-git-send-email-san@google.com>
Message-ID: <alpine.LFD.2.00.1003311036200.3707@i5.linux-foundation.org>
References: <1270056227-5442-1-git-send-email-san@google.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 31 Mar 2010, San Mehat wrote:
>
> If the mmap_sem is not held while we walk_page_range(), then
> it is possible for find_vma() to race with a remove_vma_list()
> caused by do_munmap() (or others).

I think you've found a bug, but I also look at that code and say "that's 
just totally insane".

Why does it do that initial "get_user_pages()" at all? It never _uses_ 
that 'pages' array except to mark the pages dirty, but that's insane, 
since as far as I can see the way it actually dirties the pages in 
question is by doing a regular "put_user(pfn, pm->out);". And that will 
dirty the pages in hardware (or put_user).

Also, I get the feeling that the _reason_ it is not doing that down_read() 
is that it would dead-lock the whole system, exactly on that "put_user()", 
if somebody else did a down_write() in another thread. In that case you 
have:

	thread#1		thread#2
	--------		--------

	down_read()
	...
				down_write() - blocks
	...
	put_user();
	 .. page fault ..
	  down_read();	 **DEADLOCK **


because our down_read() tries to be fair to the down_write().

So I think your patch would just create _different_ trouble.

I get the _feeling_ that the whole point of that 'pages' array was to not 
do that put_user() at all, but write to the physical pages through that 
array. But the code looks totally buggy.

I would seriously suggest that we consider removing the 'pagemap' 
interface. The way that code looks, it's just broken.

Matt - give me a reason (which includes either a patch to fix this sh*t up 
or telling me why I'm wrong, but _also_ includes a real independent reason 
to keep that thing around regardless) to not remove it all.

The whole notion seems to be utterly misdesigned.

			Linus
