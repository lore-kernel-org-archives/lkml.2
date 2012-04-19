Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab2DSMGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 08:06:41 -0400
Received: from smtp.nokia.com ([147.243.1.47]:17726 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab2DSMGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 08:06:39 -0400
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, linus.walleij@linaro.org, artem.bityutskiy@linux.intel.com,
        shubhrajyoti@ti.com
Subject: [PATCH 3/6] HSI: hsi: Remove controllers and ports from the bus
Date: Thu, 19 Apr 2012 15:05:24 +0300
Message-Id: <1334837127-12931-4-git-send-email-carlos.chinea@nokia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1334837127-12931-1-git-send-email-carlos.chinea@nokia.com>
References: <1334837127-12931-1-git-send-email-carlos.chinea@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HSI controllers and ports do not belong to the HSI bus.
Those devices are not supposed to have a driver attached to them.

Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
---
 drivers/hsi/hsi.c |   20 +-------------------
 1 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/drivers/hsi/hsi.c b/drivers/hsi/hsi.c
index 5c76a36..cec1f0c 100644
--- a/drivers/hsi/hsi.c
+++ b/drivers/hsi/hsi.c
@@ -29,18 +29,6 @@
 #include <linux/string.h>
 #include "hsi_core.h"
 
-static struct device_type hsi_ctrl = {
-	.name	= "hsi_controller",
-};
-
-static struct device_type hsi_cl = {
-	.name	= "hsi_client",
-};
-
-static struct device_type hsi_port = {
-	.name	= "hsi_port",
-};
-
 static ssize_t modalias_show(struct device *dev,
 			struct device_attribute *a __maybe_unused, char *buf)
 {
@@ -54,8 +42,7 @@ static struct device_attribute hsi_bus_dev_attrs[] = {
 
 static int hsi_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
-	if (dev->type == &hsi_cl)
-		add_uevent_var(env, "MODALIAS=hsi:%s", dev_name(dev));
+	add_uevent_var(env, "MODALIAS=hsi:%s", dev_name(dev));
 
 	return 0;
 }
@@ -85,7 +72,6 @@ static void hsi_new_client(struct hsi_port *port, struct hsi_board_info *info)
 	cl = kzalloc(sizeof(*cl), GFP_KERNEL);
 	if (!cl)
 		return;
-	cl->device.type = &hsi_cl;
 	cl->tx_cfg = info->tx_cfg;
 	cl->rx_cfg = info->rx_cfg;
 	cl->device.bus = &hsi_bus_type;
@@ -175,15 +161,11 @@ int hsi_register_controller(struct hsi_controller *hsi)
 	unsigned int i;
 	int err;
 
-	hsi->device.type = &hsi_ctrl;
-	hsi->device.bus = &hsi_bus_type;
 	err = device_add(&hsi->device);
 	if (err < 0)
 		return err;
 	for (i = 0; i < hsi->num_ports; i++) {
 		hsi->port[i]->device.parent = &hsi->device;
-		hsi->port[i]->device.bus = &hsi_bus_type;
-		hsi->port[i]->device.type = &hsi_port;
 		err = device_add(&hsi->port[i]->device);
 		if (err < 0)
 			goto out;
-- 
1.7.5.4

