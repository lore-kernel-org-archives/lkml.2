Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab3ACR5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 12:57:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38616 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580Ab3ACR5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 12:57:41 -0500
Date: Thu, 3 Jan 2013 17:57:37 +0000
From: Mel Gorman <mgorman@suse.de>
To: Zhouping Liu <zliu@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Johannes Weiner <jweiner@redhat.com>,
        hughd@google.com, Michel Lespinasse <walken@google.com>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: kernel BUG at mm/huge_memory.c:1798!
Message-ID: <20130103175737.GA3885@suse.de>
References: <1621091901.34838094.1356409676820.JavaMail.root@redhat.com>
 <535932623.34838584.1356410331076.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <535932623.34838584.1356410331076.JavaMail.root@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Michel and Rik to cc)

On Mon, Dec 24, 2012 at 11:38:51PM -0500, Zhouping Liu wrote:
> Hello all,
> 
> I found the below kernel bug using latest mainline(637704cbc95),
> my hardware has 2 numa nodes, and it's easy to reproduce the issue
> using LTP test case: "# ./mmap10 -a -s -c 200":
> 

Sorry for the long delay in responding, first day back online after being
off for a holiday. I can reproduce this problem. It takes many iterations
but triggers within a minute. It also affects 3.8-rc2.

This BUG is triggered because the rmap walk is not finding all vmas mapping
a page (walk found 0 avc's while the page mapcount was positive). THP
requires this rmap walk to be correct or minimally all the pmds will not
be marked as splitting. If PMDs are not marked splitting then all sorts
of problems can occur. The test case triggering this is fairly simple.

o A process creates a mapping 10MB-4KB in size
o The process forks, then unmaps the entire mapping and exits
o First child forks then unmaps part of the mapping and exits
o Second child unmaps then unmaps part of the mapping and exits

The partial unmapping on a page boundary but not a THP boundary is what
causes the THP split and allows this bug to be triggered. The two children
are racing with each other.

I confirmed that this bug triggers on UMA and the THP migration for NUMA
balancing is very unlikely to be a factor.  As it looked like anon_vma
rwsem was being taken for write in the correct places, it led me to conclude
that this must be a race within split_huge_page() itself somewhere.

split_huge_page consists of three tasks

  o __split_huge_page_splitting marks all PMDs as splitting

  o __split_huge_page_refcount uses the page compound lock to serialise
    based on the page and converts the compount page into 512 base pages

  o __split_huge_page_map uses the page table lock to serialise within
    the address space and updates the PTE

None of these affect avc linkages but they might be affecting the rmap
walk after the conversion to interval trees. I'm adding Michel and Rik
to the cc in case they can quickly spot how the walk could be affected
during a THP split.

The patch below hides the race by serialising split_huge_page but the
exact race needs to be identified before figuring out what the real locking
problem is. That's as far as I got with it today and will pick it up again
tomorrow. Better theories as to what is going wrong are welcome.

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9e894ed..f815ddb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1822,6 +1822,8 @@ int split_huge_page(struct page *page)
 	anon_vma = page_lock_anon_vma_read(page);
 	if (!anon_vma)
 		goto out;
+	page_unlock_anon_vma_read(anon_vma);
+	anon_vma_lock_write(anon_vma);
 	ret = 0;
 	if (!PageCompound(page))
 		goto out_unlock;
@@ -1832,7 +1834,7 @@ int split_huge_page(struct page *page)
 
 	BUG_ON(PageCompound(page));
 out_unlock:
-	page_unlock_anon_vma_read(anon_vma);
+	anon_vma_unlock(anon_vma);
 out:
 	return ret;
 }

