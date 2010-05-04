Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887Ab0EDNMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 09:12:51 -0400
Received: from gir.skynet.ie ([193.1.99.77]:49242 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab0EDNMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 09:12:50 -0400
Date: Tue, 4 May 2010 14:12:31 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 1/2] mm: Take all anon_vma locks in anon_vma_lock
Message-ID: <20100504131231.GF20979@csn.ul.ie>
References: <20100503121743.653e5ecc@annuminas.surriel.com> <20100503121847.7997d280@annuminas.surriel.com> <alpine.LFD.2.00.1005030940490.5478@i5.linux-foundation.org> <4BDEFF9E.6080508@redhat.com> <alpine.LFD.2.00.1005030958140.5478@i5.linux-foundation.org> <4BDF0ECC.5080902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4BDF0ECC.5080902@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 01:58:36PM -0400, Rik van Riel wrote:
>>
>> Btw, Mel's patch doesn't really match the description of 2/2. 2/2 says
>> that all pages must always be findable in rmap. Mel's patch seems to
>> explicitly say "we want to ignore that thing that is busy for execve". Are
>> we just avoiding a BUG_ON()? Is perhaps the BUG_ON() buggy?
>
> I have no good answer to this question.
>
> Mel?  Andrea?
>

The wording could have been better.

The problem is that once a migration PTE is established, it is expected that
rmap can find it. In the specific case of exec, this can fail because of
how the temporary stack is moved. As migration colliding with exec is rare,
the approach taken by the patch was to not create migration PTEs that rmap
could not find. On the plus side, exec (the common case) is unaffected. On
the negative side, it's avoiding the exec vs migration problem instead of
fixing it.

The BUG_ON is not a buggy check. While migration is taking place, the page lock
is held and not unreleased until all the migration PTEs have been removed. If
a migration entry exists and the page is unlocked, it means that rmap failed
to find all the entries. If the BUG_ON was not made, do_swap_page() would
either end up looking up a semi-random entry in swap cache and inserting it
(memory corruption), inserting a random page from swap (memory corruption)
or returning VM_FAULT_OOM to the fault handler (general carnage).

It was considered to lazily clean up the migration PTEs
(http://lkml.org/lkml/2010/4/27/458) but there is no guarantee that the page
the migration PTE pointed to is still the correct one. If it had been freed
and re-used, the results would probably be memory corruption.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
