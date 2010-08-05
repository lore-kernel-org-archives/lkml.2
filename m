Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854Ab0HEWYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:24:25 -0400
Received: from kroah.org ([198.145.64.141]:37594 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760797Ab0HEWXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:23:53 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 15/67] riscom8: kill use of lock_kernel
Date: Thu,  5 Aug 2010 15:22:42 -0700
Message-Id: <1281047014-23429-15-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The riscom8 board uses lock_kernel to protect bits of the port setting
ioctl logic. We can use the port mutex for this as the logic is internal
and will also lock set versus open (a locking property that has been lost
somewhere along the way)

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/riscom8.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index b02332a..af4de1f 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -47,7 +47,6 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/tty_flip.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/device.h>
 
@@ -1184,6 +1183,7 @@ static int rc_set_serial_info(struct tty_struct *tty, struct riscom_port *port,
 	if (copy_from_user(&tmp, newinfo, sizeof(tmp)))
 		return -EFAULT;
 
+	mutex_lock(&port->port.mutex);
 	change_speed = ((port->port.flags & ASYNC_SPD_MASK) !=
 			(tmp.flags & ASYNC_SPD_MASK));
 
@@ -1191,8 +1191,10 @@ static int rc_set_serial_info(struct tty_struct *tty, struct riscom_port *port,
 		if ((tmp.close_delay != port->port.close_delay) ||
 		    (tmp.closing_wait != port->port.closing_wait) ||
 		    ((tmp.flags & ~ASYNC_USR_MASK) !=
-		     (port->port.flags & ~ASYNC_USR_MASK)))
+		     (port->port.flags & ~ASYNC_USR_MASK))) {
+			mutex_unlock(&port->port.mutex);
 			return -EPERM;
+		}
 		port->port.flags = ((port->port.flags & ~ASYNC_USR_MASK) |
 			       (tmp.flags & ASYNC_USR_MASK));
 	} else  {
@@ -1208,6 +1210,7 @@ static int rc_set_serial_info(struct tty_struct *tty, struct riscom_port *port,
 		rc_change_speed(tty, bp, port);
 		spin_unlock_irqrestore(&riscom_lock, flags);
 	}
+	mutex_unlock(&port->port.mutex);
 	return 0;
 }
 
@@ -1220,12 +1223,15 @@ static int rc_get_serial_info(struct riscom_port *port,
 	memset(&tmp, 0, sizeof(tmp));
 	tmp.type = PORT_CIRRUS;
 	tmp.line = port - rc_port;
+
+	mutex_lock(&port->port.mutex);
 	tmp.port = bp->base;
 	tmp.irq  = bp->irq;
 	tmp.flags = port->port.flags;
 	tmp.baud_base = (RC_OSCFREQ + CD180_TPC/2) / CD180_TPC;
 	tmp.close_delay = port->port.close_delay * HZ/100;
 	tmp.closing_wait = port->port.closing_wait * HZ/100;
+	mutex_unlock(&port->port.mutex);
 	tmp.xmit_fifo_size = CD180_NFIFO;
 	return copy_to_user(retinfo, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
@@ -1242,14 +1248,10 @@ static int rc_ioctl(struct tty_struct *tty, struct file *filp,
 
 	switch (cmd) {
 	case TIOCGSERIAL:
-		lock_kernel();
 		retval = rc_get_serial_info(port, argp);
-		unlock_kernel();
 		break;
 	case TIOCSSERIAL:
-		lock_kernel();
 		retval = rc_set_serial_info(tty, port, argp);
-		unlock_kernel();
 		break;
 	default:
 		retval = -ENOIOCTLCMD;
-- 
1.7.2

