Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab2G2OGx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 10:06:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38440 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab2G2OGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 10:06:52 -0400
From: Baodong Chen <chenbdchenbd@gmail.com>
To: gregkh@linuxfoundation.org, jslaby@suse.cz, davem@davemloft.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Baodong Chen <chenbdchenbd@gmail.com>
Subject: [PATCH] staging:net:fixed to fit tty_driver's kref field
Date: Sun, 29 Jul 2012 22:06:32 +0800
Message-Id: <1343570792-10604-1-git-send-email-chenbdchenbd@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed code to fix tty_driver's kref field
Coding style issues

Signed-off-by: Baodong Chen <chenbdchenbd@gmail.com>
---
 drivers/staging/net/pc300_tty.c |  123 ++++++++++++++++++++------------------
 1 files changed, 65 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/net/pc300_tty.c b/drivers/staging/net/pc300_tty.c
index 4709f42..8a7277c 100644
--- a/drivers/staging/net/pc300_tty.c
+++ b/drivers/staging/net/pc300_tty.c
@@ -46,6 +46,8 @@
 #include <linux/slab.h>
 #include <linux/if.h>
 #include <linux/skbuff.h>
+#include <linux/kref.h>
+
 /* TTY includes */
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
@@ -134,12 +136,26 @@ static void cpc_tty_signal_on(pc300dev_t *pc300dev, unsigned char);
 static int pc300_tiocmset(struct tty_struct *, unsigned int, unsigned int);
 static int pc300_tiocmget(struct tty_struct *);
 
+static void cpc_tty_do_unreg_driver(struct kref *ref);
+
 /* functions called by PC300 driver */
 void cpc_tty_init(pc300dev_t *dev);
 void cpc_tty_unregister_service(pc300dev_t *pc300dev);
 void cpc_tty_receive(pc300dev_t *pc300dev);
 void cpc_tty_trigger_poll(pc300dev_t *pc300dev);
 
+static void cpc_tty_do_unreg_driver(struct kref *ref)
+{
+	struct tty_driver *drv = container_of(ref, struct tty_driver, kref);
+	int ret;
+
+	cpc_tty_unreg_flag = 0;
+
+	res = tty_unregister_driver(drv);
+	if (res)
+		CPC_TTY_DBG("unregister the tty driver error=%d\n", res);
+}
+
 /*
  * PC300 TTY clear "signal"
  */
@@ -239,6 +255,8 @@ void cpc_tty_init(pc300dev_t *pc300dev)
 		/* interface routines from the upper tty layer to the tty driver */
 		tty_set_operations(&serial_drv, &pc300_ops);
 
+		kref_init(&serial_drv.kref);
+
 		/* register the TTY driver */
 		if (tty_register_driver(&serial_drv)) { 
 			printk("%s-tty: Failed to register serial driver! ",
@@ -363,37 +381,37 @@ static void cpc_tty_close(struct tty_struct *tty, struct file *flip)
 	unsigned long flags;
 	int res;
 
-	if (!tty || !tty->driver_data ) {
+	if (!tty || !tty->driver_data) {
 		CPC_TTY_DBG("hdlx-tty: no TTY in close\n");
 		return;
 	}
 
 	cpc_tty = (st_cpc_tty_area *) tty->driver_data;
 
-	if ((cpc_tty->tty != tty)|| (cpc_tty->state != CPC_TTY_ST_OPEN)) {
-		CPC_TTY_DBG("%s: TTY is not opened\n",cpc_tty->name);
+	if ((cpc_tty->tty != tty) || (cpc_tty->state != CPC_TTY_ST_OPEN)) {
+		CPC_TTY_DBG("%s: TTY is not opened\n", cpc_tty->name);
 		return;
 	}
-   	
+
 	if (!cpc_tty->num_open) {
-		CPC_TTY_DBG("%s: TTY is closed\n",cpc_tty->name);
+		CPC_TTY_DBG("%s: TTY is closed\n", cpc_tty->name);
 		return;
 	}
 
 	if (--cpc_tty->num_open > 0) {
-		CPC_TTY_DBG("%s: TTY closed\n",cpc_tty->name);
+		CPC_TTY_DBG("%s: TTY closed\n", cpc_tty->name);
 		return;
 	}
 
 	cpc_tty_signal_off(cpc_tty->pc300dev, CTL_DTR);
 
-	CPC_TTY_LOCK(cpc_tty->pc300dev->chan->card, flags);  /* lock irq */ 
+	CPC_TTY_LOCK(cpc_tty->pc300dev->chan->card, flags);  /* lock irq */
 	cpc_tty->tty = NULL;
 	cpc_tty->state = CPC_TTY_ST_INIT;
-	CPC_TTY_UNLOCK(cpc_tty->pc300dev->chan->card, flags); /* unlock irq */ 
-	
+	CPC_TTY_UNLOCK(cpc_tty->pc300dev->chan->card, flags); /* unlock irq */
+
 	if (cpc_tty->buf_rx.first) {
-		unsigned char * aux;
+		unsigned char *aux;
 		while (cpc_tty->buf_rx.first) {
 			aux = (unsigned char *)cpc_tty->buf_rx.first;
 			cpc_tty->buf_rx.first = cpc_tty->buf_rx.first->next;
@@ -402,22 +420,18 @@ static void cpc_tty_close(struct tty_struct *tty, struct file *flip)
 		cpc_tty->buf_rx.first = NULL;
 		cpc_tty->buf_rx.last = NULL;
 	}
-	
+
 	kfree(cpc_tty->buf_tx);
 	cpc_tty->buf_tx = NULL;
 
-	CPC_TTY_DBG("%s: TTY closed\n",cpc_tty->name);
-	
-	if (!serial_drv.refcount && cpc_tty_unreg_flag) {
-		cpc_tty_unreg_flag = 0;
-		CPC_TTY_DBG("%s: unregister the tty driver\n", cpc_tty->name);
-		if ((res=tty_unregister_driver(&serial_drv))) { 
-			CPC_TTY_DBG("%s: ERROR ->unregister the tty driver error=%d\n",
-							cpc_tty->name,res);
-		}
+	CPC_TTY_DBG("%s: TTY closed\n", cpc_tty->name);
+
+	if (cpc_tty_unreg_flag) {
+		CPC_TTY_DBG("%s: checking unregister the tty driver...\n", cpc_tty->name);
+		kref_put(&serial_drv.kref, cpc_tty_do_unreg_driver);
 	}
-	return; 
-} 
+	return;
+}
 
 /*
  * PC300 TTY WRITE routine
@@ -624,33 +638,29 @@ static void cpc_tty_flush_buffer(struct tty_struct *tty)
 /*
  * PC300 TTY Hangup routine
  *
- * This routine is called by the tty driver to hangup the interface 
+ * This routine is called by the tty driver to hangup the interface
  * o clear DTR signal
  */
 
 static void cpc_tty_hangup(struct tty_struct *tty)
-{ 
-	st_cpc_tty_area    *cpc_tty; 
+{
+	st_cpc_tty_area    *cpc_tty;
 	int res;
 
-	if (!tty || !tty->driver_data ) {
-		CPC_TTY_DBG("hdlcX-tty: no TTY to hangup\n");	
-		return ; 
+	if (!tty || !tty->driver_data) {
+		CPC_TTY_DBG("hdlcX-tty: no TTY to hangup\n");
+		return ;
 	}
 
-	cpc_tty = (st_cpc_tty_area *) tty->driver_data; 
+	cpc_tty = (st_cpc_tty_area *) tty->driver_data;
 
 	if ((cpc_tty->tty != tty) || (cpc_tty->state != CPC_TTY_ST_OPEN)) {
-		CPC_TTY_DBG("%s: TTY is not opened\n",cpc_tty->name);
+		CPC_TTY_DBG("%s: TTY is not opened\n", cpc_tty->name);
 		return ;
 	}
-	if (!serial_drv.refcount && cpc_tty_unreg_flag) {
-		cpc_tty_unreg_flag = 0;
-		CPC_TTY_DBG("%s: unregister the tty driver\n", cpc_tty->name);
-		if ((res=tty_unregister_driver(&serial_drv))) { 
-			CPC_TTY_DBG("%s: ERROR ->unregister the tty driver error=%d\n",
-							cpc_tty->name,res);
-		}
+	if (cpc_tty_unreg_flag) {
+		CPC_TTY_DBG("%s: checking unregister the tty driver...\n", cpc_tty->name);
+		kref_put(&serial_drv.kref, cpc_tty_do_unreg_driver);
 	}
 	cpc_tty_signal_off(cpc_tty->pc300dev, CTL_DTR);
 }
@@ -1027,43 +1037,40 @@ static void cpc_tty_trace(pc300dev_t *dev, char* buf, int len, char rxtx)
  */
 void cpc_tty_unregister_service(pc300dev_t *pc300dev)
 {
-	st_cpc_tty_area *cpc_tty; 
+	st_cpc_tty_area *cpc_tty = (st_cpc_tty_area *) pc300dev->cpc_tty;
 	ulong flags;
 	int res;
 
-	if ((cpc_tty= (st_cpc_tty_area *) pc300dev->cpc_tty) == NULL) {
+	if (cpc_tty == NULL) {
 		CPC_TTY_DBG("%s: interface is not TTY\n", pc300dev->dev->name);
-		return; 
+		return;
 	}
 	CPC_TTY_DBG("%s: cpc_tty_unregister_service", cpc_tty->name);
 
-	if (cpc_tty->pc300dev != pc300dev) { 
-		CPC_TTY_DBG("%s: invalid tty ptr=%s\n", 
+	if (cpc_tty->pc300dev != pc300dev) {
+		CPC_TTY_DBG("%s: invalid tty ptr=%s\n",
 		pc300dev->dev->name, cpc_tty->name);
-		return; 
+		return;
 	}
 
-	if (--cpc_tty_cnt == 0) { 
-		if (serial_drv.refcount) {
-			CPC_TTY_DBG("%s: unregister is not possible, refcount=%d",
-							cpc_tty->name, serial_drv.refcount);
+	if (--cpc_tty_cnt == 0) {
+		CPC_TTY_DBG("%s: checking unregister the tty driver...\n",
+				cpc_tty->name);
+		res = kref_put(&serial_drv.kref, cpc_tty_do_unreg_driver);
+		if (0 == res) {
+			CPC_TTY_DBG("%s: unregister is not possible\n",
+					cpc_tty->name);
 			cpc_tty_cnt++;
 			cpc_tty_unreg_flag = 1;
 			return;
-		} else { 
-			CPC_TTY_DBG("%s: unregister the tty driver\n", cpc_tty->name);
-			if ((res=tty_unregister_driver(&serial_drv))) { 
-				CPC_TTY_DBG("%s: ERROR ->unregister the tty driver error=%d\n",
-								cpc_tty->name,res);
-			}
 		}
 	}
-	CPC_TTY_LOCK(pc300dev->chan->card,flags);
-	cpc_tty->tty = NULL; 
+	CPC_TTY_LOCK(pc300dev->chan->card, flags);
+	cpc_tty->tty = NULL;
 	CPC_TTY_UNLOCK(pc300dev->chan->card, flags);
-	cpc_tty->tty_minor = 0; 
-	cpc_tty->state = CPC_TTY_ST_IDLE; 
-} 
+	cpc_tty->tty_minor = 0;
+	cpc_tty->state = CPC_TTY_ST_IDLE;
+}
 
 /*
  * PC300 TTY trigger poll routine
-- 
1.7.0.4

