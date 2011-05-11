Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395Ab1EKWZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 18:25:23 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:55620 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245Ab1EKWZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 18:25:15 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Milton Miller <miltonm@bga.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Will Schmidt <will_schmidt@vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] pseries/iommu: remove ddw property when destroying window
Date: Wed, 11 May 2011 15:24:58 -0700
Message-Id: <1305152704-4864-3-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305152704-4864-1-git-send-email-nacc@us.ibm.com>
References: <1305152704-4864-1-git-send-email-nacc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milton Miller <miltonm@bga.com>

If we destroy the window, we need to remove the property recording that
we setup the window.  Otherwise the next kernel we kexec will be
confused.

Also we should remove the property if even if we don't find the
ibm,ddw-applicable window or if one of the property sizes is unexpected;
presumably these came from a prior kernel via kexec, and we will not be
maintaining the window with respect to memory hotplug.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
---
 arch/powerpc/platforms/pseries/iommu.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 05c101e..a0421ac 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -665,9 +665,12 @@ static void remove_ddw(struct device_node *np)
 
 	ddr_avail = of_get_property(np, "ibm,ddw-applicable", &len);
 	win64 = of_find_property(np, DIRECT64_PROPNAME, NULL);
-	if (!win64 || !ddr_avail || len < 3 * sizeof(u32))
+	if (!win64)
 		return;
 
+	if (!ddr_avail || len < 3 * sizeof(u32) || win64->length < sizeof(*dwp))
+		goto delprop;
+
 	dwp = win64->value;
 	liobn = (u64)be32_to_cpu(dwp->liobn);
 
@@ -690,8 +693,13 @@ static void remove_ddw(struct device_node *np)
 		pr_debug("%s: successfully removed direct window: rtas returned "
 			"%d to ibm,remove-pe-dma-window(%x) %llx\n",
 			np->full_name, ret, ddr_avail[2], liobn);
-}
 
+delprop:
+	ret = of_remove_property(np, win64);
+	if (ret)
+		pr_warning("%s: failed to remove direct window property: %d\n"
+			np->full_name, ret);
+}
 
 static u64 dupe_ddw_if_already_created(struct pci_dev *dev, struct device_node *pdn)
 {
-- 
1.7.4.1

