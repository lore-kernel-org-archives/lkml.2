Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab0DLSmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 14:42:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461Ab0DLSmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 14:42:13 -0400
Message-ID: <4BC36916.3080005@redhat.com>
Date: Mon, 12 Apr 2010 14:40:22 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Borislav Petkov <bp@alien8.de>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
References: <alpine.LFD.2.00.1004101336440.3618@i5.linux-foundation.org> <20100410212555.GA1797@a1.tnic> <alpine.LFD.2.00.1004101427090.3618@i5.linux-foundation.org> <20100410215115.GA2599@a1.tnic> <20100411130801.GA7189@a1.tnic> <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org> <alpine.LFD.2.00.1004111010280.3514@i5.linux-foundation.org> <20100411185508.GA4450@liondog.tnic> <alpine.LFD.2.00.1004111707360.3514@i5.linux-foundation.org> <alpine.LFD.2.00.1004111759440.3521@i5.linux-foundation.org> <20100412072056.GA2432@liondog.tnic> <alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org> <alpine.LFD.2.00.1004120906370.26679@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004120906370.26679@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 12:26 PM, Linus Torvalds wrote:

> But there is a _much_ more subtle case that involved swapping.
>
> So guys, here's my fairly simple theory on what happens:

That bug looks entirely possible.  Given that Borislav
has heavy swapping going on, it is quite possible that
this is the bug he has been triggering.

> The patch below is my largely mindless try at fixing this. It's untested.
> I'm not entirely sure that it actually works. But it makes some amount of
> conceptual sense. No?

The patch would help avoid the bug you described.

It does have the drawback of moving all the pages of
child processes back into the anon_vma of the parent
process after swapin, even if they are privately owned
pages by the child process.

I am guessing it may need a check to see whether the
page and swap slot are exclusively owned by the current
process.

Page or swap slot shared?      => oldest anon_vma
Page and swap slot exclusive?  => newest anon_vma

I suspect the easiest way to achieve this would be to
pass a flag in from do_swap_page, where we already
check this, a few lines above calling page_add_anon_rmap:

         if ((flags & FAULT_FLAG_WRITE) && reuse_swap_page(page)) {
                 pte = maybe_mkwrite(pte_mkdirty(pte), vma);
                 flags &= ~FAULT_FLAG_WRITE;
         }



