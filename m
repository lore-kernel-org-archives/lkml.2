Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab0I2LzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 07:55:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:51878 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980Ab0I2LyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 07:54:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,252,1283756400"; 
   d="scan'208";a="559002001"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v2 2/5] ACPI, APEI, Fix acpi_pre_map() return value
Date: Wed, 29 Sep 2010 19:53:52 +0800
Message-Id: <1285761235-4751-3-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285761235-4751-1-git-send-email-ying.huang@intel.com>
References: <1285761235-4751-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jin Dongming <jin.dongming@np.css.fujitsu.com>

After we ioremap() a new region, we call __acpi_try_ioremap() to
see whether another thread has already mapped the same region.
This check clobbers "vaddr",  so compute the return value of
acpi_pre_map() using the ioremap() result "map->vaddr" instead.

v2:
    Modified the unsuitable description of patch.

v3:
    Removed unlikely() check and made description simpler.

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/atomicio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/atomicio.c
+++ b/drivers/acpi/atomicio.c
@@ -142,7 +142,7 @@ static void __iomem *acpi_pre_map(phys_a
 	list_add_tail_rcu(&map->list, &acpi_iomaps);
 	spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
 
-	return vaddr + (paddr - pg_off);
+	return map->vaddr + (paddr - map->paddr);
 err_unmap:
 	iounmap(vaddr);
 	return NULL;
