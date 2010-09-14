Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab0INPCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 11:02:46 -0400
Received: from mxout1.idt.com ([157.165.5.25]:56575 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523Ab0INPCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 11:02:42 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Thomas Moll <thomas.moll@sysgo.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: [PATCH v2 05/10] RapidIO: Add default handler for error-stopped state
Date: Tue, 14 Sep 2010 10:59:18 -0400
Message-Id: <1284476363-1677-6-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com>
References: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default error-stopped state handler provides recovery mechanism as defined
by RIO specification.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Micha Nelissen <micha@neli.hopto.org>
---
 drivers/rapidio/rio.c             |  218 +++++++++++++++++++++++++++++++-----
 drivers/rapidio/switches/idtcps.c |   10 ++
 drivers/rapidio/switches/tsi57x.c |    4 +
 include/linux/rio_regs.h          |    8 +-
 4 files changed, 206 insertions(+), 34 deletions(-)

diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index 74e9d22..77bd416 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -495,6 +495,148 @@ int rio_set_port_lockout(struct rio_dev *rdev, u32 pnum, int lock)
 }
 
 /**
+ * rio_get_input_status - Sends a Link-Request/Input-Status control symbol and
+ *                        returns link-response (if requested).
+ * @rdev: RIO devive to issue Input-status command
+ * @pnum: Device port number to issue the command
+ * @lnkresp: Response from a link partner
+ */
+static int
+rio_get_input_status(struct rio_dev *rdev, int pnum, u32 *lnkresp)
+{
+	struct rio_mport *mport = rdev->net->hport;
+	u16 destid = rdev->rswitch->destid;
+	u8 hopcount = rdev->rswitch->hopcount;
+	u32 regval;
+	int checkcount;
+
+	if (lnkresp) {
+		/* Read from link maintenance response register
+		 * to clear valid bit */
+		rio_mport_read_config_32(mport, destid, hopcount,
+			rdev->phys_efptr + RIO_PORT_N_MNT_RSP_CSR(pnum),
+			&regval);
+		udelay(50);
+	}
+
+	/* Issue Input-status command */
+	rio_mport_write_config_32(mport, destid, hopcount,
+		rdev->phys_efptr + RIO_PORT_N_MNT_REQ_CSR(pnum),
+		RIO_MNT_REQ_CMD_IS);
+
+	/* Exit if the response is not expected */
+	if (lnkresp == NULL)
+		return 0;
+
+	checkcount = 3;
+	while (checkcount--) {
+		udelay(50);
+		rio_mport_read_config_32(mport, destid, hopcount,
+			rdev->phys_efptr + RIO_PORT_N_MNT_RSP_CSR(pnum),
+			&regval);
+		if (regval & RIO_PORT_N_MNT_RSP_RVAL) {
+			*lnkresp = regval;
+			return 0;
+		}
+	}
+
+	return -EIO;
+}
+
+/**
+ * rio_clr_err_stopped - Clears port Error-stopped states.
+ * @rdev: Pointer to RIO device control structure
+ * @pnum: Switch port number to clear errors
+ * @err_status: port error status (if 0 reads register from device)
+ */
+static int rio_clr_err_stopped(struct rio_dev *rdev, u32 pnum, u32 err_status)
+{
+	struct rio_mport *mport = rdev->net->hport;
+	u16 destid = rdev->rswitch->destid;
+	u8 hopcount = rdev->rswitch->hopcount;
+	struct rio_dev *nextdev = rdev->rswitch->nextdev[pnum];
+	u32 regval;
+	u32 far_ackid, far_linkstat, near_ackid;
+
+	if (err_status == 0)
+		rio_mport_read_config_32(mport, destid, hopcount,
+			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(pnum),
+			&err_status);
+
+	if (err_status & RIO_PORT_N_ERR_STS_PW_OUT_ES) {
+		pr_debug("RIO_EM: servicing Output Error-Stopped state\n");
+		/*
+		 * Send a Link-Request/Input-Status control symbol
+		 */
+		if (rio_get_input_status(rdev, pnum, &regval)) {
+			pr_debug("RIO_EM: Input-status response timeout\n");
+			goto rd_err;
+		}
+
+		pr_debug("RIO_EM: SP%d Input-status response=0x%08x\n",
+			 pnum, regval);
+		far_ackid = (regval & RIO_PORT_N_MNT_RSP_ASTAT) >> 5;
+		far_linkstat = regval & RIO_PORT_N_MNT_RSP_LSTAT;
+		rio_mport_read_config_32(mport, destid, hopcount,
+			rdev->phys_efptr + RIO_PORT_N_ACK_STS_CSR(pnum),
+			&regval);
+		pr_debug("RIO_EM: SP%d_ACK_STS_CSR=0x%08x\n", pnum, regval);
+		near_ackid = (regval & RIO_PORT_N_ACK_INBOUND) >> 24;
+		pr_debug("RIO_EM: SP%d far_ackID=0x%02x far_linkstat=0x%02x" \
+			 " near_ackID=0x%02x\n",
+			pnum, far_ackid, far_linkstat, near_ackid);
+
+		/*
+		 * If required, synchronize ackIDs of near and
+		 * far sides.
+		 */
+		if ((far_ackid != ((regval & RIO_PORT_N_ACK_OUTSTAND) >> 8)) ||
+		    (far_ackid != (regval & RIO_PORT_N_ACK_OUTBOUND))) {
+			/* Align near outstanding/outbound ackIDs with
+			 * far inbound.
+			 */
+			rio_mport_write_config_32(mport, destid,
+				hopcount, rdev->phys_efptr +
+					RIO_PORT_N_ACK_STS_CSR(pnum),
+				(near_ackid << 24) |
+					(far_ackid << 8) | far_ackid);
+			/* Align far outstanding/outbound ackIDs with
+			 * near inbound.
+			 */
+			far_ackid++;
+			if (nextdev)
+				rio_write_config_32(nextdev,
+					nextdev->phys_efptr +
+					RIO_PORT_N_ACK_STS_CSR(RIO_GET_PORT_NUM(nextdev->swpinfo)),
+					(far_ackid << 24) |
+					(near_ackid << 8) | near_ackid);
+			else
+				pr_debug("RIO_EM: Invalid nextdev pointer (NULL)\n");
+		}
+rd_err:
+		rio_mport_read_config_32(mport, destid, hopcount,
+			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(pnum),
+			&err_status);
+		pr_debug("RIO_EM: SP%d_ERR_STS_CSR=0x%08x\n", pnum, err_status);
+	}
+
+	if ((err_status & RIO_PORT_N_ERR_STS_PW_INP_ES) && nextdev) {
+		pr_debug("RIO_EM: servicing Input Error-Stopped state\n");
+		rio_get_input_status(nextdev,
+				     RIO_GET_PORT_NUM(nextdev->swpinfo), NULL);
+		udelay(50);
+
+		rio_mport_read_config_32(mport, destid, hopcount,
+			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(pnum),
+			&err_status);
+		pr_debug("RIO_EM: SP%d_ERR_STS_CSR=0x%08x\n", pnum, err_status);
+	}
+
+	return (err_status & (RIO_PORT_N_ERR_STS_PW_OUT_ES |
+			      RIO_PORT_N_ERR_STS_PW_INP_ES)) ? 1 : 0;
+}
+
+/**
  * rio_inb_pwrite_handler - process inbound port-write message
  * @pw_msg: pointer to inbound port-write message
  *
@@ -507,7 +649,7 @@ int rio_inb_pwrite_handler(union rio_pw_msg *pw_msg)
 	struct rio_mport *mport;
 	u8 hopcount;
 	u16 destid;
-	u32 err_status;
+	u32 err_status, em_perrdet, em_ltlerrdet;
 	int rc, portnum;
 
 	rdev = rio_get_comptag(pw_msg->em.comptag, NULL);
@@ -524,12 +666,11 @@ int rio_inb_pwrite_handler(union rio_pw_msg *pw_msg)
 	{
 	u32 i;
 	for (i = 0; i < RIO_PW_MSG_SIZE/sizeof(u32);) {
-			pr_debug("0x%02x: %08x %08x %08x %08x",
+			pr_debug("0x%02x: %08x %08x %08x %08x\n",
 				 i*4, pw_msg->raw[i], pw_msg->raw[i + 1],
 				 pw_msg->raw[i + 2], pw_msg->raw[i + 3]);
 			i += 4;
 	}
-	pr_debug("\n");
 	}
 #endif
 
@@ -573,29 +714,28 @@ int rio_inb_pwrite_handler(union rio_pw_msg *pw_msg)
 			&err_status);
 	pr_debug("RIO_PW: SP%d_ERR_STS_CSR=0x%08x\n", portnum, err_status);
 
-	if (pw_msg->em.errdetect) {
-		pr_debug("RIO_PW: RIO_EM_P%d_ERR_DETECT=0x%08x\n",
-			 portnum, pw_msg->em.errdetect);
-		/* Clear EM Port N Error Detect CSR */
-		rio_mport_write_config_32(mport, destid, hopcount,
-			rdev->em_efptr + RIO_EM_PN_ERR_DETECT(portnum), 0);
-	}
+	if (err_status & RIO_PORT_N_ERR_STS_PORT_OK) {
 
-	if (pw_msg->em.ltlerrdet) {
-		pr_debug("RIO_PW: RIO_EM_LTL_ERR_DETECT=0x%08x\n",
-			 pw_msg->em.ltlerrdet);
-		/* Clear EM L/T Layer Error Detect CSR */
-		rio_mport_write_config_32(mport, destid, hopcount,
-			rdev->em_efptr + RIO_EM_LTL_ERR_DETECT, 0);
-	}
+		if (!(rdev->rswitch->port_ok & (1 << portnum))) {
+			rdev->rswitch->port_ok |= (1 << portnum);
+			rio_set_port_lockout(rdev, portnum, 0);
+			/* Schedule Insertion Service */
+			pr_debug("RIO_PW: Device Insertion on [%s]-P%d\n",
+			       rio_name(rdev), portnum);
+		}
 
-	/* Clear Port Errors */
-	rio_mport_write_config_32(mport, destid, hopcount,
-			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(portnum),
-			err_status & RIO_PORT_N_ERR_STS_CLR_MASK);
+		/* Clear error-stopped states (if reported).
+		 * Depending on the link partner state, two attempts
+		 * may be needed for successful recovery.
+		 */
+		if (err_status & (RIO_PORT_N_ERR_STS_PW_OUT_ES |
+				  RIO_PORT_N_ERR_STS_PW_INP_ES)) {
+			if (rio_clr_err_stopped(rdev, portnum, err_status))
+				rio_clr_err_stopped(rdev, portnum, 0);
+		}
+	}  else { /* if (err_status & RIO_PORT_N_ERR_STS_PORT_UNINIT) */
 
-	if (rdev->rswitch->port_ok & (1 << portnum)) {
-		if (err_status & RIO_PORT_N_ERR_STS_PORT_UNINIT) {
+		if (rdev->rswitch->port_ok & (1 << portnum)) {
 			rdev->rswitch->port_ok &= ~(1 << portnum);
 			rio_set_port_lockout(rdev, portnum, 1);
 
@@ -608,17 +748,33 @@ int rio_inb_pwrite_handler(union rio_pw_msg *pw_msg)
 			pr_debug("RIO_PW: Device Extraction on [%s]-P%d\n",
 			       rio_name(rdev), portnum);
 		}
-	} else {
-		if (err_status & RIO_PORT_N_ERR_STS_PORT_OK) {
-			rdev->rswitch->port_ok |= (1 << portnum);
-			rio_set_port_lockout(rdev, portnum, 0);
+	}
 
-			/* Schedule Insertion Service */
-			pr_debug("RIO_PW: Device Insertion on [%s]-P%d\n",
-			       rio_name(rdev), portnum);
-		}
+	rio_mport_read_config_32(mport, destid, hopcount,
+		rdev->em_efptr + RIO_EM_PN_ERR_DETECT(portnum), &em_perrdet);
+	if (em_perrdet) {
+		pr_debug("RIO_PW: RIO_EM_P%d_ERR_DETECT=0x%08x\n",
+			 portnum, em_perrdet);
+		/* Clear EM Port N Error Detect CSR */
+		rio_mport_write_config_32(mport, destid, hopcount,
+			rdev->em_efptr + RIO_EM_PN_ERR_DETECT(portnum), 0);
 	}
 
+	rio_mport_read_config_32(mport, destid, hopcount,
+		rdev->em_efptr + RIO_EM_LTL_ERR_DETECT, &em_ltlerrdet);
+	if (em_ltlerrdet) {
+		pr_debug("RIO_PW: RIO_EM_LTL_ERR_DETECT=0x%08x\n",
+			 em_ltlerrdet);
+		/* Clear EM L/T Layer Error Detect CSR */
+		rio_mport_write_config_32(mport, destid, hopcount,
+			rdev->em_efptr + RIO_EM_LTL_ERR_DETECT, 0);
+	}
+
+	/* Clear remaining error bits */
+	rio_mport_write_config_32(mport, destid, hopcount,
+			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(portnum),
+			err_status & RIO_PORT_N_ERR_STS_CLR_MASK);
+
 	/* Clear Port-Write Pending bit */
 	rio_mport_write_config_32(mport, destid, hopcount,
 			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(portnum),
diff --git a/drivers/rapidio/switches/idtcps.c b/drivers/rapidio/switches/idtcps.c
index 2c790c1..fc9f637 100644
--- a/drivers/rapidio/switches/idtcps.c
+++ b/drivers/rapidio/switches/idtcps.c
@@ -117,6 +117,10 @@ idtcps_get_domain(struct rio_mport *mport, u16 destid, u8 hopcount,
 
 static int idtcps_switch_init(struct rio_dev *rdev, int do_enum)
 {
+	struct rio_mport *mport = rdev->net->hport;
+	u16 destid = rdev->rswitch->destid;
+	u8 hopcount = rdev->rswitch->hopcount;
+
 	pr_debug("RIO: %s for %s\n", __func__, rio_name(rdev));
 	rdev->rswitch->add_entry = idtcps_route_add_entry;
 	rdev->rswitch->get_entry = idtcps_route_get_entry;
@@ -126,6 +130,12 @@ static int idtcps_switch_init(struct rio_dev *rdev, int do_enum)
 	rdev->rswitch->em_init = NULL;
 	rdev->rswitch->em_handle = NULL;
 
+	if (do_enum) {
+		/* set TVAL = ~50us */
+		rio_mport_write_config_32(mport, destid, hopcount,
+			rdev->phys_efptr + RIO_PORT_LINKTO_CTL_CSR, 0x8e << 8);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/rapidio/switches/tsi57x.c b/drivers/rapidio/switches/tsi57x.c
index d34df72..d9e9492 100644
--- a/drivers/rapidio/switches/tsi57x.c
+++ b/drivers/rapidio/switches/tsi57x.c
@@ -205,6 +205,10 @@ tsi57x_em_init(struct rio_dev *rdev)
 			portnum++;
 	}
 
+	/* set TVAL = ~50us */
+	rio_mport_write_config_32(mport, destid, hopcount,
+		rdev->phys_efptr + RIO_PORT_LINKTO_CTL_CSR, 0x9a << 8);
+
 	return 0;
 }
 
diff --git a/include/linux/rio_regs.h b/include/linux/rio_regs.h
index be80b1b..daa269d 100644
--- a/include/linux/rio_regs.h
+++ b/include/linux/rio_regs.h
@@ -224,15 +224,17 @@
 #define  RIO_PORT_GEN_MASTER		0x40000000
 #define  RIO_PORT_GEN_DISCOVERED	0x20000000
 #define RIO_PORT_N_MNT_REQ_CSR(x)	(0x0040 + x*0x20)	/* 0x0002 */
+#define  RIO_MNT_REQ_CMD_RD		0x03	/* Reset-device command */
+#define  RIO_MNT_REQ_CMD_IS		0x04	/* Input-status command */
 #define RIO_PORT_N_MNT_RSP_CSR(x)	(0x0044 + x*0x20)	/* 0x0002 */
 #define  RIO_PORT_N_MNT_RSP_RVAL	0x80000000 /* Response Valid */
 #define  RIO_PORT_N_MNT_RSP_ASTAT	0x000003e0 /* ackID Status */
 #define  RIO_PORT_N_MNT_RSP_LSTAT	0x0000001f /* Link Status */
 #define RIO_PORT_N_ACK_STS_CSR(x)	(0x0048 + x*0x20)	/* 0x0002 */
 #define  RIO_PORT_N_ACK_CLEAR		0x80000000
-#define  RIO_PORT_N_ACK_INBOUND		0x1f000000
-#define  RIO_PORT_N_ACK_OUTSTAND	0x00001f00
-#define  RIO_PORT_N_ACK_OUTBOUND	0x0000001f
+#define  RIO_PORT_N_ACK_INBOUND		0x3f000000
+#define  RIO_PORT_N_ACK_OUTSTAND	0x00003f00
+#define  RIO_PORT_N_ACK_OUTBOUND	0x0000003f
 #define RIO_PORT_N_ERR_STS_CSR(x)	(0x0058 + x*0x20)
 #define  RIO_PORT_N_ERR_STS_PW_OUT_ES	0x00010000 /* Output Error-stopped */
 #define  RIO_PORT_N_ERR_STS_PW_INP_ES	0x00000100 /* Input Error-stopped */
-- 
1.7.0.5

