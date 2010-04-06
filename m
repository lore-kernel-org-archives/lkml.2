Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab0DFV2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:28:53 -0400
Received: from mxout1.idt.com ([157.165.5.25]:34957 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756973Ab0DFV2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:28:47 -0400
Date: Tue, 6 Apr 2010 17:21:51 -0400
From: Alexandre Bounine <abounine@tundra.com>
To: torvalds@linux-foundation.org
Cc: mporter@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org, thomas.moll@sysgo.com,
       abounine@tundra.com
Subject: [PATCH v3 2/6] RapidIO: Add switch locking during discovery
Message-ID: <20100406212151.GB26292@amak.tundra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Alexandre Bounine <alexandre.bounine@idt.com>

Add switch access locking during RapidIO discovery. Access lock is
required when reading switch routing table contents due to indexed mechanism
of RT addressing.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Tested-by: Thomas Moll <thomas.moll@sysgo.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
---

 rio-scan.c |  164 +++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 144 insertions(+), 20 deletions(-)

diff -x '*.pj' -X dontdiff_2.6.32-rc5 -pNur w34r3a/drivers/rapidio/rio-scan.c w34r3b/drivers/rapidio/rio-scan.c
--- w34r3a/drivers/rapidio/rio-scan.c	2010-04-06 13:44:13.994872000 -0400
+++ w34r3b/drivers/rapidio/rio-scan.c	2010-04-06 14:19:21.218017000 -0400
@@ -457,12 +457,87 @@ rio_sport_is_active(struct rio_mport *po
 }
 
 /**
+ * rio_lock_device - Acquires host device lock for specified device
+ * @port: Master port to send transaction
+ * @destid: Destination ID for device/switch
+ * @hopcount: Hopcount to reach switch
+ * @wait_ms: Max wait time in msec (0 = no timeout)
+ *
+ * Attepts to acquire host device lock for specified device
+ * Returns 0 if device lock acquired or EINVAL if timeout expires.
+ */
+static int
+rio_lock_device(struct rio_mport *port, u16 destid, u8 hopcount, int wait_ms)
+{
+	u32 result;
+	int tcnt = 0;
+
+	/* Attempt to acquire device lock */
+	rio_mport_write_config_32(port, destid, hopcount,
+				  RIO_HOST_DID_LOCK_CSR, port->host_deviceid);
+	rio_mport_read_config_32(port, destid, hopcount,
+				 RIO_HOST_DID_LOCK_CSR, &result);
+
+	while (result != port->host_deviceid) {
+		if (wait_ms != 0 && tcnt == wait_ms) {
+			pr_debug("RIO: timeout when locking device %x:%x\n",
+				destid, hopcount);
+			return -EINVAL;
+		}
+
+		/* Delay a bit */
+		mdelay(1);
+		tcnt++;
+		/* Try to acquire device lock again */
+		rio_mport_write_config_32(port, destid,
+			hopcount,
+			RIO_HOST_DID_LOCK_CSR,
+			port->host_deviceid);
+		rio_mport_read_config_32(port, destid,
+			hopcount,
+			RIO_HOST_DID_LOCK_CSR, &result);
+	}
+
+	return 0;
+}
+
+/**
+ * rio_unlock_device - Releases host device lock for specified device
+ * @port: Master port to send transaction
+ * @destid: Destination ID for device/switch
+ * @hopcount: Hopcount to reach switch
+ *
+ * Returns 0 if device lock released or EINVAL if fails.
+ */
+static int
+rio_unlock_device(struct rio_mport *port, u16 destid, u8 hopcount)
+{
+	u32 result;
+
+	/* Release device lock */
+	rio_mport_write_config_32(port, destid,
+				  hopcount,
+				  RIO_HOST_DID_LOCK_CSR,
+				  port->host_deviceid);
+	rio_mport_read_config_32(port, destid, hopcount,
+		RIO_HOST_DID_LOCK_CSR, &result);
+	if ((result & 0xffff) != 0xffff) {
+		pr_debug("RIO: badness when releasing device lock %x:%x\n",
+			 destid, hopcount);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
  * rio_route_add_entry- Add a route entry to a switch routing table
  * @mport: Master port to send transaction
  * @rswitch: Switch device
  * @table: Routing table ID
  * @route_destid: Destination ID to be routed
  * @route_port: Port number to be routed
+ * @lock: lock switch device flag
  *
  * Calls the switch specific add_entry() method to add a route entry
  * on a switch. The route table can be specified using the @table
@@ -471,12 +546,26 @@ rio_sport_is_active(struct rio_mport *po
  * %RIO_GLOBAL_TABLE in @table. Returns %0 on success or %-EINVAL
  * on failure.
  */
-static int rio_route_add_entry(struct rio_mport *mport, struct rio_switch *rswitch,
-			       u16 table, u16 route_destid, u8 route_port)
+static int
+rio_route_add_entry(struct rio_mport *mport, struct rio_switch *rswitch,
+		    u16 table, u16 route_destid, u8 route_port, int lock)
 {
-	return rswitch->add_entry(mport, rswitch->destid,
+	int rc;
+
+	if (lock) {
+		rc = rio_lock_device(mport, rswitch->destid,
+				     rswitch->hopcount, 1000);
+		if (rc)
+			return rc;
+	}
+
+	rc = rswitch->add_entry(mport, rswitch->destid,
 					rswitch->hopcount, table,
 					route_destid, route_port);
+	if (lock)
+		rio_unlock_device(mport, rswitch->destid, rswitch->hopcount);
+
+	return rc;
 }
 
 /**
@@ -486,6 +575,7 @@ static int rio_route_add_entry(struct ri
  * @table: Routing table ID
  * @route_destid: Destination ID to be routed
  * @route_port: Pointer to read port number into
+ * @lock: lock switch device flag
  *
  * Calls the switch specific get_entry() method to read a route entry
  * in a switch. The route table can be specified using the @table
@@ -496,11 +586,24 @@ static int rio_route_add_entry(struct ri
  */
 static int
 rio_route_get_entry(struct rio_mport *mport, struct rio_switch *rswitch, u16 table,
-		    u16 route_destid, u8 * route_port)
+		    u16 route_destid, u8 *route_port, int lock)
 {
-	return rswitch->get_entry(mport, rswitch->destid,
+	int rc;
+
+	if (lock) {
+		rc = rio_lock_device(mport, rswitch->destid,
+				     rswitch->hopcount, 1000);
+		if (rc)
+			return rc;
+	}
+
+	rc = rswitch->get_entry(mport, rswitch->destid,
 					rswitch->hopcount, table,
 					route_destid, route_port);
+	if (lock)
+		rio_unlock_device(mport, rswitch->destid, rswitch->hopcount);
+
+	return rc;
 }
 
 /**
@@ -640,14 +743,14 @@ static int __devinit rio_enum_peer(struc
 		sw_inport = rio_get_swpinfo_inport(port,
 				RIO_ANY_DESTID(port->sys_size), hopcount);
 		rio_route_add_entry(port, rdev->rswitch, RIO_GLOBAL_TABLE,
-				    port->host_deviceid, sw_inport);
+				    port->host_deviceid, sw_inport, 0);
 		rdev->rswitch->route_table[port->host_deviceid] = sw_inport;
 
 		for (destid = 0; destid < next_destid; destid++) {
 			if (destid == port->host_deviceid)
 				continue;
 			rio_route_add_entry(port, rdev->rswitch, RIO_GLOBAL_TABLE,
-					    destid, sw_inport);
+					    destid, sw_inport, 0);
 			rdev->rswitch->route_table[destid] = sw_inport;
 		}
 
@@ -673,7 +776,7 @@ static int __devinit rio_enum_peer(struc
 				rio_route_add_entry(port, rdev->rswitch,
 						RIO_GLOBAL_TABLE,
 						RIO_ANY_DESTID(port->sys_size),
-						port_num);
+						port_num, 0);
 
 				if (rio_enum_peer(net, port, hopcount + 1) < 0)
 					return -1;
@@ -687,7 +790,8 @@ static int __devinit rio_enum_peer(struc
 						rio_route_add_entry(port, rdev->rswitch,
 								    RIO_GLOBAL_TABLE,
 								    destid,
-								    port_num);
+								    port_num,
+								    0);
 						rdev->rswitch->
 						    route_table[destid] =
 						    port_num;
@@ -778,17 +882,21 @@ rio_disc_peer(struct rio_net *net, struc
 				pr_debug(
 				    "RIO: scanning device on port %d\n",
 				    port_num);
+
+				rio_lock_device(port, destid, hopcount, 1000);
+
 				for (ndestid = 0;
 				     ndestid < RIO_ANY_DESTID(port->sys_size);
 				     ndestid++) {
 					rio_route_get_entry(port, rdev->rswitch,
 							    RIO_GLOBAL_TABLE,
 							    ndestid,
-							    &route_port);
+							    &route_port, 0);
 					if (route_port == port_num)
 						break;
 				}
 
+				rio_unlock_device(port, destid, hopcount);
 				if (rio_disc_peer
 				    (net, port, ndestid, hopcount + 1) < 0)
 					return -1;
@@ -889,7 +997,9 @@ static void rio_update_route_tables(stru
 						rswitch->destid, rswitch->hopcount);
 
 				if (rswitch->add_entry)	{
-					rio_route_add_entry(port, rswitch, RIO_GLOBAL_TABLE, destid, sport);
+					rio_route_add_entry(port, rswitch,
+						RIO_GLOBAL_TABLE, destid,
+						sport, 0);
 					rswitch->route_table[destid] = sport;
 				}
 			}
@@ -963,15 +1073,22 @@ static void rio_build_route_tables(void)
 	u8 sport;
 
 	list_for_each_entry(rdev, &rio_devices, global_list)
-	    if (rio_is_switch(rdev))
-		for (i = 0;
-		     i < RIO_MAX_ROUTE_ENTRIES(rdev->net->hport->sys_size);
-		     i++) {
-			if (rio_route_get_entry
-			    (rdev->net->hport, rdev->rswitch, RIO_GLOBAL_TABLE,
-			     i, &sport) < 0)
-				continue;
-			rdev->rswitch->route_table[i] = sport;
+		if (rio_is_switch(rdev)) {
+			rio_lock_device(rdev->net->hport, rdev->rswitch->destid,
+					rdev->rswitch->hopcount, 1000);
+			for (i = 0;
+			     i < RIO_MAX_ROUTE_ENTRIES(rdev->net->hport->sys_size);
+			     i++) {
+				if (rio_route_get_entry
+				    (rdev->net->hport, rdev->rswitch,
+				     RIO_GLOBAL_TABLE, i, &sport, 0) < 0)
+					continue;
+				rdev->rswitch->route_table[i] = sport;
+			}
+
+			rio_unlock_device(rdev->net->hport,
+					  rdev->rswitch->destid,
+					  rdev->rswitch->hopcount);
 		}
 }
 
@@ -1030,6 +1147,13 @@ int __devinit rio_disc_mport(struct rio_
 		del_timer_sync(&rio_enum_timer);
 
 		pr_debug("done\n");
+
+		/* Read DestID assigned by enumerator */
+		rio_local_read_config_32(mport, RIO_DID_CSR,
+					 &mport->host_deviceid);
+		mport->host_deviceid = RIO_GET_DID(mport->sys_size,
+						   mport->host_deviceid);
+
 		if (rio_disc_peer(net, mport, RIO_ANY_DESTID(mport->sys_size),
 					0) < 0) {
 			printk(KERN_INFO
