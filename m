Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab0IBHTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 03:19:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58774 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab0IBHTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 03:19:41 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4C7F5032.70108@np.css.fujitsu.com>
Date: Thu, 02 Sep 2010 16:20:18 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: APEI-lenb <lenb@kernel.org>
CC: Huang Ying <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        ACPI <linux-acpi@vger.kernel.org>, LKLM <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] [Patch-next] ACPI, APEI Fix the return value(==NULL)
 of acpi_pre_map().
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_pre_map() is used for remapping the physical address of I/O, so
it should be return NULL or remapped virtual address. The problem is
that when (paddr - pg_off) equals 0, no matter whether I/O remapping is
successful or not, the function returns NULL.

In acpi_pre_map(), after the physical address is remapped successfully,
it will check whether the physical address has been added into acpi_iomaps
list again.
   - If the physical address has been added into acpi_iomaps, the virtual
     address will be saved in vaddr.
   - Otherwise, NULL be saved in vaddr.

So if the physical address is the first time to be remapped, vaddr will be
NULL always.

In many cases, (paddr - pg_off) may not equal 0. So the function could work
well. In our machine, (paddr - pg_off) equals 0, so the return value of
acpi_pre_map() is NULL.

This patch fixed it and I confirmed it on x86_64 next-tree.

v2:
    Modified the unsuitable description of patch.

v3:
    Modified the wrong words in the description of patch.   

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Acked-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/atomicio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/atomicio.c b/drivers/acpi/atomicio.c
index 8f8bd73..1bc2614 100644
--- a/drivers/acpi/atomicio.c
+++ b/drivers/acpi/atomicio.c
@@ -133,7 +133,7 @@ static void __iomem *acpi_pre_map(phys_addr_t paddr,
 
 	spin_lock_irqsave(&acpi_iomaps_lock, flags);
 	vaddr = __acpi_try_ioremap(paddr, size);
-	if (vaddr) {
+	if (unlikely(vaddr)) {
 		spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
 		iounmap(map->vaddr);
 		kfree(map);
@@ -142,7 +142,7 @@ static void __iomem *acpi_pre_map(phys_addr_t paddr,
 	list_add_tail_rcu(&map->list, &acpi_iomaps);
 	spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
 
-	return vaddr + (paddr - pg_off);
+	return map->vaddr + (paddr - pg_off);
 err_unmap:
 	iounmap(vaddr);
 	return NULL;
-- 1.7.1.

