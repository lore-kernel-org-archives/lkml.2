Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab1EKPtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:49:39 -0400
Received: from mxout1.idt.com ([157.165.5.25]:49240 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755423Ab1EKPth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:49:37 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Thomas Moll <thomas.moll@sysgo.com>
Subject: [PATCH] RapidIO: Fix default routing initialization
Date: Wed, 11 May 2011 10:46:03 -0400
Message-Id: <1305125163-14590-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix switch initialization to ensure that all switches have default
routing disabled. This guarantees that no unexpected RapidIO packets
arrive to the default port set by reset and there is no default routing
destination until it is properly configured by software.

This update also unifies handling of unmapped destinations by tsi57x,
IDT Gen1 and IDT Gen2 switches.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
---
 drivers/rapidio/switches/idt_gen2.c |    9 +++++++++
 drivers/rapidio/switches/idtcps.c   |    6 ++++++
 drivers/rapidio/switches/tsi57x.c   |    6 ++++++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/rapidio/switches/idt_gen2.c b/drivers/rapidio/switches/idt_gen2.c
index ac2701b..043ee31 100644
--- a/drivers/rapidio/switches/idt_gen2.c
+++ b/drivers/rapidio/switches/idt_gen2.c
@@ -95,6 +95,9 @@ idtg2_route_add_entry(struct rio_mport *mport, u16 destid, u8 hopcount,
 	else
 		table++;
 
+	if (route_port == RIO_INVALID_ROUTE)
+		route_port = IDT_DEFAULT_ROUTE;
+
 	rio_mport_write_config_32(mport, destid, hopcount,
 				  LOCAL_RTE_CONF_DESTID_SEL, table);
 
@@ -411,6 +414,12 @@ static int idtg2_switch_init(struct rio_dev *rdev, int do_enum)
 	rdev->rswitch->em_handle = idtg2_em_handler;
 	rdev->rswitch->sw_sysfs = idtg2_sysfs;
 
+	if (do_enum) {
+		/* Ensure that default routing is disabled on startup */
+		rio_write_config_32(rdev,
+				    RIO_STD_RTE_DEFAULT_PORT, IDT_NO_ROUTE);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/rapidio/switches/idtcps.c b/drivers/rapidio/switches/idtcps.c
index 3a97107..d06ee2d 100644
--- a/drivers/rapidio/switches/idtcps.c
+++ b/drivers/rapidio/switches/idtcps.c
@@ -26,6 +26,9 @@ idtcps_route_add_entry(struct rio_mport *mport, u16 destid, u8 hopcount,
 {
 	u32 result;
 
+	if (route_port == RIO_INVALID_ROUTE)
+		route_port = CPS_DEFAULT_ROUTE;
+
 	if (table == RIO_GLOBAL_TABLE) {
 		rio_mport_write_config_32(mport, destid, hopcount,
 				RIO_STD_RTE_CONF_DESTID_SEL_CSR, route_destid);
@@ -130,6 +133,9 @@ static int idtcps_switch_init(struct rio_dev *rdev, int do_enum)
 		/* set TVAL = ~50us */
 		rio_write_config_32(rdev,
 			rdev->phys_efptr + RIO_PORT_LINKTO_CTL_CSR, 0x8e << 8);
+		/* Ensure that default routing is disabled on startup */
+		rio_write_config_32(rdev,
+				    RIO_STD_RTE_DEFAULT_PORT, CPS_NO_ROUTE);
 	}
 
 	return 0;
diff --git a/drivers/rapidio/switches/tsi57x.c b/drivers/rapidio/switches/tsi57x.c
index d322fa0..10e7ddc 100644
--- a/drivers/rapidio/switches/tsi57x.c
+++ b/drivers/rapidio/switches/tsi57x.c
@@ -303,6 +303,12 @@ static int tsi57x_switch_init(struct rio_dev *rdev, int do_enum)
 	rdev->rswitch->em_init = tsi57x_em_init;
 	rdev->rswitch->em_handle = tsi57x_em_handler;
 
+	if (do_enum) {
+		/* Ensure that default routing is disabled on startup */
+		rio_write_config_32(rdev, RIO_STD_RTE_DEFAULT_PORT,
+				    RIO_INVALID_ROUTE);
+	}
+
 	return 0;
 }
 
-- 
1.7.3.1

