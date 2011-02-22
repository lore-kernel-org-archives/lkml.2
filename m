Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab1BVWVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:21:38 -0500
Received: from kroah.org ([198.145.64.141]:46650 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140Ab1BVWV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:28 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:39 2011
Message-Id: <20110222221838.961427663@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:16:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefan Bader <stefan.bader@canonical.com>
Subject: [19/70] xen/p2m: Mark INVALID_P2M_ENTRY the mfn_list past max_pfn.
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Bader <stefan.bader@canonical.com>

commit cf04d120d9413de581437cf9a29f138ec1178f65 upstream.

In case the mfn_list does not have enough entries to fill
a p2m page we do not want the entries from max_pfn up to
the boundary to be filled with unknown values. Hence
set them to INVALID_P2M_ENTRY.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/mmu.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -399,21 +399,15 @@ void __init xen_build_dynamic_phys_to_ma
 		 * As long as the mfn_list has enough entries to completely
 		 * fill a p2m page, pointing into the array is ok. But if
 		 * not the entries beyond the last pfn will be undefined.
-		 * And guessing that the 'what-ever-there-is' does not take it
-		 * too kindly when changing it to invalid markers, a new page
-		 * is allocated, initialized and filled with the valid part.
 		 */
 		if (unlikely(pfn + P2M_PER_PAGE > max_pfn)) {
 			unsigned long p2midx;
-			unsigned long *p2m = extend_brk(PAGE_SIZE, PAGE_SIZE);
-			p2m_init(p2m);
 
-			for (p2midx = 0; pfn + p2midx < max_pfn; p2midx++) {
-				p2m[p2midx] = mfn_list[pfn + p2midx];
-			}
-			p2m_top[topidx][mididx] = p2m;
-		} else
-			p2m_top[topidx][mididx] = &mfn_list[pfn];
+			p2midx = max_pfn % P2M_PER_PAGE;
+			for ( ; p2midx < P2M_PER_PAGE; p2midx++)
+				mfn_list[pfn + p2midx] = INVALID_P2M_ENTRY;
+		}
+		p2m_top[topidx][mididx] = &mfn_list[pfn];
 	}
 }
 


