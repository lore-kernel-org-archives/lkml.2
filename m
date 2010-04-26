Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab0DZWLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 18:11:23 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53231 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894Ab0DZWLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 18:11:22 -0400
Date: Mon, 26 Apr 2010 23:11:03 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 04/14] mm,migration: Allow the migration of
	PageSwapCache pages
Message-ID: <20100426221102.GB8459@csn.ul.ie>
References: <1271947206.2100.216.camel@barrios-desktop> <20100422154443.GD30306@csn.ul.ie> <20100423183135.GT32034@random.random> <20100423192311.GC14351@csn.ul.ie> <20100423193948.GU32034@random.random> <20100423213549.GV32034@random.random> <20100424105226.GF14351@csn.ul.ie> <20100424111340.GB32034@random.random> <20100424115936.GG14351@csn.ul.ie> <4BD60B80.8050605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4BD60B80.8050605@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 05:54:08PM -0400, Rik van Riel wrote:
> On 04/24/2010 07:59 AM, Mel Gorman wrote:
>> On Sat, Apr 24, 2010 at 01:13:40PM +0200, Andrea Arcangeli wrote:
>
>>> Also keep in mind expand_downwards which also adjusts
>>> vm_start/vm_pgoff the same way (and without mmap_sem write mode).
>>
>> Will keep it in mind. It's taking the anon_vma lock but once again,
>> there might be more than one anon_vma to worry about and the proper
>> locking still isn't massively clear to me.
>
> The locking for the anon_vma_chain->same_vma list is
> essentially the same as what was used before in mmap
> and anon_vma_prepare.
>
> Either the mmap_sem is held for write, or the mmap_sem
> is held for reading and the page_table_lock is held.
>
> What exactly is the problem that migration is seeing?
>

There are two problems.

Migration isn't holding the mmap_sem for write, for read or the pagetable
lock. It locks the page, unmaps it, puts a migration PTE in place that looks
like a swap entry, copies it and remaps it under the pagetable lock. At no
point does it hold the mmap_sem, but it needs to be sure it finds all the
migration pte it created. Because there are multiple anon_vma's, the locking
is tricky and unclear. I have one patch that locks the anon_vmas as it finds
them but is prepared to start over in the event of contention.

The second appears to be migration ptes that get copied during fork().
This is easier to handle.

I'm testing two patches at the moment and after 8 hours have seen no problem
even though the races are being detected (and handled). If it survives the
night, I'll post them.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
