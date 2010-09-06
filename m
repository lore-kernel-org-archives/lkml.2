Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab0IFBK0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 21:10:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36270 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab0IFBKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 21:10:24 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4C843F97.70608@np.css.fujitsu.com>
Date: Mon, 06 Sep 2010 10:10:47 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>, APEI-lenb <lenb@kernel.org>
CC: Huang Ying <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        ACPI <linux-acpi@vger.kernel.org>, LKLM <linux-kernel@vger.kernel.org>
Subject: [Patch-next] ACPI, APEI: fix acpi_pre_map() return value.
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After we ioremap() a new region, we call __acpi_try_ioremap() to
see whether another thread has already mapped the same region.
This check clobbers "vaddr",  so compute the return value of
acpi_pre_map() using the ioremap() result "map->vaddr" instead.

v2:
    Modified the unsuitable description of patch.

v3:
    Removed unlikely() check and made description simpler.

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Acked-by: Huang Ying <ying.huang@intel.com>

---
 drivers/acpi/atomicio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/atomicio.c b/drivers/acpi/atomicio.c
index 8f8bd73..542e539 100644
--- a/drivers/acpi/atomicio.c
+++ b/drivers/acpi/atomicio.c
@@ -142,7 +142,7 @@ static void __iomem *acpi_pre_map(phys_addr_t paddr,
 	list_add_tail_rcu(&map->list, &acpi_iomaps);
 	spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
 
-	return vaddr + (paddr - pg_off);
+	return map->vaddr + (paddr - map->paddr);
 err_unmap:
 	iounmap(vaddr);
 	return NULL;
-- 
1.7.1.1

