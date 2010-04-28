Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab0D1BW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 21:22:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55548 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab0D1BW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 21:22:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Apr 2010 10:18:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] mm,migration: Remove straggling migration PTEs when
 page tables are being moved after the VMA has already moved
Message-Id: <20100428101858.1da1d2ed.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100428010543.GJ510@random.random>
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie>
	<1272403852-10479-4-git-send-email-mel@csn.ul.ie>
	<20100427223004.GF8860@random.random>
	<20100427225852.GH8860@random.random>
	<20100428093948.c4e6faa1.kamezawa.hiroyu@jp.fujitsu.com>
	<20100428010543.GJ510@random.random>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010 03:05:43 +0200
Andrea Arcangeli <aarcange@redhat.com> wrote:

> On Wed, Apr 28, 2010 at 09:39:48AM +0900, KAMEZAWA Hiroyuki wrote:
> > Seems nice.
> 
> What did you mean with objrmap inconsistency? I think this is single
> threaded there, userland didn't run yet and I don't think page faults
> could run. Maybe it's safer to add a VM_BUG_ON(vma->anon_vma) just
> before vma->anon_vma = anon_vma to be sure nothing run in between.
> 
I mean following relationship.

	vma_address(vma, page1) <-> address <-> pte <-> page2
	
	If page1 == page2, objrmap is consistent.
	If page1 != page2, objrmap is inconsistent.





> > I'll test this but I think we need to take care of do_mremap(), too.
> > And it's more complicated....
> 
> do_mremap has to be safe by:
> 
> 1) adjusting page->index atomically with the pte updates inside pt
>    lock (while it moves from one pte to another)
> 
I reviewed do_mremap again and am thinking it's safe.


	new_vma = copy_vma();
	....                   ----------(*)
	move_ptes().
	munmap unnecessary range.

At (*), if page1 != page2, rmap_walk will not run correctly.
But it seems copy_vma() keeps page1==page2 

As I reported, when there is a problem, vma_address() returns an address but
that address doesn't contain migration_pte.

BTW, page->index is not updated, we just keep [start_address, pgoff] to be
sane value.

Thanks,
-Kame


