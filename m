Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab0INPCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 11:02:44 -0400
Received: from mxout1.idt.com ([157.165.5.25]:56574 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356Ab0INPCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 11:02:41 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Thomas Moll <thomas.moll@sysgo.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: [PATCH v2 04/10] RapidIO: Add relation links between RIO device structures
Date: Tue, 14 Sep 2010 10:59:17 -0400
Message-Id: <1284476363-1677-5-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com>
References: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create back and forward links between RIO devices. These links are intended for
use by error management and hot-plug extensions. Links for redundant RIO
connections between switches are not set (will be fixed in a separate patch).

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Micha Nelissen <micha@neli.hopto.org>
---
 drivers/rapidio/rio-scan.c |   56 ++++++++++++++++++--------------------------
 include/linux/rio.h        |    4 +++
 2 files changed, 27 insertions(+), 33 deletions(-)

diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index d09c359..d2ea018 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -444,7 +444,10 @@ static struct rio_dev __devinit *rio_setup_device(struct rio_net *net,
 
 	/* If a PE has both switch and other functions, show it as a switch */
 	if (rio_is_switch(rdev)) {
-		rswitch = kzalloc(sizeof(struct rio_switch), GFP_KERNEL);
+		rswitch = kzalloc(sizeof(*rswitch) +
+				  RIO_GET_TOTAL_PORTS(rdev->swpinfo) *
+				  sizeof(rswitch->nextdev[0]),
+				  GFP_KERNEL);
 		if (!rswitch)
 			goto cleanup;
 		rswitch->switchid = next_switchid;
@@ -723,25 +726,6 @@ static u16 rio_get_host_deviceid_lock(struct rio_mport *port, u8 hopcount)
 }
 
 /**
- * rio_get_swpinfo_tports- Gets total number of ports on the switch
- * @mport: Master port to send transaction
- * @destid: Destination ID associated with the switch
- * @hopcount: Number of hops to the device
- *
- * Returns total numbers of ports implemented by the switch device.
- */
-static u8 rio_get_swpinfo_tports(struct rio_mport *mport, u16 destid,
-				 u8 hopcount)
-{
-	u32 result;
-
-	rio_mport_read_config_32(mport, destid, hopcount, RIO_SWP_INFO_CAR,
-				 &result);
-
-	return RIO_GET_TOTAL_PORTS(result);
-}
-
-/**
  * rio_net_add_mport- Add a master port to a RIO network
  * @net: RIO network
  * @port: Master port to add
@@ -761,15 +745,16 @@ static void rio_net_add_mport(struct rio_net *net, struct rio_mport *port)
  * @net: RIO network being enumerated
  * @port: Master port to send transactions
  * @hopcount: Number of hops into the network
+ * @prev: Previous RIO device connected to the enumerated one
+ * @prev_port: Port on previous RIO device
  *
  * Recursively enumerates a RIO network.  Transactions are sent via the
  * master port passed in @port.
  */
 static int __devinit rio_enum_peer(struct rio_net *net, struct rio_mport *port,
-			 u8 hopcount)
+			 u8 hopcount, struct rio_dev *prev, int prev_port)
 {
 	int port_num;
-	int num_ports;
 	int cur_destid;
 	int sw_destid;
 	int sw_inport;
@@ -814,6 +799,9 @@ static int __devinit rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 	if (rdev) {
 		/* Add device to the global and bus/net specific list. */
 		list_add_tail(&rdev->net_list, &net->devices);
+		rdev->prev = prev;
+		if (prev && rio_is_switch(prev))
+			prev->rswitch->nextdev[prev_port] = rdev;
 	} else
 		return -1;
 
@@ -832,14 +820,14 @@ static int __devinit rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 			rdev->rswitch->route_table[destid] = sw_inport;
 		}
 
-		num_ports =
-		    rio_get_swpinfo_tports(port, RIO_ANY_DESTID(port->sys_size),
-						hopcount);
 		pr_debug(
 		    "RIO: found %s (vid %4.4x did %4.4x) with %d ports\n",
-		    rio_name(rdev), rdev->vid, rdev->did, num_ports);
+		    rio_name(rdev), rdev->vid, rdev->did,
+		    RIO_GET_TOTAL_PORTS(rdev->swpinfo));
 		sw_destid = next_destid;
-		for (port_num = 0; port_num < num_ports; port_num++) {
+		for (port_num = 0;
+		     port_num < RIO_GET_TOTAL_PORTS(rdev->swpinfo);
+		     port_num++) {
 			/*Enable Input Output Port (transmitter reviever)*/
 			rio_enable_rx_tx_port(port, 0,
 					      RIO_ANY_DESTID(port->sys_size),
@@ -864,7 +852,8 @@ static int __devinit rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 						RIO_ANY_DESTID(port->sys_size),
 						port_num, 0);
 
-				if (rio_enum_peer(net, port, hopcount + 1) < 0)
+				if (rio_enum_peer(net, port, hopcount + 1,
+						  rdev, port_num) < 0)
 					return -1;
 
 				/* Update routing tables */
@@ -951,7 +940,6 @@ rio_disc_peer(struct rio_net *net, struct rio_mport *port, u16 destid,
 	      u8 hopcount)
 {
 	u8 port_num, route_port;
-	int num_ports;
 	struct rio_dev *rdev;
 	u16 ndestid;
 
@@ -968,11 +956,13 @@ rio_disc_peer(struct rio_net *net, struct rio_mport *port, u16 destid,
 		/* Associated destid is how we accessed this switch */
 		rdev->rswitch->destid = destid;
 
-		num_ports = rio_get_swpinfo_tports(port, destid, hopcount);
 		pr_debug(
 		    "RIO: found %s (vid %4.4x did %4.4x) with %d ports\n",
-		    rio_name(rdev), rdev->vid, rdev->did, num_ports);
-		for (port_num = 0; port_num < num_ports; port_num++) {
+		    rio_name(rdev), rdev->vid, rdev->did,
+		    RIO_GET_TOTAL_PORTS(rdev->swpinfo));
+		for (port_num = 0;
+		     port_num < RIO_GET_TOTAL_PORTS(rdev->swpinfo);
+		     port_num++) {
 			if (RIO_GET_PORT_NUM(rdev->swpinfo) == port_num)
 				continue;
 
@@ -1167,7 +1157,7 @@ int __devinit rio_enum_mport(struct rio_mport *mport)
 		/* Enable Input Output Port (transmitter reviever) */
 		rio_enable_rx_tx_port(mport, 1, 0, 0, 0);
 
-		if (rio_enum_peer(net, mport, 0) < 0) {
+		if (rio_enum_peer(net, mport, 0, NULL, 0) < 0) {
 			/* A higher priority host won enumeration, bail. */
 			printk(KERN_INFO
 			       "RIO: master port %d device has lost enumeration to a remote host\n",
diff --git a/include/linux/rio.h b/include/linux/rio.h
index ffdfe5a..8d9e66d 100644
--- a/include/linux/rio.h
+++ b/include/linux/rio.h
@@ -99,6 +99,7 @@ union rio_pw_msg;
  * @riores: RIO resources this device owns
  * @pwcback: port-write callback function for this device
  * @destid: Network destination ID
+ * @prev: Previous RIO device connected to the current one
  */
 struct rio_dev {
 	struct list_head global_list;	/* node in list of all RIO devices */
@@ -125,6 +126,7 @@ struct rio_dev {
 	struct resource riores[RIO_MAX_DEV_RESOURCES];
 	int (*pwcback) (struct rio_dev *rdev, union rio_pw_msg *msg, int step);
 	u16 destid;
+	struct rio_dev *prev;
 };
 
 #define rio_dev_g(n) list_entry(n, struct rio_dev, global_list)
@@ -232,6 +234,7 @@ struct rio_net {
  * @get_domain: Callback for switch-specific domain get function
  * @em_init: Callback for switch-specific error management initialization function
  * @em_handle: Callback for switch-specific error management handler function
+ * @nextdev: Array of per-port pointers to the next attached device
  */
 struct rio_switch {
 	struct list_head node;
@@ -253,6 +256,7 @@ struct rio_switch {
 			   u8 *sw_domain);
 	int (*em_init) (struct rio_dev *dev);
 	int (*em_handle) (struct rio_dev *dev, u8 swport);
+	struct rio_dev *nextdev[0];
 };
 
 /* Low-level architecture-dependent routines */
-- 
1.7.0.5

