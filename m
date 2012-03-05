Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965023Ab2CEN6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:58:01 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34841 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964847Ab2CENx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:26 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 58/68] TTY: amiserial no longer needs serialP
Date: Mon,  5 Mar 2012 14:52:45 +0100
Message-Id: <1330955575-26641-59-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

amiserial is the last user of serialP.h. Let's move struct
serial_state directly to amiserial and remove serialP crap from
includes. Finally, remove the header from the tree completely.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/tty/amiserial.c |   20 ++++++++++++++++++-
 include/linux/serialP.h |   49 -----------------------------------------------
 2 files changed, 19 insertions(+), 50 deletions(-)
 delete mode 100644 include/linux/serialP.h

diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index b182bcc..613d6a3 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -58,7 +58,6 @@
 
 #include <linux/types.h>
 #include <linux/serial.h>
-#include <linux/serialP.h>
 #include <linux/serial_reg.h>
 static char *serial_version = "4.30";
 
@@ -70,6 +69,7 @@ static char *serial_version = "4.30";
 #include <linux/interrupt.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
+#include <linux/circ_buf.h>
 #include <linux/console.h>
 #include <linux/major.h>
 #include <linux/string.h>
@@ -92,6 +92,24 @@ static char *serial_version = "4.30";
 #include <asm/amigahw.h>
 #include <asm/amigaints.h>
 
+struct serial_state {
+	struct tty_port		tport;
+	struct circ_buf		xmit;
+	struct async_icount	icount;
+
+	unsigned long		port;
+	int			baud_base;
+	int			xmit_fifo_size;
+	int			custom_divisor;
+	int			read_status_mask;
+	int			ignore_status_mask;
+	int			timeout;
+	int			quot;
+	int			IER; 	/* Interrupt Enable Register */
+	int			MCR; 	/* Modem control register */
+	int			x_char;	/* xon/xoff character */
+};
+
 #define custom amiga_custom
 static char *serial_name = "Amiga-builtin serial driver";
 
diff --git a/include/linux/serialP.h b/include/linux/serialP.h
deleted file mode 100644
index 77afbdb..0000000
--- a/include/linux/serialP.h
+++ /dev/null
@@ -1,49 +0,0 @@
-/*
- * Private header file for the (dumb) serial driver
- *
- * Copyright (C) 1997 by Theodore Ts'o.
- * 
- * Redistribution of this file is permitted under the terms of the GNU 
- * Public License (GPL)
- */
-
-#ifndef _LINUX_SERIALP_H
-#define _LINUX_SERIALP_H
-
-/*
- * This is our internal structure for each serial port's state.
- * 
- * Many fields are paralleled by the structure used by the serial_struct
- * structure.
- *
- * For definitions of the flags field, see tty.h
- */
-
-#include <linux/termios.h>
-#include <linux/workqueue.h>
-#include <linux/interrupt.h>
-#include <linux/circ_buf.h>
-#include <linux/tty.h>
-#include <linux/wait.h>
-
-struct serial_state {
-	int	baud_base;
-	unsigned long	port;
-	int	xmit_fifo_size;
-	int	custom_divisor;
-	struct async_icount	icount;	
-	struct tty_port tport;
-
-	/* amiserial */
-	int			read_status_mask;
-	int			ignore_status_mask;
-	int			timeout;
-	int			quot;
-	int			IER; 	/* Interrupt Enable Register */
-	int			MCR; 	/* Modem control register */
-	int			x_char;	/* xon/xoff character */
- 	struct circ_buf		xmit;
-	/* /amiserial */
-};
-
-#endif /* _LINUX_SERIAL_H */
-- 
1.7.9.2


