Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab1FDPqE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 11:46:04 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:48504 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756690Ab1FDPpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 11:45:49 -0400
Date: Sat, 4 Jun 2011 17:35:58 +0200
From: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richard.cochran@omicron.at>,
        =?iso-8859-15?B?TWljaGHFgiBNaXJvc8WCYXc=?= 
	<mirq-linux@rere.qmqm.pl>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH 2/8] drivers/octeon: use printk_ratelimited instead of
 printk_ratelimit
Message-ID: <da7c3f67bec16e03e95762ada884620061769f61.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
References: <cover.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per printk_ratelimit comment, it should not be used

Signed-off-by: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
---
 drivers/staging/octeon/ethernet-mdio.c  |   27 +++++++++++++------------
 drivers/staging/octeon/ethernet-rgmii.c |   33 ++++++++++++++++---------------
 drivers/staging/octeon/ethernet-rx.c    |   24 ++++++++++++----------
 drivers/staging/octeon/ethernet-sgmii.c |   14 +++++++-----
 drivers/staging/octeon/ethernet-tx.c    |   11 +++++----
 drivers/staging/octeon/ethernet-util.h  |    4 ---
 drivers/staging/octeon/ethernet-xaui.c  |   22 +++++++++++---------
 7 files changed, 70 insertions(+), 65 deletions(-)

diff --git a/drivers/staging/octeon/ethernet-mdio.c b/drivers/staging/octeon/ethernet-mdio.c
index 8a11ffc..f18e3e1 100644
--- a/drivers/staging/octeon/ethernet-mdio.c
+++ b/drivers/staging/octeon/ethernet-mdio.c
@@ -27,6 +27,7 @@
 #include <linux/kernel.h>
 #include <linux/ethtool.h>
 #include <linux/phy.h>
+#include <linux/ratelimit.h>
 
 #include <net/dst.h>
 
@@ -129,22 +130,22 @@ static void cvm_oct_adjust_link(struct net_device *dev)
 		if (priv->last_link) {
 			netif_carrier_on(dev);
 			if (priv->queue != -1)
-				DEBUGPRINT("%s: %u Mbps %s duplex, "
-					   "port %2d, queue %2d\n",
-					   dev->name, priv->phydev->speed,
-					   priv->phydev->duplex ?
-						"Full" : "Half",
-					   priv->port, priv->queue);
+				printk_ratelimited("%s: %u Mbps %s duplex, "
+						   "port %2d, queue %2d\n",
+						   dev->name, priv->phydev->speed,
+						   priv->phydev->duplex ?
+						   "Full" : "Half",
+						   priv->port, priv->queue);
 			else
-				DEBUGPRINT("%s: %u Mbps %s duplex, "
-					   "port %2d, POW\n",
-					   dev->name, priv->phydev->speed,
-					   priv->phydev->duplex ?
-						"Full" : "Half",
-					   priv->port);
+				printk_ratelimited("%s: %u Mbps %s duplex, "
+						   "port %2d, POW\n",
+						   dev->name, priv->phydev->speed,
+						   priv->phydev->duplex ?
+						   "Full" : "Half",
+						   priv->port);
 		} else {
 			netif_carrier_off(dev);
-			DEBUGPRINT("%s: Link down\n", dev->name);
+			printk_ratelimited("%s: Link down\n", dev->name);
 		}
 	}
 }
diff --git a/drivers/staging/octeon/ethernet-rgmii.c b/drivers/staging/octeon/ethernet-rgmii.c
index a0d4d4b..9c0d293 100644
--- a/drivers/staging/octeon/ethernet-rgmii.c
+++ b/drivers/staging/octeon/ethernet-rgmii.c
@@ -27,6 +27,7 @@
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
 #include <linux/phy.h>
+#include <linux/ratelimit.h>
 #include <net/dst.h>
 
 #include <asm/octeon/octeon.h>
@@ -116,9 +117,9 @@ static void cvm_oct_rgmii_poll(struct net_device *dev)
 				cvmx_write_csr(CVMX_GMXX_RXX_INT_REG
 					       (index, interface),
 					       gmxx_rxx_int_reg.u64);
-				DEBUGPRINT("%s: Using 10Mbps with software "
-					   "preamble removal\n",
-				     dev->name);
+				printk_ratelimited("%s: Using 10Mbps with software "
+						   "preamble removal\n",
+						   dev->name);
 			}
 		}
 
@@ -174,23 +175,23 @@ static void cvm_oct_rgmii_poll(struct net_device *dev)
 			if (!netif_carrier_ok(dev))
 				netif_carrier_on(dev);
 			if (priv->queue != -1)
-				DEBUGPRINT("%s: %u Mbps %s duplex, "
-					   "port %2d, queue %2d\n",
-					   dev->name, link_info.s.speed,
-					   (link_info.s.full_duplex) ?
-						"Full" : "Half",
-					   priv->port, priv->queue);
+				printk_ratelimited("%s: %u Mbps %s duplex, "
+						   "port %2d, queue %2d\n",
+						   dev->name, link_info.s.speed,
+						   (link_info.s.full_duplex) ?
+						   "Full" : "Half",
+						   priv->port, priv->queue);
 			else
-				DEBUGPRINT("%s: %u Mbps %s duplex, "
-					   "port %2d, POW\n",
-					   dev->name, link_info.s.speed,
-					   (link_info.s.full_duplex) ?
-						"Full" : "Half",
-					   priv->port);
+				printk_ratelimited("%s: %u Mbps %s duplex, "
+						   "port %2d, POW\n",
+						   dev->name, link_info.s.speed,
+						   (link_info.s.full_duplex) ?
+						   "Full" : "Half",
+						   priv->port);
 		} else {
 			if (netif_carrier_ok(dev))
 				netif_carrier_off(dev);
-			DEBUGPRINT("%s: Link down\n", dev->name);
+			printk_ratelimited("%s: Link down\n", dev->name);
 		}
 	}
 }
diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index cb38f9e..0f22f0f 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -34,6 +34,7 @@
 #include <linux/ip.h>
 #include <linux/string.h>
 #include <linux/prefetch.h>
+#include <linux/ratelimit.h>
 #include <linux/smp.h>
 #include <net/dst.h>
 #ifdef CONFIG_XFRM
@@ -186,13 +187,13 @@ static inline int cvm_oct_check_rcv_error(cvmx_wqe_t *work)
 
 			if (*ptr == 0xd5) {
 				/*
-				   DEBUGPRINT("Port %d received 0xd5 preamble\n", work->ipprt);
+				  printk_ratelimited("Port %d received 0xd5 preamble\n", work->ipprt);
 				 */
 				work->packet_ptr.s.addr += i + 1;
 				work->len -= i + 5;
 			} else if ((*ptr & 0xf) == 0xd) {
 				/*
-				   DEBUGPRINT("Port %d received 0x?d preamble\n", work->ipprt);
+				  printk_ratelimited("Port %d received 0x?d preamble\n", work->ipprt);
 				 */
 				work->packet_ptr.s.addr += i;
 				work->len -= i + 4;
@@ -203,9 +204,9 @@ static inline int cvm_oct_check_rcv_error(cvmx_wqe_t *work)
 					ptr++;
 				}
 			} else {
-				DEBUGPRINT("Port %d unknown preamble, packet "
-					   "dropped\n",
-				     work->ipprt);
+				printk_ratelimited("Port %d unknown preamble, packet "
+						   "dropped\n",
+						   work->ipprt);
 				/*
 				   cvmx_helper_dump_packet(work);
 				 */
@@ -214,8 +215,8 @@ static inline int cvm_oct_check_rcv_error(cvmx_wqe_t *work)
 			}
 		}
 	} else {
-		DEBUGPRINT("Port %d receive error code %d, packet dropped\n",
-			   work->ipprt, work->word2.snoip.err_code);
+		printk_ratelimited("Port %d receive error code %d, packet dropped\n",
+				   work->ipprt, work->word2.snoip.err_code);
 		cvm_oct_free_work(work);
 		return 1;
 	}
@@ -334,8 +335,9 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 			 */
 			skb = dev_alloc_skb(work->len);
 			if (!skb) {
-				DEBUGPRINT("Port %d failed to allocate skbuff, packet dropped\n",
-					   work->ipprt);
+				printk_ratelimited("Port %d failed to allocate "
+						   "skbuff, packet dropped\n",
+						   work->ipprt);
 				cvm_oct_free_work(work);
 				continue;
 			}
@@ -429,7 +431,7 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 			} else {
 				/* Drop any packet received for a device that isn't up */
 				/*
-				DEBUGPRINT("%s: Device not up, packet dropped\n",
+				  printk_ratelimited("%s: Device not up, packet dropped\n",
 					   dev->name);
 				*/
 #ifdef CONFIG_64BIT
@@ -444,7 +446,7 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 			 * Drop any packet received for a device that
 			 * doesn't exist.
 			 */
-			DEBUGPRINT("Port %d not controlled by Linux, packet dropped\n",
+			printk_ratelimited("Port %d not controlled by Linux, packet dropped\n",
 				   work->ipprt);
 			dev_kfree_skb_irq(skb);
 		}
diff --git a/drivers/staging/octeon/ethernet-sgmii.c b/drivers/staging/octeon/ethernet-sgmii.c
index 2d8589e..5e148b5 100644
--- a/drivers/staging/octeon/ethernet-sgmii.c
+++ b/drivers/staging/octeon/ethernet-sgmii.c
@@ -26,6 +26,7 @@
 **********************************************************************/
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/ratelimit.h>
 #include <net/dst.h>
 
 #include <asm/octeon/octeon.h>
@@ -90,20 +91,21 @@ static void cvm_oct_sgmii_poll(struct net_device *dev)
 		if (!netif_carrier_ok(dev))
 			netif_carrier_on(dev);
 		if (priv->queue != -1)
-			DEBUGPRINT
+			printk_ratelimited
 			    ("%s: %u Mbps %s duplex, port %2d, queue %2d\n",
 			     dev->name, link_info.s.speed,
 			     (link_info.s.full_duplex) ? "Full" : "Half",
 			     priv->port, priv->queue);
 		else
-			DEBUGPRINT("%s: %u Mbps %s duplex, port %2d, POW\n",
-				   dev->name, link_info.s.speed,
-				   (link_info.s.full_duplex) ? "Full" : "Half",
-				   priv->port);
+			printk_ratelimited
+				("%s: %u Mbps %s duplex, port %2d, POW\n",
+				 dev->name, link_info.s.speed,
+				 (link_info.s.full_duplex) ? "Full" : "Half",
+				 priv->port);
 	} else {
 		if (netif_carrier_ok(dev))
 			netif_carrier_off(dev);
-		DEBUGPRINT("%s: Link down\n", dev->name);
+		printk_ratelimited("%s: Link down\n", dev->name);
 	}
 }
 
diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index afc2b73..6227571 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -30,6 +30,7 @@
 #include <linux/init.h>
 #include <linux/etherdevice.h>
 #include <linux/ip.h>
+#include <linux/ratelimit.h>
 #include <linux/string.h>
 #include <net/dst.h>
 #ifdef CONFIG_XFRM
@@ -446,7 +447,7 @@ dont_put_skbuff_in_hw:
 						 priv->queue + qos,
 						 pko_command, hw_buffer,
 						 CVMX_PKO_LOCK_NONE))) {
-		DEBUGPRINT("%s: Failed to send the packet\n", dev->name);
+		printk_ratelimited("%s: Failed to send the packet\n", dev->name);
 		queue_type = QUEUE_DROP;
 	}
 skip_xmit:
@@ -525,8 +526,8 @@ int cvm_oct_xmit_pow(struct sk_buff *skb, struct net_device *dev)
 	/* Get a work queue entry */
 	cvmx_wqe_t *work = cvmx_fpa_alloc(CVMX_FPA_WQE_POOL);
 	if (unlikely(work == NULL)) {
-		DEBUGPRINT("%s: Failed to allocate a work queue entry\n",
-			   dev->name);
+		printk_ratelimited("%s: Failed to allocate a work "
+				   "queue entry\n", dev->name);
 		priv->stats.tx_dropped++;
 		dev_kfree_skb(skb);
 		return 0;
@@ -535,8 +536,8 @@ int cvm_oct_xmit_pow(struct sk_buff *skb, struct net_device *dev)
 	/* Get a packet buffer */
 	packet_buffer = cvmx_fpa_alloc(CVMX_FPA_PACKET_POOL);
 	if (unlikely(packet_buffer == NULL)) {
-		DEBUGPRINT("%s: Failed to allocate a packet buffer\n",
-			   dev->name);
+		printk_ratelimited("%s: Failed to allocate a packet buffer\n",
+				   dev->name);
 		cvmx_fpa_free(work, CVMX_FPA_WQE_POOL, DONT_WRITEBACK(1));
 		priv->stats.tx_dropped++;
 		dev_kfree_skb(skb);
diff --git a/drivers/staging/octeon/ethernet-util.h b/drivers/staging/octeon/ethernet-util.h
index c745a72..144fb99 100644
--- a/drivers/staging/octeon/ethernet-util.h
+++ b/drivers/staging/octeon/ethernet-util.h
@@ -25,10 +25,6 @@
  * Contact Cavium Networks for more information
 *********************************************************************/
 
-#define DEBUGPRINT(format, ...) do { if (printk_ratelimit()) 		\
-					printk(format, ##__VA_ARGS__);	\
-				} while (0)
-
 /**
  * cvm_oct_get_buffer_ptr - convert packet data address to pointer
  * @packet_ptr: Packet data hardware address
diff --git a/drivers/staging/octeon/ethernet-xaui.c b/drivers/staging/octeon/ethernet-xaui.c
index 3fca1cc..861a4b3 100644
--- a/drivers/staging/octeon/ethernet-xaui.c
+++ b/drivers/staging/octeon/ethernet-xaui.c
@@ -26,6 +26,7 @@
 **********************************************************************/
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/ratelimit.h>
 #include <net/dst.h>
 
 #include <asm/octeon/octeon.h>
@@ -89,20 +90,21 @@ static void cvm_oct_xaui_poll(struct net_device *dev)
 		if (!netif_carrier_ok(dev))
 			netif_carrier_on(dev);
 		if (priv->queue != -1)
-			DEBUGPRINT
-			    ("%s: %u Mbps %s duplex, port %2d, queue %2d\n",
-			     dev->name, link_info.s.speed,
-			     (link_info.s.full_duplex) ? "Full" : "Half",
-			     priv->port, priv->queue);
+			printk_ratelimited
+				("%s: %u Mbps %s duplex, port %2d, queue %2d\n",
+				 dev->name, link_info.s.speed,
+				 (link_info.s.full_duplex) ? "Full" : "Half",
+				 priv->port, priv->queue);
 		else
-			DEBUGPRINT("%s: %u Mbps %s duplex, port %2d, POW\n",
-				   dev->name, link_info.s.speed,
-				   (link_info.s.full_duplex) ? "Full" : "Half",
-				   priv->port);
+			printk_ratelimited
+				("%s: %u Mbps %s duplex, port %2d, POW\n",
+				 dev->name, link_info.s.speed,
+				 (link_info.s.full_duplex) ? "Full" : "Half",
+				 priv->port);
 	} else {
 		if (netif_carrier_ok(dev))
 			netif_carrier_off(dev);
-		DEBUGPRINT("%s: Link down\n", dev->name);
+		printk_ratelimited("%s: Link down\n", dev->name);
 	}
 }
 
-- 
1.7.1

