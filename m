Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab0DJWte (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 18:49:34 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:34062 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab0DJWtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 18:49:32 -0400
Date: Sun, 11 Apr 2010 00:49:15 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas of a mergeable VMA
Message-ID: <20100410224915.GJ28964@cmpxchg.org>
References: <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org> <20100409204328.GG28964@cmpxchg.org> <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org> <20100410003110.GI28964@cmpxchg.org> <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org> <20100410072714.GA9246@liondog.tnic> <20100410112639.GA24708@a1.tnic> <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004100930460.3558@i5.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004100930460.3558@i5.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 10, 2010 at 09:41:52AM -0700, Linus Torvalds wrote:
> [...]
>
> It also splits off the decision of whether we can reuse an non_vma from 
> the decision of whether we can merge the vma's - the two are kind of 
> related, but they are not really the same, and they have different issues. 
> I think it's good to try to keep separate issues separate.
>
> [...]
>
> + * NOTE! The fact that we share an anon_vma doesn't _have_ to mean that
> + * we can merge the two vma's. For example, we refuse to merge a vma if
> + * there is a vm_ops->close() function, because that indicates that the
> + * driver is doing some kind of reference counting. But that doesn't
> + * really matter for the anon_vma sharing case.

I am all in favor of only doing singletons, so that we don't have to
inflict my psycho-active merging routine on civilians.

I am not convinced it's a good idea to share an anon_vma, however, when
we know beforehand the vmas will never merge, because it will increase
rmap overhead of walking unrelated vmas for every page in every vma that
is part of the reused anon_vma.

So we usually take that as a trade-off when there is a chance the vmas
could still reunite and we don't want to spoil that through differing
anon_vmas.

But if it's already clear that they won't, it appears to me it would
be more efficient in the long run to just allocate our own anon_vma.

Did you have something in mind that I missed?

	Hannes
