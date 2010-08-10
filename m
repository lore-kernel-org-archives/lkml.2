Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab0HJWLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:11:23 -0400
Received: from kroah.org ([198.145.64.141]:44833 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933325Ab0HJV7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 17:59:50 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/68] isicom: kill off the BKL
Date: Tue, 10 Aug 2010 14:58:38 -0700
Message-Id: <1281477570-18944-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100810214425.GB17385@kroah.com>
References: <20100810214425.GB17385@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

As with the others we can use the port mutex to get the needed locking
properties and fix the race with open.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/isicom.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 98310e1..c27e9d2 100644
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
-- 
1.7.2

