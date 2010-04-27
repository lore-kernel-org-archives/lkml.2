Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab0D0X4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 19:56:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51521 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab0D0X4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 19:56:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Apr 2010 08:52:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] mm,migration: During fork(), wait for migration to
 end if migration PTE is encountered
Message-Id: <20100428085203.4336b761.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100427222245.GE8860@random.random>
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie>
	<1272403852-10479-2-git-send-email-mel@csn.ul.ie>
	<20100427222245.GE8860@random.random>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010 00:22:45 +0200
Andrea Arcangeli <aarcange@redhat.com> wrote:

> Ok I had a first look:
> 
> On Tue, Apr 27, 2010 at 10:30:50PM +0100, Mel Gorman wrote:
> > 	CPUA			CPU B
> > 				do_fork()
> > 				copy_mm() (from process 1 to process2)
> > 				insert new vma to mmap_list (if inode/anon_vma)
> 
> Insert to the tail of the anon_vma list...
> 
> > 	pte_lock(process1)
> > 	unmap a page
> > 	insert migration_entry
> > 	pte_unlock(process1)
> > 
> > 	migrate page copy
> > 				copy_page_range
> > 	remap new page by rmap_walk()
> 
> rmap_walk will walk process1 first! It's at the head, the vmas with
> unmapped ptes are at the tail so process1 is walked before process2.
> 
> > 	pte_lock(process2)
> > 	found no pte.
> > 	pte_unlock(process2)
> > 				pte lock(process2)
> > 				pte lock(process1)
> > 				copy migration entry to process2
> > 				pte unlock(process1)
> > 				pte unlokc(process2)
> > 	pte_lock(process1)
> > 	replace migration entry
> > 	to new page's pte.
> > 	pte_unlock(process1)
> 
> rmap_walk has to lock down process1 before process2, this is the
> ordering issue I already mentioned in earlier email. So it cannot
> happen and this patch is unnecessary.
> 
> The ordering is fundamental and as said anon_vma_link already adds new
> vmas to the _tail_ of the anon-vma. And this is why it has to add to
> the tail. If anon_vma_link would add new vmas to the head of the list,
> the above bug could materialize, but it doesn't so it cannot happen.
> 
> In mainline anon_vma_link is called anon_vma_chain_link, see the
> list_add_tail there to provide this guarantee.
> 
> Because process1 is walked first by CPU A, the migration entry is
> replaced by the final pte before copy-migration-entry
> runs. Alternatively if copy-migration-entry runs before before
> process1 is walked, the migration entry will be copied and found in
> process 2.
> 

I already explained this doesn't happend and said "I'm sorry".

But considering maintainance, it's not necessary to copy migration ptes
and we don't have to keep a fundamental risks of migration circus.

So, I don't say "we don't need this patch."

Thanks,
-Kame

