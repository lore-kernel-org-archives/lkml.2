Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab0DFX4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 19:56:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183Ab0DFX4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 19:56:50 -0400
Message-ID: <4BBBC240.3090302@redhat.com>
Date: Tue, 06 Apr 2010 19:22:40 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux 2.6.34-rc3)
References: <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org> <1270571019.1814.163.camel@barrios-desktop> <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org> <1270572327.1711.3.camel@barrios-desktop> <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org> <4BBB69A9.5090906@redhat.com> <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org> <20100406120315.53ad7390.akpm@linux-foundation.org> <20100406194238.GB20357@a1.tnic> <alpine.LFD.2.00.1004061243240.3487@i5.linux-foundation.org> <20100406205123.GC20357@a1.tnic> <alpine.LFD.2.00.1004061403170.3487@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004061403170.3487@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 05:27 PM, Linus Torvalds wrote:

> I still don't see _how_ it happens, though. That 'struct anon_vma' is very
> simple, and contains literally just the lock and that list_head.

It gets more fun.  It looks like the anon_vma is only
allocated through anon_vma_alloc() and only handled
by the functions in rmap.c

By themselves, all of those functions look alright.

However, I think I may have found a possible bug in
the interplay between anon_vma_prepare() and vma_adjust(),
across several mprotect invocations.

Let me explain what I think may be going on in small
steps, since it is quite subtle (assuming I am right).

1) a process forks, creating a second "layer" of
    anon_vma objects for the VMAs that have anon pages

2) a new VMA is created adjacant to an existing one,
    with different permissions

3) anon_vma_prepare is called on the new VMA, this
    only links the "top" anon_vma to the new VMA, since
    that is the anon_vma where all new pages get
    instantiated anyway   (this would be part of the bug)

4) mprotect changes the permission of one of the VMAs,
    causing the old and the new VMAs to get merged

5) vma_adjust calls anon_vma_merge, causing the anon_vma
    chain of one of the VMAs to get nuked - with bad luck,
    this is the original one, leaving just the new anon_vma
    attached to the VMA

6) if the parent process quits, the old anon_vma structs
    get freed

7) meanwhile, we may still have some anonymous pages
    stick around in memory that have their page->mapping
    point to a freed anon_vma struct

Does this look like it could happen?

If so, I'll cook up a patch to change anon_vma_prepare
and find_mergeable_anon_vma to attach the whole chain
of anon_vmas to the new VMA, using anon_vma_clone().
