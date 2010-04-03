Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab0DCAYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 20:24:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751565Ab0DCAYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 20:24:15 -0400
Date: Fri, 2 Apr 2010 17:19:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@alien8.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Minchan Kim <minchan.kim@gmail.com>, Nick Piggin <npiggin@suse.de>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
In-Reply-To: <4BB66941.1060809@redhat.com>
Message-ID: <alpine.LFD.2.00.1004021705420.3634@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org> <20100402175937.GA19690@liondog.tnic> <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org> <20100402112428.f46ddc44.akpm@linux-foundation.org> <alpine.LFD.2.00.1004021135530.3634@i5.linux-foundation.org>
 <4BB66941.1060809@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Apr 2010, Rik van Riel wrote:
> 
> Interesting that it is a null pointer dereference, given
> that we do not zero out the anon_vma_chain structs before
> freeing them.
> 
> Page_referenced_anon() takes the anon_vma->lock before
> walking the list.  The three places where we modify the
> anon_vma_chain->same_anon_vma list, we also hold the
> lock.

So let's look at the individual anon_vma_chain entries instead.

What is the protection of the 'vma->anon_vma_chain' list? In 
anon_vma_prepare(), the code implies that it is the page_table_lock, but 
what about anon_vma_clone()? If I'm reading it correctly, it is some odd 
mix of "mmap_sem held for writing" or "mmap_sem held for reading _and_ 
page_table_lock". And then we have the exit case that apparently has no 
locking at all, but that should hopefully be single-threaded.

That thing is subtle. A few more comments about the locking would be good, 
so that people like me wouldn't have to try to guess the rules from 
reading the source.

> There has to be a reason why a very heavy AIM7 workload
> and some other stress tests did not trigger it, but a few
> people are able to trigger it on their systems...

I don't think AIM7 is at all a very interesting workload, and not likely 
to stress anything at all. Did your AIM7 test actually cause heavy 
swapping? I doubt it. 

Page swapout is where a lot of the magic happens, since that happens 
without mmap_sem held etc. 

			Linus
