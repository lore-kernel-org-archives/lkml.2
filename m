Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933827Ab0DHXUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 19:20:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933785Ab0DHXUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 19:20:44 -0400
Date: Thu, 8 Apr 2010 16:16:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
In-Reply-To: <20100408210035.GA25834@a1.tnic>
Message-ID: <alpine.LFD.2.00.1004081610020.3558@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004071505510.3586@i5.linux-foundation.org> <alpine.LFD.2.00.1004071625490.3586@i5.linux-foundation.org> <20100408101925.FB9F.A69D9226@jp.fujitsu.com> <alpine.LFD.2.00.1004071929090.3586@i5.linux-foundation.org>
 <20100408054707.GA9299@a1.tnic> <alpine.LFD.2.00.1004080706500.3586@i5.linux-foundation.org> <20100408210035.GA25834@a1.tnic>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Apr 2010, Borislav Petkov wrote:
> 
> And this happens quite often - I changed the WARN_ONCE to WARN and can't
> start kvm, iceowl (mozilla calendar) and the console-kit-daemon craps up
> upon boot too:

Hmm. I tried console-kit-daemon, which I had installed, but didn't get 
anything like that. Probably some setup difference.

I also went through every user of 'vm_area_cachep', and saw nothing 
suspicious at least for the mmu case (I didn't check the nommu.c code). I 
must have missed something.

One thing you could do is to add some more debugging info when that "no 
anon_vma" warning happens. In particular, if you still have the SLUB 
debugging on, you could try to do that

	page = virt_to_head_page(vma);
	object_err(vm_area_cachep, page, (void *)vma, "NULL anon_vma");

and it should give you _which_ routine did the kmem_cache_alloc() for the 
vma that doesn't have an anon_vma.

		Linus
