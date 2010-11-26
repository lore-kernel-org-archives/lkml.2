Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab0KZRTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:19:47 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45525 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751531Ab0KZRTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:19:46 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] mfd: Provide pm_runtime_no_callbacks flag in cell data
Date: Fri, 26 Nov 2010 17:19:34 +0000
Message-Id: <1290791975-21160-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow MFD cells to have pm_runtime_no_callbacks() called on them during
registration. This causes the runtime PM framework to ignore them,
allowing use of runtime PM to suspend the device as a whole even if
not all drivers for the MFD can usefully implement runtime PM. For
example, RTCs are likely to run continuously regardless of the power
state of the system.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/mfd-core.c   |    4 ++++
 include/linux/mfd/core.h |    6 ++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index ec99f68..d83ad0f 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -15,6 +15,7 @@
 #include <linux/platform_device.h>
 #include <linux/acpi.h>
 #include <linux/mfd/core.h>
+#include <linux/pm_runtime.h>
 #include <linux/slab.h>
 
 static int mfd_add_device(struct device *parent, int id,
@@ -82,6 +83,9 @@ static int mfd_add_device(struct device *parent, int id,
 	if (ret)
 		goto fail_res;
 
+	if (cell->pm_runtime_no_callbacks)
+		pm_runtime_no_callbacks(&pdev->dev);
+
 	kfree(res);
 
 	return 0;
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index 5582ab3..835996e 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -47,6 +47,12 @@ struct mfd_cell {
 
 	/* don't check for resource conflicts */
 	bool			ignore_resource_conflicts;
+
+	/*
+	 * Disable runtime PM callbacks for this subdevice - see
+	 * pm_runtime_no_callbacks().
+	 */
+	bool			pm_runtime_no_callbacks;
 };
 
 extern int mfd_add_devices(struct device *parent, int id,
-- 
1.7.1

