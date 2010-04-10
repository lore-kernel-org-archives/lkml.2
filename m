Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab0DJUpg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 16:45:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075Ab0DJUpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 16:45:10 -0400
Date: Sat, 10 Apr 2010 13:40:39 -0700 (PDT)
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
In-Reply-To: <20100410203628.GB32035@a1.tnic>
Message-ID: <alpine.LFD.2.00.1004101336440.3618@i5.linux-foundation.org>
References: <20100410072714.GA9246@liondog.tnic> <20100410112639.GA24708@a1.tnic> <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org> <20100410163828.GA25579@a1.tnic> <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org> <20100410185145.GB28952@a1.tnic> <20100410185839.GA32035@a1.tnic> <alpine.LFD.2.00.1004101234210.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004101308250.3618@i5.linux-foundation.org>
 <20100410203628.GB32035@a1.tnic>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Apr 2010, Borislav Petkov wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Sat, Apr 10, 2010 at 01:12:46PM -0700
> 
> > So I'm actually pretty optimistic that this really is it.
> 
> Ok, let me verify what/in which order should be tested before I test
> something wrongly. The RCU-safe fix for the TLB flush can stay for
> correctness reasons, this last patch, obviosly, what happens with the
> find_mergeable_anon_vma() changes to use only singleton lists for
> merging? Should I keep those too?

Yes. So the patches I actually think are important are:

 - the RCU fix is real, although admittedly the race window is probably 
   too small to ever really hit.

 - the simplification rule to find_mergeable_anon_vma's is required, 
   because otherwise our anon_vma_merge() will do the wrong thing (maybe 
   Johannes' patch would be an alternative, but quite frankly, I think we 
   want the simpler code, and I don't think we even _want_ to share 
   anon_vma's that are complex due to forking)

   I like my "cleanup" version (the bigger one with lots of comments) more 
   than the two-liner version, but they should be equivalent.

 - the vma_adjust() fix is the one that I think may actually end up fixing 
   your problems for good. Knock wood.

So I think they are all required, but I suspect that the vma_adjust() one 
is finally the most direct explanation of the problem you've seen.

		Linus
