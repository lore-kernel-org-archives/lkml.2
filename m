Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab1BVWeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:34:22 -0500
Received: from kroah.org ([198.145.64.141]:46648 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014Ab1BVWV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:38 2011
Message-Id: <20110222221838.863586483@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:16:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stefan Bader <stefan.bader@canonical.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [18/70] xen: p2m: correctly initialize partial p2m leaf
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Bader <stefan.bader@canonical.com>

commit 8e1b4cf2108488ccfb9a3e7ed7cd85a435e01d4b upstream.

After changing the p2m mapping to a tree by

  commit 58e05027b530ff081ecea68e38de8d59db8f87e0
    xen: convert p2m to a 3 level tree

and trying to boot a DomU with 615MB of memory, the following crash was
observed in the dump:

kernel direct mapping tables up to 26f00000 @ 1ec4000-1fff000
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<c0107397>] xen_set_pte+0x27/0x60
*pdpt = 0000000000000000 *pde = 0000000000000000

Adding further debug statements showed that when trying to set up
pfn=0x26700 the returned mapping was invalid.

pfn=0x266ff calling set_pte(0xc1fe77f8, 0x6b3003)
pfn=0x26700 calling set_pte(0xc1fe7800, 0x3)

Although the last_pfn obtained from the startup info is 0x26700, which
should in turn not be hit, the additional 8MB which are added as extra
memory normally seem to be ok. This lead to looking into the initial
p2m tree construction, which uses the smaller value and assuming that
there is other code handling the extra memory.

When the p2m tree is set up, the leaves are directly pointed to the
array which the domain builder set up. But if the mapping is not on a
boundary that fits into one p2m page, this will result in the last leaf
being only partially valid. And as the invalid entries are not
initialized in that case, things go badly wrong.

I am trying to fix that by checking whether the current leaf is a
complete map and if not, allocate a completely new page and copy only
the valid pointers there. This may not be the most efficient or elegant
solution, but at least it seems to allow me booting DomUs with memory
assignments all over the range.

BugLink: http://bugs.launchpad.net/bugs/686692
[v2: Redid a bit of commit wording and fixed a compile warning]

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/mmu.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -395,7 +395,25 @@ void __init xen_build_dynamic_phys_to_ma
 			p2m_top[topidx] = mid;
 		}
 
-		p2m_top[topidx][mididx] = &mfn_list[pfn];
+		/*
+		 * As long as the mfn_list has enough entries to completely
+		 * fill a p2m page, pointing into the array is ok. But if
+		 * not the entries beyond the last pfn will be undefined.
+		 * And guessing that the 'what-ever-there-is' does not take it
+		 * too kindly when changing it to invalid markers, a new page
+		 * is allocated, initialized and filled with the valid part.
+		 */
+		if (unlikely(pfn + P2M_PER_PAGE > max_pfn)) {
+			unsigned long p2midx;
+			unsigned long *p2m = extend_brk(PAGE_SIZE, PAGE_SIZE);
+			p2m_init(p2m);
+
+			for (p2midx = 0; pfn + p2midx < max_pfn; p2midx++) {
+				p2m[p2midx] = mfn_list[pfn + p2midx];
+			}
+			p2m_top[topidx][mididx] = p2m;
+		} else
+			p2m_top[topidx][mididx] = &mfn_list[pfn];
 	}
 }
 


