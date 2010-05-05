Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598Ab0EEPfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 11:35:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760368Ab0EEPfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 11:35:10 -0400
Date: Wed, 5 May 2010 08:31:42 -0700 (PDT)
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
In-Reply-To: <20100505145620.GP20979@csn.ul.ie>
Message-ID: <alpine.LFD.2.00.1005050815060.5478@i5.linux-foundation.org>
References: <1273065281-13334-1-git-send-email-mel@csn.ul.ie> <1273065281-13334-2-git-send-email-mel@csn.ul.ie> <alpine.LFD.2.00.1005050729000.5478@i5.linux-foundation.org> <20100505145620.GP20979@csn.ul.ie>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 5 May 2010, Mel Gorman wrote:
> 
> rmap_walk() appears to be the only one that takes multiple locks but it itself
> is not serialised. If there are more than one process calling rmap_walk()
> on different processes sharing the same VMAs, is there a guarantee they walk
> it in the same order?

So I had this notion of the list always getting deeper and us guaranteeing 
the order in it, but you're right - that's not the 'same_anon_vma' list, 
it's the 'same_vma' one.

Damn. So yeah, I don't see us guaranteeing any ordering guarantees. My 
bad.

That said, I do wonder if we could _make_ the ordering reliable. I did 
that for the 'same_vma' one, because I wanted to be able to verify that 
chains were consistent (and we also needed to be able to find the "oldest 
anon_vma" for the case of re-instantiating pages that migth exist in 
multiple different anon_vma's).

Any ideas?

		Linus
