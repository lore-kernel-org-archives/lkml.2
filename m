Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab0DZW2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 18:28:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab0DZW2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 18:28:10 -0400
Date: Tue, 27 Apr 2010 00:26:55 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 04/14] mm,migration: Allow the migration of
 PageSwapCache pages
Message-ID: <20100426222655.GJ8860@random.random>
References: <20100422154443.GD30306@csn.ul.ie>
 <20100423183135.GT32034@random.random>
 <20100423192311.GC14351@csn.ul.ie>
 <20100423193948.GU32034@random.random>
 <20100423213549.GV32034@random.random>
 <20100424105226.GF14351@csn.ul.ie>
 <20100424111340.GB32034@random.random>
 <20100424115936.GG14351@csn.ul.ie>
 <4BD60B80.8050605@redhat.com>
 <20100426221102.GB8459@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100426221102.GB8459@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 11:11:03PM +0100, Mel Gorman wrote:
> Migration isn't holding the mmap_sem for write, for read or the pagetable
> lock. It locks the page, unmaps it, puts a migration PTE in place that looks
> like a swap entry, copies it and remaps it under the pagetable lock. At no
> point does it hold the mmap_sem, but it needs to be sure it finds all the
> migration pte it created. Because there are multiple anon_vma's, the locking
> is tricky and unclear. I have one patch that locks the anon_vmas as it finds
> them but is prepared to start over in the event of contention.

split_huge_page has the exact same requirements, except it is more
strict and it will stop zap_page_range and count that the same number
of pmds it marked as splitting are found again later.


Also note migration has the same "ordering" requirements for
anon_vma_link during fork, new vmas have to be appended at the end or
migration will choke (not going into the details of why, but I can if
you want). This should be safe in new anon-vma code as I already
pointed out this requirement to Rik for split_huge_page to be safe too.

I never tested split_huge_page on the fixed new anon-vma code (before
the latest fixes so with rc4 or so, I only know before the latest
fixes it was triggering BUG_ON in split_huge_page as I've enough
bug-on in there to be sure if split_huge_page doesn't BUG_ON, it's
safe). I need to retry with the new anon-vma code... split_huge_page
never showed anything wrong with the 2.6.33 code that I'm running on
to reduce the variables in the equation.

> The second appears to be migration ptes that get copied during fork().
> This is easier to handle.

And this is also where the requirement that new vmas are added to the
end of the anon-vma lists comes from.

> I'm testing two patches at the moment and after 8 hours have seen no problem
> even though the races are being detected (and handled). If it survives the
> night, I'll post them.

I run again the same kernel as before and I reproduced the crash in
migration_entry_wait swapops.h (page not locked) just once when I
posted the stack trace and never again. I wanted to compare stack
traces and see if it happens again. But that bug in
migration_entry_wait can't be related to the new anon-vma code because
I've backed it out from aa.git. Still you've to figure out if your
patch is fixing a real bug.

I'm just pointing out if there's a bug in anon-vma
vma_adjust/expand_downards is unrelated to the crash in swapops.h
migration_entry_wait. And obviously it's not either a bug in
transparent hugepage code, as you also reproduced the same crash
without using aa.git only with v8.

We need to fix the swapops.h bug with maximum priority... (and of
course the anon-vma bug too if it exists).

Other than that swapops.h in migrate that you can also reproduce with
only mainline + memory compaction v8, I had zero other problems with
current aa.git.
