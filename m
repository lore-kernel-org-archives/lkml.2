Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab0FAUxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:53:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:65463 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757471Ab0FAUxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:53:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 09/31] specialix; Kill the BKL
Date: Tue,  1 Jun 2010 22:52:49 +0200
Message-Id: <1275425591-8803-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275425591-8803-1-git-send-email-arnd@arndb.de>
References: <1275425591-8803-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18qZycbaudf9NCVFeSf05xXWZog9fDSQ/r9SIz
 9fAo1t2RQBH7ru4HpWw+BxSzFh0WMZSPmrf38MmQYl8mkNsE6/
 RKGY4VgnnEKFjxCjBaymQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

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
-- 
1.7.0.4

