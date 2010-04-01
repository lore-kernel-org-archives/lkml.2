Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215Ab0DAQfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:35:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44895 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758166Ab0DAQec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:34:32 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 07/14] riscom8: kill use of lock_kernel
To: linux-kernel@vger.kernel.org
Date: Thu, 01 Apr 2010 17:05:42 +0100
Message-ID: <20100401160533.8882.38905.stgit@localhost.localdomain>
In-Reply-To: <20100401155513.8882.54006.stgit@localhost.localdomain>
References: <20100401155513.8882.54006.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The riscom8 board uses lock_kernel to protect bits of the port setting
ioctl logic. We can use the port mutex for this as the logic is internal
and will also lock set versus open (a locking property that has been lost
somewhere along the way)

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/riscom8.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)


diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index 0a8d1e5..9c00b7d 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -47,7 +47,6 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/tty_flip.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/device.h>
 
@@ -1183,6 +1182,7 @@ static int rc_set_serial_info(struct tty_struct *tty, struct riscom_port *port,
 	if (copy_from_user(&tmp, newinfo, sizeof(tmp)))
 		return -EFAULT;
 
+	mutex_lock(&port->port.mutex);
 	change_speed = ((port->port.flags & ASYNC_SPD_MASK) !=
 			(tmp.flags & ASYNC_SPD_MASK));
 
@@ -1190,8 +1190,10 @@ static int rc_set_serial_info(struct tty_struct *tty, struct riscom_port *port,
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
@@ -1207,6 +1209,7 @@ static int rc_set_serial_info(struct tty_struct *tty, struct riscom_port *port,
 		rc_change_speed(tty, bp, port);
 		spin_unlock_irqrestore(&riscom_lock, flags);
 	}
+	mutex_unlock(&port->port.mutex);
 	return 0;
 }
 
@@ -1219,12 +1222,15 @@ static int rc_get_serial_info(struct riscom_port *port,
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
@@ -1241,14 +1247,10 @@ static int rc_ioctl(struct tty_struct *tty, struct file *filp,
 
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

