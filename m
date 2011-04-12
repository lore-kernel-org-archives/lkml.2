Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232Ab1DLRFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:05:46 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:54927 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758094Ab1DLRFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:05:44 -0400
Date: Tue, 12 Apr 2011 19:05:37 +0200 (CEST)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@c4eb
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] driver-core: fix race between device_register and
 driver_register
In-Reply-To: <20110412160220.GA28483@suse.de>
Message-ID: <alpine.LFD.2.02.1104121903170.2025@c4eb>
References: <alpine.LFD.2.02.1104111556280.1938@c4eb> <20110411141309.GA8924@suse.de> <alpine.LFD.2.02.1104111622490.1938@c4eb> <20110411144956.GA16610@suse.de> <alpine.LFD.2.02.1104111658560.1770@c4eb> <20110411151947.GA17913@suse.de>
 <alpine.LFD.2.02.1104111943590.2036@c4eb> <20110411175628.GA24301@suse.de> <alpine.LFD.2.02.1104121637450.2239@c4eb> <20110412160220.GA28483@suse.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Organization: "IBM Deutschland Research & Development GmbH Vorsitzender des Aufsichtsrats: Martin Jetter Geschaeftsfuehrung: Dirk Wittkopp Sitz der Gesellschaft: Boeblingen Registergericht: Amtsgericht Stuttgart, HRB 243294"
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When a device is registered to a bus it will be a) added to the list
of devices of the bus and b) bind to a driver (if one matches). As a
result of a driver being registered at this bus between a) and b) this
device could already be bound to a driver. This leads to a warning
and incorrect refcounting.
To fix this add a check to device_attach to identify an already bound
device.

Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
---
 drivers/base/dd.c |    5 +++++
 1 file changed, 5 insertions(+)

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
