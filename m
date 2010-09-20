Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab0ITSVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:21:23 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:15380 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab0ITSVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:21:21 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 20 Sep 2010 20:23:04 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] usb: gadget: rndis: don't use dev_get_stats()
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Message-id: <bdd595ff5a45c008254da0a0c4322b6e7b699cf2.1285006511.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit removes the call to dev_get_stats() from the
gen_ndis_query_resp() function.  Since spin_lock_bh() was
added to dev_txq_stats_fold() the call started causing
warnings.  This is because gen_ndis_query_resp() can be
(indirectly) called from rndis_command_complete() which is
called with interrupts disabled.

While at it, this commit also changes the
gen_ndis_query_resp() function so that "net" local variable is
used instead of "rndis_per_dev_params[configNr].dev" in all
places this is referenced.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
---
 drivers/usb/gadget/rndis.c |   50 +++++++++++++++++++------------------------
 1 files changed, 22 insertions(+), 28 deletions(-)


Without this patch, I got the following warning when RNDIS
configuration is chosen:

> WARNING: at kernel/softirq.c:143 local_bh_enable_ip+0x44/0xc0()
[...]
> [<c0049024>] (local_bh_enable_ip+0x44/0xc0) from [<c025ef18>] (dev_txq_stats_fold+0xac/0x108)
> [<c025ef18>] (dev_txq_stats_fold+0xac/0x108) from [<c025f018>] (dev_get_stats+0xa4/0xac)
> [<c025f018>] (dev_get_stats+0xa4/0xac) from [<c01f72bc>] (gen_ndis_query_resp+0x4c/0x43c)
> [<c01f72bc>] (gen_ndis_query_resp+0x4c/0x43c) from [<c01f784c>] (rndis_msg_parser+0x1a0/0x32c)
> [<c01f784c>] (rndis_msg_parser+0x1a0/0x32c) from [<c01f79f8>] (rndis_command_complete+0x20/0x4c)
> [<c01f79f8>] (rndis_command_complete+0x20/0x4c) from [<c01f3278>] (done+0x5c/0x70)
> [<c01f3278>] (done+0x5c/0x70) from [<c01f3c60>] (complete_tx+0xf0/0x1a8)
> [<c01f3c60>] (complete_tx+0xf0/0x1a8) from [<c01f3d8c>] (process_ep_in_intr+0x74/0x14c)
> [<c01f3d8c>] (process_ep_in_intr+0x74/0x14c) from [<c01f470c>] (s3c_udc_irq+0x2c8/0x3f4)
> [<c01f470c>] (s3c_udc_irq+0x2c8/0x3f4) from [<c006dfd0>] (handle_IRQ_event+0x24/0xe4)
> [<c006dfd0>] (handle_IRQ_event+0x24/0xe4) from [<c006fe40>] (handle_level_irq+0xb0/0x12c)
> [<c006fe40>] (handle_level_irq+0xb0/0x12c) from [<c0027074>] (asm_do_IRQ+0x74/0x98)
> [<c0027074>] (asm_do_IRQ+0x74/0x98) from [<c0027ca4>] (__irq_usr+0x44/0xc0)

After some investigation I found out that recently introduced commit
bd27290a593f80cb99e95287cb29c72c0d57608b causes this.

> diff --git a/net/core/dev.c b/net/core/dev.c
> index 1c002c7..9de75cd 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5282,15 +5282,17 @@ void netdev_run_todo(void)
>  void dev_txq_stats_fold(const struct net_device *dev,
>  			struct rtnl_link_stats64 *stats)
>  {
> -	unsigned long tx_bytes = 0, tx_packets = 0, tx_dropped = 0;
> +	u64 tx_bytes = 0, tx_packets = 0, tx_dropped = 0;
>  	unsigned int i;
>  	struct netdev_queue *txq;
>  
>  	for (i = 0; i < dev->num_tx_queues; i++) {
>  		txq = netdev_get_tx_queue(dev, i);
> +		spin_lock_bh(&txq->_xmit_lock);
>  		tx_bytes   += txq->tx_bytes;
>  		tx_packets += txq->tx_packets;
>  		tx_dropped += txq->tx_dropped;
> +		spin_unlock_bh(&txq->_xmit_lock);
>  	}
>  	if (tx_bytes || tx_packets || tx_dropped) {
>  		stats->tx_bytes   = tx_bytes;

David Miller didn't agree to change spin_lock_bh() to
spin_lock_irqsave() so I'm trying to fix the issue by changing
rndis.c.


At this point, I'm not entirely sure whether replacing dev_get_stats()
with simple access to net->stats doesn't break something and I'm not
really sure how to test that either (g_ether works when connected to
Windows host).


The other solution would be to change rndis_command_complete() so that
a tasklet is used.


If everyone is happy with this change, I think it's good idea
to get it pulled before 2.6.36.


Also, David (Brownel), can rndis_per_dev_params[configNr].dev
be ever NULL?  The line dev_get_stats() assumed it's never
NULL but some other parts of the code checked the value.
I left the checking just to be safe but maybe it can be
dropped?


diff --git a/drivers/usb/gadget/rndis.c b/drivers/usb/gadget/rndis.c
index 972d5dd..ea597cc 100644
--- a/drivers/usb/gadget/rndis.c
+++ b/drivers/usb/gadget/rndis.c
@@ -171,8 +171,6 @@ gen_ndis_query_resp (int configNr, u32 OID, u8 *buf, unsigned buf_len,
 	int			i, count;
 	rndis_query_cmplt_type	*resp;
 	struct net_device	*net;
-	struct rtnl_link_stats64 temp;
-	const struct rtnl_link_stats64 *stats;
 
 	if (!r) return -ENOMEM;
 	resp = (rndis_query_cmplt_type *) r->buf;
@@ -195,7 +193,6 @@ gen_ndis_query_resp (int configNr, u32 OID, u8 *buf, unsigned buf_len,
 	resp->InformationBufferOffset = cpu_to_le32 (16);
 
 	net = rndis_per_dev_params[configNr].dev;
-	stats = dev_get_stats(net, &temp);
 
 	switch (OID) {
 
@@ -242,9 +239,8 @@ gen_ndis_query_resp (int configNr, u32 OID, u8 *buf, unsigned buf_len,
 	/* mandatory */
 	case OID_GEN_MAXIMUM_FRAME_SIZE:
 		pr_debug("%s: OID_GEN_MAXIMUM_FRAME_SIZE\n", __func__);
-		if (rndis_per_dev_params [configNr].dev) {
-			*outbuf = cpu_to_le32 (
-				rndis_per_dev_params [configNr].dev->mtu);
+		if (net) {
+			*outbuf = cpu_to_le32(net->mtu);
 			retval = 0;
 		}
 		break;
@@ -265,9 +261,8 @@ gen_ndis_query_resp (int configNr, u32 OID, u8 *buf, unsigned buf_len,
 	/* mandatory */
 	case OID_GEN_TRANSMIT_BLOCK_SIZE:
 		pr_debug("%s: OID_GEN_TRANSMIT_BLOCK_SIZE\n", __func__);
-		if (rndis_per_dev_params [configNr].dev) {
-			*outbuf = cpu_to_le32 (
-				rndis_per_dev_params [configNr].dev->mtu);
+		if (net) {
+			*outbuf = cpu_to_le32(net->mtu);
 			retval = 0;
 		}
 		break;
@@ -275,9 +270,8 @@ gen_ndis_query_resp (int configNr, u32 OID, u8 *buf, unsigned buf_len,
 	/* mandatory */
 	case OID_GEN_RECEIVE_BLOCK_SIZE:
 		pr_debug("%s: OID_GEN_RECEIVE_BLOCK_SIZE\n", __func__);
-		if (rndis_per_dev_params [configNr].dev) {
-			*outbuf = cpu_to_le32 (
-				rndis_per_dev_params [configNr].dev->mtu);
+		if (net) {
+			*outbuf = cpu_to_le32(net->mtu);
 			retval = 0;
 		}
 		break;
@@ -357,9 +351,9 @@ gen_ndis_query_resp (int configNr, u32 OID, u8 *buf, unsigned buf_len,
 	case OID_GEN_XMIT_OK:
 		if (rndis_debug > 1)
 			pr_debug("%s: OID_GEN_XMIT_OK\n", __func__);
-		if (stats) {
-			*outbuf = cpu_to_le32(stats->tx_packets
-				- stats->tx_errors - stats->tx_dropped);
+		if (net) {
+			*outbuf = cpu_to_le32(net->stats.tx_packets
+				- net->stats.tx_errors - net->stats.tx_dropped);
 			retval = 0;
 		}
 		break;
@@ -368,9 +362,9 @@ gen_ndis_query_resp (int configNr, u32 OID, u8 *buf, unsigned buf_len,
 	case OID_GEN_RCV_OK:
 		if (rndis_debug > 1)
 			pr_debug("%s: OID_GEN_RCV_OK\n", __func__);
-		if (stats) {
-			*outbuf = cpu_to_le32(stats->rx_packets
-				- stats->rx_errors - stats->rx_dropped);
+		if (net) {
+			*outbuf = cpu_to_le32(net->stats.rx_packets
+				- net->stats.rx_errors - net->stats.rx_dropped);
 			retval = 0;
 		}
 		break;
@@ -379,8 +373,8 @@ gen_ndis_query_resp (int configNr, u32 OID, u8 *buf, unsigned buf_len,
 	case OID_GEN_XMIT_ERROR:
 		if (rndis_debug > 1)
 			pr_debug("%s: OID_GEN_XMIT_ERROR\n", __func__);
-		if (stats) {
-			*outbuf = cpu_to_le32(stats->tx_errors);
+		if (net) {
+			*outbuf = cpu_to_le32(net->stats.tx_errors);
 			retval = 0;
 		}
 		break;
@@ -389,8 +383,8 @@ gen_ndis_query_resp (int configNr, u32 OID, u8 *buf, unsigned buf_len,
 	case OID_GEN_RCV_ERROR:
 		if (rndis_debug > 1)
 			pr_debug("%s: OID_GEN_RCV_ERROR\n", __func__);
-		if (stats) {
-			*outbuf = cpu_to_le32(stats->rx_errors);
+		if (net) {
+			*outbuf = cpu_to_le32(net->stats.rx_errors);
 			retval = 0;
 		}
 		break;
@@ -398,8 +392,8 @@ gen_ndis_query_resp (int configNr, u32 OID, u8 *buf, unsigned buf_len,
 	/* mandatory */
 	case OID_GEN_RCV_NO_BUFFER:
 		pr_debug("%s: OID_GEN_RCV_NO_BUFFER\n", __func__);
-		if (stats) {
-			*outbuf = cpu_to_le32(stats->rx_dropped);
+		if (net) {
+			*outbuf = cpu_to_le32(net->stats.rx_dropped);
 			retval = 0;
 		}
 		break;
@@ -409,7 +403,7 @@ gen_ndis_query_resp (int configNr, u32 OID, u8 *buf, unsigned buf_len,
 	/* mandatory */
 	case OID_802_3_PERMANENT_ADDRESS:
 		pr_debug("%s: OID_802_3_PERMANENT_ADDRESS\n", __func__);
-		if (rndis_per_dev_params [configNr].dev) {
+		if (net) {
 			length = ETH_ALEN;
 			memcpy (outbuf,
 				rndis_per_dev_params [configNr].host_mac,
@@ -421,7 +415,7 @@ gen_ndis_query_resp (int configNr, u32 OID, u8 *buf, unsigned buf_len,
 	/* mandatory */
 	case OID_802_3_CURRENT_ADDRESS:
 		pr_debug("%s: OID_802_3_CURRENT_ADDRESS\n", __func__);
-		if (rndis_per_dev_params [configNr].dev) {
+		if (net) {
 			length = ETH_ALEN;
 			memcpy (outbuf,
 				rndis_per_dev_params [configNr].host_mac,
@@ -457,8 +451,8 @@ gen_ndis_query_resp (int configNr, u32 OID, u8 *buf, unsigned buf_len,
 	/* mandatory */
 	case OID_802_3_RCV_ERROR_ALIGNMENT:
 		pr_debug("%s: OID_802_3_RCV_ERROR_ALIGNMENT\n", __func__);
-		if (stats) {
-			*outbuf = cpu_to_le32(stats->rx_frame_errors);
+		if (net) {
+			*outbuf = cpu_to_le32(net->stats.rx_frame_errors);
 			retval = 0;
 		}
 		break;
-- 
1.7.1

