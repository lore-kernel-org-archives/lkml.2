Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935202Ab1ETEhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 00:37:23 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:53185 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752488Ab1ETEhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 00:37:19 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 02/12] staging: usbip: remove unnecessary lines and extra return statements
Date: Thu, 19 May 2011 21:36:56 -0700
Message-Id: <7c91bc561054db4742fb55022b7534f6b14221a1.1305866084.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305866084.git.mfm@muteddisk.com>
References: <cover.1305866084.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, fix a few alignment issues that were originally missed.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/stub.h         |    1 +
 drivers/staging/usbip/stub_dev.c     |   21 +++++++--------------
 drivers/staging/usbip/stub_main.c    |   13 -------------
 drivers/staging/usbip/stub_tx.c      |   13 ++++++-------
 drivers/staging/usbip/usbip_common.c |   13 ++++++-------
 drivers/staging/usbip/usbip_common.h |    2 +-
 drivers/staging/usbip/vhci_hcd.c     |    9 +++------
 drivers/staging/usbip/vhci_rx.c      |    2 --
 8 files changed, 24 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/usbip/stub.h b/drivers/staging/usbip/stub.h
index 6592aa2..2cc596e 100644
--- a/drivers/staging/usbip/stub.h
+++ b/drivers/staging/usbip/stub.h
@@ -77,6 +77,7 @@ struct stub_unlink {
 };
 
 #define BUSID_SIZE 20
+
 struct bus_id_priv {
 	char name[BUSID_SIZE];
 	char status;
diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index 6e99ec8..e35d62c 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -207,10 +207,11 @@ static void stub_shutdown_connection(struct usbip_device *ud)
 	if (ud->tcp_tx && !task_is_dead(ud->tcp_tx))
 		kthread_stop(ud->tcp_tx);
 
-	/* 2. close the socket */
 	/*
-	 * tcp_socket is freed after threads are killed.
-	 * So usbip_xmit do not touch NULL socket.
+	 * 2. close the socket
+	 *
+	 * tcp_socket is freed after threads are killed so that usbip_xmit does
+	 * not touch NULL socket.
 	 */
 	if (ud->tcp_socket) {
 		sock_release(ud->tcp_socket);
@@ -230,8 +231,8 @@ static void stub_shutdown_connection(struct usbip_device *ud)
 			list_del(&unlink->list);
 			kfree(unlink);
 		}
-		list_for_each_entry_safe(unlink, tmp,
-						 &sdev->unlink_free, list) {
+		list_for_each_entry_safe(unlink, tmp, &sdev->unlink_free,
+					 list) {
 			list_del(&unlink->list);
 			kfree(unlink);
 		}
@@ -258,22 +259,17 @@ static void stub_device_reset(struct usbip_device *ud)
 
 	/* try to reset the device */
 	ret = usb_reset_device(udev);
-
 	usb_unlock_device(udev);
 
 	spin_lock(&ud->lock);
 	if (ret) {
 		dev_err(&udev->dev, "device reset\n");
 		ud->status = SDEV_ST_ERROR;
-
 	} else {
 		dev_info(&udev->dev, "device reset\n");
 		ud->status = SDEV_ST_AVAILABLE;
-
 	}
 	spin_unlock(&ud->lock);
-
-	return;
 }
 
 static void stub_device_unusable(struct usbip_device *ud)
@@ -375,7 +371,7 @@ static int stub_probe(struct usb_interface *interface,
 
 	/* check we should claim or not by busid_table */
 	busid_priv = get_busid_priv(udev_busid);
-	if (!busid_priv  || (busid_priv->status == STUB_BUSID_REMOV) ||
+	if (!busid_priv || (busid_priv->status == STUB_BUSID_REMOV) ||
 	    (busid_priv->status == STUB_BUSID_OTHER)) {
 		dev_info(&interface->dev, "%s is not in match_busid table... "
 			 "skip!\n", udev_busid);
@@ -420,7 +416,6 @@ static int stub_probe(struct usb_interface *interface,
 				udev_busid);
 			usb_set_intfdata(interface, NULL);
 			busid_priv->interf_count--;
-
 			return err;
 		}
 
@@ -443,7 +438,6 @@ static int stub_probe(struct usb_interface *interface,
 	/* set private data to usb_interface */
 	usb_set_intfdata(interface, sdev);
 	busid_priv->interf_count++;
-
 	busid_priv->sdev = sdev;
 
 	err = stub_add_files(&interface->dev);
@@ -453,7 +447,6 @@ static int stub_probe(struct usb_interface *interface,
 		usb_put_intf(interface);
 
 		busid_priv->interf_count = 0;
-
 		busid_priv->sdev = NULL;
 		stub_device_free(sdev);
 		return err;
diff --git a/drivers/staging/usbip/stub_main.c b/drivers/staging/usbip/stub_main.c
index e9085d6..44671ee 100644
--- a/drivers/staging/usbip/stub_main.c
+++ b/drivers/staging/usbip/stub_main.c
@@ -25,9 +25,7 @@
 #define DRIVER_AUTHOR "Takahiro Hirofuchi"
 #define DRIVER_DESC "USB/IP Host Driver"
 
-/* stub_priv is allocated from stub_priv_cache */
 struct kmem_cache *stub_priv_cache;
-
 /*
  * busid_tables defines matching busids that usbip can grab. A user can change
  * dynamically what device is locally used and what device is exported to a
@@ -42,7 +40,6 @@ int match_busid(const char *busid)
 	int i;
 
 	spin_lock(&busid_table_lock);
-
 	for (i = 0; i < MAX_BUSID; i++)
 		if (busid_table[i].name[0])
 			if (!strncmp(busid_table[i].name, busid, BUSID_SIZE)) {
@@ -50,7 +47,6 @@ int match_busid(const char *busid)
 				spin_unlock(&busid_table_lock);
 				return 0;
 			}
-
 	spin_unlock(&busid_table_lock);
 
 	return 1;
@@ -61,7 +57,6 @@ struct bus_id_priv *get_busid_priv(const char *busid)
 	int i;
 
 	spin_lock(&busid_table_lock);
-
 	for (i = 0; i < MAX_BUSID; i++)
 		if (busid_table[i].name[0])
 			if (!strncmp(busid_table[i].name, busid, BUSID_SIZE)) {
@@ -69,7 +64,6 @@ struct bus_id_priv *get_busid_priv(const char *busid)
 				spin_unlock(&busid_table_lock);
 				return &(busid_table[i]);
 			}
-
 	spin_unlock(&busid_table_lock);
 
 	return NULL;
@@ -81,15 +75,12 @@ static ssize_t show_match_busid(struct device_driver *drv, char *buf)
 	char *out = buf;
 
 	spin_lock(&busid_table_lock);
-
 	for (i = 0; i < MAX_BUSID; i++)
 		if (busid_table[i].name[0])
 			out += sprintf(out, "%s ", busid_table[i].name);
-
 	spin_unlock(&busid_table_lock);
 
 	out += sprintf(out, "\n");
-
 	return out - buf;
 }
 
@@ -101,7 +92,6 @@ static int add_match_busid(char *busid)
 		return 0;
 
 	spin_lock(&busid_table_lock);
-
 	for (i = 0; i < MAX_BUSID; i++)
 		if (!busid_table[i].name[0]) {
 			strncpy(busid_table[i].name, busid, BUSID_SIZE);
@@ -111,7 +101,6 @@ static int add_match_busid(char *busid)
 			spin_unlock(&busid_table_lock);
 			return 0;
 		}
-
 	spin_unlock(&busid_table_lock);
 
 	return -1;
@@ -122,7 +111,6 @@ int del_match_busid(char *busid)
 	int i;
 
 	spin_lock(&busid_table_lock);
-
 	for (i = 0; i < MAX_BUSID; i++)
 		if (!strncmp(busid_table[i].name, busid, BUSID_SIZE)) {
 			/* found */
@@ -135,7 +123,6 @@ int del_match_busid(char *busid)
 			spin_unlock(&busid_table_lock);
 			return 0;
 		}
-
 	spin_unlock(&busid_table_lock);
 
 	return -1;
diff --git a/drivers/staging/usbip/stub_tx.c b/drivers/staging/usbip/stub_tx.c
index fda2bc9..1cbae44 100644
--- a/drivers/staging/usbip/stub_tx.c
+++ b/drivers/staging/usbip/stub_tx.c
@@ -97,13 +97,12 @@ void stub_complete(struct urb *urb)
 
 	/* link a urb to the queue of tx. */
 	spin_lock_irqsave(&sdev->priv_lock, flags);
-
 	if (priv->unlinking) {
 		stub_enqueue_ret_unlink(sdev, priv->seqnum, urb->status);
 		stub_free_priv_and_urb(priv);
-	} else
+	} else {
 		list_move_tail(&priv->list, &sdev->priv_tx);
-
+	}
 	spin_unlock_irqrestore(&sdev->priv_lock, flags);
 
 	/* wake up tx_thread */
@@ -113,10 +112,10 @@ void stub_complete(struct urb *urb)
 static inline void setup_base_pdu(struct usbip_header_basic *base,
 				  __u32 command, __u32 seqnum)
 {
-	base->command = command;
-	base->seqnum  = seqnum;
-	base->devid   = 0;
-	base->ep      = 0;
+	base->command	= command;
+	base->seqnum	= seqnum;
+	base->devid	= 0;
+	base->ep	= 0;
 	base->direction = 0;
 }
 
diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index 433a3b6..954d90d 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -63,9 +63,9 @@ static void usbip_dump_buffer(char *buff, int bufflen)
 static void usbip_dump_pipe(unsigned int p)
 {
 	unsigned char type = usb_pipetype(p);
-	unsigned char ep = usb_pipeendpoint(p);
-	unsigned char dev = usb_pipedevice(p);
-	unsigned char dir = usb_pipein(p);
+	unsigned char ep   = usb_pipeendpoint(p);
+	unsigned char dev  = usb_pipedevice(p);
+	unsigned char dir  = usb_pipein(p);
 
 	pr_debug("dev(%d) ep(%d) [%s] ", dev, ep, dir ? "IN" : "OUT");
 
@@ -334,8 +334,8 @@ void usbip_dump_header(struct usbip_header *pdu)
 EXPORT_SYMBOL_GPL(usbip_dump_header);
 
 /* Send/receive messages over TCP/IP. I refer drivers/block/nbd.c */
-int usbip_xmit(int send, struct socket *sock, char *buf,
-	       int size, int msg_flags)
+int usbip_xmit(int send, struct socket *sock, char *buf, int size,
+	       int msg_flags)
 {
 	int result;
 	struct msghdr msg;
@@ -628,8 +628,7 @@ void usbip_header_correct_endian(struct usbip_header *pdu, int send)
 EXPORT_SYMBOL_GPL(usbip_header_correct_endian);
 
 static void usbip_iso_pakcet_correct_endian(
-	struct usbip_iso_packet_descriptor *iso,
-	int send)
+		struct usbip_iso_packet_descriptor *iso, int send)
 {
 	/* does not need all members. but copy all simply. */
 	if (send) {
diff --git a/drivers/staging/usbip/usbip_common.h b/drivers/staging/usbip/usbip_common.h
index 4a641c5..83f8c1e 100644
--- a/drivers/staging/usbip/usbip_common.h
+++ b/drivers/staging/usbip/usbip_common.h
@@ -65,7 +65,7 @@ enum {
 #define usbip_dbg_flag_vhci_tx	(usbip_debug_flag & usbip_debug_vhci_tx)
 #define usbip_dbg_flag_stub_rx	(usbip_debug_flag & usbip_debug_stub_rx)
 #define usbip_dbg_flag_stub_tx	(usbip_debug_flag & usbip_debug_stub_tx)
-#define usbip_dbg_flag_vhci_sysfs   (usbip_debug_flag & usbip_debug_vhci_sysfs)
+#define usbip_dbg_flag_vhci_sysfs  (usbip_debug_flag & usbip_debug_vhci_sysfs)
 
 extern unsigned long usbip_debug_flag;
 extern struct device_attribute dev_attr_usbip_debug;
diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index a76e8fa..5b94b80 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -344,9 +344,9 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		 *                                   */
 		if (dum->resuming && time_after(jiffies, dum->re_timeout)) {
 			dum->port_status[rhport] |=
-					(1 << USB_PORT_FEAT_C_SUSPEND);
+				(1 << USB_PORT_FEAT_C_SUSPEND);
 			dum->port_status[rhport] &=
-					~(1 << USB_PORT_FEAT_SUSPEND);
+				~(1 << USB_PORT_FEAT_SUSPEND);
 			dum->resuming = 0;
 			dum->re_timeout = 0;
 			/* if (dum->driver && dum->driver->resume) {
@@ -639,9 +639,7 @@ no_need_xmit:
 	usb_hcd_unlink_urb_from_ep(hcd, urb);
 no_need_unlink:
 	spin_unlock_irqrestore(&the_controller->lock, flags);
-
 	usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb, urb->status);
-
 	return ret;
 }
 
@@ -1033,9 +1031,8 @@ static int vhci_bus_resume(struct usb_hcd *hcd)
 		hcd->state = HC_STATE_RUNNING;
 	}
 	spin_unlock_irq(&vhci->lock);
-	return rc;
 
-	return 0;
+	return rc;
 }
 
 #else
diff --git a/drivers/staging/usbip/vhci_rx.c b/drivers/staging/usbip/vhci_rx.c
index e42ce9d..09c44ab 100644
--- a/drivers/staging/usbip/vhci_rx.c
+++ b/drivers/staging/usbip/vhci_rx.c
@@ -179,8 +179,6 @@ static void vhci_recv_ret_unlink(struct vhci_device *vdev,
 	}
 
 	kfree(unlink);
-
-	return;
 }
 
 static int vhci_priv_tx_empty(struct vhci_device *vdev)
-- 
1.7.5.1

