Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab1AaXKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:10:25 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:22835 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab1AaXJS (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 31 Jan 2011 18:09:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Xen-devel@lists.xensource.com,
        konrad@kernel.org, jeremy@goop.org
Cc: hpa@zytor.com, stefano.stabellini@eu.citrix.com,
        Ian.Campbell@eu.citrix.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 02/11] xen/mmu: Add the notion of identity (1-1) mapping.
Date: Mon, 31 Jan 2011 17:44:27 -0500
Message-Id: <1296513876-31415-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
References: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D474118.0052:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our P2M tree structure is a three-level. On the leaf nodes
we set the Machine Frame Number (MFN) of the PFN. What this means
is that when one does: pfn_to_mfn(pfn), which is used when creating
PTE entries, you get the real MFN of the hardware. When Xen sets
up a guest it initially populates a array which has descending
(or ascending) MFN values, as so:

 idx: 0,  1,       2
 [0x290F, 0x290E, 0x290D, ..]

so pfn_to_mfn(2)==0x290D. If you start, restart many guests that list
starts looking quite random.

We graft this structure on our P2M tree structure and stick in
those MFN in the leafs. But for all other leaf entries, or for the top
root, or middle one, for which there is a void entry, we assume it is
"missing". So
 pfn_to_mfn(0xc0000)=INVALID_P2M_ENTRY.

We add the possibility of setting 1-1 mappings on certain regions, so
that:
 pfn_to_mfn(0xc0000)=0xc0000

The benefit of this is, that we can assume for non-RAM regions (think
PCI BARs, or ACPI spaces), we can create mappings easily b/c we
get the PFN value to match the MFN.

For this to work efficiently we introduce one new page p2m_identity and
allocate (via reserved_brk) any other pages we need to cover the sides
(1GB or 4MB boundary violations). All entries in p2m_identity are set to
INVALID_P2M_ENTRY type (Xen toolstack only recognizes that and MFNs,
no other fancy value).

On lookup we spot that the entry points to p2m_identity and return the identity
value instead of dereferencing and returning INVALID_P2M_ENTRY. If the entry
points to an allocated page, we just proceed as before and return the PFN.
If the PFN has IDENTITY_FRAME_BIT set we unmask that in appropriate functions
(pfn_to_mfn).

The reason for having the IDENTITY_FRAME_BIT instead of just returning the
PFN is that we could find ourselves where pfn_to_mfn(pfn)==pfn for a
non-identity pfn. To protect ourselves against we elect to set (and get) the
IDENTITY_FRAME_BIT on all identity mapped PFNs.

This simplistic diagram is used to explain the more subtle piece of code.
There is also a digram of the P2M at the end that can help.
Imagine your E820 looking as so:

                   1GB                                           2GB
/-------------------+---------\/----\         /----------\    /---+-----\
| System RAM        | Sys RAM ||ACPI|         | reserved |    | Sys RAM |
\-------------------+---------/\----/         \----------/    \---+-----/
                              ^- 1029MB                       ^- 2001MB

[1029MB = 263424 (0x40500), 2001MB = 512256 (0x7D100), 2048MB = 524288 (0x80000)]

And dom0_mem=max:3GB,1GB is passed in to the guest, meaning memory past 1GB
is actually not present (would have to kick the balloon driver to put it in).

When we are told to set the PFNs for identity mapping (see patch: "xen/setup:
Set identity mapping for non-RAM E820 and E820 gaps.") we pass in the start
of the PFN and the end PFN (263424 and 512256 respectively). The first step is
to reserve_brk a top leaf page if the p2m[1] is missing. The top leaf page
covers 512^2 of page estate (1GB) and in case the start or end PFN is not
aligned on 512^2*PAGE_SIZE (1GB) we loop on aligned 1GB PFNs from start pfn to
end pfn.  We reserve_brk top leaf pages if they are missing (means they point
to p2m_mid_missing).

With the E820 example above, 263424 is not 1GB aligned so we allocate a
reserve_brk page which will cover the PFNs estate from 0x40000 to 0x80000.
Each entry in the allocate page is "missing" (points to p2m_missing).

Next stage is to determine if we need to do a more granular boundary check
on the 4MB (or 2MB depending on architecture) off the start and end pfn's.
We check if the start pfn and end pfn violate that boundary check, and if
so reserve_brk a middle (p2m[x][y]) leaf page. This way we have a much finer
granularity of setting which PFNs are missing and which ones are identity.
In our example 263424 and 512256 both fail the check so we reserve_brk two
pages. Populate them with INVALID_P2M_ENTRY (so they both have "missing" values)
and assign them to p2m[1][2] and p2m[1][488] respectively.

At this point we would at minimum reserve_brk one page, but could be up to
three. Each call to set_phys_range_identity has at maximum a three page
cost. If we were to query the P2M at this stage, all those entries from
start PFN through end PFN (so 1029MB -> 2001MB) would return INVALID_P2M_ENTRY
("missing").

The next step is to walk from the start pfn to the end pfn setting
the IDENTITY_FRAME_BIT on each PFN. This is done in '__set_phys_to_machine'.
If we find that the middle leaf is pointing to p2m_missing we can swap it over
to p2m_identity - this way covering 4MB (or 2MB) PFN space.  At this point we
do not need to worry about boundary aligment (so no need to reserve_brk a middle
page, figure out which PFNs are "missing" and which ones are identity), as that
has been done earlier.  If we find that the middle leaf is not occupied by
p2m_identity or p2m_missing, we dereference that page (which covers
512 PFNs) and set the appropriate PFN with IDENTITY_FRAME_BIT. In our example
263424 and 512256 end up there, and we set from p2m[1][2][256->511] and
p2m[1][488][0->256] with IDENTITY_FRAME_BIT set.

All other regions that are void (or not filled) either point to p2m_missing
(considered missing) or have the default value of INVALID_P2M_ENTRY (also
considered missing). In our case, p2m[1][2][0->255] and p2m[1][488][257->511]
contain the INVALID_P2M_ENTRY value and are considered "missing."

This is what the p2m ends up looking (for the E820 above) with this
fabulous drawing:

   p2m         /--------------\
 /-----\       | &mfn_list[0],|                           /-----------------\
 |  0  |------>| &mfn_list[1],|    /---------------\      | ~0, ~0, ..      |
 |-----|       |  ..., ~0, ~0 |    | ~0, ~0, [x]---+----->| IDENTITY [@256] |
 |  1  |---\   \--------------/    | [p2m_identity]+\     | IDENTITY [@257] |
 |-----|    \                      | [p2m_identity]+\\    | ....            |
 |  2  |--\  \-------------------->|  ...          | \\   \----------------/
 |-----|   \                       \---------------/  \\
 |  3  |\   \                                          \\  p2m_identity
 |-----| \   \-------------------->/---------------\   /-----------------\
 | ..  +->+                        | [p2m_identity]+-->| ~0, ~0, ~0, ... |
 \-----/ /                         | [p2m_identity]+-->| ..., ~0         |
        / /---------------\        | ....          |   \-----------------/
       /  | IDENTITY[@0]  |      /-+-[x], ~0, ~0.. |
      /   | IDENTITY[@256]|<----/  \---------------/
     /    | ~0, ~0, ....  |
    |     \---------------/
    |
    p2m_missing             p2m_missing
/------------------\     /------------\
| [p2m_mid_missing]+---->| ~0, ~0, ~0 |
| [p2m_mid_missing]+---->| ..., ~0    |
\------------------/     \------------/

where ~0 is INVALID_P2M_ENTRY. IDENTITY is (PFN | IDENTITY_BIT)

[v4: Squished patches in just this one]
[v5: Changed code to use ranges, added ASCII art]
[v6: Rebased on top of xen->p2m code split]
[v7: Added RESERVE_BRK for potentially allocated pages]
[v8: Fixed alignment problem]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/xen/page.h |    6 ++-
 arch/x86/xen/p2m.c              |  109 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 112 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 8ea9772..47c1b59 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -30,7 +30,9 @@ typedef struct xpaddr {
 /**** MACHINE <-> PHYSICAL CONVERSION MACROS ****/
 #define INVALID_P2M_ENTRY	(~0UL)
 #define FOREIGN_FRAME_BIT	(1UL<<31)
+#define IDENTITY_FRAME_BIT	(1UL<<30)
 #define FOREIGN_FRAME(m)	((m) | FOREIGN_FRAME_BIT)
+#define IDENTITY_FRAME(m)	((m) | IDENTITY_FRAME_BIT)
 
 /* Maximum amount of memory we can handle in a domain in pages */
 #define MAX_DOMAIN_PAGES						\
@@ -42,6 +44,8 @@ extern unsigned int   machine_to_phys_order;
 extern unsigned long get_phys_to_machine(unsigned long pfn);
 extern bool set_phys_to_machine(unsigned long pfn, unsigned long mfn);
 extern bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn);
+extern unsigned long set_phys_range_identity(unsigned long pfn_s,
+					     unsigned long pfn_e);
 
 extern int m2p_add_override(unsigned long mfn, struct page *page);
 extern int m2p_remove_override(struct page *page);
@@ -58,7 +62,7 @@ static inline unsigned long pfn_to_mfn(unsigned long pfn)
 	mfn = get_phys_to_machine(pfn);
 
 	if (mfn != INVALID_P2M_ENTRY)
-		mfn &= ~FOREIGN_FRAME_BIT;
+		mfn &= ~(FOREIGN_FRAME_BIT | IDENTITY_FRAME_BIT);
 
 	return mfn;
 }
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index df4e367..19b0a65 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -59,9 +59,15 @@ static RESERVE_BRK_ARRAY(unsigned long **, p2m_top, P2M_TOP_PER_PAGE);
 static RESERVE_BRK_ARRAY(unsigned long, p2m_top_mfn, P2M_TOP_PER_PAGE);
 static RESERVE_BRK_ARRAY(unsigned long *, p2m_top_mfn_p, P2M_TOP_PER_PAGE);
 
+static RESERVE_BRK_ARRAY(unsigned long, p2m_identity, P2M_PER_PAGE);
+
 RESERVE_BRK(p2m_mid, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MID_PER_PAGE)));
 RESERVE_BRK(p2m_mid_mfn, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MID_PER_PAGE)));
 
+/* We might hit two boundary violations at the start and end, at max each
+ * boundary violation will require three middle nodes. */
+RESERVE_BRK(p2m_mid_identity, PAGE_SIZE * 2 * 3);
+
 static inline unsigned p2m_top_index(unsigned long pfn)
 {
 	BUG_ON(pfn >= MAX_P2M_PFN);
@@ -221,6 +227,9 @@ void __init xen_build_dynamic_phys_to_machine(void)
 	p2m_top = extend_brk(PAGE_SIZE, PAGE_SIZE);
 	p2m_top_init(p2m_top);
 
+	p2m_identity = extend_brk(PAGE_SIZE, PAGE_SIZE);
+	p2m_init(p2m_identity);
+
 	/*
 	 * The domain builder gives us a pre-constructed p2m array in
 	 * mfn_list for all the pages initially given to us, so we just
@@ -272,6 +281,14 @@ unsigned long get_phys_to_machine(unsigned long pfn)
 	mididx = p2m_mid_index(pfn);
 	idx = p2m_index(pfn);
 
+	/*
+	 * The INVALID_P2M_ENTRY is filled in both p2m_*identity
+	 * and in p2m_*missing, so returning the INVALID_P2M_ENTRY
+	 * would be wrong.
+	 */
+	if (p2m_top[topidx][mididx] == p2m_identity)
+		return IDENTITY_FRAME(pfn);
+
 	return p2m_top[topidx][mididx][idx];
 }
 EXPORT_SYMBOL_GPL(get_phys_to_machine);
@@ -341,9 +358,11 @@ static bool alloc_p2m(unsigned long pfn)
 			p2m_top_mfn_p[topidx] = mid_mfn;
 	}
 
-	if (p2m_top[topidx][mididx] == p2m_missing) {
+	if (p2m_top[topidx][mididx] == p2m_identity ||
+	    p2m_top[topidx][mididx] == p2m_missing) {
 		/* p2m leaf page is missing */
 		unsigned long *p2m;
+		unsigned long *p2m_orig = p2m_top[topidx][mididx];
 
 		p2m = alloc_p2m_page();
 		if (!p2m)
@@ -351,7 +370,7 @@ static bool alloc_p2m(unsigned long pfn)
 
 		p2m_init(p2m);
 
-		if (cmpxchg(&mid[mididx], p2m_missing, p2m) != p2m_missing)
+		if (cmpxchg(&mid[mididx], p2m_orig, p2m) != p2m_orig)
 			free_p2m_page(p2m);
 		else
 			mid_mfn[mididx] = virt_to_mfn(p2m);
@@ -360,6 +379,78 @@ static bool alloc_p2m(unsigned long pfn)
 	return true;
 }
 
+bool __early_alloc_p2m(unsigned long pfn)
+{
+	unsigned topidx, mididx, idx;
+
+	topidx = p2m_top_index(pfn);
+	mididx = p2m_mid_index(pfn);
+	idx = p2m_index(pfn);
+
+	/* Pfff.. No boundary cross-over, lets get out. */
+	if (!idx)
+		return false;
+
+	WARN(p2m_top[topidx][mididx] == p2m_identity,
+		"P2M[%d][%d] == IDENTITY, should be MISSING (or alloced)!\n",
+		topidx, mididx);
+
+	/*
+	 * Could be done by xen_build_dynamic_phys_to_machine..
+	 */
+	if (p2m_top[topidx][mididx] != p2m_missing)
+		return false;
+
+	/* Boundary cross-over for the edges: */
+	if (idx) {
+		unsigned long *p2m = extend_brk(PAGE_SIZE, PAGE_SIZE);
+
+		p2m_init(p2m);
+
+		p2m_top[topidx][mididx] = p2m;
+
+	}
+	return idx != 0;
+}
+unsigned long set_phys_range_identity(unsigned long pfn_s,
+					unsigned long pfn_e)
+{
+	unsigned long pfn;
+
+	if (unlikely(pfn_s >= MAX_P2M_PFN || pfn_e >= MAX_P2M_PFN))
+		return 0;
+
+	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap)))
+		return pfn_e - pfn_s;
+
+	for (pfn = (pfn_s & ~(P2M_MID_PER_PAGE * P2M_PER_PAGE - 1));
+		pfn < ALIGN(pfn_e, (P2M_MID_PER_PAGE * P2M_PER_PAGE));
+		pfn += P2M_MID_PER_PAGE * P2M_PER_PAGE)
+	{
+		unsigned topidx = p2m_top_index(pfn);
+		if (p2m_top[topidx] == p2m_mid_missing) {
+			unsigned long **mid = extend_brk(PAGE_SIZE, PAGE_SIZE);
+
+			p2m_mid_init(mid);
+
+			p2m_top[topidx] = mid;
+		}
+	}
+
+	__early_alloc_p2m(pfn_s);
+	__early_alloc_p2m(pfn_e);
+
+	for (pfn = pfn_s; pfn < pfn_e; pfn++)
+		if (!__set_phys_to_machine(pfn, IDENTITY_FRAME(pfn)))
+			break;
+
+	WARN((pfn - pfn_s) != (pfn_e - pfn_s),
+		"Identity mapping failed. We are %ld short of 1-1 mappings!\n",
+		(pfn_e - pfn_s) - (pfn - pfn_s));
+
+	return pfn - pfn_s;
+}
+
 /* Try to install p2m mapping; fail if intermediate bits missing */
 bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 {
@@ -378,6 +469,20 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 	mididx = p2m_mid_index(pfn);
 	idx = p2m_index(pfn);
 
+	/* For sparse holes were the p2m leaf has real PFN along with
+	 * PCI holes, stick in the PFN as the MFN value.
+	 */
+	if (mfn != INVALID_P2M_ENTRY && (mfn & IDENTITY_FRAME_BIT)) {
+		if (p2m_top[topidx][mididx] == p2m_identity)
+			return true;
+
+		/* Swap over from MISSING to IDENTITY if needed. */
+		if (p2m_top[topidx][mididx] == p2m_missing) {
+			p2m_top[topidx][mididx] = p2m_identity;
+			return true;
+		}
+	}
+
 	if (p2m_top[topidx][mididx] == p2m_missing)
 		return mfn == INVALID_P2M_ENTRY;
 
-- 
1.7.1

