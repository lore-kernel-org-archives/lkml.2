Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844Ab2HPQAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:00:10 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30575 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab2HPQAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:00:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/2] xen/p2m: Fix for 32-bit builds the "Reserve 8MB of _brk space for P2M"
Date: Thu, 16 Aug 2012 11:50:13 -0400
Message-Id: <1345132214-15298-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345132214-15298-1-git-send-email-konrad.wilk@oracle.com>
References: <1345132214-15298-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

We fix that by using the above mentioned math instead of predefined
PMD_SIZE.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/p2m.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index b2e91d4..626c979 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -198,7 +198,8 @@ RESERVE_BRK(p2m_mid_identity, PAGE_SIZE * 2 * 3);
  * max we have is seen is 395979, but that does not mean it can't be more.
  * But some machines can have 3GB I/O holes even. So lets reserve enough
  * for 4GB of I/O and E820 holes. */
-RESERVE_BRK(p2m_populated, PMD_SIZE * 4);
+RESERVE_BRK(p2m_populated, 1048576 * sizeof(unsigned long));
+
 static inline unsigned p2m_top_index(unsigned long pfn)
 {
 	BUG_ON(pfn >= MAX_P2M_PFN);
-- 
1.7.7.6

