Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab2JCTZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 15:25:44 -0400
Received: from mxout1.idt.com ([157.165.5.25]:40750 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab2JCTZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 15:25:41 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Subject: [PATCH 5/5] rapidio: add destination ID allocation mechanism
Date: Wed,  3 Oct 2012 15:18:43 -0400
Message-Id: <1349291923-22860-6-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1349291923-22860-1-git-send-email-alexandre.bounine@idt.com>
References: <1349291923-22860-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the single global destination ID counter with per-net allocation
mechanism to allow independent destID management for each available RapidIO
network. Using bitmap based mechanism instead of counters allows
destination ID release and reuse in systems that support hot-swap.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
---
 drivers/rapidio/rio-scan.c |  205 ++++++++++++++++++++++++++++++++++++--------
 include/linux/rio.h        |    9 ++
 2 files changed, 179 insertions(+), 35 deletions(-)

diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index 745670f..48e9041 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -54,6 +54,114 @@ static int rio_mport_phys_table[] = {
 	-1,
 };
 
+
+/*
+ * rio_destid_alloc - Allocate next available destID for given network
+ * net: RIO network
+ *
+ * Returns next available device destination ID for the specified RIO network.
+ * Marks allocated ID as one in use.
+ * Returns RIO_INVALID_DESTID if new destID is not available.
+ */
+static u16 rio_destid_alloc(struct rio_net *net)
+{
+	int destid;
+	struct rio_id_table *idtab = &net->destid_table;
+
+	spin_lock(&idtab->lock);
+	destid = find_next_zero_bit(idtab->table, idtab->max, idtab->next);
+	if (destid >= idtab->max)
+		destid = find_first_zero_bit(idtab->table, idtab->max);
+
+	if (destid < idtab->max) {
+		idtab->next = destid + 1;
+		if (idtab->next >= idtab->max)
+			idtab->next = 0;
+		set_bit(destid, idtab->table);
+		destid += idtab->start;
+	} else
+		destid = RIO_INVALID_DESTID;
+
+	spin_unlock(&idtab->lock);
+	return (u16)destid;
+}
+
+/*
+ * rio_destid_reserve - Reserve the specivied destID
+ * net: RIO network
+ * destid: destID to reserve
+ *
+ * Tries to reserve the specified destID.
+ * Returns 0 if successfull.
+ */
+static int rio_destid_reserve(struct rio_net *net, u16 destid)
+{
+	int oldbit;
+	struct rio_id_table *idtab = &net->destid_table;
+
+	destid -= idtab->start;
+	spin_lock(&idtab->lock);
+	oldbit = test_and_set_bit(destid, idtab->table);
+	spin_unlock(&idtab->lock);
+	return oldbit;
+}
+
+/*
+ * rio_destid_free - free a previously allocated destID
+ * net: RIO network
+ * destid: destID to free
+ *
+ * Makes the specified destID available for use.
+ */
+static void rio_destid_free(struct rio_net *net, u16 destid)
+{
+	struct rio_id_table *idtab = &net->destid_table;
+
+	destid -= idtab->start;
+	spin_lock(&idtab->lock);
+	clear_bit(destid, idtab->table);
+	spin_unlock(&idtab->lock);
+}
+
+/*
+ * rio_destid_first - return first destID in use
+ * net: RIO network
+ */
+static u16 rio_destid_first(struct rio_net *net)
+{
+	int destid;
+	struct rio_id_table *idtab = &net->destid_table;
+
+	spin_lock(&idtab->lock);
+	destid = find_first_bit(idtab->table, idtab->max);
+	if (destid >= idtab->max)
+		destid = RIO_INVALID_DESTID;
+	else
+		destid += idtab->start;
+	spin_unlock(&idtab->lock);
+	return (u16)destid;
+}
+
+/*
+ * rio_destid_next - return next destID in use
+ * net: RIO network
+ * from: destination ID from which search shall continue
+ */
+static u16 rio_destid_next(struct rio_net *net, u16 from)
+{
+	int destid;
+	struct rio_id_table *idtab = &net->destid_table;
+
+	spin_lock(&idtab->lock);
+	destid = find_next_bit(idtab->table, idtab->max, from);
+	if (destid >= idtab->max)
+		destid = RIO_INVALID_DESTID;
+	else
+		destid += idtab->start;
+	spin_unlock(&idtab->lock);
+	return (u16)destid;
+}
+
 /**
  * rio_get_device_id - Get the base/extended device id for a device
  * @port: RIO master port
@@ -171,10 +279,6 @@ static int rio_enum_host(struct rio_mport *port)
 
 	/* Set master port destid and init destid ctr */
 	rio_local_set_device_id(port, port->host_deviceid);
-
-	if (next_destid == port->host_deviceid)
-		next_destid++;
-
 	return 0;
 }
 
@@ -441,9 +545,8 @@ static struct rio_dev __devinit *rio_setup_device(struct rio_net *net,
 	if (rio_device_has_destid(port, rdev->src_ops, rdev->dst_ops)) {
 		if (do_enum) {
 			rio_set_device_id(port, destid, hopcount, next_destid);
-			rdev->destid = next_destid++;
-			if (next_destid == port->host_deviceid)
-				next_destid++;
+			rdev->destid = next_destid;
+			next_destid = rio_destid_alloc(net);
 		} else
 			rdev->destid = rio_get_device_id(port, destid, hopcount);
 
@@ -742,12 +845,7 @@ static u16 rio_get_host_deviceid_lock(struct rio_mport *port, u8 hopcount)
 static int __devinit rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 			 u8 hopcount, struct rio_dev *prev, int prev_port)
 {
-	int port_num;
-	int cur_destid;
-	int sw_destid;
-	int sw_inport;
 	struct rio_dev *rdev;
-	u16 destid;
 	u32 regval;
 	int tmp;
 
@@ -813,19 +911,26 @@ static int __devinit rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 		return -1;
 
 	if (rio_is_switch(rdev)) {
+		int sw_destid;
+		int cur_destid;
+		int sw_inport;
+		u16 destid;
+		int port_num;
+
 		sw_inport = RIO_GET_PORT_NUM(rdev->swpinfo);
 		rio_route_add_entry(rdev, RIO_GLOBAL_TABLE,
 				    port->host_deviceid, sw_inport, 0);
 		rdev->rswitch->route_table[port->host_deviceid] = sw_inport;
 
-		for (destid = 0; destid < next_destid; destid++) {
-			if (destid == port->host_deviceid)
-				continue;
-			rio_route_add_entry(rdev, RIO_GLOBAL_TABLE,
-					    destid, sw_inport, 0);
-			rdev->rswitch->route_table[destid] = sw_inport;
+		destid = rio_destid_first(net);
+		while (destid != RIO_INVALID_DESTID && destid < next_destid) {
+			if (destid != port->host_deviceid) {
+				rio_route_add_entry(rdev, RIO_GLOBAL_TABLE,
+						    destid, sw_inport, 0);
+				rdev->rswitch->route_table[destid] = sw_inport;
+			}
+			destid = rio_destid_next(net, destid + 1);
 		}
-
 		pr_debug(
 		    "RIO: found %s (vid %4.4x did %4.4x) with %d ports\n",
 		    rio_name(rdev), rdev->vid, rdev->did,
@@ -863,19 +968,22 @@ static int __devinit rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 					return -1;
 
 				/* Update routing tables */
-				if (next_destid > cur_destid) {
+				destid = rio_destid_next(net, cur_destid + 1);
+				if (destid != RIO_INVALID_DESTID) {
 					for (destid = cur_destid;
-					     destid < next_destid; destid++) {
-						if (destid == port->host_deviceid)
-							continue;
-						rio_route_add_entry(rdev,
+					     destid < next_destid;) {
+						if (destid != port->host_deviceid) {
+							rio_route_add_entry(rdev,
 								    RIO_GLOBAL_TABLE,
 								    destid,
 								    port_num,
 								    0);
-						rdev->rswitch->
-						    route_table[destid] =
-						    port_num;
+							rdev->rswitch->
+								route_table[destid] =
+								port_num;
+						}
+						destid = rio_destid_next(net,
+								destid + 1);
 					}
 				}
 			} else {
@@ -901,11 +1009,8 @@ static int __devinit rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 		rio_init_em(rdev);
 
 		/* Check for empty switch */
-		if (next_destid == sw_destid) {
-			next_destid++;
-			if (next_destid == port->host_deviceid)
-				next_destid++;
-		}
+		if (next_destid == sw_destid)
+			next_destid = rio_destid_alloc(net);
 
 		rdev->destid = sw_destid;
 	} else
@@ -1043,17 +1148,39 @@ static int rio_mport_is_active(struct rio_mport *port)
 /**
  * rio_alloc_net- Allocate and configure a new RIO network
  * @port: Master port associated with the RIO network
+ * @do_enum: Enumeration/Discovery mode flag
+ * @start: logical minimal start id for new net
  *
  * Allocates a RIO network structure, initializes per-network
  * list heads, and adds the associated master port to the
  * network list of associated master ports. Returns a
  * RIO network pointer on success or %NULL on failure.
  */
-static struct rio_net __devinit *rio_alloc_net(struct rio_mport *port)
+static struct rio_net __devinit *rio_alloc_net(struct rio_mport *port,
+					       int do_enum, u16 start)
 {
 	struct rio_net *net;
 
 	net = kzalloc(sizeof(struct rio_net), GFP_KERNEL);
+	if (net && do_enum) {
+		net->destid_table.table = kzalloc(
+			BITS_TO_LONGS(RIO_MAX_ROUTE_ENTRIES(port->sys_size)) *
+			sizeof(long),
+			GFP_KERNEL);
+
+		if (net->destid_table.table == NULL) {
+			pr_err("RIO: failed to allocate destID table\n");
+			kfree(net);
+			net = NULL;
+		} else {
+			net->destid_table.start = start;
+			net->destid_table.next = 0;
+			net->destid_table.max =
+					RIO_MAX_ROUTE_ENTRIES(port->sys_size);
+			spin_lock_init(&net->destid_table.lock);
+		}
+	}
+
 	if (net) {
 		INIT_LIST_HEAD(&net->node);
 		INIT_LIST_HEAD(&net->devices);
@@ -1163,12 +1290,16 @@ int __devinit rio_enum_mport(struct rio_mport *mport)
 
 	/* If master port has an active link, allocate net and enum peers */
 	if (rio_mport_is_active(mport)) {
-		if (!(net = rio_alloc_net(mport))) {
+		net = rio_alloc_net(mport, 1, 0);
+		if (!net) {
 			printk(KERN_ERR "RIO: failed to allocate new net\n");
 			rc = -ENOMEM;
 			goto out;
 		}
 
+		/* reserve mport destID in new net */
+		rio_destid_reserve(net, mport->host_deviceid);
+
 		/* Enable Input Output Port (transmitter reviever) */
 		rio_enable_rx_tx_port(mport, 1, 0, 0, 0);
 
@@ -1176,6 +1307,8 @@ int __devinit rio_enum_mport(struct rio_mport *mport)
 		rio_local_write_config_32(mport, RIO_COMPONENT_TAG_CSR,
 					  next_comptag++);
 
+		next_destid = rio_destid_alloc(net);
+
 		if (rio_enum_peer(net, mport, 0, NULL, 0) < 0) {
 			/* A higher priority host won enumeration, bail. */
 			printk(KERN_INFO
@@ -1185,6 +1318,8 @@ int __devinit rio_enum_mport(struct rio_mport *mport)
 			rc = -EBUSY;
 			goto out;
 		}
+		/* free the last allocated destID (unused) */
+		rio_destid_free(net, next_destid);
 		rio_update_route_tables(net);
 		rio_clear_locks(net);
 		rio_pw_enable(mport, 1);
@@ -1265,7 +1400,7 @@ int __devinit rio_disc_mport(struct rio_mport *mport)
 enum_done:
 		pr_debug("RIO: ... enumeration done\n");
 
-		net = rio_alloc_net(mport);
+		net = rio_alloc_net(mport, 0, 0);
 		if (!net) {
 			printk(KERN_ERR "RIO: Failed to allocate new net\n");
 			goto bail;
diff --git a/include/linux/rio.h b/include/linux/rio.h
index 7ea02c4..d2dff22 100644
--- a/include/linux/rio.h
+++ b/include/linux/rio.h
@@ -264,6 +264,14 @@ struct rio_mport {
 #endif
 };
 
+struct rio_id_table {
+	u16 start;	/* logical minimal id */
+	u16 next;	/* hint for find */
+	u32 max;	/* max number of IDs in table */
+	spinlock_t lock;
+	unsigned long *table;
+};
+
 /**
  * struct rio_net - RIO network info
  * @node: Node in global list of RIO networks
@@ -279,6 +287,7 @@ struct rio_net {
 	struct list_head mports;	/* list of ports accessing net */
 	struct rio_mport *hport;	/* primary port for accessing net */
 	unsigned char id;	/* RIO network ID */
+	struct rio_id_table destid_table;  /* destID allocation table */
 };
 
 /* Definitions used by switch sysfs initialization callback */
-- 
1.7.8.4

