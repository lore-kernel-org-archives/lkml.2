Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab0JVSc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:32:27 -0400
Received: from kroah.org ([198.145.64.141]:37758 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758906Ab0JVSZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:22 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Patrick Pannuto <ppannuto@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/31] driver core: platform: Use drv->driver.bus instead of assuming platform_bus_type
Date: Fri, 22 Oct 2010 11:24:49 -0700
Message-Id: <1287771916-15016-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick Pannuto <ppannuto@codeaurora.org>

In theory (although not *yet* in practice), a driver being passed
to platform_driver_probe might have driver.bus set to something
other than platform_bus_type. Locking drv->driver.bus is always
correct.

Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index c6c933f..579906f 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -488,12 +488,12 @@ int __init_or_module platform_driver_probe(struct platform_driver *drv,
 	 * if the probe was successful, and make sure any forced probes of
 	 * new devices fail.
 	 */
-	spin_lock(&platform_bus_type.p->klist_drivers.k_lock);
+	spin_lock(&drv->driver.bus->p->klist_drivers.k_lock);
 	drv->probe = NULL;
 	if (code == 0 && list_empty(&drv->driver.p->klist_devices.k_list))
 		retval = -ENODEV;
 	drv->driver.probe = platform_drv_probe_fail;
-	spin_unlock(&platform_bus_type.p->klist_drivers.k_lock);
+	spin_unlock(&drv->driver.bus->p->klist_drivers.k_lock);
 
 	if (code != retval)
 		platform_driver_unregister(drv);
-- 
1.7.2

