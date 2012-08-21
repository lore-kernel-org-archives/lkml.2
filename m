Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab2HUOZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 10:25:12 -0400
Received: from mxout1.idt.com ([157.165.5.25]:39376 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919Ab2HUOZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 10:25:01 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>
Subject: [PATCH] rapidio: apply RX/TX enable to active switch ports only
Date: Tue, 21 Aug 2012 10:23:55 -0400
Message-Id: <1345559035-25879-2-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1345559035-25879-1-git-send-email-alexandre.bounine@idt.com>
References: <1345559035-25879-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify RIO enumeration to apply RX/TX enable operations only to active
switch ports. This will leave inactive ports in condition consistent with
their state.

This patch is applicable to kernel versions starting from v2.6.35.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
---
 drivers/rapidio/rio-scan.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index 2bebd79..02e686b 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -839,12 +839,10 @@ static int __devinit rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 		for (port_num = 0;
 		     port_num < RIO_GET_TOTAL_PORTS(rdev->swpinfo);
 		     port_num++) {
-			/*Enable Input Output Port (transmitter reviever)*/
-			rio_enable_rx_tx_port(port, 0,
+			if (sw_inport == port_num) {
+				rio_enable_rx_tx_port(port, 0,
 					      RIO_ANY_DESTID(port->sys_size),
 					      hopcount, port_num);
-
-			if (sw_inport == port_num) {
 				rdev->rswitch->port_ok |= (1 << port_num);
 				continue;
 			}
@@ -857,6 +855,9 @@ static int __devinit rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 				pr_debug(
 				    "RIO: scanning device on port %d\n",
 				    port_num);
+				rio_enable_rx_tx_port(port, 0,
+					      RIO_ANY_DESTID(port->sys_size),
+					      hopcount, port_num);
 				rdev->rswitch->port_ok |= (1 << port_num);
 				rio_route_add_entry(rdev, RIO_GLOBAL_TABLE,
 						RIO_ANY_DESTID(port->sys_size),
-- 
1.7.8.4

