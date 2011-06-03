Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab1FCTFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 15:05:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:38815 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398Ab1FCTEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 15:04:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,315,1304319600"; 
   d="scan'208";a="13242374"
From: Russ Gorby <russ.gorby@intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Russ Gorby <russ.gorby@intel.com>,
        linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com, russ.gorby@intel.com
Subject: [PATCH 3/5] tty: n_gsm: Added refcount usage to gsm_mux and gsm_dlci structs
Date: Fri,  3 Jun 2011 12:03:39 -0700
Message-Id: <1307127821-21665-4-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH 0/5] N_GSM patchset : 06/03/2011>
References: <[PATCH 0/5] N_GSM patchset : 06/03/2011>
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
 drivers/tty/n_gsm.c |   83 ++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 69 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 0a2a5da..c8a43de 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -133,6 +133,7 @@ struct gsm_dlci {
 #define DLCI_OPENING		1	/* Sending SABM not seen UA */
 #define DLCI_OPEN		2	/* SABM/UA complete */
 #define DLCI_CLOSING		3	/* Sending DISC not seen UA/DM */
+	struct kref ref;		/* freed from port or mux close */
 
 	/* Link layer */
 	spinlock_t lock;	/* Protects the internal state */
@@ -191,6 +192,7 @@ struct gsm_mux {
 	struct tty_struct *tty;		/* The tty our ldisc is bound to */
 	spinlock_t lock;
 	unsigned int num;
+	struct kref ref;
 
 	/* Events on the GSM channel */
 	wait_queue_head_t event;
@@ -1603,6 +1605,7 @@ static struct gsm_dlci *gsm_dlci_alloc(struct gsm_mux *gsm, int addr)
 	if (dlci == NULL)
 		return NULL;
 	spin_lock_init(&dlci->lock);
+	kref_init(&dlci->ref);
 	dlci->fifo = &dlci->_fifo;
 	if (kfifo_alloc(&dlci->_fifo, 4096, GFP_KERNEL) < 0) {
 		kfree(dlci);
@@ -1629,26 +1632,42 @@ static struct gsm_dlci *gsm_dlci_alloc(struct gsm_mux *gsm, int addr)
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
+	kref_put(&dlci->ref, gsm_dlci_free);
 }
 
 /*
@@ -1986,7 +2005,7 @@ void gsm_cleanup_mux(struct gsm_mux *gsm)
 	/* Free up any link layer users */
 	for (i = 0; i < NUM_DLCI; i++)
 		if (gsm->dlci[i])
-			gsm_dlci_free(gsm->dlci[i]);
+			gsm_dlci_release(gsm->dlci[i]);
 	/* Now wipe the queues */
 	for (txq = gsm->tx_head; txq != NULL; txq = gsm->tx_head) {
 		gsm->tx_head = txq->next;
@@ -2047,8 +2066,7 @@ EXPORT_SYMBOL_GPL(gsm_activate_mux);
  *	gsm_free_mux		-	free up a mux
  *	@mux: mux to free
  *
- *	Dispose of allocated resources for a dead mux. No refcounting
- *	at present so the mux must be truly dead.
+ *	Dispose of allocated resources for a dead mux
  */
 void gsm_free_mux(struct gsm_mux *gsm)
 {
@@ -2059,6 +2077,30 @@ void gsm_free_mux(struct gsm_mux *gsm)
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
+/**
+ *	gsm_release_mux		-	release a mux
+ *	@mux: mux to release
+ *
+ *	Dispose of allocated resources for a dead mux on release
+ *	from last client.
+ */
+static void gsm_release_mux(struct gsm_mux *gsm)
+{
+	kref_put(&gsm->ref, gsm_free_muxr);
+}
+
+/**
  *	gsm_alloc_mux		-	allocate a mux
  *
  *	Creates a new mux ready for activation.
@@ -2081,6 +2123,7 @@ struct gsm_mux *gsm_alloc_mux(void)
 		return NULL;
 	}
 	spin_lock_init(&gsm->lock);
+	kref_init(&gsm->ref);
 
 	gsm->t1 = T1;
 	gsm->t2 = T2;
@@ -2255,7 +2298,7 @@ static void gsmld_close(struct tty_struct *tty)
 
 	gsmld_flush_buffer(tty);
 	/* Do other clean up here */
-	gsm_free_mux(gsm);
+	gsm_release_mux(gsm);
 }
 
 /**
@@ -2805,6 +2848,9 @@ static int gsmtty_open(struct tty_struct *tty, struct file *filp)
 	port = &dlci->port;
 	port->count++;
 	tty->driver_data = dlci;
+	kref_get(&dlci->ref);
+	kref_get(&dlci->gsm->dlci[0]->ref);
+	kref_get(&dlci->gsm->ref);
 	tty_port_tty_set(port, tty);
 
 	dlci->modem_rx = 0;
@@ -2820,14 +2866,23 @@ static int gsmtty_open(struct tty_struct *tty, struct file *filp)
 static void gsmtty_close(struct tty_struct *tty, struct file *filp)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
+	struct gsm_mux *gsm;
+
 	if (dlci == NULL)
 		return;
+	gsm = dlci->gsm;
 	gsm_destroy_network(dlci);
-	if (tty_port_close_start(&dlci->port, tty, filp) == 0)
+	if (tty_port_close_start(&dlci->port, tty, filp) == 0) {
+		kref_put(&dlci->ref, gsm_dlci_free);
+		gsm_release_mux(gsm);
 		return;
+	}
 	gsm_dlci_begin_close(dlci);
 	tty_port_close_end(&dlci->port, tty);
 	tty_port_tty_set(&dlci->port, NULL);
+	kref_put(&dlci->ref, gsm_dlci_free);
+	kref_put(&gsm->dlci[0]->ref, gsm_dlci_free);
+	gsm_release_mux(gsm);
 }
 
 static void gsmtty_hangup(struct tty_struct *tty)
-- 
1.7.0.4

