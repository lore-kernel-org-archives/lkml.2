Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031Ab0ECPs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 11:48:28 -0400
Received: from mxout1.idt.com ([157.165.5.25]:42465 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933001Ab0ECPsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 11:48:22 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
       Alexandre Bounine <alexandre.bounine@idt.com>,
       Matt Porter <mporter@kernel.crashing.org>,
       Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
       Thomas Moll <thomas.moll@sysgo.com>
Subject: [PATCH -mm 5/5] RapidIO: Use default route value for CPS switches
Date: Mon,  3 May 2010 11:45:58 -0400
Message-Id: <1272901558-9292-6-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <1272901558-9292-1-git-send-email-alexandre.bounine@idt.com>
References: <1272901558-9292-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed to use correct default value for routing table entries. 

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Thomas Moll <thomas.moll@sysgo.com>
---
 drivers/rapidio/switches/idtcps.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/rapidio/switches/idtcps.c b/drivers/rapidio/switches/idtcps.c
index 73c3677..2c790c1 100644
--- a/drivers/rapidio/switches/idtcps.c
+++ b/drivers/rapidio/switches/idtcps.c
@@ -15,7 +15,8 @@
 #include <linux/rio_ids.h>
 #include "../rio.h"
 
-#define CPS_NO_ROUTE 0xdf
+#define CPS_DEFAULT_ROUTE	0xde
+#define CPS_NO_ROUTE		0xdf
 
 #define IDTCPS_RIO_DOMAIN 0xf20020
 
@@ -53,10 +54,11 @@ idtcps_route_get_entry(struct rio_mport *mport, u16 destid, u8 hopcount,
 		rio_mport_read_config_32(mport, destid, hopcount,
 				RIO_STD_RTE_CONF_PORT_SEL_CSR, &result);
 
-		if (CPS_NO_ROUTE == (u8)result)
-			result = RIO_INVALID_ROUTE;
-
-		*route_port = (u8)result;
+		if (CPS_DEFAULT_ROUTE == (u8)result ||
+		    CPS_NO_ROUTE == (u8)result)
+			*route_port = RIO_INVALID_ROUTE;
+		else
+			*route_port = (u8)result;
 	}
 
 	return 0;
@@ -74,9 +76,9 @@ idtcps_route_clr_table(struct rio_mport *mport, u16 destid, u8 hopcount,
 				RIO_STD_RTE_CONF_DESTID_SEL_CSR, i);
 			rio_mport_write_config_32(mport, destid, hopcount,
 				RIO_STD_RTE_CONF_PORT_SEL_CSR,
-				(RIO_INVALID_ROUTE << 24) |
-				(RIO_INVALID_ROUTE << 16) |
-				(RIO_INVALID_ROUTE << 8) | RIO_INVALID_ROUTE);
+				(CPS_DEFAULT_ROUTE << 24) |
+				(CPS_DEFAULT_ROUTE << 16) |
+				(CPS_DEFAULT_ROUTE << 8) | CPS_DEFAULT_ROUTE);
 			i += 4;
 		}
 	}
-- 
1.7.0.5

