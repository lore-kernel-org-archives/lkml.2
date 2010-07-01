Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460Ab0GASeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:34:24 -0400
Received: from kroah.org ([198.145.64.141]:40710 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758076Ab0GASYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:24:04 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:15 2010
Message-Id: <20100701173215.923278556@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:32:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Hutchings <ben@decadent.org.uk>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 108/149] via-velocity: Give RX descriptors to the NIC later on open or MTU change
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 35bb5cadc8c7b1462df57e32e08d964f1be7a75c upstream.

velocity_open() calls velocity_give_many_rx_descs(), which gives RX
descriptors to the NIC, before installing an interrupt handler or
calling velocity_init_registers().  I think this is very unsafe and it
appears to explain the bug report <http://bugs.debian.org/508527>.

On MTU change, velocity_give_many_rx_descs() is again called before
velocity_init_registers().  I'm not sure whether this is unsafe but
it does look wrong.

Therefore, move the calls to velocity_give_many_rx_descs() after
request_irq() and velocity_init_registers().

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Tested-by: Jan Ceuleers <jan.ceuleers@computer.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/via-velocity.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/via-velocity.c
+++ b/drivers/net/via-velocity.c
@@ -2186,8 +2186,6 @@ static int velocity_open(struct net_devi
 	/* Ensure chip is running */
 	pci_set_power_state(vptr->pdev, PCI_D0);
 
-	velocity_give_many_rx_descs(vptr);
-
 	velocity_init_registers(vptr, VELOCITY_INIT_COLD);
 
 	ret = request_irq(vptr->pdev->irq, &velocity_intr, IRQF_SHARED,
@@ -2199,6 +2197,8 @@ static int velocity_open(struct net_devi
 		goto out;
 	}
 
+	velocity_give_many_rx_descs(vptr);
+
 	mac_enable_int(vptr->mac_regs);
 	netif_start_queue(dev);
 	vptr->flags |= VELOCITY_FLAGS_OPENED;
@@ -2287,10 +2287,10 @@ static int velocity_change_mtu(struct ne
 
 		dev->mtu = new_mtu;
 
-		velocity_give_many_rx_descs(vptr);
-
 		velocity_init_registers(vptr, VELOCITY_INIT_COLD);
 
+		velocity_give_many_rx_descs(vptr);
+
 		mac_enable_int(vptr->mac_regs);
 		netif_start_queue(dev);
 


