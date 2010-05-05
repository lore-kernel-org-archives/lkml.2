Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760329Ab0EEOiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 10:38:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754549Ab0EEOiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 10:38:07 -0400
Date: Wed, 5 May 2010 07:34:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/2] mm,migration: Prevent rmap_walk_[anon|ksm] seeing
 the wrong VMA information
In-Reply-To: <1273065281-13334-2-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.LFD.2.00.1005050729000.5478@i5.linux-foundation.org>
References: <1273065281-13334-1-git-send-email-mel@csn.ul.ie> <1273065281-13334-2-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 5 May 2010, Mel Gorman wrote:
>
> With the recent anon_vma changes, there can be more than one anon_vma->lock
> to take in a anon_vma_chain but a second lock cannot be spinned upon in case
> of deadlock. The rmap walker tries to take locks of different anon_vma's
> but if the attempt fails, locks are released and the operation is restarted.

Btw, is this really needed?

Nobody else takes two anon_vma locks at the same time, so in order to 
avoid ABBA deadlocks all we need to guarantee is that rmap_walk_ksm() and 
rmap_walk_anon() always lock the anon_vma's in the same order.

And they do, as far as I can tell. How could we ever get a deadlock when 
we have both cases doing the locking by walking the same_anon_vma list?

	list_for_each_entry(avc, &anon_vma->head, same_anon_vma) {

So I think the "retry" logic looks unnecessary, and actually opens us up 
to a possible livelock bug (imagine a long chain, and heavy page fault 
activity elsewhere that ends up locking some anon_vma in the chain, and 
just the right behavior that gets us into a lockstep situation), rather 
than fixing an ABBA deadlock.

Now, if it's true that somebody else _does_ do nested anon_vma locking, 
I'm obviously wrong. But I don't see such usage.

Comments?

				Linus
