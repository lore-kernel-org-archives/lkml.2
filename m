Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab1BPIl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:41:26 -0500
Received: from adelie.canonical.com ([91.189.90.139]:49413 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742Ab1BPIlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:41:22 -0500
Message-ID: <4D5B8DAE.5000105@canonical.com>
Date: Wed, 16 Feb 2011 09:41:18 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [stable] [000/272] 2.6.37.1-stable review
References: <20110216001559.GA31413@kroah.com>
In-Reply-To: <20110216001559.GA31413@kroah.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/mixed;
 boundary="------------080906070006080402050300"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080906070006080402050300
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I had been submitted the following two backports for 2.6.37.y (only for that)
but do not see them in the current batch. I know 270+ is already big and they
may come later. Just wanted to ensure they have not fallen through the cracks.

-Stefan

>From f1bd6699f775b43bf0ba384dd50a5a8865e1dbd5 Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Thu, 20 Jan 2011 11:37:43 +0100
Subject: [PATCH 1/2] xen: mmu: correctly initialize partial p2m leaf

commit 8e1b4cf2108488ccfb9a3e7ed7cd85a435e01d4b upstream

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

[backported to 2.6.37]
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 arch/x86/xen/mmu.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 44924e5..468c9e2 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -395,7 +395,25 @@ void __init xen_build_dynamic_phys_to_machine(void)
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

-- 
1.7.0.4

>From c94d1a58392615ce4bf914ba79c1437117d3df57 Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Thu, 27 Jan 2011 10:03:14 -0500
Subject: [PATCH 2/2] xen/p2m: Mark INVALID_P2M_ENTRY the mfn_list past max_pfn.

commit cf04d120d9413de581437cf9a29f138ec1178f65 upstream

In case the mfn_list does not have enough entries to fill
a p2m page we do not want the entries from max_pfn up to
the boundary to be filled with unknown values. Hence
set them to INVALID_P2M_ENTRY.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

[backported to 2.6.37]
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 arch/x86/xen/mmu.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 468c9e2..198df8d 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -399,21 +399,15 @@ void __init xen_build_dynamic_phys_to_machine(void)
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

-- 
1.7.0.4



--------------080906070006080402050300
Content-Type: text/x-diff;
 name="0001-xen-mmu-correctly-initialize-partial-p2m-leaf.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-xen-mmu-correctly-initialize-partial-p2m-leaf.patch"

>From f1bd6699f775b43bf0ba384dd50a5a8865e1dbd5 Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Thu, 20 Jan 2011 11:37:43 +0100
Subject: [PATCH 1/2] xen: mmu: correctly initialize partial p2m leaf

commit 8e1b4cf2108488ccfb9a3e7ed7cd85a435e01d4b upstream

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

[backported to 2.6.37]
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 arch/x86/xen/mmu.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 44924e5..468c9e2 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -395,7 +395,25 @@ void __init xen_build_dynamic_phys_to_machine(void)
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
 
-- 
1.7.0.4


--------------080906070006080402050300
Content-Type: text/x-diff;
 name="0002-xen-p2m-Mark-INVALID_P2M_ENTRY-the-mfn_list-past-max.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-xen-p2m-Mark-INVALID_P2M_ENTRY-the-mfn_list-past-max.pa";
 filename*1="tch"

>From c94d1a58392615ce4bf914ba79c1437117d3df57 Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Thu, 27 Jan 2011 10:03:14 -0500
Subject: [PATCH 2/2] xen/p2m: Mark INVALID_P2M_ENTRY the mfn_list past max_pfn.

commit cf04d120d9413de581437cf9a29f138ec1178f65 upstream

In case the mfn_list does not have enough entries to fill
a p2m page we do not want the entries from max_pfn up to
the boundary to be filled with unknown values. Hence
set them to INVALID_P2M_ENTRY.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

[backported to 2.6.37]
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 arch/x86/xen/mmu.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 468c9e2..198df8d 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -399,21 +399,15 @@ void __init xen_build_dynamic_phys_to_machine(void)
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
 
-- 
1.7.0.4


--------------080906070006080402050300--
