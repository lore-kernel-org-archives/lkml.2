Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780Ab0DJURn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 16:17:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750829Ab0DJURm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 16:17:42 -0400
Date: Sat, 10 Apr 2010 13:12:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
cc: Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
In-Reply-To: <alpine.LFD.2.00.1004101234210.3558@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004101308250.3618@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org> <20100410003110.GI28964@cmpxchg.org> <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org> <20100410072714.GA9246@liondog.tnic> <20100410112639.GA24708@a1.tnic>
 <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org> <20100410163828.GA25579@a1.tnic> <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org> <20100410185145.GB28952@a1.tnic>
 <20100410185839.GA32035@a1.tnic> <alpine.LFD.2.00.1004101234210.3558@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Apr 2010, Linus Torvalds wrote:
> 
> This patch is scary and untested, but the more I look at that code, the 
> more convinced I am that vma_adjust was _really_ badly screwed up. The 
> patch below may make things worse. I'll test it myself too, but I'm 
> sending it out first, since I was writing the email as I was looking at 
> the piece of cr*p.

Ok, it boots. Which means it must be bug-free and perfect. And I really am 
convinced that the old vma_adjust() use of anon_vma_clone() was _totally_ 
broken, so this really could explain everything.

The RCU grace period thing for the TLB flush does look like a real bug 
too, but it's one that is probably impossible to hit in practice.

A broken vma_adjust(), however, would seem to be trivial to hit once you 
just get the right memory freeing patterns going, because the anon_vma 
would easily be _loong_ gone because we didn't create a chain to it at 
all, so the anon_vma code decided that it's not used any more.

So I'm actually pretty optimistic that this really is it.

		Linus
