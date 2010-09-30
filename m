Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab0I3Uzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 16:55:46 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:10820 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754788Ab0I3Uzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:55:44 -0400
From: Daniel Drake <dsd@laptop.org>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Cc: laforge@gnumonks.org
Subject: [PATCH 1/3] MFD: allow for bypass of cell resource conflict check
Message-Id: <20100930205536.4E29E9D401B@zog.reactivated.net>
Date: Thu, 30 Sep 2010 21:55:36 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=3ENABmdyEd/Fm7fR7+mZIuMDn6+IErAeEhlfWBImZFk= c=1 sm=0 a=_JRckMHBnKwA:10 a=Op-mwl0xAAAA:8 a=RjTlBu_mslm3W7mdjkYA:9 a=1uRPCKjqvSW6HJgjwXgA:7 a=hWC3oO3mwqSHEjf--8rMYzdu7SEA:4 a=d4CUUju0HPYA:10 a=ZqE-xyJRjPZ-Y33R:21 a=dNOf9lcGPSViquiT:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The upcoming VIA VX855 MFD driver needs to communicate resources
to subdevices where the resources may be claimed by ACPI.

Add a flag to mfd_cell to request that resources are not policed.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/mfd/mfd-core.c   |    8 +++++---
 include/linux/mfd/core.h |    3 +++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 1823a57..d1c8605 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -65,9 +65,11 @@ static int mfd_add_device(struct device *parent, int id,
 			res[r].end   = cell->resources[r].end;
 		}
 
-		ret = acpi_check_resource_conflict(res);
-		if (ret)
-			goto fail_res;
+		if (!cell->ignore_resource_conflicts) {
+			ret = acpi_check_resource_conflict(res);
+			if (ret)
+				goto fail_res;
+		}
 	}
 
 	ret = platform_device_add_resources(pdev, res, cell->num_resources);
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index 11d740b..cb93d80 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -44,6 +44,9 @@ struct mfd_cell {
 	 */
 	int			num_resources;
 	const struct resource	*resources;
+
+	/* don't check for resource conflicts */
+	bool			ignore_resource_conflicts;
 };
 
 extern int mfd_add_devices(struct device *parent, int id,
-- 
1.7.2.3

