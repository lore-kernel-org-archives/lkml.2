Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab2BRVCo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 16:02:44 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52752 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab2BRVCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 16:02:43 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 18 Feb 2012 22:02:33 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] firewire: net: prefix all log messages with interface
 name
Message-ID: <20120218220233.5d67b31a@stein>
In-Reply-To: <20120218215824.5b2359bf@stein>
References: <20120218215824.5b2359bf@stein>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the log line prefix from "firewire_net: " to
"firewire_net firewire0: " etc. for the case that several RFC 2734
interfaces are being used in the same machine.  Despite this addition,
module size is a little bit decreased because KBUILD_MODNAME is now
moved from the format strings into a %s argument.

Note, the kernel's stock functions are not very useful to firewire-net:

    dev_notice(&net->dev, "abc\n"); -> net firewire0: abc
    netdev_notice(net, "abc\n");    -> firewire_ohci 0000:0a:00.0: firewire0: abc

Nor would be a dev_printk on the fw_unit.device to which firewire-net is
being bound, because there are generally multiple ones of those per
interface (from all RFC 2734 peers on the bus, the local node being only
one of them).

In the initialization message of each interface, log the PCI device
name of the card which is parent of the netdevice instead of the GUID
of the peer which was semi-randomly used to establish the netdevice.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/net.c |   43 ++++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 18 deletions(-)

--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -29,6 +29,11 @@
 #include <asm/unaligned.h>
 #include <net/arp.h>
 
+#define fwnet_notice(net, fmt, args...) \
+	printk(KERN_NOTICE "%s %s: " fmt, KBUILD_MODNAME, (net)->name, ## args)
+#define fwnet_err(net, fmt, args...) \
+	printk(KERN_ERR "%s %s: " fmt, KBUILD_MODNAME, (net)->name, ## args)
+
 /* rx limits */
 #define FWNET_MAX_FRAGMENTS		30 /* arbitrary, > TX queue depth */
 #define FWNET_ISO_PAGE_COUNT		(PAGE_SIZE < 16*1024 ? 4 : 2)
@@ -256,8 +261,8 @@ static int fwnet_header_rebuild(struct s
 	if (get_unaligned_be16(&h->h_proto) == ETH_P_IP)
 		return arp_find((unsigned char *)&h->h_dest, skb);
 
-	fw_notify("%s: unable to resolve type %04x addresses\n",
-		  skb->dev->name, be16_to_cpu(h->h_proto));
+	fwnet_notice(skb->dev, "unable to resolve type %04x addresses\n",
+		     be16_to_cpu(h->h_proto));
 	return 0;
 }
 
@@ -369,7 +374,7 @@ static struct fwnet_fragment_info *fwnet
 
 	new = kmalloc(sizeof(*new), GFP_ATOMIC);
 	if (!new) {
-		fw_error("out of memory\n");
+		fwnet_err(pd->skb->dev, "out of memory\n");
 		return NULL;
 	}
 
@@ -414,7 +419,7 @@ fail_w_fi:
 fail_w_new:
 	kfree(new);
 fail:
-	fw_error("out of memory\n");
+	fwnet_err(net, "out of memory\n");
 
 	return NULL;
 }
@@ -554,7 +559,7 @@ static int fwnet_finish_incoming_packet(
 		sspd = arp1394->sspd;
 		/* Sanity check.  OS X 10.3 PPC reportedly sends 131. */
 		if (sspd > SCODE_3200) {
-			fw_notify("sspd %x out of range\n", sspd);
+			fwnet_notice(net, "sspd %x out of range\n", sspd);
 			sspd = SCODE_3200;
 		}
 		max_payload = fwnet_max_payload(arp1394->max_rec, sspd);
@@ -574,8 +579,8 @@ static int fwnet_finish_incoming_packet(
 		spin_unlock_irqrestore(&dev->lock, flags);
 
 		if (!peer) {
-			fw_notify("No peer for ARP packet from %016llx\n",
-				  (unsigned long long)peer_guid);
+			fwnet_notice(net, "no peer for ARP packet from %016llx\n",
+				     (unsigned long long)peer_guid);
 			goto no_peer;
 		}
 
@@ -691,7 +696,7 @@ static int fwnet_incoming_packet(struct
 
 		skb = dev_alloc_skb(len + net->hard_header_len + 15);
 		if (unlikely(!skb)) {
-			fw_error("out of memory\n");
+			fwnet_err(net, "out of memory\n");
 			net->stats.rx_dropped++;
 
 			return -ENOMEM;
@@ -814,7 +819,7 @@ static void fwnet_receive_packet(struct
 		rcode = RCODE_TYPE_ERROR;
 	else if (fwnet_incoming_packet(dev, payload, length,
 				       source, generation, false) != 0) {
-		fw_error("Incoming packet failure\n");
+		fwnet_err(dev->netdev, "incoming packet failure\n");
 		rcode = RCODE_CONFLICT_ERROR;
 	} else
 		rcode = RCODE_COMPLETE;
@@ -881,7 +886,7 @@ static void fwnet_receive_broadcast(stru
 	if (retval >= 0)
 		fw_iso_context_queue_flush(dev->broadcast_rcv_context);
 	else
-		fw_error("requeue failed\n");
+		fwnet_err(dev->netdev, "requeue failed\n");
 }
 
 static struct kmem_cache *fwnet_packet_task_cache;
@@ -936,9 +941,10 @@ static void fwnet_transmit_packet_done(s
 		case RFC2374_HDR_LASTFRAG:
 		case RFC2374_HDR_UNFRAG:
 		default:
-			fw_error("Outstanding packet %x lf %x, header %x,%x\n",
-				 ptask->outstanding_pkts, lf, ptask->hdr.w0,
-				 ptask->hdr.w1);
+			fwnet_err(dev->netdev,
+				  "outstanding packet %x lf %x, header %x,%x\n",
+				  ptask->outstanding_pkts, lf, ptask->hdr.w0,
+				  ptask->hdr.w1);
 			BUG();
 
 		case RFC2374_HDR_FIRSTFRAG:
@@ -1010,8 +1016,9 @@ static void fwnet_write_complete(struct
 		fwnet_transmit_packet_failed(ptask);
 
 		if (printk_timed_ratelimit(&j,  1000) || rcode != last_rcode) {
-			fw_error("fwnet_write_complete: "
-				"failed: %x (skipped %d)\n", rcode, errors_skipped);
+			fwnet_err(ptask->dev->netdev,
+				  "fwnet_write_complete failed: %x (skipped %d)\n",
+				  rcode, errors_skipped);
 
 			errors_skipped = 0;
 			last_rcode = rcode;
@@ -1540,13 +1547,13 @@ static int fwnet_probe(struct device *_d
 	put_unaligned_be64(~0ULL, net->broadcast);
 	ret = register_netdev(net);
 	if (ret) {
-		fw_error("Cannot register the driver\n");
+		fwnet_err(net, "cannot register the driver\n");
 		goto out;
 	}
 
 	list_add_tail(&dev->dev_link, &fwnet_device_list);
-	fw_notify("%s: IPv4 over FireWire on device %016llx\n",
-		  net->name, (unsigned long long)card->guid);
+	fwnet_notice(net, "IPv4 over FireWire on card %s\n",
+		     dev_name(card->device));
  have_dev:
 	ret = fwnet_add_peer(dev, unit, device);
 	if (ret && allocated_netdev) {


-- 
Stefan Richter
-=====-===-- --=- =--=-
http://arcgraph.de/sr/
