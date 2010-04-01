Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab0DAQeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:34:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44898 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758192Ab0DAQek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:34:40 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 08/14] isicom: kill off the BKL
To: linux-kernel@vger.kernel.org
Date: Thu, 01 Apr 2010 17:05:50 +0100
Message-ID: <20100401160548.8882.26940.stgit@localhost.localdomain>
In-Reply-To: <20100401155513.8882.54006.stgit@localhost.localdomain>
References: <20100401155513.8882.54006.stgit@localhost.localdomain>
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

 drivers/char/isicom.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)


diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 0fa2e4a..989dd4b 100644
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
@@ -1113,8 +1112,7 @@ static int isicom_set_serial_info(struct tty_struct *tty,
 	if (copy_from_user(&newinfo, info, sizeof(newinfo)))
 		return -EFAULT;
 
-	lock_kernel();
-
+	mutex_lock(&port->port.mutex);
 	reconfig_port = ((port->port.flags & ASYNC_SPD_MASK) !=
 		(newinfo.flags & ASYNC_SPD_MASK));
 
@@ -1123,7 +1121,7 @@ static int isicom_set_serial_info(struct tty_struct *tty,
 				(newinfo.closing_wait != port->port.closing_wait) ||
 				((newinfo.flags & ~ASYNC_USR_MASK) !=
 				(port->port.flags & ~ASYNC_USR_MASK))) {
-			unlock_kernel();
+			mutex_unlock(&port->port.mutex);
 			return -EPERM;
 		}
 		port->port.flags = ((port->port.flags & ~ASYNC_USR_MASK) |
@@ -1140,7 +1138,7 @@ static int isicom_set_serial_info(struct tty_struct *tty,
 		isicom_config_port(tty);
 		spin_unlock_irqrestore(&port->card->card_lock, flags);
 	}
-	unlock_kernel();
+	mutex_unlock(&port->port.mutex);
 	return 0;
 }
 
@@ -1149,7 +1147,7 @@ static int isicom_get_serial_info(struct isi_port *port,
 {
 	struct serial_struct out_info;
 
-	lock_kernel();
+	mutex_lock(&port->port.mutex);
 	memset(&out_info, 0, sizeof(out_info));
 /*	out_info.type = ? */
 	out_info.line = port - isi_ports;
@@ -1159,7 +1157,7 @@ static int isicom_get_serial_info(struct isi_port *port,
 /*	out_info.baud_base = ? */
 	out_info.close_delay = port->port.close_delay;
 	out_info.closing_wait = port->port.closing_wait;
-	unlock_kernel();
+	mutex_unlock(&port->port.mutex);
 	if (copy_to_user(info, &out_info, sizeof(out_info)))
 		return -EFAULT;
 	return 0;

