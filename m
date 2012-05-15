Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab2EOLr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:47:28 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:59661 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758518Ab2EOLr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 07:47:27 -0400
Date: Tue, 15 May 2012 13:47:16 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>, David Miller <davem@davemloft.net>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] mm: remove sparsemem allocation details from the
 bootmem allocator
Message-ID: <20120515114716.GI1406@cmpxchg.org>
References: <1336390672-14421-1-git-send-email-hannes@cmpxchg.org>
 <1336390672-14421-11-git-send-email-hannes@cmpxchg.org>
 <20120510144439.eba9c486.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120510144439.eba9c486.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 02:44:39PM -0700, Andrew Morton wrote:
> On Mon,  7 May 2012 13:37:52 +0200
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > alloc_bootmem_section() derives allocation area constraints from the
> > specified sparsemem section.  This is a bit specific for a generic
> > memory allocator like bootmem, though, so move it over to sparsemem.
> > 
> > As __alloc_bootmem_node_nopanic() already retries failed allocations
> > with relaxed area constraints, the fallback code in sparsemem.c can be
> > removed and the code becomes a bit more compact overall.
> > 
> > ...
> >
> > @@ -332,9 +334,9 @@ static void __init check_usemap_section_nr(int nid, unsigned long *usemap)
> >  #else
> >  static unsigned long * __init
> >  sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
> > -					 unsigned long count)
> > +					 unsigned long size)
> >  {
> > -	return NULL;
> > +	return alloc_bootmem_node_nopanic(pgdat, size)
> 
> You've been bad.   Your penance is to runtime test this code with
> CONFIG_MEMORY_HOTREMOVE=n!

I did now.

See, but I DID test the =y case, missed an obvious bug and even
considered the particular node-section dependency warnings to be
expected in the setup configuration.  Testing is no way around being a
cretin :(

So here is another fix:

---
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch] mm: remove sparsemem allocation details from the bootmem
 allocator fix

Don't confuse an address with a pfn.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 2192b67..66d1845 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -288,7 +288,7 @@ sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
 	 * this problem.
 	 */
 	goal = __pa(pgdat) & PAGE_SECTION_MASK;
-	host_pgdat = NODE_DATA(early_pfn_to_nid(goal));
+	host_pgdat = NODE_DATA(early_pfn_to_nid(goal >> PAGE_SHIFT));
 	printk("allocating usemap for node %d on node %d (goal=%lu)\n",
 	       pgdat->node_id, host_pgdat->node_id, goal);
 	return __alloc_bootmem_node_nopanic(host_pgdat, size,
-- 
1.7.10.1

