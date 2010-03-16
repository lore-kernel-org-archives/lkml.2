Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab0CPVGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:06:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:62213 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab0CPVGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:06:32 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de, Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>,
       Alan Cox <alan@linux.intel.com>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/5] tty_port,usb-console: Fix usb serial console open/close regression
Date: Tue, 16 Mar 2010 16:05:42 -0500
Message-Id: <1268773546-12457-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1268773546-12457-1-git-send-email-jason.wessel@windriver.com>
References: <1268773546-12457-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 16 Mar 2010 21:05:57.0917 (UTC) FILETIME=[7971D4D0:01CAC54C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Alan Cox <alan@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Neukum <oliver@neukum.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: linux-usb@vger.kernel.org
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
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
index 568369a..9c9719e 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -223,6 +223,7 @@ struct tty_port {
 	wait_queue_head_t	close_wait;	/* Close waiters */
 	wait_queue_head_t	delta_msr_wait;	/* Modem status change */
 	unsigned long		flags;		/* TTY flags ASY_*/
+	unsigned char		console:1;	/* port is a console */
 	struct mutex		mutex;		/* Locking */
 	struct mutex		buf_mutex;	/* Buffer alloc lock */
 	unsigned char		*xmit_buf;	/* Optional buffer */
-- 
1.6.4.rc1

