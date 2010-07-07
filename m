Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab0GGNgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:36:24 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43335 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab0GGNgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:36:21 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 7 Jul 2010 15:36:07 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: cdev: fix fw_cdev_event_bus_reset emission after
 local config ROM changes
To: Jay Fenlason <fenlason@redhat.com>
cc: Clemens Ladisch <clemens@ladisch.de>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <4C347D4A.9000309@s5r6.in-berlin.de>
Message-ID: <tkrat.46dd12a3a66c6dd7@s5r6.in-berlin.de>
References: <20100511154924.GA11700@redhat.com> <4BEA56D2.8030902@ladisch.de>
 <4BEA5B50.6090701@s5r6.in-berlin.de> <4C347B28.4040204@s5r6.in-berlin.de>
 <4C347D4A.9000309@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a descriptor was added or removed to the local node's config ROM,
userspace clients which had a local node's /dev/fw* open did not receive
any fw_cdev_event_bus_reset for poll()/read() consumption.

The cause was that the core-device.c facility which re-reads the config
ROM of the bus reset initiator node missed to call the fw_device update
function.  The fw_units are destroyed and newly added, but their parent
stays and needs to be updated.

Reported-by: Jay Fenlason <fenlason@redhat.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-device.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/firewire/core-device.c
===================================================================
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -1136,6 +1136,7 @@ static void fw_device_refresh(struct wor
 		goto give_up;
 	}
 
+	fw_device_cdev_update(device);
 	create_units(device);
 
 	/* Userspace may want to re-read attributes. */

-- 
Stefan Richter
-=====-==-=- -=== --===
http://arcgraph.de/sr/

