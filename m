Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762576Ab2FVPaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:30:23 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40780 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762327Ab2FVPaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:30:18 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 10/12] tty: tidy up the RESET_TERMIOS case
To: greg@kroah.com, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Fri, 22 Jun 2012 16:46:14 +0100
Message-ID: <20120622154510.1405.45258.stgit@localhost.localdomain>
In-Reply-To: <20120622153600.1405.15575.stgit@localhost.localdomain>
References: <20120622153600.1405.15575.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we are going to reset the termios then we don't need the driver side
buffers at all as we now have the tty allocation.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/tty_io.c |   45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index f5c8d4f..14db2a8 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1249,16 +1249,20 @@ int tty_init_termios(struct tty_struct *tty)
 	struct ktermios *tp;
 	int idx = tty->index;
 
-	tp = tty->driver->termios[idx];
-	if (tp == NULL) {
-		tp = kmalloc(sizeof(struct ktermios), GFP_KERNEL);
-		if (tp == NULL)
-			return -ENOMEM;
-		*tp = tty->driver->init_termios;
-		tty->driver->termios[idx] = tp;
-	}
-	tty->termios = *tp;
-
+	if (tty->driver->flags & TTY_DRIVER_RESET_TERMIOS)
+		tty->termios = tty->driver->init_termios;
+	else {
+		tp = tty->driver->termios[idx];
+		if (tp == NULL) {
+			tp = kzalloc(sizeof(struct ktermios[2]), GFP_KERNEL);
+			if (tp == NULL)
+				return -ENOMEM;
+			tp[0] = tty->driver->init_termios;
+			tty->driver->termios[idx] = tp;
+		}
+		tty->termios = tp[0];
+		tty->termios_locked = tp[1];
+        }
 	/* Compatibility until drivers always set this */
 	tty->termios.c_ispeed = tty_termios_input_baud_rate(&tty->termios);
 	tty->termios.c_ospeed = tty_termios_baud_rate(&tty->termios);
@@ -1432,16 +1436,9 @@ err_release_tty:
 
 void tty_free_termios(struct tty_struct *tty)
 {
-	struct ktermios *tp;
 	int idx = tty->index;
 	/* Kill this flag and push into drivers for locking etc */
-	if (tty->driver->flags & TTY_DRIVER_RESET_TERMIOS) {
-		/* FIXME: Locking on ->termios array */
-		tp = tty->driver->termios[idx];
-		tty->driver->termios[idx] = NULL;
-		kfree(tp);
-	}
-	else
+	if (!(tty->driver->flags & TTY_DRIVER_RESET_TERMIOS))
 		*tty->driver->termios[idx] = tty->termios;
 }
 EXPORT_SYMBOL(tty_free_termios);
@@ -3069,16 +3066,18 @@ static void destruct_tty_driver(struct kref *kref)
 		 * drivers are removed from the kernel.
 		 */
 		for (i = 0; i < driver->num; i++) {
-			tp = driver->termios[i];
-			if (tp) {
-				driver->termios[i] = NULL;
-				kfree(tp);
+			if (!(driver->flags & TTY_DRIVER_RESET_TERMIOS)) {
+				tp = driver->termios[i];
+				if (tp) {
+					driver->termios[i] = NULL;
+					kfree(tp);
+				}
 			}
 			if (!(driver->flags & TTY_DRIVER_DYNAMIC_DEV))
 				tty_unregister_device(driver, i);
 		}
 		p = driver->ttys;
 		proc_tty_unregister_driver(driver);
 		driver->ttys = NULL;
 		driver->termios = NULL;
 		kfree(p);
@@ -3117,6 +3117,7 @@ int tty_register_driver(struct tty_driver *driver)
 	void **p = NULL;
 	struct device *d;
 
+	/* FIXME: at this point we are overallocating for the RESET_TERMIOS case */
 	if (!(driver->flags & TTY_DRIVER_DEVPTS_MEM) && driver->num) {
 		p = kzalloc(driver->num * 2 * sizeof(void *), GFP_KERNEL);
 		if (!p)

