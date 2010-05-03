Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980Ab0ECPsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 11:48:21 -0400
Received: from mxout1.idt.com ([157.165.5.25]:42459 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932928Ab0ECPsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 11:48:15 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
       Alexandre Bounine <alexandre.bounine@idt.com>,
       Matt Porter <mporter@kernel.crashing.org>,
       Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
       Thomas Moll <thomas.moll@sysgo.com>
Subject: [PATCH -mm 4/5] RapidIO: Add switch domain routines
Date: Mon,  3 May 2010 11:45:57 -0400
Message-Id: <1272901558-9292-5-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <1272901558-9292-1-git-send-email-alexandre.bounine@idt.com>
References: <1272901558-9292-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added switch specific domain routines required for 16-bit routing support
in switches with hierarchical implementation of routing tables.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Thomas Moll <thomas.moll@sysgo.com>
---
 drivers/rapidio/switches/idtcps.c |   33 +++++++++++++++++++++++++++
 drivers/rapidio/switches/tsi500.c |    2 +
 drivers/rapidio/switches/tsi568.c |    2 +
 drivers/rapidio/switches/tsi57x.c |   45 +++++++++++++++++++++++++++++++++++++
 include/linux/rio.h               |    4 +++
 5 files changed, 86 insertions(+), 0 deletions(-)

diff --git a/drivers/rapidio/switches/idtcps.c b/drivers/rapidio/switches/idtcps.c
index 46e6630..73c3677 100644
--- a/drivers/rapidio/switches/idtcps.c
+++ b/drivers/rapidio/switches/idtcps.c
@@ -17,6 +17,8 @@
 
 #define CPS_NO_ROUTE 0xdf
 
+#define IDTCPS_RIO_DOMAIN 0xf20020
+
 static int
 idtcps_route_add_entry(struct rio_mport *mport, u16 destid, u8 hopcount,
 		       u16 table, u16 route_destid, u8 route_port)
@@ -82,12 +84,43 @@ idtcps_route_clr_table(struct rio_mport *mport, u16 destid, u8 hopcount,
 	return 0;
 }
 
+static int
+idtcps_set_domain(struct rio_mport *mport, u16 destid, u8 hopcount,
+		       u8 sw_domain)
+{
+	/*
+	 * Switch domain configuration operates only at global level
+	 */
+	rio_mport_write_config_32(mport, destid, hopcount,
+				  IDTCPS_RIO_DOMAIN, (u32)sw_domain);
+	return 0;
+}
+
+static int
+idtcps_get_domain(struct rio_mport *mport, u16 destid, u8 hopcount,
+		       u8 *sw_domain)
+{
+	u32 regval;
+
+	/*
+	 * Switch domain configuration operates only at global level
+	 */
+	rio_mport_read_config_32(mport, destid, hopcount,
+				IDTCPS_RIO_DOMAIN, &regval);
+
+	*sw_domain = (u8)(regval & 0xff);
+
+	return 0;
+}
+
 static int idtcps_switch_init(struct rio_dev *rdev, int do_enum)
 {
 	pr_debug("RIO: %s for %s\n", __func__, rio_name(rdev));
 	rdev->rswitch->add_entry = idtcps_route_add_entry;
 	rdev->rswitch->get_entry = idtcps_route_get_entry;
 	rdev->rswitch->clr_table = idtcps_route_clr_table;
+	rdev->rswitch->set_domain = idtcps_set_domain;
+	rdev->rswitch->get_domain = idtcps_get_domain;
 	rdev->rswitch->em_init = NULL;
 	rdev->rswitch->em_handle = NULL;
 
diff --git a/drivers/rapidio/switches/tsi500.c b/drivers/rapidio/switches/tsi500.c
index 65b865d..914eddd 100644
--- a/drivers/rapidio/switches/tsi500.c
+++ b/drivers/rapidio/switches/tsi500.c
@@ -67,6 +67,8 @@ static int tsi500_switch_init(struct rio_dev *rdev, int do_enum)
 	rdev->rswitch->add_entry = tsi500_route_add_entry;
 	rdev->rswitch->get_entry = tsi500_route_get_entry;
 	rdev->rswitch->clr_table = NULL;
+	rdev->rswitch->set_domain = NULL;
+	rdev->rswitch->get_domain = NULL;
 	rdev->rswitch->em_init = NULL;
 	rdev->rswitch->em_handle = NULL;
 
diff --git a/drivers/rapidio/switches/tsi568.c b/drivers/rapidio/switches/tsi568.c
index 322840d..f7fd789 100644
--- a/drivers/rapidio/switches/tsi568.c
+++ b/drivers/rapidio/switches/tsi568.c
@@ -135,6 +135,8 @@ static int tsi568_switch_init(struct rio_dev *rdev, int do_enum)
 	rdev->rswitch->add_entry = tsi568_route_add_entry;
 	rdev->rswitch->get_entry = tsi568_route_get_entry;
 	rdev->rswitch->clr_table = tsi568_route_clr_table;
+	rdev->rswitch->set_domain = NULL;
+	rdev->rswitch->get_domain = NULL;
 	rdev->rswitch->em_init = tsi568_em_init;
 	rdev->rswitch->em_handle = NULL;
 
diff --git a/drivers/rapidio/switches/tsi57x.c b/drivers/rapidio/switches/tsi57x.c
index 2e902d3..d34df72 100644
--- a/drivers/rapidio/switches/tsi57x.c
+++ b/drivers/rapidio/switches/tsi57x.c
@@ -30,13 +30,17 @@
 #define SPP_ROUTE_CFG_PORT(n)	(0x11074 + 0x100*n)
 
 #define TSI578_SP_MODE(n)	(0x11004 + n*0x100)
+#define TSI578_SP_MODE_GLBL	0x10004
 #define  TSI578_SP_MODE_PW_DIS	0x08000000
+#define  TSI578_SP_MODE_LUT_512	0x01000000
 
 #define TSI578_SP_CTL_INDEP(n)	(0x13004 + n*0x100)
 #define TSI578_SP_LUT_PEINF(n)	(0x13010 + n*0x100)
 #define TSI578_SP_CS_TX(n)	(0x13014 + n*0x100)
 #define TSI578_SP_INT_STATUS(n) (0x13018 + n*0x100)
 
+#define TSI578_GLBL_ROUTE_BASE	0x10078
+
 static int
 tsi57x_route_add_entry(struct rio_mport *mport, u16 destid, u8 hopcount,
 		       u16 table, u16 route_destid, u8 route_port)
@@ -113,6 +117,45 @@ tsi57x_route_clr_table(struct rio_mport *mport, u16 destid, u8 hopcount,
 }
 
 static int
+tsi57x_set_domain(struct rio_mport *mport, u16 destid, u8 hopcount,
+		       u8 sw_domain)
+{
+	u32 regval;
+
+	/*
+	 * Switch domain configuration operates only at global level
+	 */
+
+	/* Turn off flat (LUT_512) mode */
+	rio_mport_read_config_32(mport, destid, hopcount,
+				 TSI578_SP_MODE_GLBL, &regval);
+	rio_mport_write_config_32(mport, destid, hopcount, TSI578_SP_MODE_GLBL,
+				  regval & ~TSI578_SP_MODE_LUT_512);
+	/* Set switch domain base */
+	rio_mport_write_config_32(mport, destid, hopcount,
+				  TSI578_GLBL_ROUTE_BASE,
+				  (u32)(sw_domain << 24));
+	return 0;
+}
+
+static int
+tsi57x_get_domain(struct rio_mport *mport, u16 destid, u8 hopcount,
+		       u8 *sw_domain)
+{
+	u32 regval;
+
+	/*
+	 * Switch domain configuration operates only at global level
+	 */
+	rio_mport_read_config_32(mport, destid, hopcount,
+				TSI578_GLBL_ROUTE_BASE, &regval);
+
+	*sw_domain = (u8)(regval >> 24);
+
+	return 0;
+}
+
+static int
 tsi57x_em_init(struct rio_dev *rdev)
 {
 	struct rio_mport *mport = rdev->net->hport;
@@ -258,6 +301,8 @@ static int tsi57x_switch_init(struct rio_dev *rdev, int do_enum)
 	rdev->rswitch->add_entry = tsi57x_route_add_entry;
 	rdev->rswitch->get_entry = tsi57x_route_get_entry;
 	rdev->rswitch->clr_table = tsi57x_route_clr_table;
+	rdev->rswitch->set_domain = tsi57x_set_domain;
+	rdev->rswitch->get_domain = tsi57x_get_domain;
 	rdev->rswitch->em_init = tsi57x_em_init;
 	rdev->rswitch->em_handle = tsi57x_em_handler;
 
diff --git a/include/linux/rio.h b/include/linux/rio.h
index 3d0ac93..19b5f22 100644
--- a/include/linux/rio.h
+++ b/include/linux/rio.h
@@ -238,6 +238,10 @@ struct rio_switch {
 			  u16 table, u16 route_destid, u8 * route_port);
 	int (*clr_table) (struct rio_mport *mport, u16 destid, u8 hopcount,
 			  u16 table);
+	int (*set_domain) (struct rio_mport *mport, u16 destid, u8 hopcount,
+			   u8 sw_domain);
+	int (*get_domain) (struct rio_mport *mport, u16 destid, u8 hopcount,
+			   u8 *sw_domain);
 	int (*em_init) (struct rio_dev *dev);
 	int (*em_handle) (struct rio_dev *dev, u8 swport);
 };
-- 
1.7.0.5

