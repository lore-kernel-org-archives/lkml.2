Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab2IRS3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:29:09 -0400
Received: from mxout1.idt.com ([157.165.5.25]:38555 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab2IRS3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:29:04 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>
Subject: [PATCH RESEND] rapidio: apply RX/TX enable to active switch ports only
Date: Tue, 18 Sep 2012 14:27:13 -0400
Message-Id: <1347992833-13744-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apply port RX/TX enable operations only to active switch ports.

RapidIO specification (Part 6: LP-Serial Physical Layer)
recommends to keep Output Port Enable (TX) and Input Port Enable (RX)
control bits in disabled state (0b0) after device reset. It also allows
to have implementation specific reset state for these bits.

This patch ensures that TX/RX enable action is applied only to active
switch's ports while preserving an initial state of inactive ones.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
---

RESEND: Initial submission of this patch was dropped due to feedback
comment which raised concern about some RapidIO switch implementations
that may be affected by the change. After specification and device details
review this patch declared to be safe because it preserves any combination
of initial states of RX/TX enable for inactive port. 

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

