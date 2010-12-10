Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab0LJUpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:45:55 -0500
Received: from mxout1.idt.com ([157.165.5.25]:39667 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757233Ab0LJUpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:45:53 -0500
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Dec 2010 15:45:44 EST
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Thomas Moll <thomas.moll@sysgo.com>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: [PATCH -mm 2/4] RapidIO: Add device object linking into discovery
Date: Fri, 10 Dec 2010 15:38:16 -0500
Message-Id: <1292013498-31406-3-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1292013498-31406-1-git-send-email-alexandre.bounine@idt.com>
References: <1292013498-31406-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add setting links between rio_dev objects into the discovery process.
This needed to report device connections on agent (non-host) processors
that perform RIO discovery. Originally, these links have been introduced
for enumerating host only to support error management.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
---
 drivers/rapidio/rio-scan.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index 45d14cd..e655756 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -947,7 +947,7 @@ static int rio_enum_complete(struct rio_mport *port)
  */
 static int __devinit
 rio_disc_peer(struct rio_net *net, struct rio_mport *port, u16 destid,
-	      u8 hopcount)
+	      u8 hopcount, struct rio_dev *prev, int prev_port)
 {
 	u8 port_num, route_port;
 	struct rio_dev *rdev;
@@ -957,6 +957,9 @@ rio_disc_peer(struct rio_net *net, struct rio_mport *port, u16 destid,
 	if ((rdev = rio_setup_device(net, port, destid, hopcount, 0))) {
 		/* Add device to the global and bus/net specific list. */
 		list_add_tail(&rdev->net_list, &net->devices);
+		rdev->prev = prev;
+		if (prev && rio_is_switch(prev))
+			prev->rswitch->nextdev[prev_port] = rdev;
 	} else
 		return -1;
 
@@ -998,8 +1001,8 @@ rio_disc_peer(struct rio_net *net, struct rio_mport *port, u16 destid,
 				if (ndestid == RIO_ANY_DESTID(port->sys_size))
 					continue;
 				rio_unlock_device(port, destid, hopcount);
-				if (rio_disc_peer
-				    (net, port, ndestid, hopcount + 1) < 0)
+				if (rio_disc_peer(net, port, ndestid,
+					hopcount + 1, rdev, port_num) < 0)
 					return -1;
 			}
 		}
@@ -1291,7 +1294,7 @@ int __devinit rio_disc_mport(struct rio_mport *mport)
 						   mport->host_deviceid);
 
 		if (rio_disc_peer(net, mport, RIO_ANY_DESTID(mport->sys_size),
-					0) < 0) {
+					0, NULL, 0) < 0) {
 			printk(KERN_INFO
 			       "RIO: master port %d device has failed discovery\n",
 			       mport->id);
-- 
1.7.3.1

