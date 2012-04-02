Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab2DBL4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:05 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48001 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab2DBLzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:07 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 67/69] TTY: rfcomm/tty, use tty_port refcounting
Date: Mon,  2 Apr 2012 13:54:51 +0200
Message-Id: <1333367693-3244-68-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch the refcounting from manual atomic plays with refcounter to the
one offered by tty_port.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/bluetooth/rfcomm/tty.c |   58 ++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 32 deletions(-)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 97c2a08..da4f545 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -50,7 +50,6 @@ static struct tty_driver *rfcomm_tty_driver;
 struct rfcomm_dev {
 	struct tty_port		port;
 	struct list_head	list;
-	atomic_t		refcnt;
 
 	char			name[12];
 	int			id;
@@ -85,8 +84,17 @@ static void rfcomm_dev_modem_status(struct rfcomm_dlc *dlc, u8 v24_sig);
 static void rfcomm_tty_wakeup(struct work_struct *work);
 
 /* ---- Device functions ---- */
-static void rfcomm_dev_destruct(struct rfcomm_dev *dev)
+
+/*
+ * The reason this isn't actually a race, as you no doubt have a little voice
+ * screaming at you in your head, is that the refcount should never actually
+ * reach zero unless the device has already been taken off the list, in
+ * rfcomm_dev_del(). And if that's not true, we'll hit the BUG() in
+ * rfcomm_dev_destruct() anyway.
+ */
+static void rfcomm_dev_destruct(struct tty_port *port)
 {
+	struct rfcomm_dev *dev = container_of(port, struct rfcomm_dev, port);
 	struct rfcomm_dlc *dlc = dev->dlc;
 
 	BT_DBG("dev %p dlc %p", dev, dlc);
@@ -113,23 +121,9 @@ static void rfcomm_dev_destruct(struct rfcomm_dev *dev)
 	module_put(THIS_MODULE);
 }
 
-static inline void rfcomm_dev_hold(struct rfcomm_dev *dev)
-{
-	atomic_inc(&dev->refcnt);
-}
-
-static inline void rfcomm_dev_put(struct rfcomm_dev *dev)
-{
-	/* The reason this isn't actually a race, as you no
-	   doubt have a little voice screaming at you in your
-	   head, is that the refcount should never actually
-	   reach zero unless the device has already been taken
-	   off the list, in rfcomm_dev_del(). And if that's not
-	   true, we'll hit the BUG() in rfcomm_dev_destruct()
-	   anyway. */
-	if (atomic_dec_and_test(&dev->refcnt))
-		rfcomm_dev_destruct(dev);
-}
+static const struct tty_port_operations rfcomm_port_ops = {
+	.destruct = rfcomm_dev_destruct,
+};
 
 static struct rfcomm_dev *__rfcomm_dev_get(int id)
 {
@@ -154,7 +148,7 @@ static inline struct rfcomm_dev *rfcomm_dev_get(int id)
 		if (test_bit(RFCOMM_TTY_RELEASED, &dev->flags))
 			dev = NULL;
 		else
-			rfcomm_dev_hold(dev);
+			tty_port_get(&dev->port);
 	}
 
 	spin_unlock(&rfcomm_dev_lock);
@@ -241,7 +235,6 @@ static int rfcomm_dev_add(struct rfcomm_dev_req *req, struct rfcomm_dlc *dlc)
 	sprintf(dev->name, "rfcomm%d", dev->id);
 
 	list_add(&dev->list, head);
-	atomic_set(&dev->refcnt, 1);
 
 	bacpy(&dev->src, &req->src);
 	bacpy(&dev->dst, &req->dst);
@@ -253,6 +246,7 @@ static int rfcomm_dev_add(struct rfcomm_dev_req *req, struct rfcomm_dlc *dlc)
 	atomic_set(&dev->opened, 0);
 
 	tty_port_init(&dev->port);
+	dev->port.ops = &rfcomm_port_ops;
 	init_waitqueue_head(&dev->wait);
 	INIT_WORK(&dev->wakeup_task, rfcomm_tty_wakeup);
 
@@ -332,7 +326,7 @@ static void rfcomm_dev_del(struct rfcomm_dev *dev)
 	list_del_init(&dev->list);
 	spin_unlock(&rfcomm_dev_lock);
 
-	rfcomm_dev_put(dev);
+	tty_port_put(&dev->port);
 }
 
 /* ---- Send buffer ---- */
@@ -349,12 +343,12 @@ static void rfcomm_wfree(struct sk_buff *skb)
 	atomic_sub(skb->truesize, &dev->wmem_alloc);
 	if (test_bit(RFCOMM_TTY_ATTACHED, &dev->flags))
 		queue_work(system_nrt_wq, &dev->wakeup_task);
-	rfcomm_dev_put(dev);
+	tty_port_put(&dev->port);
 }
 
 static inline void rfcomm_set_owner_w(struct sk_buff *skb, struct rfcomm_dev *dev)
 {
-	rfcomm_dev_hold(dev);
+	tty_port_get(&dev->port);
 	atomic_add(skb->truesize, &dev->wmem_alloc);
 	skb->sk = (void *) dev;
 	skb->destructor = rfcomm_wfree;
@@ -433,7 +427,7 @@ static int rfcomm_release_dev(void __user *arg)
 		return -ENODEV;
 
 	if (dev->flags != NOCAP_FLAGS && !capable(CAP_NET_ADMIN)) {
-		rfcomm_dev_put(dev);
+		tty_port_put(&dev->port);
 		return -EPERM;
 	}
 
@@ -446,7 +440,7 @@ static int rfcomm_release_dev(void __user *arg)
 
 	if (!test_bit(RFCOMM_RELEASE_ONHUP, &dev->flags))
 		rfcomm_dev_del(dev);
-	rfcomm_dev_put(dev);
+	tty_port_put(&dev->port);
 	return 0;
 }
 
@@ -524,7 +518,7 @@ static int rfcomm_get_dev_info(void __user *arg)
 	if (copy_to_user(arg, &di, sizeof(di)))
 		err = -EFAULT;
 
-	rfcomm_dev_put(dev);
+	tty_port_put(&dev->port);
 	return err;
 }
 
@@ -592,7 +586,7 @@ static void rfcomm_dev_state_change(struct rfcomm_dlc *dlc, int err)
 				 * 1. rfcomm_dev_get will take rfcomm_dev_lock
 				 *    but in rfcomm_dev_add there's lock order:
 				 *    rfcomm_dev_lock -> dlc lock
-				 * 2. rfcomm_dev_put will deadlock if it's
+				 * 2. tty_port_put will deadlock if it's
 				 *    the last reference
 				 */
 				rfcomm_dlc_unlock(dlc);
@@ -602,7 +596,7 @@ static void rfcomm_dev_state_change(struct rfcomm_dlc *dlc, int err)
 				}
 
 				rfcomm_dev_del(dev);
-				rfcomm_dev_put(dev);
+				tty_port_put(&dev->port);
 				rfcomm_dlc_lock(dlc);
 			}
 		} else
@@ -771,11 +765,11 @@ static void rfcomm_tty_close(struct tty_struct *tty, struct file *filp)
 			list_del_init(&dev->list);
 			spin_unlock(&rfcomm_dev_lock);
 
-			rfcomm_dev_put(dev);
+			tty_port_put(&dev->port);
 		}
 	}
 
-	rfcomm_dev_put(dev);
+	tty_port_put(&dev->port);
 }
 
 static int rfcomm_tty_write(struct tty_struct *tty, const unsigned char *buf, int count)
@@ -1084,7 +1078,7 @@ static void rfcomm_tty_hangup(struct tty_struct *tty)
 		if (rfcomm_dev_get(dev->id) == NULL)
 			return;
 		rfcomm_dev_del(dev);
-		rfcomm_dev_put(dev);
+		tty_port_put(&dev->port);
 	}
 }
 
-- 
1.7.9.2


