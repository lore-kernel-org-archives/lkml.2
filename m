Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab0DLPdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 11:33:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38575 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab0DLPdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 11:33:32 -0400
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the
 anon_vmas  of a mergeable VMA
From: Peter Zijlstra <peterz@infradead.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
In-Reply-To: <r2i28c262361004120817hbd161cd2k4476ea3a6ad3de6a@mail.gmail.com>
References: <20100409191425.GB10780@a1.tnic>
	 <20100410003110.GI28964@cmpxchg.org>
	 <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org>
	 <20100410072714.GA9246@liondog.tnic> <20100410112639.GA24708@a1.tnic>
	 <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org>
	 <20100410163828.GA25579@a1.tnic>
	 <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org>
	 <1271083207.4807.18.camel@twins>
	 <r2i28c262361004120817hbd161cd2k4476ea3a6ad3de6a@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Apr 2010 17:33:25 +0200
Message-ID: <1271086405.20295.3382.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-13 at 00:17 +0900, Minchan Kim wrote:
> > Concurrent reclaim/gup/whatever could still have a count out on the page
> > delaying the actual free beyond the tlb gather RCU section.
> 
> anon_vma lock is just valid in case of page_mapped.
> if reclaim/gup/whatever want to use anon_vma, it should check with page_mapped.
> And last put_page doesn't touch anon_vma for freeing the page so I
> think it's not a problem. Do I miss something?

Hmm, I think you're right. The race I was thinking of makes the
page_lock_anon_vma() RCU section overlap with that of the mmu_gather,
which ensures the thing is long enough, or hits the !_mapcount case.

I'm not sure there are other page->mapping users that are interesting.

