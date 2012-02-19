Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab2BSLsx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 06:48:53 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57194 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab2BSLsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 06:48:51 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 19 Feb 2012 12:48:36 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Joe Perches <joe@perches.com>, linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] firewire: net: prefix all log messages with
 interface name
Message-ID: <20120219124836.0fd5ead8@stein>
In-Reply-To: <1329600742.1753.20.camel@joe2Laptop>
References: <20120218215824.5b2359bf@stein>
	<20120218220233.5d67b31a@stein>
	<1329600742.1753.20.camel@joe2Laptop>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 18 Joe Perches wrote:
> On Sat, 2012-02-18 at 22:02 +0100, Stefan Richter wrote:
> > Change the log line prefix from "firewire_net: " to
> > "firewire_net firewire0: " etc. for the case that several RFC 2734
> > interfaces are being used in the same machine.
> 
> Why not just "firewireX: " ?

The double prefix is strangely verbose and pedantic, but it does make
immediately obvious which driver emitted the message (as opposed to one of
the lower-level firewire drivers, or one of the upper-level networking
drivers).

For somebody who is familiar with the drivers --- or after full text search
through the source --- the firewire_net part is of course superfluous.

> []
> > +#define fwnet_notice(net, fmt, args...) \
> > +	printk(KERN_NOTICE "%s %s: " fmt, KBUILD_MODNAME, (net)->name, ## args)
> > +#define fwnet_err(net, fmt, args...) \
> > +	printk(KERN_ERR "%s %s: " fmt, KBUILD_MODNAME, (net)->name, ## args)
> 
> Adding code for the "%s:...", KBUILD_MODNAME rarely saves
> overall space.  Did you try embedding KBUILD_MODNAME
> without the "%s: " and comparing the size?
> 
> Perhaps just add pr_fmt and pr_<level>?
> 
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt 	/* (if really necessary) */
> 
> and
> 
> #define fwnet_notice(net, fmt, ...)		\
> 	pr_notice("%s: " fmt, (net)->name, ##__VA_ARGS__)
> #define fwnet_err(net, fmt, ...)		\
> 	pr_err("%s: " fmt, (net)->name, ##__VA_ARGS__)

I think I tried it when I wrote the patch, hence the "module size is a
little bit decreased because KBUILD_MODNAME is now moved from the format
strings into a %s argument" in the changelog.  But I wrote this quite a
while ago, so I better try again.

This is on linux-3.2 elf64-x86-64 with a few debug options, gcc-4.5.3.
Before yesterday's patch:
$ size firewire-net.ko; du -b firewire-net.ko
   text    data     bss     dec     hex filename
   9499     744      24   10267    281b firewire-net.ko
209777  firewire-net.ko

With the patch that I posted yesterday:
   text    data     bss     dec     hex filename
   9613     744      24   10381    288d firewire-net.ko
210056  firewire-net.ko

Weird, I must have done something differently back then.  Wrongly, for
example.

With module name in the format strings:
#define fwnet_notice(net, fmt, args...) \
	printk(KERN_NOTICE KBUILD_MODNAME " %s: " fmt, (net)->name, ## args)
#define fwnet_err(net, fmt, args...) \
	printk(KERN_ERR KBUILD_MODNAME " %s: " fmt, (net)->name, ## args)

   text    data     bss     dec     hex filename
   9613     744      24   10381    288d firewire-net.ko
209760  firewire-net.ko

Without the module name, i.e.:
#define fwnet_notice(net, fmt, args...) \
	printk(KERN_NOTICE "%s: " fmt, (net)->name, ## args)
#define fwnet_err(net, fmt, args...) \
	printk(KERN_ERR "%s: " fmt, (net)->name, ## args)

   text    data     bss     dec     hex filename
   9483     744      24   10251    280b firewire-net.ko
209632  firewire-net.ko

So how about the following patch, for sake of countering kernel bloat?
   text    data     bss     dec     hex filename
   9430     744      24   10198    27d6 firewire-net.ko
209659  firewire-net.ko

--------------------------------- 8< ---------------------------------

Subject: [PATCH 3/4] firewire: net: use dev_printk API

Change the log line prefix from "firewire_net: " to "net firewire0: "
etc. for the case that several RFC 2734 interfaces are being used in the
same machine.

Note, the netdev_printk API is not very useful to firewire-net.
netdev_notice(net, "abc\n") would result in irritating messages like
"firewire_ohci 0000:0a:00.0: firewire0: abc".  Nor would a dev_printk on
the fw_unit.device to which firewire-net is being bound be useful,
because there are generally multiple ones of those per interface (from
all RFC 2734 peers on the bus, the local node being only one of them).

In the initialization message of each interface, log the PCI device
name of the card which is parent of the netdevice instead of the GUID
of the peer which was semi-randomly used to establish the netdevice.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/net.c |   41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -256,8 +256,8 @@ static int fwnet_header_rebuild(struct s
 	if (get_unaligned_be16(&h->h_proto) == ETH_P_IP)
 		return arp_find((unsigned char *)&h->h_dest, skb);
 
-	fw_notify("%s: unable to resolve type %04x addresses\n",
-		  skb->dev->name, be16_to_cpu(h->h_proto));
+	dev_notice(&skb->dev->dev, "unable to resolve type %04x addresses\n",
+		   be16_to_cpu(h->h_proto));
 	return 0;
 }
 
@@ -369,7 +369,7 @@ static struct fwnet_fragment_info *fwnet
 
 	new = kmalloc(sizeof(*new), GFP_ATOMIC);
 	if (!new) {
-		fw_error("out of memory\n");
+		dev_err(&pd->skb->dev->dev, "out of memory\n");
 		return NULL;
 	}
 
@@ -414,7 +414,7 @@ fail_w_fi:
 fail_w_new:
 	kfree(new);
 fail:
-	fw_error("out of memory\n");
+	dev_err(&net->dev, "out of memory\n");
 
 	return NULL;
 }
@@ -554,7 +554,7 @@ static int fwnet_finish_incoming_packet(
 		sspd = arp1394->sspd;
 		/* Sanity check.  OS X 10.3 PPC reportedly sends 131. */
 		if (sspd > SCODE_3200) {
-			fw_notify("sspd %x out of range\n", sspd);
+			dev_notice(&net->dev, "sspd %x out of range\n", sspd);
 			sspd = SCODE_3200;
 		}
 		max_payload = fwnet_max_payload(arp1394->max_rec, sspd);
@@ -574,8 +574,9 @@ static int fwnet_finish_incoming_packet(
 		spin_unlock_irqrestore(&dev->lock, flags);
 
 		if (!peer) {
-			fw_notify("No peer for ARP packet from %016llx\n",
-				  (unsigned long long)peer_guid);
+			dev_notice(&net->dev,
+				   "no peer for ARP packet from %016llx\n",
+				   (unsigned long long)peer_guid);
 			goto no_peer;
 		}
 
@@ -691,7 +692,7 @@ static int fwnet_incoming_packet(struct
 
 		skb = dev_alloc_skb(len + net->hard_header_len + 15);
 		if (unlikely(!skb)) {
-			fw_error("out of memory\n");
+			dev_err(&net->dev, "out of memory\n");
 			net->stats.rx_dropped++;
 
 			return -ENOMEM;
@@ -814,7 +815,7 @@ static void fwnet_receive_packet(struct
 		rcode = RCODE_TYPE_ERROR;
 	else if (fwnet_incoming_packet(dev, payload, length,
 				       source, generation, false) != 0) {
-		fw_error("Incoming packet failure\n");
+		dev_err(&dev->netdev->dev, "incoming packet failure\n");
 		rcode = RCODE_CONFLICT_ERROR;
 	} else
 		rcode = RCODE_COMPLETE;
@@ -881,7 +882,7 @@ static void fwnet_receive_broadcast(stru
 	if (retval >= 0)
 		fw_iso_context_queue_flush(dev->broadcast_rcv_context);
 	else
-		fw_error("requeue failed\n");
+		dev_err(&dev->netdev->dev, "requeue failed\n");
 }
 
 static struct kmem_cache *fwnet_packet_task_cache;
@@ -936,9 +937,10 @@ static void fwnet_transmit_packet_done(s
 		case RFC2374_HDR_LASTFRAG:
 		case RFC2374_HDR_UNFRAG:
 		default:
-			fw_error("Outstanding packet %x lf %x, header %x,%x\n",
-				 ptask->outstanding_pkts, lf, ptask->hdr.w0,
-				 ptask->hdr.w1);
+			dev_err(&dev->netdev->dev,
+				"outstanding packet %x lf %x, header %x,%x\n",
+				ptask->outstanding_pkts, lf, ptask->hdr.w0,
+				ptask->hdr.w1);
 			BUG();
 
 		case RFC2374_HDR_FIRSTFRAG:
@@ -1010,8 +1012,9 @@ static void fwnet_write_complete(struct
 		fwnet_transmit_packet_failed(ptask);
 
 		if (printk_timed_ratelimit(&j,  1000) || rcode != last_rcode) {
-			fw_error("fwnet_write_complete: "
-				"failed: %x (skipped %d)\n", rcode, errors_skipped);
+			dev_err(&ptask->dev->netdev->dev,
+				"fwnet_write_complete failed: %x (skipped %d)\n",
+				rcode, errors_skipped);
 
 			errors_skipped = 0;
 			last_rcode = rcode;
@@ -1539,14 +1542,12 @@ static int fwnet_probe(struct device *_d
 	put_unaligned_be64(card->guid, net->dev_addr);
 	put_unaligned_be64(~0ULL, net->broadcast);
 	ret = register_netdev(net);
-	if (ret) {
-		fw_error("Cannot register the driver\n");
+	if (ret)
 		goto out;
-	}
 
 	list_add_tail(&dev->dev_link, &fwnet_device_list);
-	fw_notify("%s: IPv4 over FireWire on device %016llx\n",
-		  net->name, (unsigned long long)card->guid);
+	dev_notice(&net->dev, "IPv4 over IEEE 1394 on card %s\n",
+		   dev_name(card->device));
  have_dev:
 	ret = fwnet_add_peer(dev, unit, device);
 	if (ret && allocated_netdev) {


-- 
Stefan Richter
-=====-===-- --=- =--==
http://arcgraph.de/sr/
