Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993085Ab2KOIuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:50:11 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:58347 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992995Ab2KOIuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:50:04 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 6/9] TTY: n_gsm, use kref from tty_port
Date: Thu, 15 Nov 2012 09:49:53 +0100
Message-Id: <1352969396-23760-7-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352969396-23760-1-git-send-email-jslaby@suse.cz>
References: <1352969396-23760-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit "TTY: move tty buffers to tty_port", the tty buffers are
not freed in some drivers. This is because tty_port_destructor is not
called whenever a tty_port is freed. This was an assumption I counted
with but was unfortunately untrue. So fix the drivers to fulfil this
assumption.

Here it is enough to switch to refcounting in tty_port.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/n_gsm.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 1e8e8ce..dcc0430 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -134,7 +134,6 @@ struct gsm_dlci {
 #define DLCI_OPENING		1	/* Sending SABM not seen UA */
 #define DLCI_OPEN		2	/* SABM/UA complete */
 #define DLCI_CLOSING		3	/* Sending DISC not seen UA/DM */
-	struct kref ref;		/* freed from port or mux close */
 	struct mutex mutex;
 
 	/* Link layer */
@@ -1635,7 +1634,6 @@ static struct gsm_dlci *gsm_dlci_alloc(struct gsm_mux *gsm, int addr)
 	if (dlci == NULL)
 		return NULL;
 	spin_lock_init(&dlci->lock);
-	kref_init(&dlci->ref);
 	mutex_init(&dlci->mutex);
 	dlci->fifo = &dlci->_fifo;
 	if (kfifo_alloc(&dlci->_fifo, 4096, GFP_KERNEL) < 0) {
@@ -1669,9 +1667,9 @@ static struct gsm_dlci *gsm_dlci_alloc(struct gsm_mux *gsm, int addr)
  *
  *	Can sleep.
  */
-static void gsm_dlci_free(struct kref *ref)
+static void gsm_dlci_free(struct tty_port *port)
 {
-	struct gsm_dlci *dlci = container_of(ref, struct gsm_dlci, ref);
+	struct gsm_dlci *dlci = container_of(port, struct gsm_dlci, port);
 
 	del_timer_sync(&dlci->t1);
 	dlci->gsm->dlci[dlci->addr] = NULL;
@@ -1683,12 +1681,12 @@ static void gsm_dlci_free(struct kref *ref)
 
 static inline void dlci_get(struct gsm_dlci *dlci)
 {
-	kref_get(&dlci->ref);
+	tty_port_get(&dlci->port);
 }
 
 static inline void dlci_put(struct gsm_dlci *dlci)
 {
-	kref_put(&dlci->ref, gsm_dlci_free);
+	tty_port_put(&dlci->port);
 }
 
 /**
@@ -2874,6 +2872,7 @@ static void gsm_dtr_rts(struct tty_port *port, int onoff)
 static const struct tty_port_operations gsm_port_ops = {
 	.carrier_raised = gsm_carrier_raised,
 	.dtr_rts = gsm_dtr_rts,
+	.destruct = gsm_dlci_free,
 };
 
 static int gsmtty_install(struct tty_driver *driver, struct tty_struct *tty)
-- 
1.8.0


