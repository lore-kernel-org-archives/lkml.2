Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934685Ab0EEKk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 06:40:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54786 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934632Ab0EEKk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 06:40:57 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 09/20] specialix; Kill the BKL
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Date: Wed, 05 May 2010 11:02:31 +0100
Message-ID: <20100505100230.3595.3512.stgit@localhost.localdomain>
In-Reply-To: <20100505100144.3595.65633.stgit@localhost.localdomain>
References: <20100505100144.3595.65633.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the port mutex instead

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/specialix.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)


diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index 2c24fcd..7be456f 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -1863,8 +1863,7 @@ static int sx_set_serial_info(struct specialix_port *port,
 		return -EFAULT;
 	}
 
-	lock_kernel();
-
+	mutex_lock(&port->port.mutex);
 	change_speed = ((port->port.flags & ASYNC_SPD_MASK) !=
 			(tmp.flags & ASYNC_SPD_MASK));
 	change_speed |= (tmp.custom_divisor != port->custom_divisor);
@@ -1875,7 +1874,7 @@ static int sx_set_serial_info(struct specialix_port *port,
 		    ((tmp.flags & ~ASYNC_USR_MASK) !=
 		     (port->port.flags & ~ASYNC_USR_MASK))) {
 			func_exit();
-			unlock_kernel();
+			mutex_unlock(&port->port.mutex);
 			return -EPERM;
 		}
 		port->port.flags = ((port->port.flags & ~ASYNC_USR_MASK) |
@@ -1892,7 +1891,7 @@ static int sx_set_serial_info(struct specialix_port *port,
 		sx_change_speed(bp, port);
 
 	func_exit();
-	unlock_kernel();
+	mutex_unlock(&port->port.mutex);
 	return 0;
 }
 
@@ -1906,7 +1905,7 @@ static int sx_get_serial_info(struct specialix_port *port,
 	func_enter();
 
 	memset(&tmp, 0, sizeof(tmp));
-	lock_kernel();
+	mutex_lock(&port->port.mutex);
 	tmp.type = PORT_CIRRUS;
 	tmp.line = port - sx_port;
 	tmp.port = bp->base;
@@ -1917,7 +1916,7 @@ static int sx_get_serial_info(struct specialix_port *port,
 	tmp.closing_wait = port->port.closing_wait * HZ/100;
 	tmp.custom_divisor =  port->custom_divisor;
 	tmp.xmit_fifo_size = CD186x_NFIFO;
-	unlock_kernel();
+	mutex_unlock(&port->port.mutex);
 	if (copy_to_user(retinfo, &tmp, sizeof(tmp))) {
 		func_exit();
 		return -EFAULT;

