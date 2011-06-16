Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab1FPVUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 17:20:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:4512 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757293Ab1FPVUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 17:20:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,377,1304319600"; 
   d="scan'208";a="14474057"
From: Russ Gorby <russ.gorby@intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Russ Gorby <russ.gorby@intel.com>,
        linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com, russ.gorby@intel.com
Subject: [PATCH 2/2] tty: n_gsm: Added refcount usage to gsm_mux and gsm_dlci structs
Date: Thu, 16 Jun 2011 14:20:13 -0700
Message-Id: <1308259213-31887-3-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH 0/2] N_GSM: RAW_IP Support : June 16, 2011>
References: <[PATCH 0/2] N_GSM: RAW_IP Support : June 16, 2011>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gsm_mux is created/destroyed when ldisc is
opened/closed but clients of the MUX channel devices (gsmttyN)
may access this structure as long as the TTYs are open.
For the open, the ldisc open is guaranteed to preceed the TTY open,
but the close has no such guaranteed ordering. As a result,
the gsm_mux can be freed in the ldisc close before being accessed
by one of the TTY clients. This can happen if the ldisc is removed
while there are open, active MUX channels.
A similar situation exists for DLCI-0, it is basically a resource
shared by MUX and DLCI  , and should not be freed while they can
be accessed

To avoid this, gsm_mux and dlcis now have a reference counter
ldisc open takes a reference on the mux and all the dlcis
gsmtty_open takes a reference on the mux, dlci0 and its specific
dlci. Dropping the last reference initiates the actual free.

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
---
 drivers/tty/n_gsm.c |  111 +++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 91 insertions(+), 20 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 491df49..28b7ff9 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -133,6 +133,7 @@ struct gsm_dlci {
 #define DLCI_OPENING		1	/* Sending SABM not seen UA */
 #define DLCI_OPEN		2	/* SABM/UA complete */
 #define DLCI_CLOSING		3	/* Sending DISC not seen UA/DM */
+	struct kref ref;		/* freed from port or mux close */
 	struct mutex mutex;
 
 	/* Link layer */
@@ -194,6 +195,7 @@ struct gsm_mux {
 	struct tty_struct *tty;		/* The tty our ldisc is bound to */
 	spinlock_t lock;
 	unsigned int num;
+	struct kref ref;
 
 	/* Events on the GSM channel */
 	wait_queue_head_t event;
@@ -1620,6 +1622,7 @@ static struct gsm_dlci *gsm_dlci_alloc(struct gsm_mux *gsm, int addr)
 	if (dlci == NULL)
 		return NULL;
 	spin_lock_init(&dlci->lock);
+	kref_init(&dlci->ref);
 	mutex_init(&dlci->mutex);
 	dlci->fifo = &dlci->_fifo;
 	if (kfifo_alloc(&dlci->_fifo, 4096, GFP_KERNEL) < 0) {
@@ -1646,26 +1649,52 @@ static struct gsm_dlci *gsm_dlci_alloc(struct gsm_mux *gsm, int addr)
 }
 
 /**
- *	gsm_dlci_free		-	release DLCI
+ *	gsm_dlci_free		-	free DLCI
+ *	@dlci: DLCI to free
+ *
+ *	Free up a DLCI.
+ *
+ *	Can sleep.
+ */
+static void gsm_dlci_free(struct kref *ref)
+{
+	struct gsm_dlci *dlci = container_of(ref, struct gsm_dlci, ref);
+
+	del_timer_sync(&dlci->t1);
+	dlci->gsm->dlci[dlci->addr] = NULL;
+	kfifo_free(dlci->fifo);
+	while ((dlci->skb = skb_dequeue(&dlci->skb_list)))
+		kfree_skb(dlci->skb);
+	kfree(dlci);
+}
+
+static inline void dlci_get(struct gsm_dlci *dlci)
+{
+	kref_get(&dlci->ref);
+}
+
+static inline void dlci_put(struct gsm_dlci *dlci)
+{
+	kref_put(&dlci->ref, gsm_dlci_free);
+}
+
+/**
+ *	gsm_dlci_release		-	release DLCI
  *	@dlci: DLCI to destroy
  *
- *	Free up a DLCI. Currently to keep the lifetime rules sane we only
- *	clean up DLCI objects when the MUX closes rather than as the port
- *	is closed down on both the tty and mux levels.
+ *	Release a DLCI. Actual free is deferred until either
+ *	mux is closed or tty is closed - whichever is last.
  *
  *	Can sleep.
  */
-static void gsm_dlci_free(struct gsm_dlci *dlci)
+static void gsm_dlci_release(struct gsm_dlci *dlci)
 {
 	struct tty_struct *tty = tty_port_tty_get(&dlci->port);
 	if (tty) {
 		tty_vhangup(tty);
 		tty_kref_put(tty);
 	}
-	del_timer_sync(&dlci->t1);
-	dlci->gsm->dlci[dlci->addr] = NULL;
-	kfifo_free(dlci->fifo);
-	kfree(dlci);
+	dlci_put(dlci);
 }
 
 /*
@@ -2003,7 +2032,7 @@ void gsm_cleanup_mux(struct gsm_mux *gsm)
 	/* Free up any link layer users */
 	for (i = 0; i < NUM_DLCI; i++)
 		if (gsm->dlci[i])
-			gsm_dlci_free(gsm->dlci[i]);
+			gsm_dlci_release(gsm->dlci[i]);
 	/* Now wipe the queues */
 	for (txq = gsm->tx_head; txq != NULL; txq = gsm->tx_head) {
 		gsm->tx_head = txq->next;
@@ -2064,8 +2093,7 @@ EXPORT_SYMBOL_GPL(gsm_activate_mux);
  *	gsm_free_mux		-	free up a mux
  *	@mux: mux to free
  *
- *	Dispose of allocated resources for a dead mux. No refcounting
- *	at present so the mux must be truly dead.
+ *	Dispose of allocated resources for a dead mux
  */
 void gsm_free_mux(struct gsm_mux *gsm)
 {
@@ -2076,6 +2104,28 @@ void gsm_free_mux(struct gsm_mux *gsm)
 EXPORT_SYMBOL_GPL(gsm_free_mux);
 
 /**
+ *	gsm_free_muxr		-	free up a mux
+ *	@mux: mux to free
+ *
+ *	Dispose of allocated resources for a dead mux
+ */
+static void gsm_free_muxr(struct kref *ref)
+{
+	struct gsm_mux *gsm = container_of(ref, struct gsm_mux, ref);
+	gsm_free_mux(gsm);
+}
+
+static inline void mux_get(struct gsm_mux *gsm)
+{
+	kref_get(&gsm->ref);
+}
+
+static inline void mux_put(struct gsm_mux *gsm)
+{
+	kref_put(&gsm->ref, gsm_free_muxr);
+}
+
+/**
  *	gsm_alloc_mux		-	allocate a mux
  *
  *	Creates a new mux ready for activation.
@@ -2098,6 +2148,7 @@ struct gsm_mux *gsm_alloc_mux(void)
 		return NULL;
 	}
 	spin_lock_init(&gsm->lock);
+	kref_init(&gsm->ref);
 
 	gsm->t1 = T1;
 	gsm->t2 = T2;
@@ -2271,7 +2322,7 @@ static void gsmld_close(struct tty_struct *tty)
 
 	gsmld_flush_buffer(tty);
 	/* Do other clean up here */
-	gsm_free_mux(gsm);
+	mux_put(gsm);
 }
 
 /**
@@ -2570,12 +2621,22 @@ static void net_free(struct kref *ref)
 	}
 }
 
+static inline void muxnet_get(struct gsm_mux_net *mux_net)
+{
+	kref_get(&mux_net->ref);
+}
+
+static inline void muxnet_put(struct gsm_mux_net *mux_net)
+{
+	kref_put(&mux_net->ref, net_free);
+}
+
 static int gsm_mux_net_start_xmit(struct sk_buff *skb,
 				      struct net_device *net)
 {
 	struct gsm_mux_net *mux_net = (struct gsm_mux_net *)netdev_priv(net);
 	struct gsm_dlci *dlci = mux_net->dlci;
-	kref_get(&mux_net->ref);
+	muxnet_get(mux_net);
 
 	skb_queue_head(&dlci->skb_list, skb);
 	STATS(net).tx_packets++;
@@ -2583,7 +2644,7 @@ static int gsm_mux_net_start_xmit(struct sk_buff *skb,
 	gsm_dlci_data_kick(dlci);
 	/* And tell the kernel when the last transmit started. */
 	net->trans_start = jiffies;
-	kref_put(&mux_net->ref, net_free);
+	muxnet_put(mux_net);
 	return NETDEV_TX_OK;
 }
 
@@ -2603,14 +2664,14 @@ static void gsm_mux_rx_netchar(struct gsm_dlci *dlci,
 	struct net_device *net = dlci->net;
 	struct sk_buff *skb;
 	struct gsm_mux_net *mux_net = (struct gsm_mux_net *)netdev_priv(net);
-	kref_get(&mux_net->ref);
+	muxnet_get(mux_net);
 
 	/* Allocate an sk_buff */
 	skb = dev_alloc_skb(size + NET_IP_ALIGN);
 	if (!skb) {
 		/* We got no receive buffer. */
 		STATS(net).rx_dropped++;
-		kref_put(&mux_net->ref, net_free);
+		muxnet_put(mux_net);
 		return;
 	}
 	skb_reserve(skb, NET_IP_ALIGN);
@@ -2625,7 +2686,7 @@ static void gsm_mux_rx_netchar(struct gsm_dlci *dlci,
 	/* update out statistics */
 	STATS(net).rx_packets++;
 	STATS(net).rx_bytes += size;
-	kref_put(&mux_net->ref, net_free);
+	muxnet_put(mux_net);
 	return;
 }
 
@@ -2668,7 +2729,7 @@ static void gsm_destroy_network(struct gsm_dlci *dlci)
 	if (!dlci->net)
 		return;
 	mux_net = (struct gsm_mux_net *)netdev_priv(dlci->net);
-	kref_put(&mux_net->ref, net_free);
+	muxnet_put(mux_net);
 }
 
 
@@ -2830,6 +2891,9 @@ static int gsmtty_open(struct tty_struct *tty, struct file *filp)
 	port = &dlci->port;
 	port->count++;
 	tty->driver_data = dlci;
+	dlci_get(dlci);
+	dlci_get(dlci->gsm->dlci[0]);
+	mux_get(dlci->gsm);
 	tty_port_tty_set(port, tty);
 
 	dlci->modem_rx = 0;
@@ -2845,16 +2909,23 @@ static int gsmtty_open(struct tty_struct *tty, struct file *filp)
 static void gsmtty_close(struct tty_struct *tty, struct file *filp)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
+	struct gsm_mux *gsm;
+
 	if (dlci == NULL)
 		return;
 	mutex_lock(&dlci->mutex);
 	gsm_destroy_network(dlci);
 	mutex_unlock(&dlci->mutex);
+	gsm = dlci->gsm;
 	if (tty_port_close_start(&dlci->port, tty, filp) == 0)
-		return;
+		goto out;
 	gsm_dlci_begin_close(dlci);
 	tty_port_close_end(&dlci->port, tty);
 	tty_port_tty_set(&dlci->port, NULL);
+out:
+	dlci_put(dlci);
+	dlci_put(gsm->dlci[0]);
+	mux_put(gsm);
 }
 
 static void gsmtty_hangup(struct tty_struct *tty)
-- 
1.7.0.4

