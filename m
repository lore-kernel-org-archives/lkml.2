Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab2FZS5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 14:57:10 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:37207 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab2FZSz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 14:55:59 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-pcmcia@lists.infradead.org
Subject: [PATCH -v12 11/15] pcmcia: Remove workaround for fixing pci parent bus subordinate
Date: Tue, 26 Jun 2012 11:54:05 -0700
Message-Id: <1340736849-14875-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
References: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now pci busn allocation code is there, and it will preallocate bus number and it
will make sure parent buses subordinate is right.

So remove workaround here.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Tested-by: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-pcmcia@lists.infradead.org
---
 drivers/pcmcia/yenta_socket.c |   75 -----------------------------------------
 1 files changed, 0 insertions(+), 75 deletions(-)

diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index 667678d..7e42bb4 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -1064,79 +1064,6 @@ static void yenta_config_init(struct yenta_socket *socket)
 	config_writew(socket, CB_BRIDGE_CONTROL, bridge);
 }
 
-/**
- * yenta_fixup_parent_bridge - Fix subordinate bus# of the parent bridge
- * @cardbus_bridge: The PCI bus which the CardBus bridge bridges to
- *
- * Checks if devices on the bus which the CardBus bridge bridges to would be
- * invisible during PCI scans because of a misconfigured subordinate number
- * of the parent brige - some BIOSes seem to be too lazy to set it right.
- * Does the fixup carefully by checking how far it can go without conflicts.
- * See http://bugzilla.kernel.org/show_bug.cgi?id=2944 for more information.
- */
-static void yenta_fixup_parent_bridge(struct pci_bus *cardbus_bridge)
-{
-	struct list_head *tmp;
-	unsigned char upper_limit;
-	/*
-	 * We only check and fix the parent bridge: All systems which need
-	 * this fixup that have been reviewed are laptops and the only bridge
-	 * which needed fixing was the parent bridge of the CardBus bridge:
-	 */
-	struct pci_bus *bridge_to_fix = cardbus_bridge->parent;
-
-	/* Check bus numbers are already set up correctly: */
-	if (bridge_to_fix->busn_res.end >= cardbus_bridge->busn_res.end)
-		return; /* The subordinate number is ok, nothing to do */
-
-	if (!bridge_to_fix->parent)
-		return; /* Root bridges are ok */
-
-	/* stay within the limits of the bus range of the parent: */
-	upper_limit = bridge_to_fix->parent->busn_res.end;
-
-	/* check the bus ranges of all silbling bridges to prevent overlap */
-	list_for_each(tmp, &bridge_to_fix->parent->children) {
-		struct pci_bus *silbling = pci_bus_b(tmp);
-		/*
-		 * If the silbling has a higher secondary bus number
-		 * and it's secondary is equal or smaller than our
-		 * current upper limit, set the new upper limit to
-		 * the bus number below the silbling's range:
-		 */
-		if (silbling->busn_res.start > bridge_to_fix->busn_res.end
-		    && silbling->busn_res.start <= upper_limit)
-			upper_limit = silbling->busn_res.start - 1;
-	}
-
-	/* Show that the wanted subordinate number is not possible: */
-	if (cardbus_bridge->busn_res.end > upper_limit)
-		dev_printk(KERN_WARNING, &cardbus_bridge->dev,
-			   "Upper limit for fixing this "
-			   "bridge's parent bridge: #%02x\n", upper_limit);
-
-	/* If we have room to increase the bridge's subordinate number, */
-	if (bridge_to_fix->busn_res.end < upper_limit) {
-
-		/* use the highest number of the hidden bus, within limits */
-		unsigned char subordinate_to_assign =
-			min_t(int, cardbus_bridge->busn_res.end, upper_limit);
-
-		dev_printk(KERN_INFO, &bridge_to_fix->dev,
-			   "Raising subordinate bus# of parent "
-			   "bus (#%02x) from #%02x to #%02x\n",
-			   bridge_to_fix->number,
-			   (int)bridge_to_fix->busn_res.end, subordinate_to_assign);
-
-		/* Save the new subordinate in the bus struct of the bridge */
-		bridge_to_fix->busn_res.end = subordinate_to_assign;
-
-		/* and update the PCI config space with the new subordinate */
-		pci_write_config_byte(bridge_to_fix->self,
-			PCI_SUBORDINATE_BUS, bridge_to_fix->busn_res.end);
-	}
-}
-
 /*
  * Initialize a cardbus controller. Make sure we have a usable
  * interrupt, and that we can map the cardbus area. Fill in the
@@ -1257,8 +1184,6 @@ static int __devinit yenta_probe(struct pci_dev *dev, const struct pci_device_id
 	dev_printk(KERN_INFO, &dev->dev,
 		   "Socket status: %08x\n", cb_readl(socket, CB_SOCKET_STATE));
 
-	yenta_fixup_parent_bridge(dev->subordinate);
-
 	/* Register it with the pcmcia layer.. */
 	ret = pcmcia_register_socket(&socket->socket);
 	if (ret == 0) {
-- 
1.7.7

