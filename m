Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab1IUNGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 09:06:23 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:52164 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab1IUNGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 09:06:22 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: benh@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, nhorman@redhat.com,
        jesse.brandeburg@intel.com, alexander.h.duyck@intel.com,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2] powerpc: reserve iommu page 0
Date: Wed, 21 Sep 2011 10:06:12 -0300
Message-Id: <1316610372-5795-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices have a dma-window that starts at the address 0. This allows
DMA addresses to be mapped to this address and returned to drivers as a
valid DMA address. Some drivers may not behave well in this case, since
the address 0 is considered an error or not allocated.

The solution to avoid this kind of error from happening is reserve the
page addressed as 0 so it cannot be allocated for a DMA mapping.

Ben Herrenschmidt deserves the credit for this patch. He pointed out the
solution and what code would do the job.

v2:
Add a comment in the code.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
---

Resending, since it was recommended to add a comment about this
particular code.

---
 arch/powerpc/kernel/iommu.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 961bb03..8395301 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -501,6 +501,14 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
 	tbl->it_map = page_address(page);
 	memset(tbl->it_map, 0, sz);
 
+	/*
+	 * Reserve page 0 so it will not be used for any mappings.
+	 * This avoids buggy drivers that consider page 0 to be invalid
+	 * to crash the machine or even lose data.
+	*/
+	if (tbl->it_offset == 0)
+		set_bit(0, tbl->it_map);
+		
 	tbl->it_hint = 0;
 	tbl->it_largehint = tbl->it_halfpoint;
 	spin_lock_init(&tbl->it_lock);
-- 
1.7.4.4

