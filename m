Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab2A3WDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:03:54 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:61252 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab2A3WDw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:03:52 -0500
MIME-Version: 1.0
Message-ID: <72823e35-1ecb-45ce-b9ca-4f6fb3cdaaa6@default>
Date: Mon, 30 Jan 2012 14:03:38 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Konrad Wilk <konrad.wilk@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Nebojsa Trpkovic <trx.lists@gmail.com>, minchan@kernel.org,
        Chris Mason <chris.mason@oracle.com>
Subject: RE: [PATCH] mm: implement WasActive page flag (for improving
 cleancache)
References: <ea3b0850-dfe0-46db-9201-2bfef110848d@default>
 <4F218D36.2060308@linux.vnet.ibm.com>
 <9fcd06f5-360e-4542-9fbb-f8c7efb28cb6@default>
 <20120126163150.31a8688f.akpm@linux-foundation.org>
 <ccb76a4d-d453-4faa-93a9-d1ce015255c0@default>
 <20120126171548.2c85dd44.akpm@linux-foundation.org>
 <7198bfb3-1e32-40d3-8601-d88aed7aabd8@default> <4F221AFE.6070108@redhat.com>
 <22f6781b-9cc4-4857-b3e1-e2d9f595f64d@default>
 <20120130175730.de654d9c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120130175730.de654d9c.kamezawa.hiroyu@jp.fujitsu.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4F2713B9.003B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: KAMEZAWA Hiroyuki [mailto:kamezawa.hiroyu@jp.fujitsu.com]
> Subject: Re: [PATCH] mm: implement WasActive page flag (for improving cleancache)
> 
> On Thu, 26 Jan 2012 21:15:16 -0800 (PST)
> Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> 
> > > From: Rik van Riel [mailto:riel@redhat.com]
> > > Subject: Re: [PATCH] mm: implement WasActive page flag (for improving cleancache)
> > >
> > > On 01/26/2012 09:43 PM, Dan Magenheimer wrote:
> > >
> > > > Maybe the Active page bit could be overloaded with some minor
> > > > rewriting?  IOW, perhaps the Active bit could be ignored when
> > > > the page is moved to the inactive LRU?  (Confusing I know, but I am
> > > > just brainstorming...)
> > >
> > > The PG_referenced bit is already overloaded.  We keep
> > > the bit set when we move a page from the active to the
> > > inactive list, so a page that was previously active
> > > only needs to be referenced once to become active again.
> > >
> > > The LRU bits (PG_lru, PG_active, etc) are needed to
> > > figure out which LRU list the page is on.  I don't
> > > think we can overload those...
> >
> > I suspected that was true, but was just brainstorming.
> > Thanks for confirming.
> >
> > Are there any other page bits that are dont-care when
> > a page is on an LRU list?
> 
> How about replacing PG_slab ?
> 
> I think  PageSlab(page) be implemented as
> 
> #define SLABMAGIC		(some value)
> #define PageSlab(page)		(page->mapping == SLABMAGIC)
> 
> or some...

Hi Kame --

Sounds like a great idea!  It looks like the PG_slab bit is part
of the kernel<->user ABI (see fs/proc/page.c: stable_page_flags())
but I think it can be simulated without actually using the physical
bit in struct pageflags.  If so, PG_slab is completely free
to be used/overloaded!

Here's a possible patch... compile/boot tested but nothing else (and
memory-failure.c isn't even compiled and may need more work):

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index dee29fa..ef8498e 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -80,7 +80,7 @@ enum pageflags {
 	PG_dirty,
 	PG_lru,
 	PG_active,
-	PG_slab,
+	PG_slab,		/* for legacy kernel<->user ABI only */
 	PG_owner_priv_1,	/* Owner use. If pagecache, fs may use*/
 	PG_arch_1,
 	PG_reserved,
@@ -206,7 +206,6 @@ PAGEFLAG(Dirty, dirty) TESTSCFLAG(Dirty, dirty) __CLEARPAGEFLAG(Dirty, dirty)
 PAGEFLAG(LRU, lru) __CLEARPAGEFLAG(LRU, lru)
 PAGEFLAG(Active, active) __CLEARPAGEFLAG(Active, active)
 	TESTCLEARFLAG(Active, active)
-__PAGEFLAG(Slab, slab)
 PAGEFLAG(Checked, checked)		/* Used by some filesystems */
 PAGEFLAG(Pinned, pinned) TESTSCFLAG(Pinned, pinned)	/* Xen */
 PAGEFLAG(SavePinned, savepinned);			/* Xen */
@@ -220,6 +219,28 @@ PAGEFLAG(WasActive, was_active)
 #endif
 
 /*
+ * for legacy ABI purposes, PG_slab remains defined but all attempted
+ * uses of the bit are now simulated without using the actual page-flag bit
+ */
+struct address_space;
+#define SLAB_MAGIC ((struct address_space *)0x80758075)
+static inline bool PageSlab(struct page *page)
+{
+	return page->mapping == SLAB_MAGIC;
+}
+
+static inline void __SetPageSlab(struct page *page)
+{
+	page->mapping = SLAB_MAGIC;
+}
+
+static inline void __ClearPageSlab(struct page *page)
+{
+	page->mapping = NULL;
+}
+
+
+/*
  * Private page markings that may be used by the filesystem that owns the page
  * for its own purposes.
  * - PG_private and PG_private_2 cause releasepage() and co to be invoked
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 06d3479..b4dde77 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -742,7 +742,6 @@ static int me_huge_page(struct page *p, unsigned long pfn)
 #define head		(1UL << PG_head)
 #define tail		(1UL << PG_tail)
 #define compound	(1UL << PG_compound)
-#define slab		(1UL << PG_slab)
 #define reserved	(1UL << PG_reserved)
 
 static struct page_state {
@@ -757,13 +756,6 @@ static struct page_state {
 	 * PG_buddy pages only make a small fraction of all free pages.
 	 */
 
-	/*
-	 * Could in theory check if slab page is free or if we can drop
-	 * currently unused objects without touching them. But just
-	 * treat it as standard kernel for now.
-	 */
-	{ slab,		slab,		"kernel slab",	me_kernel },
-
 #ifdef CONFIG_PAGEFLAGS_EXTENDED
 	{ head,		head,		"huge",		me_huge_page },
 	{ tail,		tail,		"huge",		me_huge_page },
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2b8ba3a..48451a5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5787,11 +5787,12 @@ static struct trace_print_flags pageflag_names[] = {
 	{-1UL,				NULL		},
 };
 
-static void dump_page_flags(unsigned long flags)
+static void dump_page_flags(struct page *page)
 {
 	const char *delim = "";
 	unsigned long mask;
 	int i;
+	unsigned long flags = page->flags;
 
 	printk(KERN_ALERT "page flags: %#lx(", flags);
 
@@ -5801,7 +5802,10 @@ static void dump_page_flags(unsigned long flags)
 	for (i = 0; pageflag_names[i].name && flags; i++) {
 
 		mask = pageflag_names[i].mask;
-		if ((flags & mask) != mask)
+		if (mask == PG_slab) {
+			if (!PageSlab(page))
+				continue;
+		} else if ((flags & mask) != mask)
 			continue;
 
 		flags &= ~mask;
@@ -5822,6 +5826,6 @@ void dump_page(struct page *page)
 	       "page:%p count:%d mapcount:%d mapping:%p index:%#lx\n",
 		page, atomic_read(&page->_count), page_mapcount(page),
 		page->mapping, page->index);
-	dump_page_flags(page->flags);
+	dump_page_flags(page);
 	mem_cgroup_print_bad_page(page);
 }
diff --git a/mm/slub.c b/mm/slub.c
index ed3334d..a0fdca1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1361,7 +1361,7 @@ static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 
 	inc_slabs_node(s, page_to_nid(page), page->objects);
 	page->slab = s;
-	page->flags |= 1 << PG_slab;
+	page->mapping = SLAB_MAGIC;
 
 	start = page_address(page);


