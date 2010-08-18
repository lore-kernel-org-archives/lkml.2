Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab0HRTPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 15:15:53 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60579 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab0HRTPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 15:15:49 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6078"; a="51462463"
From: Patrick Pannuto <ppannuto@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: ppannuto@codeaurora.org, linux-arm-msm@vger.kernel.org,
        magnus.damm@gmail.com, grant.likely@secretlab.ca, gregkh@suse.de,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <damm@opensource.se>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 1/4] platform: Use drv->driver.bus instead of assuming platform_bus_type
Date: Wed, 18 Aug 2010 12:15:40 -0700
Message-Id: <1282158943-11902-2-git-send-email-ppannuto@codeaurora.org>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1282158943-11902-1-git-send-email-ppannuto@codeaurora.org>
References: <1282158943-11902-1-git-send-email-ppannuto@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In theory (although not *yet* in practice), a driver being passed
to platform_driver_probe might have driver.bus set to something
other than platform_bus_type. Locking drv->driver.bus is always
correct.

Change-Id: Ib015c35237eb5493d17a812576a3a9906e1344d4
Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
---
 drivers/base/platform.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 4d99c8b..b69ccb4 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -539,12 +539,12 @@ int __init_or_module platform_driver_probe(struct platform_driver *drv,
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
1.7.2.1

