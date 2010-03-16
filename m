Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab0CPVGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:06:12 -0400
Received: from mail.windriver.com ([147.11.1.11]:62120 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab0CPVGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:06:05 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de, Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>,
       Alan Cox <alan@linux.intel.com>, Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3/5] usb-console: pass baud from console to the initial tty open
Date: Tue, 16 Mar 2010 16:05:44 -0500
Message-Id: <1268773546-12457-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1268773546-12457-3-git-send-email-jason.wessel@windriver.com>
References: <1268773546-12457-1-git-send-email-jason.wessel@windriver.com>
 <1268773546-12457-2-git-send-email-jason.wessel@windriver.com>
 <1268773546-12457-3-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 16 Mar 2010 21:06:00.0104 (UTC) FILETIME=[7ABF8A80:01CAC54C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usb console code has had a long standing problem of not being able
to pass the baud rate from the kernel argument console=ttyUSB0,BAUD
down to the initial tty open, unless you were willing to settle for
9600 baud.

The solution is to directly use tty_init_termios() in
usb_console_setup() as this will preserve any changes to the initial
termios setting on future opens.

CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Alan Cox <alan@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>
CC: linux-usb@vger.kernel.org
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/usb/serial/console.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
index 4ea64fe..1ee6b2a 100644
--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -66,7 +66,7 @@ static int usb_console_setup(struct console *co, char *options)
 	struct usb_serial_port *port;
 	int retval;
 	struct tty_struct *tty = NULL;
-	struct ktermios *termios = NULL, dummy;
+	struct ktermios dummy;
 
 	dbg("%s", __func__);
 
@@ -141,15 +141,14 @@ static int usb_console_setup(struct console *co, char *options)
 				goto reset_open_count;
 			}
 			kref_init(&tty->kref);
-			termios = kzalloc(sizeof(*termios), GFP_KERNEL);
-			if (!termios) {
+			tty_port_tty_set(&port->port, tty);
+			tty->driver = usb_serial_tty_driver;
+			tty->index = co->index;
+			if (tty_init_termios(tty)) {
 				retval = -ENOMEM;
 				err("no more memory");
 				goto free_tty;
 			}
-			memset(&dummy, 0, sizeof(struct ktermios));
-			tty->termios = termios;
-			tty_port_tty_set(&port->port, tty);
 		}
 
 		/* only call the device specific open if this
@@ -161,16 +160,16 @@ static int usb_console_setup(struct console *co, char *options)
 
 		if (retval) {
 			err("could not open USB console port");
-			goto free_termios;
+			goto fail;
 		}
 
 		if (serial->type->set_termios) {
-			termios->c_cflag = cflag;
-			tty_termios_encode_baud_rate(termios, baud, baud);
+			tty->termios->c_cflag = cflag;
+			tty_termios_encode_baud_rate(tty->termios, baud, baud);
+			memset(&dummy, 0, sizeof(struct ktermios));
 			serial->type->set_termios(tty, port, &dummy);
 
 			tty_port_tty_set(&port->port, NULL);
-			kfree(termios);
 			kfree(tty);
 		}
 		set_bit(ASYNCB_INITIALIZED, &port->port.flags);
@@ -185,8 +184,7 @@ static int usb_console_setup(struct console *co, char *options)
 	mutex_unlock(&serial->disc_mutex);
 	return retval;
 
- free_termios:
-	kfree(termios);
+ fail:
 	tty_port_tty_set(&port->port, NULL);
  free_tty:
 	kfree(tty);
-- 
1.6.4.rc1

