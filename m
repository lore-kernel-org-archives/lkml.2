Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab0ECSOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 14:14:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841Ab0ECSOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 14:14:41 -0400
Date: Mon, 3 May 2010 20:13:40 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Mel Gorman <mel@csn.ul.ie>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 1/2] mm: Take all anon_vma locks in anon_vma_lock
Message-ID: <20100503181340.GH19891@random.random>
References: <20100503121743.653e5ecc@annuminas.surriel.com>
 <20100503121847.7997d280@annuminas.surriel.com>
 <alpine.LFD.2.00.1005030940490.5478@i5.linux-foundation.org>
 <4BDEFF9E.6080508@redhat.com>
 <alpine.LFD.2.00.1005030958140.5478@i5.linux-foundation.org>
 <4BDF0ECC.5080902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BDF0ECC.5080902@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Btw, Mel's patch doesn't really match the description of 2/2. 2/2 says
> > that all pages must always be findable in rmap. Mel's patch seems to
> > explicitly say "we want to ignore that thing that is busy for execve". Are
> > we just avoiding a BUG_ON()? Is perhaps the BUG_ON() buggy?
> 
> I have no good answer to this question.
> 
> Mel?  Andrea?

If try_to_unmap is allowed to establish the migration pte, then such
pte has to remain reachable through rmap_walk at all times after that,
or migration_entry_wait will crash because it notices the page has
been migrated already (PG_lock not set) but there is still a migration
pte established. (remove_migration_pte like split_huge_page isn't
allowed to fail finding all migration ptes mapping a page during the
rmap walk)

It's not false positive BUG_ON if that's what you mean, removing the
BUG_ON would still lead to infinite hang waiting on a migration pte
that shouldn't be there anymore.
