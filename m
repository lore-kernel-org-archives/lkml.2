Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab0K3TDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:03:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617Ab0K3TDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:03:23 -0500
Date: Tue, 30 Nov 2010 20:01:59 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 53 of 66] add numa awareness to hugepage allocations
Message-ID: <20101130190159.GJ30389@random.random>
References: <patchbomb.1288798055@v2.random>
 <223ee926614158fc1353.1288798108@v2.random>
 <20101129143801.abef5228.nishimura@mxp.nes.nec.co.jp>
 <20101129161103.GE24474@random.random>
 <20101130093804.23f8c355.nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101130093804.23f8c355.nishimura@mxp.nes.nec.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 09:38:04AM +0900, Daisuke Nishimura wrote:
> I'm sorry if I miss something, "new_page" will be reused in !CONFIG_NUMA case
> as you say, but, in CONFIG_NUMA case, it is allocated in this function
> (collapse_huge_page()) by alloc_hugepage_vma(), and is not freed when memcg's
> charge failed.
> Actually, we do in collapse_huge_page():
> 	if (unlikely(!isolated)) {
> 		...
> #ifdef CONFIG_NUMA
> 		put_page(new_page);
> #endif
> 		goto out;
> 	}
> later. I think we need a similar logic in memcg's failure path too.

Apologies, you really found a minor memleak in case of memcg
accounting failure.

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1726,7 +1726,7 @@ static void collapse_huge_page(struct mm
 	}
 #endif
 	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL)))
-		goto out;
+		goto out_put_page;
 
 	anon_vma_lock(vma->anon_vma);
 
@@ -1755,10 +1755,7 @@ static void collapse_huge_page(struct mm
 		spin_unlock(&mm->page_table_lock);
 		anon_vma_unlock(vma->anon_vma);
 		mem_cgroup_uncharge_page(new_page);
-#ifdef CONFIG_NUMA
-		put_page(new_page);
-#endif
-		goto out;
+		goto out_put_page;
 	}
 
 	/*
@@ -1799,6 +1796,13 @@ static void collapse_huge_page(struct mm
 	khugepaged_pages_collapsed++;
 out:
 	up_write(&mm->mmap_sem);
+	return;
+
+out_put_page:
+#ifdef CONFIG_NUMA
+	put_page(new_page);
+#endif
+	goto out;
 }
 
 static int khugepaged_scan_pmd(struct mm_struct *mm,



I was too optimistic that there wasn't really a bug, I thought it was
some confusion about the hpage usage that differs with numa and not
numa.

On a side note, the CONFIG_NUMA case will later change further to move
the allocation out of the mmap_sem write mode to make the fs
submitting I/O from userland and doing memory allocations in the I/O
paths happier.
