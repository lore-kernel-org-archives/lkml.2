Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab1AUO2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 09:28:48 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:50385 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab1AUO2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 09:28:47 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 21 Jan 2011 15:28:28 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire updates post 2.6.38-rc1
Message-ID: <20110121152828.0c9a308d@stein>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the fixes and fwnet branches at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git fixes
    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git fwnet

to receive (a) an update which waited on a new net/ EXPORT_SYMBOL,
(b) a regression fix for the IEEE 1394 (FireWire) subsystem.  Thanks.

Maxim Levitsky (1):
      firewire: net: invalidate ARP entries of removed nodes

Stefan Richter (2):
      firewire: core: fix unstable I/O with Canon camcorder
      firewire: net: is not experimental anymore

 drivers/firewire/Kconfig     |    6 ++----
 drivers/firewire/core-card.c |   11 +++++++++--
 drivers/firewire/net.c       |    9 ++++++++-
 3 files changed, 19 insertions(+), 7 deletions(-)


diff --git a/drivers/firewire/Kconfig b/drivers/firewire/Kconfig
index 68f942c..0c56989 100644
--- a/drivers/firewire/Kconfig
+++ b/drivers/firewire/Kconfig
@@ -49,15 +49,13 @@ config FIREWIRE_SBP2
 	  configuration section.
 
 config FIREWIRE_NET
-	tristate "IP networking over 1394 (EXPERIMENTAL)"
-	depends on FIREWIRE && INET && EXPERIMENTAL
+	tristate "IP networking over 1394"
+	depends on FIREWIRE && INET
 	help
 	  This enables IPv4 over IEEE 1394, providing IP connectivity with
 	  other implementations of RFC 2734 as found on several operating
 	  systems.  Multicast support is currently limited.
 
-	  NOTE, this driver is not stable yet!
-
 	  To compile this driver as a module, say M here:  The module will be
 	  called firewire-net.
 
diff --git a/drivers/firewire/core-card.c b/drivers/firewire/core-card.c
index be04923..24ff355 100644
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -75,6 +75,8 @@ static size_t config_rom_length = 1 + 4 + 1 + 1;
 #define BIB_IRMC		((1) << 31)
 #define NODE_CAPABILITIES	0x0c0083c0 /* per IEEE 1394 clause 8.3.2.6.5.2 */
 
+#define CANON_OUI		0x000085
+
 static void generate_config_rom(struct fw_card *card, __be32 *config_rom)
 {
 	struct fw_descriptor *desc;
@@ -284,6 +286,7 @@ static void bm_work(struct work_struct *work)
 	bool root_device_is_running;
 	bool root_device_is_cmc;
 	bool irm_is_1394_1995_only;
+	bool keep_this_irm;
 
 	spin_lock_irq(&card->lock);
 
@@ -305,6 +308,10 @@ static void bm_work(struct work_struct *work)
 	irm_is_1394_1995_only = irm_device && irm_device->config_rom &&
 			(irm_device->config_rom[2] & 0x000000f0) == 0;
 
+	/* Canon MV5i works unreliably if it is not root node. */
+	keep_this_irm = irm_device && irm_device->config_rom &&
+			irm_device->config_rom[3] >> 8 == CANON_OUI;
+
 	root_id  = root_node->node_id;
 	irm_id   = card->irm_node->node_id;
 	local_id = card->local_node->node_id;
@@ -333,7 +340,7 @@ static void bm_work(struct work_struct *work)
 			goto pick_me;
 		}
 
-		if (irm_is_1394_1995_only) {
+		if (irm_is_1394_1995_only && !keep_this_irm) {
 			new_root_id = local_id;
 			fw_notify("%s, making local node (%02x) root.\n",
 				  "IRM is not 1394a compliant", new_root_id);
@@ -382,7 +389,7 @@ static void bm_work(struct work_struct *work)
 
 		spin_lock_irq(&card->lock);
 
-		if (rcode != RCODE_COMPLETE) {
+		if (rcode != RCODE_COMPLETE && !keep_this_irm) {
 			/*
 			 * The lock request failed, maybe the IRM
 			 * isn't really IRM capable after all. Let's
diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index c2e194c..7ed08fd 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -191,6 +191,7 @@ struct fwnet_peer {
 	struct fwnet_device *dev;
 	u64 guid;
 	u64 fifo;
+	__be32 ip;
 
 	/* guarded by dev->lock */
 	struct list_head pd_list; /* received partial datagrams */
@@ -570,6 +571,8 @@ static int fwnet_finish_incoming_packet(struct net_device *net,
 				peer->speed = sspd;
 			if (peer->max_payload > max_payload)
 				peer->max_payload = max_payload;
+
+			peer->ip = arp1394->sip;
 		}
 		spin_unlock_irqrestore(&dev->lock, flags);
 
@@ -1470,6 +1473,7 @@ static int fwnet_add_peer(struct fwnet_device *dev,
 	peer->dev = dev;
 	peer->guid = (u64)device->config_rom[3] << 32 | device->config_rom[4];
 	peer->fifo = FWNET_NO_FIFO_ADDR;
+	peer->ip = 0;
 	INIT_LIST_HEAD(&peer->pd_list);
 	peer->pdg_size = 0;
 	peer->datagram_label = 0;
@@ -1589,10 +1593,13 @@ static int fwnet_remove(struct device *_dev)
 
 	mutex_lock(&fwnet_device_mutex);
 
+	net = dev->netdev;
+	if (net && peer->ip)
+		arp_invalidate(net, peer->ip);
+
 	fwnet_remove_peer(peer, dev);
 
 	if (list_empty(&dev->peer_list)) {
-		net = dev->netdev;
 		unregister_netdev(net);
 
 		if (dev->local_fifo != FWNET_NO_FIFO_ADDR)

-- 
Stefan Richter
-=====-==-== ---= =-=-=
http://arcgraph.de/sr/
