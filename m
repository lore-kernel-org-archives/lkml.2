Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab0JROJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:09:53 -0400
Received: from mxout1.idt.com ([157.165.5.25]:55193 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172Ab0JROJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:09:52 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Thomas Moll <thomas.moll@sysgo.com>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: [PATCH -mm 2/2] RapidIO: Fix destructive port EM initialization for Tsi568
Date: Mon, 18 Oct 2010 10:03:20 -0400
Message-Id: <1287410600-24783-2-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1287410600-24783-1-git-send-email-alexandre.bounine@idt.com>
References: <1287410600-24783-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaces possibly damaging broadcast writes into the per-port SP_MODE
registers with individual writes for each port. This will preserve
individual port configurations in case if ports are configured differently.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
---
 drivers/rapidio/switches/tsi568.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/rapidio/switches/tsi568.c b/drivers/rapidio/switches/tsi568.c
index f7fd789..b9a389b 100644
--- a/drivers/rapidio/switches/tsi568.c
+++ b/drivers/rapidio/switches/tsi568.c
@@ -29,7 +29,7 @@
 #define SPP_ROUTE_CFG_DESTID(n)	(0x11070 + 0x100*n)
 #define SPP_ROUTE_CFG_PORT(n)	(0x11074 + 0x100*n)
 
-#define TSI568_SP_MODE_BC	0x10004
+#define TSI568_SP_MODE(n)	(0x11004 + 0x100*n)
 #define  TSI568_SP_MODE_PW_DIS	0x08000000
 
 static int
@@ -117,14 +117,19 @@ tsi568_em_init(struct rio_dev *rdev)
 	u16 destid = rdev->rswitch->destid;
 	u8 hopcount = rdev->rswitch->hopcount;
 	u32 regval;
+	int portnum;
 
 	pr_debug("TSI568 %s [%d:%d]\n", __func__, destid, hopcount);
 
 	/* Make sure that Port-Writes are disabled (for all ports) */
-	rio_mport_read_config_32(mport, destid, hopcount,
-			TSI568_SP_MODE_BC, &regval);
-	rio_mport_write_config_32(mport, destid, hopcount,
-			TSI568_SP_MODE_BC, regval | TSI568_SP_MODE_PW_DIS);
+	for (portnum = 0;
+	     portnum < RIO_GET_TOTAL_PORTS(rdev->swpinfo); portnum++) {
+		rio_mport_read_config_32(mport, destid, hopcount,
+				TSI568_SP_MODE(portnum), &regval);
+		rio_mport_write_config_32(mport, destid, hopcount,
+				TSI568_SP_MODE(portnum),
+				regval | TSI568_SP_MODE_PW_DIS);
+	}
 
 	return 0;
 }
-- 
1.7.3.1

