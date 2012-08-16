Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab2HPRmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 13:42:08 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36272 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544Ab2HPRmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 13:42:06 -0400
Date: Thu, 16 Aug 2012 13:32:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] [PATCH 1/2] xen/p2m: Fix for 32-bit builds the
 "Reserve 8MB of _brk space for P2M"
Message-ID: <20120816173215.GB9790@phenom.dumpdata.com>
References: <1345132214-15298-1-git-send-email-konrad.wilk@oracle.com>
 <1345132214-15298-2-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345132214-15298-2-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 11:50:13AM -0400, Konrad Rzeszutek Wilk wrote:
> The git commit 5bc6f9888db5739abfa0cae279b4b442e4db8049
> xen/p2m: Reserve 8MB of _brk space for P2M leafs when populating back.
> 
> extended the _brk space to fit 1048576 PFNs. The math is that each
> P2M leaf can cover PAGE_SIZE/sizeof(unsigned long) PFNs. In 64-bit
> that means 512 PFNs, on 32-bit that is 1024. If on 64-bit machines
> we want to cover 4GB of PFNs, that means having enough for space
> to fit 1048576 unsigned longs.

Scratch that patch. This is better, but even with that I am still
hitting some weird 32-bit cases.

 
>From 5502d44e8c7293f6d81a7fdabe25e49845c25cf8 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Thu, 16 Aug 2012 10:57:09 -0400
Subject: [PATCH] xen/p2m: Fix for 32-bit builds the "Reserve 8MB of _brk
 space for P2M"

The git commit 5bc6f9888db5739abfa0cae279b4b442e4db8049
xen/p2m: Reserve 8MB of _brk space for P2M leafs when populating back.

extended the _brk space to fit 1048576 PFNs. The math is that each
P2M leaf can cover PAGE_SIZE/sizeof(unsigned long) PFNs. In 64-bit
that means 512 PFNs, on 32-bit that is 1024. If on 64-bit machines
we want to cover 4GB of PFNs, that means having enough for space
to fit 1048576 unsigned longs.

On 64-bit:
1048576 * sizeof(unsigned long) (8) bytes = 8MB

On 32-bit:
1048576 * sizeof(unsigned long) (4) bytes = 4MB

.. But if you look in the comment it says 3GB not 4GB, so
lets also fix that and reserve enough space for 3GB of PFNs.

We fix that by using the above mentioned math instead of predefined
PMD_SIZE.

CC: stable@vger.kernel.org #only for 3.5
[v2: 4GB/3GB]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/p2m.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index b2e91d4..29244d0 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -196,9 +196,9 @@ RESERVE_BRK(p2m_mid_identity, PAGE_SIZE * 2 * 3);
 
 /* When we populate back during bootup, the amount of pages can vary. The
  * max we have is seen is 395979, but that does not mean it can't be more.
- * But some machines can have 3GB I/O holes even. So lets reserve enough
- * for 4GB of I/O and E820 holes. */
-RESERVE_BRK(p2m_populated, PMD_SIZE * 4);
+ * Some machines can have 3GB I/O holes so lets reserve for that. */
+RESERVE_BRK(p2m_populated, 786432 * sizeof(unsigned long));
+
 static inline unsigned p2m_top_index(unsigned long pfn)
 {
 	BUG_ON(pfn >= MAX_P2M_PFN);
-- 
1.7.7.6

