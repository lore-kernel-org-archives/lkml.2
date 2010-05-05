Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934578Ab0EEKkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 06:40:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54766 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934554Ab0EEKk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 06:40:29 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 04/20] isicom: kill off the BKL
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Date: Wed, 05 May 2010 11:02:02 +0100
Message-ID: <20100505100202.3595.51706.stgit@localhost.localdomain>
In-Reply-To: <20100505100144.3595.65633.stgit@localhost.localdomain>
References: <20100505100144.3595.65633.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As with the others we can use the port mutex to get the needed locking
properties and fix the race with open.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/isicom.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)


diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index c1ab303..bfeaefc 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -124,7 +124,6 @@
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/serial.h>
-#include <linux/smp_lock.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/timer.h>
@@ -872,7 +871,6 @@ static struct tty_port *isicom_find_port(struct tty_struct *tty)
 static int isicom_open(struct tty_struct *tty, struct file *filp)
 {
 	struct isi_port *port;
-	struct isi_board *card;
 	struct tty_port *tport;
 
 	tport = isicom_find_port(tty);
@@ -1118,8 +1116,7 @@ static int isicom_set_serial_info(struct tty_struct *tty,
 	if (copy_from_user(&newinfo, info, sizeof(newinfo)))
 		return -EFAULT;
 
-	lock_kernel();
-
+	mutex_lock(&port->port.mutex);
 	reconfig_port = ((port->port.flags & ASYNC_SPD_MASK) !=
 		(newinfo.flags & ASYNC_SPD_MASK));
 
@@ -1128,7 +1125,7 @@ static int isicom_set_serial_info(struct tty_struct *tty,
 				(newinfo.closing_wait != port->port.closing_wait) ||
 				((newinfo.flags & ~ASYNC_USR_MASK) !=
 				(port->port.flags & ~ASYNC_USR_MASK))) {
-			unlock_kernel();
+			mutex_unlock(&port->port.mutex);
 			return -EPERM;
 		}
 		port->port.flags = ((port->port.flags & ~ASYNC_USR_MASK) |
@@ -1145,7 +1142,7 @@ static int isicom_set_serial_info(struct tty_struct *tty,
 		isicom_config_port(tty);
 		spin_unlock_irqrestore(&port->card->card_lock, flags);
 	}
-	unlock_kernel();
+	mutex_unlock(&port->port.mutex);
 	return 0;
 }
 
@@ -1154,7 +1151,7 @@ static int isicom_get_serial_info(struct isi_port *port,
 {
 	struct serial_struct out_info;
 
-	lock_kernel();
+	mutex_lock(&port->port.mutex);
 	memset(&out_info, 0, sizeof(out_info));
 /*	out_info.type = ? */
 	out_info.line = port - isi_ports;
@@ -1164,7 +1161,7 @@ static int isicom_get_serial_info(struct isi_port *port,
 /*	out_info.baud_base = ? */
 	out_info.close_delay = port->port.close_delay;
 	out_info.closing_wait = port->port.closing_wait;
-	unlock_kernel();
+	mutex_unlock(&port->port.mutex);
 	if (copy_to_user(info, &out_info, sizeof(out_info)))
 		return -EFAULT;
 	return 0;

