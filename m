Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab1FCXoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 19:44:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:47390 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755189Ab1FCXoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 19:44:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,317,1304319600"; 
   d="scan'208";a="13344050"
From: Russ Gorby <russ.gorby@intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Russ Gorby <russ.gorby@intel.com>,
        linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com, russ.gorby@intel.com
Subject: [PATCHv2 1/7] tty: n_gsm: Add raw-ip support
Date: Fri,  3 Jun 2011 16:43:56 -0700
Message-Id: <1307144642-5915-2-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCHv2 0/5] N_GSM patchset : 06/03/2011: v2>
References: <[PATCHv2 0/5] N_GSM patchset : 06/03/2011: v2>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the ability to open a network data connection over a mux
virtual tty channel. This is for modems that support data connections
with raw IP frames instead of PPP. On high speed data connections this
eliminates a significant amount of PPP overhead. To use this interface,
the application must first tell the modem to open a network connection on
a virtual tty. Once that has been accomplished, the app will issue an
IOCTL on that virtual tty to create the network interface. The IOCTL will
return the index of the interface created.

The two IOCTL commands are:

    ioctl( fd, GSMIOC_ENABLE_NET );

    ioctl( fd, GSMIOC_DISABLE_NET );

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
---
 drivers/tty/n_gsm.c    |  260 ++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/gsmmux.h |   11 ++
 2 files changed, 263 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index a4c42a7..47897c2 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -58,6 +58,10 @@
 #include <linux/serial.h>
 #include <linux/kfifo.h>
 #include <linux/skbuff.h>
+#include <net/arp.h>
+#include <linux/ip.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
 #include <linux/gsmmux.h>
 
 static int debug;
@@ -77,8 +81,24 @@ module_param(debug, int, 0600);
  * Semi-arbitrary buffer size limits. 0710 is normally run with 32-64 byte
  * limits so this is plenty
  */
-#define MAX_MRU 512
-#define MAX_MTU 512
+#define MAX_MRU 1500
+#define MAX_MTU 1500
+#define	GSM_NET_TX_TIMEOUT (HZ*10)
+
+/**
+ *	struct gsm_mux_net	-	network interface
+ *	@struct gsm_dlci* dlci
+ *	@struct net_device_stats stats;
+ *
+ *	Created when net interface is initialized.
+ **/
+struct gsm_mux_net {
+	struct kref ref;
+	struct gsm_dlci *dlci;
+	struct net_device_stats stats;
+};
+
+#define STATS(net) (((struct gsm_mux_net *)netdev_priv(net))->stats)
 
 /*
  *	Each block of data we have queued to go out is in the form of
@@ -134,6 +154,7 @@ struct gsm_dlci {
 	struct sk_buff_head skb_list;	/* Queued frames */
 	/* Data handling callback */
 	void (*data)(struct gsm_dlci *dlci, u8 *data, int len);
+	struct net_device *net; /* network interface, if created */
 };
 
 /* DLCI 0, 62/63 are special or reseved see gsmtty_open */
@@ -877,8 +898,10 @@ static int gsm_dlci_data_output_framed(struct gsm_mux *gsm,
 	}
 	memcpy(dp, skb_pull(dlci->skb, len), len);
 	__gsm_data_queue(dlci, msg);
-	if (last)
+	if (last) {
+		kfree_skb(dlci->skb);
 		dlci->skb = NULL;
+	}
 	return size;
 }
 
@@ -911,7 +934,7 @@ static void gsm_dlci_data_sweep(struct gsm_mux *gsm)
 			i++;
 			continue;
 		}
-		if (dlci->adaption < 3)
+		if (dlci->adaption < 3 && !dlci->net)
 			len = gsm_dlci_data_output(gsm, dlci);
 		else
 			len = gsm_dlci_data_output_framed(gsm, dlci);
@@ -938,9 +961,12 @@ static void gsm_dlci_data_kick(struct gsm_dlci *dlci)
 
 	spin_lock_irqsave(&dlci->gsm->tx_lock, flags);
 	/* If we have nothing running then we need to fire up */
-	if (dlci->gsm->tx_bytes == 0)
-		gsm_dlci_data_output(dlci->gsm, dlci);
-	else if (dlci->gsm->tx_bytes < TX_THRESH_LO)
+	if (dlci->gsm->tx_bytes == 0) {
+		if (dlci->net)
+			gsm_dlci_data_output_framed(dlci->gsm, dlci);
+		else
+			gsm_dlci_data_output(dlci->gsm, dlci);
+	} else if (dlci->gsm->tx_bytes < TX_THRESH_LO)
 		gsm_dlci_data_sweep(dlci->gsm);
 	spin_unlock_irqrestore(&dlci->gsm->tx_lock, flags);
 }
@@ -1590,6 +1616,7 @@ static struct gsm_dlci *gsm_dlci_alloc(struct gsm_mux *gsm, int addr)
 	dlci->addr = addr;
 	dlci->adaption = gsm->adaption;
 	dlci->state = DLCI_CLOSED;
+	dlci->net = NULL;	/* network not initially created */
 	if (addr)
 		dlci->data = gsm_dlci_data;
 	else
@@ -2464,6 +2491,201 @@ static int gsmld_ioctl(struct tty_struct *tty, struct file *file,
 	}
 }
 
+/*
+ *	Network interface
+ *
+ */
+
+static int gsm_mux_net_open(struct net_device *net)
+{
+	pr_debug("%s called\n", __func__);
+	netif_start_queue(net);
+	return 0;
+}
+
+static int gsm_mux_net_close(struct net_device *net)
+{
+	netif_stop_queue(net);
+	return 0;
+}
+
+static struct net_device_stats *gsm_mux_net_get_stats(struct net_device *net)
+{
+	return &((struct gsm_mux_net *)netdev_priv(net))->stats;
+}
+static void net_free(struct kref *ref)
+{
+	struct gsm_mux_net *mux_net;
+	struct gsm_dlci *dlci;
+
+	mux_net = container_of(ref, struct gsm_mux_net, ref);
+	dlci = mux_net->dlci;
+
+	if (dlci->net) {
+		dlci->adaption = 1;
+		dlci->data = gsm_dlci_data;
+		unregister_netdev(dlci->net);
+		free_netdev(dlci->net);
+		dlci->net = 0;
+	}
+}
+static int gsm_mux_net_start_xmit(struct sk_buff *skb,
+				      struct net_device *net)
+{
+	struct gsm_dlci *dlci = ((struct gsm_mux_net *)netdev_priv(net))->dlci;
+	struct gsm_mux_net *mux_net;
+
+	mux_net = (struct gsm_mux_net *)netdev_priv(net);
+	kref_get(&mux_net->ref);
+
+	skb_queue_head(&dlci->skb_list, skb);
+	STATS(net).tx_packets++;
+	STATS(net).tx_bytes += skb->len;
+	gsm_dlci_data_kick(dlci);
+	/* And tell the kernel when the last transmit started. */
+	net->trans_start = jiffies;
+	kref_put(&mux_net->ref, net_free);
+	return NETDEV_TX_OK;
+}
+
+/* called when a packet did not ack after watchdogtimeout */
+static void gsm_mux_net_tx_timeout(struct net_device *net)
+{
+	/* Tell syslog we are hosed. */
+	dev_dbg(&net->dev, "Tx timed out.\n");
+
+	/* Update statistics */
+	STATS(net).tx_errors++;
+}
+
+static void gsm_mux_rx_netchar(struct gsm_dlci *dlci,
+				   unsigned char *in_buf, int size)
+{
+	struct net_device *net = dlci->net;
+	struct sk_buff *skb;
+	struct gsm_mux_net *mux_net;
+
+	mux_net = (struct gsm_mux_net *)netdev_priv(net);
+	kref_get(&mux_net->ref);
+
+	/* Allocate an sk_buff */
+	skb = dev_alloc_skb(size + NET_IP_ALIGN);
+	if (!skb) {
+		/* We got no receive buffer. */
+		STATS(net).rx_dropped++;
+		kref_put(&mux_net->ref, net_free);
+		return;
+	}
+	skb_reserve(skb, NET_IP_ALIGN);
+	memcpy(skb_put(skb, size), in_buf, size);
+
+	skb->dev = net;
+	skb->protocol = __constant_htons(ETH_P_IP);
+
+	/* Ship it off to the kernel */
+	netif_rx(skb);
+
+	/* update out statistics */
+	STATS(net).rx_packets++;
+	STATS(net).rx_bytes += size;
+	kref_put(&mux_net->ref, net_free);
+	return;
+}
+
+int gsm_change_mtu(struct net_device *net, int new_mtu)
+{
+	if ((new_mtu < 8) || (new_mtu > MAX_MTU))
+		return -EINVAL;
+	net->mtu = new_mtu;
+	return 0;
+}
+
+static void gsm_mux_net_init(struct net_device *net)
+{
+	static const struct net_device_ops gsm_netdev_ops = {
+		.ndo_open		= gsm_mux_net_open,
+		.ndo_stop		= gsm_mux_net_close,
+		.ndo_start_xmit		= gsm_mux_net_start_xmit,
+		.ndo_tx_timeout		= gsm_mux_net_tx_timeout,
+		.ndo_get_stats		= gsm_mux_net_get_stats,
+		.ndo_change_mtu		= gsm_change_mtu,
+	};
+	net->netdev_ops = &gsm_netdev_ops;
+
+	/* fill in the other fields */
+	net->watchdog_timeo = GSM_NET_TX_TIMEOUT;
+	net->flags = IFF_POINTOPOINT | IFF_NOARP | IFF_MULTICAST;
+	net->type = ARPHRD_NONE;
+	net->mtu = MAX_MTU;
+	net->tx_queue_len = 10;
+}
+
+
+static void gsm_destroy_network(struct gsm_dlci *dlci)
+{
+	struct gsm_mux_net *mux_net;
+
+	pr_debug("destroy network interface");
+	if (dlci->net) {
+		mux_net = (struct gsm_mux_net *)netdev_priv(dlci->net);
+		kref_put(&mux_net->ref, net_free);
+	}
+}
+
+
+static int gsm_create_network(struct gsm_dlci *dlci, struct gsm_netconfig *nc)
+{
+	char *netname;
+	int retval = 0;
+	struct net_device *net;
+	struct gsm_mux_net *mux_net;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	/* Already in a non tty mode */
+	if (dlci->adaption > 2)
+		return -EBUSY;
+
+	if (nc->protocol != htons(ETH_P_IP))
+		return -EPROTONOSUPPORT;
+
+	if (nc->adaption != 3 && nc->adaption != 4)
+		return -EPROTONOSUPPORT;
+
+	pr_debug("create network interface");
+
+	netname = "gsm%d";
+	if (nc->if_name[0] != '\0')
+		netname = nc->if_name;
+	net = alloc_netdev(sizeof(struct gsm_mux_net),
+			netname,
+			gsm_mux_net_init);
+	if (!net) {
+		pr_err("alloc_netdev failed");
+		retval = -ENOMEM;
+		goto error_ret;
+	}
+	pr_debug("register netdev");
+	net->mtu = dlci->gsm->mtu;
+	retval = register_netdev(net);
+	if (retval) {
+		pr_err("network register fail %d\n", retval);
+		free_netdev(net);
+		goto error_ret;
+	}
+	dlci->net = net;
+	dlci->adaption = nc->adaption;
+	dlci->data = gsm_mux_rx_netchar;
+	mux_net = (struct gsm_mux_net *)netdev_priv(net);
+	mux_net->dlci = dlci;
+	kref_init(&mux_net->ref);
+	strncpy(nc->if_name, net->name, IFNAMSIZ); /* return net name */
+	return net->ifindex;	/* return network index */
+
+error_ret:
+	return retval;
+}
 
 /* Line discipline for real tty */
 struct tty_ldisc_ops tty_ldisc_packet = {
@@ -2584,6 +2806,7 @@ static void gsmtty_close(struct tty_struct *tty, struct file *filp)
 	struct gsm_dlci *dlci = tty->driver_data;
 	if (dlci == NULL)
 		return;
+	gsm_destroy_network(dlci);
 	if (tty_port_close_start(&dlci->port, tty, filp) == 0)
 		return;
 	gsm_dlci_begin_close(dlci);
@@ -2665,7 +2888,28 @@ static int gsmtty_tiocmset(struct tty_struct *tty,
 static int gsmtty_ioctl(struct tty_struct *tty,
 			unsigned int cmd, unsigned long arg)
 {
-	return -ENOIOCTLCMD;
+	struct gsm_dlci *dlci = tty->driver_data;
+	struct gsm_netconfig nc;
+	int index;
+
+	switch (cmd) {
+	case GSMIOC_ENABLE_NET:
+		if (copy_from_user(&nc, (void __user *)arg, sizeof(nc)))
+			return -EFAULT;
+		nc.if_name[IFNAMSIZ-1] = '\0';
+		/* return net interface index or error code */
+		index = gsm_create_network(dlci, &nc);
+		if (copy_to_user((void __user *)arg, &nc, sizeof(nc)))
+			return -EFAULT;
+		return index;
+	case GSMIOC_DISABLE_NET:
+		if (!capable(CAP_NET_ADMIN))
+			return -EPERM;
+		gsm_destroy_network(dlci);
+		return 0;
+	default:
+		return -ENOIOCTLCMD;
+	}
 }
 
 static void gsmtty_set_termios(struct tty_struct *tty, struct ktermios *old)
diff --git a/include/linux/gsmmux.h b/include/linux/gsmmux.h
index 378de41..c25e947 100644
--- a/include/linux/gsmmux.h
+++ b/include/linux/gsmmux.h
@@ -21,5 +21,16 @@ struct gsm_config
 #define GSMIOC_GETCONF		_IOR('G', 0, struct gsm_config)
 #define GSMIOC_SETCONF		_IOW('G', 1, struct gsm_config)
 
+struct gsm_netconfig {
+	unsigned int adaption;  /* Adaption to use in network mode */
+	unsigned short protocol;/* Protocol to use - only ETH_P_IP supported */
+	unsigned short unused2;
+	char if_name[IFNAMSIZ];	/* interface name format string */
+	__u8 unused[28];        /* For future use */
+};
+
+#define GSMIOC_ENABLE_NET      _IOW('G', 2, struct gsm_netconfig)
+#define GSMIOC_DISABLE_NET     _IO('G', 3)
+
 
 #endif
-- 
1.7.0.4

