Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab0DGIjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 04:39:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:36551 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab0DGIji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 04:39:38 -0400
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
In-Reply-To: <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org>
References: <20100402175937.GA19690@liondog.tnic>
	 <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>
	 <20100406173754.7E5A.A69D9226@jp.fujitsu.com> <4BBB475A.7070002@redhat.com>
	 <1270568096.1814.145.camel@barrios-desktop>
	 <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 07 Apr 2010 10:37:19 +0200
Message-ID: <1270629439.5109.553.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 08:55 -0700, Linus Torvalds wrote:
> I do wonder if "page_lock_anon_vma()" should check the whole 
> "page_mapped()" case _after_ taking the anon_vma lock. Because if the race 
> happens, we're following a anon_vma list that has nothing to do with that 
> page (it's stilla _valid_ list, since we locked the anon_vma, but will it 
> be ok?)
> 
> IOW, what is it that really keeps the anon_vma list reliable _and_ 
> relevant wrt the page? We know we may get a stale anon_vma, are we ok if 
> that anon_vma list doesn't actually have anything to do with the page any 
> more? 

When doing the whole make i_mmap_lock/anon_vma->lock a mutex thing last
week I ran into the same issue and its on my todo list to find out wth
is happening there. 

So yes I think we should move that validation check inside
page_lock_anon_vma().

I'll cook up a patch once I'm done staring at the various funny arch
mmu_gather implementations.
