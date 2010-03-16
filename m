Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab0CPVGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:06:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:62196 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab0CPVG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:06:28 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de, Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>,
       Alan Cox <alan@linux.intel.com>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/5] usb-serial: Use tty_port version of console instead of the usb_serial_port version
Date: Tue, 16 Mar 2010 16:05:43 -0500
Message-Id: <1268773546-12457-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1268773546-12457-2-git-send-email-jason.wessel@windriver.com>
References: <1268773546-12457-1-git-send-email-jason.wessel@windriver.com>
 <1268773546-12457-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 16 Mar 2010 21:05:59.0151 (UTC) FILETIME=[7A2E1FF0:01CAC54C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace all instances of using the console variable in struct
usb_serial_port with the struct tty_port version.

CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Alan Cox <alan@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Neukum <oliver@neukum.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: linux-usb@vger.kernel.org
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/usb/serial/console.c    |    5 ++---
 drivers/usb/serial/ftdi_sio.c   |    2 +-
 drivers/usb/serial/generic.c    |    4 ++--
 drivers/usb/serial/pl2303.c     |    2 +-
 drivers/usb/serial/usb-serial.c |    4 ++--
 include/linux/usb/serial.h      |    2 --
 6 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
index f347da2..4ea64fe 100644
--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -180,7 +180,6 @@ static int usb_console_setup(struct console *co, char *options)
 	--port->port.count;
 	/* The console is special in terms of closing the device so
 	 * indicate this port is now acting as a system console. */
-	port->console = 1;
 	port->port.console = 1;
 
 	mutex_unlock(&serial->disc_mutex);
@@ -217,7 +216,7 @@ static void usb_console_write(struct console *co,
 
 	dbg("%s - port %d, %d byte(s)", __func__, port->number, count);
 
-	if (!port->console) {
+	if (!port->port.console) {
 		dbg("%s - port not opened", __func__);
 		return;
 	}
@@ -313,7 +312,7 @@ void usb_serial_console_exit(void)
 {
 	if (usbcons_info.port) {
 		unregister_console(&usbcons);
-		usbcons_info.port->console = 0;
+		usbcons_info.port->port.console = 0;
 		usbcons_info.port = NULL;
 	}
 }
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 6af0dfa..95ec748 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2073,7 +2073,7 @@ static int ftdi_process_packet(struct tty_struct *tty,
 		return 0;	/* status only */
 	ch = packet + 2;
 
-	if (!(port->console && port->sysrq) && flag == TTY_NORMAL)
+	if (!(port->port.console && port->sysrq) && flag == TTY_NORMAL)
 		tty_insert_flip_string(tty, ch, len);
 	else {
 		for (i = 0; i < len; i++, ch++) {
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 89fac36..4dea9d7 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -437,7 +437,7 @@ static void flush_and_resubmit_read_urb(struct usb_serial_port *port)
 	/* The per character mucking around with sysrq path it too slow for
 	   stuff like 3G modems, so shortcircuit it in the 99.9999999% of cases
 	   where the USB serial is not a console anyway */
-	if (!port->console || !port->sysrq)
+	if (!port->port.console || !port->sysrq)
 		tty_insert_flip_string(tty, ch, urb->actual_length);
 	else {
 		/* Push data to tty */
@@ -556,7 +556,7 @@ void usb_serial_generic_unthrottle(struct tty_struct *tty)
 int usb_serial_handle_sysrq_char(struct tty_struct *tty,
 			struct usb_serial_port *port, unsigned int ch)
 {
-	if (port->sysrq && port->console) {
+	if (port->sysrq && port->port.console) {
 		if (ch && time_before(jiffies, port->sysrq)) {
 			handle_sysrq(ch, tty);
 			port->sysrq = 0;
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 73d5f34..1891cfb 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -1056,7 +1056,7 @@ static void pl2303_push_data(struct tty_struct *tty,
 	if (line_status & UART_OVERRUN_ERROR)
 		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
 
-	if (tty_flag == TTY_NORMAL && !(port->console && port->sysrq))
+	if (tty_flag == TTY_NORMAL && !(port->port.console && port->sysrq))
 		tty_insert_flip_string(tty, data, urb->actual_length);
 	else {
 		int i;
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 3873660..f3f6517 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -289,7 +289,7 @@ static void serial_down(struct tty_port *tport)
 	 * The console is magical.  Do not hang up the console hardware
 	 * or there will be tears.
 	 */
-	if (port->console)
+	if (port->port.console)
 		return;
 	if (drv->close)
 		drv->close(port);
@@ -328,7 +328,7 @@ static void serial_cleanup(struct tty_struct *tty)
 	/* The console is magical.  Do not hang up the console hardware
 	 * or there will be tears.
 	 */
-	if (port->console)
+	if (port->port.console)
 		return;
 
 	dbg("%s - port %d", __func__, port->number);
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 0a458b8..b7682fe 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -66,7 +66,6 @@ enum port_dev_state {
  * @work: work queue entry for the line discipline waking up.
  * @throttled: nonzero if the read urb is inactive to throttle the device
  * @throttle_req: nonzero if the tty wants to throttle us
- * @console: attached usb serial console
  * @dev: pointer to the serial device
  *
  * This structure is used by the usb-serial core and drivers for the specific
@@ -106,7 +105,6 @@ struct usb_serial_port {
 	struct work_struct	work;
 	char			throttled;
 	char			throttle_req;
-	char			console;
 	unsigned long		sysrq; /* sysrq timeout */
 	struct device		dev;
 	enum port_dev_state	dev_state;
-- 
1.6.4.rc1

