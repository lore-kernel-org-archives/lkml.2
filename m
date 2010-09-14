Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab0INPDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 11:03:16 -0400
Received: from mxout1.idt.com ([157.165.5.25]:56596 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286Ab0INPCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 11:02:53 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Thomas Moll <thomas.moll@sysgo.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: [PATCH v2 03/10] RapidIO: Use stored ingress port number instead of register read
Date: Tue, 14 Sep 2010 10:59:16 -0400
Message-Id: <1284476363-1677-4-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com>
References: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A switch port information is obtained and stored during RIO device setup.
Therefore repeated reads from Switch Port Information CAR may be removed.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Micha Nelissen <micha@neli.hopto.org>
---
 drivers/rapidio/rio-scan.c |   36 +++++++++---------------------------
 include/linux/rio.h        |    4 +++-
 include/linux/rio_regs.h   |    2 ++
 3 files changed, 14 insertions(+), 28 deletions(-)

diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index 1123be8..d09c359 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -420,6 +420,11 @@ static struct rio_dev __devinit *rio_setup_device(struct rio_net *net,
 						hopcount, RIO_EFB_ERR_MGMNT);
 	}
 
+	if (rdev->pef & (RIO_PEF_SWITCH | RIO_PEF_MULTIPORT)) {
+		rio_mport_read_config_32(port, destid, hopcount,
+					 RIO_SWP_INFO_CAR, &rdev->swpinfo);
+	}
+
 	rio_mport_read_config_32(port, destid, hopcount, RIO_SRC_OPS_CAR,
 				 &rdev->src_ops);
 	rio_mport_read_config_32(port, destid, hopcount, RIO_DST_OPS_CAR,
@@ -439,8 +444,6 @@ static struct rio_dev __devinit *rio_setup_device(struct rio_net *net,
 
 	/* If a PE has both switch and other functions, show it as a switch */
 	if (rio_is_switch(rdev)) {
-		rio_mport_read_config_32(port, destid, hopcount,
-					 RIO_SWP_INFO_CAR, &rdev->swpinfo);
 		rswitch = kzalloc(sizeof(struct rio_switch), GFP_KERNEL);
 		if (!rswitch)
 			goto cleanup;
@@ -458,6 +461,7 @@ static struct rio_dev __devinit *rio_setup_device(struct rio_net *net,
 				rdid++)
 			rswitch->route_table[rdid] = RIO_INVALID_ROUTE;
 		rdev->rswitch = rswitch;
+		rswitch->rdev = rdev;
 		dev_set_name(&rdev->dev, "%02x:s:%04x", rdev->net->id,
 			     rdev->rswitch->switchid);
 		rio_switch_init(rdev, do_enum);
@@ -719,25 +723,6 @@ static u16 rio_get_host_deviceid_lock(struct rio_mport *port, u8 hopcount)
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
@@ -834,8 +819,7 @@ static int __devinit rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 
 	if (rio_is_switch(rdev)) {
 		next_switchid++;
-		sw_inport = rio_get_swpinfo_inport(port,
-				RIO_ANY_DESTID(port->sys_size), hopcount);
+		sw_inport = RIO_GET_PORT_NUM(rdev->swpinfo);
 		rio_route_add_entry(port, rdev->rswitch, RIO_GLOBAL_TABLE,
 				    port->host_deviceid, sw_inport, 0);
 		rdev->rswitch->route_table[port->host_deviceid] = sw_inport;
@@ -989,8 +973,7 @@ rio_disc_peer(struct rio_net *net, struct rio_mport *port, u16 destid,
 		    "RIO: found %s (vid %4.4x did %4.4x) with %d ports\n",
 		    rio_name(rdev), rdev->vid, rdev->did, num_ports);
 		for (port_num = 0; port_num < num_ports; port_num++) {
-			if (rio_get_swpinfo_inport(port, destid, hopcount) ==
-			    port_num)
+			if (RIO_GET_PORT_NUM(rdev->swpinfo) == port_num)
 				continue;
 
 			if (rio_sport_is_active
@@ -1109,8 +1092,7 @@ static void rio_update_route_tables(struct rio_mport *port)
 				if (rswitch->destid == destid)
 					continue;
 
-				sport = rio_get_swpinfo_inport(port,
-						rswitch->destid, rswitch->hopcount);
+				sport = RIO_GET_PORT_NUM(rswitch->rdev->swpinfo);
 
 				if (rswitch->add_entry)	{
 					rio_route_add_entry(port, rswitch,
diff --git a/include/linux/rio.h b/include/linux/rio.h
index 84c9f8c..ffdfe5a 100644
--- a/include/linux/rio.h
+++ b/include/linux/rio.h
@@ -112,7 +112,7 @@ struct rio_dev {
 	u16 asm_rev;
 	u16 efptr;
 	u32 pef;
-	u32 swpinfo;		/* Only used for switches */
+	u32 swpinfo;
 	u32 src_ops;
 	u32 dst_ops;
 	u32 comp_tag;
@@ -219,6 +219,7 @@ struct rio_net {
 /**
  * struct rio_switch - RIO switch info
  * @node: Node in global list of switches
+ * @rdev: Associated RIO device structure
  * @switchid: Switch ID that is unique across a network
  * @hopcount: Hopcount to this switch
  * @destid: Associated destid in the path
@@ -234,6 +235,7 @@ struct rio_net {
  */
 struct rio_switch {
 	struct list_head node;
+	struct rio_dev *rdev;
 	u16 switchid;
 	u16 hopcount;
 	u16 destid;
diff --git a/include/linux/rio_regs.h b/include/linux/rio_regs.h
index aedee04..be80b1b 100644
--- a/include/linux/rio_regs.h
+++ b/include/linux/rio_regs.h
@@ -33,6 +33,7 @@
 #define  RIO_PEF_MEMORY			0x40000000	/* [I] MMIO */
 #define  RIO_PEF_PROCESSOR		0x20000000	/* [I] Processor */
 #define  RIO_PEF_SWITCH			0x10000000	/* [I] Switch */
+#define  RIO_PEF_MULTIPORT		0x08000000	/* [VI, 2.1] Multiport */
 #define  RIO_PEF_INB_MBOX		0x00f00000	/* [II] Mailboxes */
 #define  RIO_PEF_INB_MBOX0		0x00800000	/* [II] Mailbox 0 */
 #define  RIO_PEF_INB_MBOX1		0x00400000	/* [II] Mailbox 1 */
@@ -51,6 +52,7 @@
 #define  RIO_SWP_INFO_PORT_TOTAL_MASK	0x0000ff00	/* [I] Total number of ports */
 #define  RIO_SWP_INFO_PORT_NUM_MASK	0x000000ff	/* [I] Maintenance transaction port number */
 #define  RIO_GET_TOTAL_PORTS(x)		((x & RIO_SWP_INFO_PORT_TOTAL_MASK) >> 8)
+#define  RIO_GET_PORT_NUM(x)		(x & RIO_SWP_INFO_PORT_NUM_MASK)
 
 #define RIO_SRC_OPS_CAR		0x18	/* [I] Source Operations CAR */
 #define  RIO_SRC_OPS_READ		0x00008000	/* [I] Read op */
-- 
1.7.0.5

