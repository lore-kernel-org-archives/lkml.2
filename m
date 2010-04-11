Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab0DKTu2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 15:50:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab0DKTu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 15:50:27 -0400
Message-ID: <4BC227B6.7050802@redhat.com>
Date: Sun, 11 Apr 2010 15:49:10 -0400
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
References: <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org> <20100410185145.GB28952@a1.tnic> <20100410185839.GA32035@a1.tnic> <alpine.LFD.2.00.1004101234210.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004101308250.3618@i5.linux-foundation.org> <20100410203628.GB32035@a1.tnic> <alpine.LFD.2.00.1004101336440.3618@i5.linux-foundation.org> <20100410212555.GA1797@a1.tnic> <alpine.LFD.2.00.1004101427090.3618@i5.linux-foundation.org> <20100410215115.GA2599@a1.tnic> <20100411130801.GA7189@a1.tnic> <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org> <alpine.LFD.2.00.1004111010280.3514@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004111010280.3514@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2010 01:16 PM, Linus Torvalds wrote:

> NOTE! If this is the race, then the hack really is just a hack, because it
> doesn't really solve anything. We still take the spinlock, and if bad
> things has happened, _that_ can still very much fail, and you get the
> watchdog lockup message instead. So this doesn't really fix anything.

Looking around the code some more, zap_pte_range()
calls page_remove_rmap(), which leaves the
page->mapping in place and has this comment:

         /*
          * It would be tidy to reset the PageAnon mapping here,
          * but that might overwrite a racing page_add_anon_rmap
          * which increments mapcount after us but sets mapping
          * before us: so leave the reset to free_hot_cold_page,
          * and remember that it's only reliable while mapped.
          * Leaving it set also helps swapoff to reinstate ptes
          * faster for those pages still in swapcache.
          */

I wonder if we can clear page->mapping here, if
list_is_singular(anon_vma->head).  That way we
will not leave stale pointers behind.

Adding another VMA to the anon_vma can happen
at fork time - which will not happen simultaneously
with exit or munmap, because the mmap_sem is taken
for write during either code path.

Am I overlooking something here?
