Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab2FQSYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:24:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50406 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758616Ab2FQSXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:23:04 -0400
Message-Id: <20120617175944.601797243@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:04 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, AnilKumar Ch <anilkumar@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 23/69] can: c_can: fix race condition in c_can_open()
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AnilKumar Ch <anilkumar@ti.com>

commit f461f27a4436dbe691908fe08b867ef888848cc3 upstream.

Fix the issue of C_CAN interrupts getting disabled forever when canconfig
utility is used multiple times. According to NAPI usage we disable all
the hardware interrupts in ISR and re-enable them in poll(). Current
implementation calls napi_enable() after hardware interrupts are enabled.
If we get any interrupts between these two steps then we do not process
those interrupts because napi is not enabled. Mostly these interrupts
come because of STATUS is not 0x7 or ERROR interrupts. If napi_enable()
happens before HW interrupts enabled then c_can_poll() function will be
called eventual re-enabling.

This patch moves the napi_enable() call before interrupts enabled.

Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
Acked-by: Wolfgang Grandegger <wg@grandegger.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/can/c_can/c_can.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index fa01621..8dc84d6 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -1064,10 +1064,11 @@ static int c_can_open(struct net_device *dev)
 		goto exit_irq_fail;
 	}
 
+	napi_enable(&priv->napi);
+
 	/* start the c_can controller */
 	c_can_start(dev);
 
-	napi_enable(&priv->napi);
 	netif_start_queue(dev);
 
 	return 0;


