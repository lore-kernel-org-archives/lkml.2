Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934229Ab1ESSN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:13:56 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58034 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934074Ab1ESSJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:09:12 -0400
X-Sasl-enc: GtYW2TaBm1R6xPRXi42Zfzg/n/JymUODiuOQOCGGQXdU 1305828551
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:59 2011
Message-Id: <20110519180559.451207499@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Thomas Moll <thomas.moll@sysgo.com>
Subject: [54/71] rapidio: fix default routing initialization
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexandre Bounine <alexandre.bounine@idt.com>

commit 0bf2461fdd9008290cf429e50e4f362dafab4249 upstream.

Fix switch initialization to ensure that all switches have default routing
disabled.  This guarantees that no unexpected RapidIO packets arrive to
the default port set by reset and there is no default routing destination
until it is properly configured by software.

This update also unifies handling of unmapped destinations by tsi57x, IDT
Gen1 and IDT Gen2 switches.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rapidio/switches/idt_gen2.c |    9 +++++++++
 drivers/rapidio/switches/idtcps.c   |    6 ++++++
 drivers/rapidio/switches/tsi57x.c   |    6 ++++++
 3 files changed, 21 insertions(+)

--- a/drivers/rapidio/switches/idt_gen2.c
+++ b/drivers/rapidio/switches/idt_gen2.c
@@ -95,6 +95,9 @@ idtg2_route_add_entry(struct rio_mport *
 	else
 		table++;
 
+	if (route_port == RIO_INVALID_ROUTE)
+		route_port = IDT_DEFAULT_ROUTE;
+
 	rio_mport_write_config_32(mport, destid, hopcount,
 				  LOCAL_RTE_CONF_DESTID_SEL, table);
 
@@ -411,6 +414,12 @@ static int idtg2_switch_init(struct rio_
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
 
--- a/drivers/rapidio/switches/idtcps.c
+++ b/drivers/rapidio/switches/idtcps.c
@@ -26,6 +26,9 @@ idtcps_route_add_entry(struct rio_mport
 {
 	u32 result;
 
+	if (route_port == RIO_INVALID_ROUTE)
+		route_port = CPS_DEFAULT_ROUTE;
+
 	if (table == RIO_GLOBAL_TABLE) {
 		rio_mport_write_config_32(mport, destid, hopcount,
 				RIO_STD_RTE_CONF_DESTID_SEL_CSR, route_destid);
@@ -130,6 +133,9 @@ static int idtcps_switch_init(struct rio
 		/* set TVAL = ~50us */
 		rio_write_config_32(rdev,
 			rdev->phys_efptr + RIO_PORT_LINKTO_CTL_CSR, 0x8e << 8);
+		/* Ensure that default routing is disabled on startup */
+		rio_write_config_32(rdev,
+				    RIO_STD_RTE_DEFAULT_PORT, CPS_NO_ROUTE);
 	}
 
 	return 0;
--- a/drivers/rapidio/switches/tsi57x.c
+++ b/drivers/rapidio/switches/tsi57x.c
@@ -303,6 +303,12 @@ static int tsi57x_switch_init(struct rio
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
 


