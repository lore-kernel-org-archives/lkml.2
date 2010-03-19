Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab0CSPSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:18:44 -0400
Received: from kroah.org ([198.145.64.141]:45885 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532Ab0CSPSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:18:42 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>, Alan Cox <alan@linux.intel.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 7/7] tty_port,usb-console: Fix usb serial console open/close regression
Date: Fri, 19 Mar 2010 08:18:36 -0700
Message-Id: <1269011916-8836-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <20100319151326.GC8541@kroah.com>
References: <20100319151326.GC8541@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wessel <jason.wessel@windriver.com>

Commit e1108a63e10d344284011cccc06328b2cd3e5da3 ("usb_serial: Use the
shutdown() operation") breaks the ability to use a usb console
starting in 2.6.33.  This was observed when using
console=ttyUSB0,115200 as a boot argument with an FTDI device.  The
error is:

ftdi_sio ttyUSB0: ftdi_submit_read_urb - failed submitting read urb, error -22

The handling of the ASYNCB_INITIALIZED changed in 2.6.32 such that in
tty_port_shutdown() it always clears the flag if it is set.  The fix
is to add a variable to the tty_port struct to indicate when the tty
port is a console.

CC: Alan Cox <alan@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Neukum <oliver@neukum.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_port.c      |    2 +-
 drivers/usb/serial/console.c |    1 +
 include/linux/tty.h          |    1 +
 3 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index be492dd..a3bd1d0 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -119,7 +119,7 @@ EXPORT_SYMBOL(tty_port_tty_set);
 static void tty_port_shutdown(struct tty_port *port)
 {
 	mutex_lock(&port->mutex);
-	if (port->ops->shutdown &&
+	if (port->ops->shutdown && !port->console &&
 		test_and_clear_bit(ASYNCB_INITIALIZED, &port->flags))
 			port->ops->shutdown(port);
 	mutex_unlock(&port->mutex);
diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
index b22ac32..f347da2 100644
--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -181,6 +181,7 @@ static int usb_console_setup(struct console *co, char *options)
 	/* The console is special in terms of closing the device so
 	 * indicate this port is now acting as a system console. */
 	port->console = 1;
+	port->port.console = 1;
 
 	mutex_unlock(&serial->disc_mutex);
 	return retval;
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 593228a..4409967 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -224,6 +224,7 @@ struct tty_port {
 	wait_queue_head_t	close_wait;	/* Close waiters */
 	wait_queue_head_t	delta_msr_wait;	/* Modem status change */
 	unsigned long		flags;		/* TTY flags ASY_*/
+	unsigned char		console:1;	/* port is a console */
 	struct mutex		mutex;		/* Locking */
 	struct mutex		buf_mutex;	/* Buffer alloc lock */
 	unsigned char		*xmit_buf;	/* Optional buffer */
-- 
1.7.0.2

