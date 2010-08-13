Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761831Ab0HMPUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 11:20:30 -0400
Received: from mxout1.idt.com ([157.165.5.25]:47127 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761807Ab0HMPUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 11:20:22 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>
Subject: [PATCH 3/9] RapidIO: Add the ingress port number into the RIO switch data structure
Date: Fri, 13 Aug 2010 11:18:00 -0400
Message-Id: <1281712686-31308-4-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com>
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A switch ingress port number has to be saved for software assisted error
recovery from the error-stopped state. Saving this information also allows
to remove several register reads from the RIO enumeration process.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Reviewed-by: Thomas Moll <thomas.moll@sysgo.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
---
 drivers/rapidio/rio-scan.c |   38 ++++++++------------------------------
 include/linux/rio.h        |    4 ++--
 2 files changed, 10 insertions(+), 32 deletions(-)

diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index 1123be8..efe3519 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -389,6 +389,7 @@ static struct rio_dev __devinit *rio_setup_device(struct rio_net *net,
 	int ret = 0;
 	struct rio_dev *rdev;
 	struct rio_switch *rswitch = NULL;
+	u32 swpinfo;
 	int result, rdid;
 
 	rdev = kzalloc(sizeof(struct rio_dev), GFP_KERNEL);
@@ -440,7 +441,7 @@ static struct rio_dev __devinit *rio_setup_device(struct rio_net *net,
 	/* If a PE has both switch and other functions, show it as a switch */
 	if (rio_is_switch(rdev)) {
 		rio_mport_read_config_32(port, destid, hopcount,
-					 RIO_SWP_INFO_CAR, &rdev->swpinfo);
+					 RIO_SWP_INFO_CAR, &swpinfo);
 		rswitch = kzalloc(sizeof(struct rio_switch), GFP_KERNEL);
 		if (!rswitch)
 			goto cleanup;
@@ -448,6 +449,7 @@ static struct rio_dev __devinit *rio_setup_device(struct rio_net *net,
 		rswitch->hopcount = hopcount;
 		rswitch->destid = destid;
 		rswitch->port_ok = 0;
+		rswitch->inport = (u8)(swpinfo & RIO_SWP_INFO_PORT_NUM_MASK);
 		rswitch->route_table = kzalloc(sizeof(u8)*
 					RIO_MAX_ROUTE_ENTRIES(port->sys_size),
 					GFP_KERNEL);
@@ -719,25 +721,6 @@ static u16 rio_get_host_deviceid_lock(struct rio_mport *port, u8 hopcount)
 }
 
 /**
- * rio_get_swpinfo_inport- Gets the ingress port number
- * @mport: Master port to send transaction
- * @destid: Destination ID associated with the switch
- * @hopcount: Number of hops to the device
- *
- * Returns port number being used to access the switch device.
- */
-static u8
-rio_get_swpinfo_inport(struct rio_mport *mport, u16 destid, u8 hopcount)
-{
-	u32 result;
-
-	rio_mport_read_config_32(mport, destid, hopcount, RIO_SWP_INFO_CAR,
-				 &result);
-
-	return (u8) (result & 0xff);
-}
-
-/**
  * rio_get_swpinfo_tports- Gets total number of ports on the switch
  * @mport: Master port to send transaction
  * @destid: Destination ID associated with the switch
@@ -834,8 +817,7 @@ static int __devinit rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 
 	if (rio_is_switch(rdev)) {
 		next_switchid++;
-		sw_inport = rio_get_swpinfo_inport(port,
-				RIO_ANY_DESTID(port->sys_size), hopcount);
+		sw_inport = rdev->rswitch->inport;
 		rio_route_add_entry(port, rdev->rswitch, RIO_GLOBAL_TABLE,
 				    port->host_deviceid, sw_inport, 0);
 		rdev->rswitch->route_table[port->host_deviceid] = sw_inport;
@@ -989,8 +971,7 @@ rio_disc_peer(struct rio_net *net, struct rio_mport *port, u16 destid,
 		    "RIO: found %s (vid %4.4x did %4.4x) with %d ports\n",
 		    rio_name(rdev), rdev->vid, rdev->did, num_ports);
 		for (port_num = 0; port_num < num_ports; port_num++) {
-			if (rio_get_swpinfo_inport(port, destid, hopcount) ==
-			    port_num)
+			if (rdev->rswitch->inport == port_num)
 				continue;
 
 			if (rio_sport_is_active
@@ -1092,7 +1073,6 @@ static void rio_update_route_tables(struct rio_mport *port)
 {
 	struct rio_dev *rdev;
 	struct rio_switch *rswitch;
-	u8 sport;
 	u16 destid;
 
 	list_for_each_entry(rdev, &rio_devices, global_list) {
@@ -1109,14 +1089,12 @@ static void rio_update_route_tables(struct rio_mport *port)
 				if (rswitch->destid == destid)
 					continue;
 
-				sport = rio_get_swpinfo_inport(port,
-						rswitch->destid, rswitch->hopcount);
-
 				if (rswitch->add_entry)	{
 					rio_route_add_entry(port, rswitch,
 						RIO_GLOBAL_TABLE, destid,
-						sport, 0);
-					rswitch->route_table[destid] = sport;
+						rswitch->inport, 0);
+					rswitch->route_table[destid] =
+								rswitch->inport;
 				}
 			}
 		}
diff --git a/include/linux/rio.h b/include/linux/rio.h
index 84c9f8c..718075a 100644
--- a/include/linux/rio.h
+++ b/include/linux/rio.h
@@ -86,7 +86,6 @@ union rio_pw_msg;
  * @asm_rev: Assembly revision
  * @efptr: Extended feature pointer
  * @pef: Processing element features
- * @swpinfo: Switch port info
  * @src_ops: Source operation capabilities
  * @dst_ops: Destination operation capabilities
  * @comp_tag: RIO component tag
@@ -112,7 +111,6 @@ struct rio_dev {
 	u16 asm_rev;
 	u16 efptr;
 	u32 pef;
-	u32 swpinfo;		/* Only used for switches */
 	u32 src_ops;
 	u32 dst_ops;
 	u32 comp_tag;
@@ -222,6 +220,7 @@ struct rio_net {
  * @switchid: Switch ID that is unique across a network
  * @hopcount: Hopcount to this switch
  * @destid: Associated destid in the path
+ * @inport: Switch ingress port number
  * @route_table: Copy of switch routing table
  * @port_ok: Status of each port (one bit per port) - OK=1 or UNINIT=0
  * @add_entry: Callback for switch-specific route add function
@@ -237,6 +236,7 @@ struct rio_switch {
 	u16 switchid;
 	u16 hopcount;
 	u16 destid;
+	u8  inport;
 	u8 *route_table;
 	u32 port_ok;
 	int (*add_entry) (struct rio_mport * mport, u16 destid, u8 hopcount,
-- 
1.7.0.5

