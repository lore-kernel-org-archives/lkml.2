Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933921Ab2JYOkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:40:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:53806 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930Ab2JYOj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:39:58 -0400
Message-ID: <1351175972.12171.14.camel@twins>
Subject: Re: [patch for-3.7] mm, mempolicy: fix printing stack contents in
 numa_maps
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, bhutchings@solarflare.com,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Thu, 25 Oct 2012 16:39:32 +0200
In-Reply-To: <1351167554.23337.14.camel@twins>
References: <20121008150949.GA15130@redhat.com>
	 <CAHGf_=pr1AYeWZhaC2MKN-XjiWB7=hs92V0sH-zVw3i00X-e=A@mail.gmail.com>
	 <alpine.DEB.2.00.1210152055150.5400@chino.kir.corp.google.com>
	 <CAHGf_=rLjQbtWQLDcbsaq5=zcZgjdveaOVdGtBgBwZFt78py4Q@mail.gmail.com>
	 <alpine.DEB.2.00.1210152306320.9480@chino.kir.corp.google.com>
	 <CAHGf_=pemT6rcbu=dBVSJE7GuGWwVFP+Wn-mwkcsZ_gBGfaOsg@mail.gmail.com>
	 <alpine.DEB.2.00.1210161657220.14014@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1210161714110.17278@chino.kir.corp.google.com>
	 <20121017040515.GA13505@redhat.com>
	 <alpine.DEB.2.00.1210162222100.26279@chino.kir.corp.google.com>
	 <CA+1xoqe74R6DX8Yx2dsp1MkaWkC1u6yAEd8eWEdiwi88pYdPaw@mail.gmail.com>
	 <alpine.DEB.2.00.1210241633290.22819@chino.kir.corp.google.com>
	 <CA+1xoqd6MEFP-eWdnWOrcz2EmE6tpd7UhgJyS8HjQ8qrGaMMMw@mail.gmail.com>
	 <alpine.DEB.2.00.1210241659260.22819@chino.kir.corp.google.com>
	 <1351167554.23337.14.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-25 at 14:19 +0200, Peter Zijlstra wrote:
> On Wed, 2012-10-24 at 17:08 -0700, David Rientjes wrote:
> > Ok, this looks the same but it's actually a different issue: 
> > mpol_misplaced(), which now only exists in linux-next and not in 3.7-rc2, 
> > calls get_vma_policy() which may take the shared policy mutex.  This 
> > happens while holding page_table_lock from do_huge_pmd_numa_page() but 
> > also from do_numa_page() while holding a spinlock on the ptl, which is 
> > coming from the sched/numa branch.
> > 
> > Is there anyway that we can avoid changing the shared policy mutex back 
> > into a spinlock (it was converted in b22d127a39dd ["mempolicy: fix a race 
> > in shared_policy_replace()"])?
> > 
> > Adding Peter, Rik, and Mel to the cc. 
> 
> Urgh, crud I totally missed that.
> 
> So the problem is that we need to compute if the current page is placed
> 'right' while holding pte_lock in order to avoid multiple pte_lock
> acquisitions on the 'fast' path.
> 
> I'll look into this in a bit, but one thing that comes to mind is having
> both a spnilock and a mutex and require holding both for modification
> while either one is sufficient for read.
> 
> That would allow sp_lookup() to use the spinlock, while insert and
> replace can hold both.
> 
> Not sure it will work for this, need to stare at this code a little
> more.

So I think the below should work, we hold the spinlock over both rb-tree
modification as sp free, this makes mpol_shared_policy_lookup() which
returns the policy with an incremented refcount work with just the
spinlock.

Comments?

---
 include/linux/mempolicy.h |    1 +
 mm/mempolicy.c            |   23 ++++++++++++++++++-----
 2 files changed, 19 insertions(+), 5 deletions(-)

--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -133,6 +133,7 @@ struct sp_node {
 
 struct shared_policy {
 	struct rb_root root;
+	spinlock_t lock;
 	struct mutex mutex;
 };
 
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2099,12 +2099,20 @@ bool __mpol_equal(struct mempolicy *a, s
  *
  * Remember policies even when nobody has shared memory mapped.
  * The policies are kept in Red-Black tree linked from the inode.
- * They are protected by the sp->lock spinlock, which should be held
- * for any accesses to the tree.
+ *
+ * The rb-tree is locked using both a mutex and a spinlock. Every modification
+ * to the tree must hold both the mutex and the spinlock, lookups can hold
+ * either to observe a stable tree.
+ *
+ * In particular, sp_insert() and sp_delete() take the spinlock, whereas
+ * sp_lookup() doesn't, this so users have choice.
+ *
+ * shared_policy_replace() and mpol_free_shared_policy() take the mutex
+ * and call sp_insert(), sp_delete().
  */
 
 /* lookup first element intersecting start-end */
-/* Caller holds sp->mutex */
+/* Caller holds either sp->lock and/or sp->mutex */
 static struct sp_node *
 sp_lookup(struct shared_policy *sp, unsigned long start, unsigned long end)
 {
@@ -2143,6 +2151,7 @@ static void sp_insert(struct shared_poli
 	struct rb_node *parent = NULL;
 	struct sp_node *nd;
 
+	spin_lock(&sp->lock);
 	while (*p) {
 		parent = *p;
 		nd = rb_entry(parent, struct sp_node, nd);
@@ -2155,6 +2164,7 @@ static void sp_insert(struct shared_poli
 	}
 	rb_link_node(&new->nd, parent, p);
 	rb_insert_color(&new->nd, &sp->root);
+	spin_unlock(&sp->lock);
 	pr_debug("inserting %lx-%lx: %d\n", new->start, new->end,
 		 new->policy ? new->policy->mode : 0);
 }
@@ -2168,13 +2178,13 @@ mpol_shared_policy_lookup(struct shared_
 
 	if (!sp->root.rb_node)
 		return NULL;
-	mutex_lock(&sp->mutex);
+	spin_lock(&sp->lock);
 	sn = sp_lookup(sp, idx, idx+1);
 	if (sn) {
 		mpol_get(sn->policy);
 		pol = sn->policy;
 	}
-	mutex_unlock(&sp->mutex);
+	spin_unlock(&sp->lock);
 	return pol;
 }
 
@@ -2295,8 +2305,10 @@ int mpol_misplaced(struct page *page, st
 static void sp_delete(struct shared_policy *sp, struct sp_node *n)
 {
 	pr_debug("deleting %lx-l%lx\n", n->start, n->end);
+	spin_lock(&sp->lock);
 	rb_erase(&n->nd, &sp->root);
 	sp_free(n);
+	spin_unlock(&sp->lock);
 }
 
 static struct sp_node *sp_alloc(unsigned long start, unsigned long end,
@@ -2381,6 +2393,7 @@ void mpol_shared_policy_init(struct shar
 	int ret;
 
 	sp->root = RB_ROOT;		/* empty tree == default mempolicy */
+	spin_lock_init(&sp->lock);
 	mutex_init(&sp->mutex);
 
 	if (mpol) {

