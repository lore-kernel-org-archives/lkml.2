Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab0ESBkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:40:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:41095 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab0ESBkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:04 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>, linux-serial@vger.kernel.org
Subject: [PATCH 10/25] kgdb,8250,pl011: Return immediately from console poll
Date: Tue, 18 May 2010 20:39:20 -0500
Message-Id: <1274233175-3675-11-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
References: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:39:50.0125 (UTC) FILETIME=[2BD409D0:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The design of the kdb shell requires that every device that can
provide input to kdb have a polling routine that exits immediately if
there is no character available.  This is required in order to get the
page scrolling mechanism working.

Changing the kernel debugger I/O API to require all polling character
routines to exit immediately if there is no data allows the kernel
debugger to process multiple input channels.

NO_POLL_CHAR will be the return code to the polling routine when ever
there is no character available.

CC: linux-serial@vger.kernel.org
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/serial/8250.c           |    4 ++--
 drivers/serial/amba-pl011.c     |    6 +++---
 include/linux/kdb.h             |    1 +
 include/linux/serial_core.h     |    1 +
 kernel/debug/debug_core.c       |    2 ++
 kernel/debug/gdbstub.c          |   37 +++++++++++++++++++++++++++++++------
 kernel/debug/kdb/kdb_debugger.c |   10 ++++++++++
 7 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 2b1ea3d..891e1dd 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1891,8 +1891,8 @@ static int serial8250_get_poll_char(struct uart_port *port)
 	struct uart_8250_port *up = (struct uart_8250_port *)port;
 	unsigned char lsr = serial_inp(up, UART_LSR);
 
-	while (!(lsr & UART_LSR_DR))
-		lsr = serial_inp(up, UART_LSR);
+	if (!(lsr & UART_LSR_DR))
+		return NO_POLL_CHAR;
 
 	return serial_inp(up, UART_RX);
 }
diff --git a/drivers/serial/amba-pl011.c b/drivers/serial/amba-pl011.c
index 743ebf5..eb4cb48 100644
--- a/drivers/serial/amba-pl011.c
+++ b/drivers/serial/amba-pl011.c
@@ -342,9 +342,9 @@ static int pl010_get_poll_char(struct uart_port *port)
 	struct uart_amba_port *uap = (struct uart_amba_port *)port;
 	unsigned int status;
 
-	do {
-		status = readw(uap->port.membase + UART01x_FR);
-	} while (status & UART01x_FR_RXFE);
+	status = readw(uap->port.membase + UART01x_FR);
+	if (status & UART01x_FR_RXFE)
+		return NO_POLL_CHAR;
 
 	return readw(uap->port.membase + UART01x_DR);
 }
diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index 4d93790..d72fa39 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -19,6 +19,7 @@
 #include <asm/atomic.h>
 
 #define KDB_POLL_FUNC_MAX	5
+extern int kdb_poll_idx;
 
 /*
  * kdb_initial_cpu is initialized to -1, and is set to the cpu
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 78dd1e7..ad83996 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -246,6 +246,7 @@ struct uart_ops {
 #endif
 };
 
+#define NO_POLL_CHAR		0x00ff0000
 #define UART_CONFIG_TYPE	(1 << 0)
 #define UART_CONFIG_IRQ		(1 << 1)
 
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 6e1fa82..1d71df6 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -882,6 +882,8 @@ EXPORT_SYMBOL_GPL(kgdb_unregister_io_module);
 int dbg_io_get_char(void)
 {
 	int ret = dbg_io_ops->read_char();
+	if (ret == NO_POLL_CHAR)
+		return -1;
 	if (!dbg_kdb_mode)
 		return ret;
 	if (ret == 127)
diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index 188203a..3c00049 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -30,6 +30,7 @@
 
 #include <linux/kernel.h>
 #include <linux/kgdb.h>
+#include <linux/kdb.h>
 #include <linux/reboot.h>
 #include <linux/uaccess.h>
 #include <asm/cacheflush.h>
@@ -62,6 +63,30 @@ static int hex(char ch)
 	return -1;
 }
 
+#ifdef CONFIG_KGDB_KDB
+static int gdbstub_read_wait(void)
+{
+	int ret = -1;
+	int i;
+
+	/* poll any additional I/O interfaces that are defined */
+	while (ret < 0)
+		for (i = 0; kdb_poll_funcs[i] != NULL; i++) {
+			ret = kdb_poll_funcs[i]();
+			if (ret > 0)
+				break;
+		}
+	return ret;
+}
+#else
+static int gdbstub_read_wait(void)
+{
+	int ret = dbg_io_ops->read_char();
+	while (ret == NO_POLL_CHAR)
+		ret = dbg_io_ops->read_char();
+	return ret;
+}
+#endif
 /* scan for the sequence $<data>#<checksum> */
 static void get_packet(char *buffer)
 {
@@ -75,7 +100,7 @@ static void get_packet(char *buffer)
 		 * Spin and wait around for the start character, ignore all
 		 * other characters:
 		 */
-		while ((ch = (dbg_io_ops->read_char())) != '$')
+		while ((ch = (gdbstub_read_wait())) != '$')
 			/* nothing */;
 
 		kgdb_connected = 1;
@@ -88,7 +113,7 @@ static void get_packet(char *buffer)
 		 * now, read until a # or end of buffer is found:
 		 */
 		while (count < (BUFMAX - 1)) {
-			ch = dbg_io_ops->read_char();
+			ch = gdbstub_read_wait();
 			if (ch == '#')
 				break;
 			checksum = checksum + ch;
@@ -98,8 +123,8 @@ static void get_packet(char *buffer)
 		buffer[count] = 0;
 
 		if (ch == '#') {
-			xmitcsum = hex(dbg_io_ops->read_char()) << 4;
-			xmitcsum += hex(dbg_io_ops->read_char());
+			xmitcsum = hex(gdbstub_read_wait()) << 4;
+			xmitcsum += hex(gdbstub_read_wait());
 
 			if (checksum != xmitcsum)
 				/* failed checksum */
@@ -144,10 +169,10 @@ static void put_packet(char *buffer)
 			dbg_io_ops->flush();
 
 		/* Now see what we get in reply. */
-		ch = dbg_io_ops->read_char();
+		ch = gdbstub_read_wait();
 
 		if (ch == 3)
-			ch = dbg_io_ops->read_char();
+			ch = gdbstub_read_wait();
 
 		/* If we get an ACK, we are done. */
 		if (ch == '+')
diff --git a/kernel/debug/kdb/kdb_debugger.c b/kernel/debug/kdb/kdb_debugger.c
index f024c0c..bf6e827 100644
--- a/kernel/debug/kdb/kdb_debugger.c
+++ b/kernel/debug/kdb/kdb_debugger.c
@@ -20,7 +20,15 @@
 get_char_func kdb_poll_funcs[] = {
 	dbg_io_get_char,
 	NULL,
+	NULL,
+	NULL,
+	NULL,
+	NULL,
 };
+EXPORT_SYMBOL_GPL(kdb_poll_funcs);
+
+int kdb_poll_idx = 1;
+EXPORT_SYMBOL_GPL(kdb_poll_idx);
 
 int kdb_stub(struct kgdb_state *ks)
 {
@@ -85,6 +93,7 @@ int kdb_stub(struct kgdb_state *ks)
 	kdb_bp_remove();
 	KDB_STATE_CLEAR(DOING_SS);
 	KDB_STATE_CLEAR(DOING_SSB);
+	KDB_STATE_SET(PAGER);
 	/* zero out any offline cpu data */
 	for_each_present_cpu(i) {
 		if (!cpu_online(i)) {
@@ -112,6 +121,7 @@ int kdb_stub(struct kgdb_state *ks)
 	kdb_initial_cpu = -1;
 	kdb_current_task = NULL;
 	kdb_current_regs = NULL;
+	KDB_STATE_CLEAR(PAGER);
 	kdbnearsym_cleanup();
 	if (error == KDB_CMD_KGDB) {
 		if (KDB_STATE(DOING_KGDB) || KDB_STATE(DOING_KGDB2)) {
-- 
1.6.3.3

