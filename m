Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169Ab2KGFa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 00:30:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab2KGFa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 00:30:58 -0500
From: Dave Airlie <airlied@redhat.com>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        Huang Ying <ying.huang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH] pci/runtime-pm: respect devices autosuspend timeout on config access
Date: Wed,  7 Nov 2012 15:30:09 +1000
Message-Id: <1352266209-29796-1-git-send-email-airlied@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I've been adding runtime pm to nouveau/radeon, and on X start it does a
lot of pci accesses. Now because the pm on these devices is equivalent
to D3cold, we have to resume them which involves a heavy latency due to
POSTing the cards. The driver configures the autosuspend timeout to 5s for
this reason, and I think the PCI layer config accesses should respect
the autosuspend.

Cc: Huang Ying <ying.huang@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/pci/pci-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 02d107b..12d3d52 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -487,7 +487,7 @@ pci_config_pm_runtime_put(struct pci_dev *pdev)
 	struct device *dev = &pdev->dev;
 	struct device *parent = dev->parent;
 
-	pm_runtime_put(dev);
+	pm_runtime_put_autosuspend(dev);
 	if (parent)
 		pm_runtime_put_sync(parent);
 }
-- 
1.7.12.1

