Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934625Ab1ETALg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:11:36 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46498 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756521Ab1ETALd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:33 -0400
X-Sasl-enc: tTwI/icmMzBtMbGFmR9GJyHUVYTLqm++Pjosa1vYpsvp 1305850292
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/44] driver-core: fix race between device_register and driver_register
Date: Thu, 19 May 2011 17:10:34 -0700
Message-Id: <1305850262-9575-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Ott <sebott@linux.vnet.ibm.com>

When a device is registered to a bus it will be a) added to the list
of devices of the bus and b) bind to a driver (if one matches). As a
result of a driver being registered at this bus between a) and b) this
device could already be bound to a driver. This leads to a warning
and incorrect refcounting.
To fix this add a check to device_attach to identify an already bound
device.

Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/dd.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index da57ee9..7e9219b 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -245,6 +245,10 @@ int device_attach(struct device *dev)
 
 	device_lock(dev);
 	if (dev->driver) {
+		if (klist_node_attached(&dev->p->knode_driver)) {
+			ret = 1;
+			goto out_unlock;
+		}
 		ret = device_bind_driver(dev);
 		if (ret == 0)
 			ret = 1;
@@ -257,6 +261,7 @@ int device_attach(struct device *dev)
 		ret = bus_for_each_drv(dev->bus, NULL, dev, __device_attach);
 		pm_runtime_put_sync(dev);
 	}
+out_unlock:
 	device_unlock(dev);
 	return ret;
 }
-- 
1.7.4.2

