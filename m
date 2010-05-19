Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856Ab0ESBow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:44:52 -0400
Received: from mail.windriver.com ([147.11.1.11]:41195 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab0ESBkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:17 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 21/25] kgdboc,kdb: Allow kdb to work on a non open console port
Date: Tue, 18 May 2010 20:39:31 -0500
Message-Id: <1274233175-3675-22-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
References: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:39:59.0188 (UTC) FILETIME=[313AF140:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kdb is open on a serial port that is not actually a console make
sure to call the poll routines to emit and receive characters.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Martin Hicks <mort@sgi.com>
---
 drivers/serial/kgdboc.c   |   14 ++++++++++++++
 include/linux/kgdb.h      |    3 +++
 kernel/debug/kdb/kdb_io.c |   16 ++++++++++++++++
 3 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index ecef6e1..b765ab4 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -16,6 +16,7 @@
 #include <linux/kgdb.h>
 #include <linux/kdb.h>
 #include <linux/tty.h>
+#include <linux/console.h>
 
 #define MAX_CONFIG_LEN		40
 
@@ -93,12 +94,14 @@ static int configure_kgdboc(void)
 	int tty_line = 0;
 	int err;
 	char *cptr = config;
+	struct console *cons;
 
 	err = kgdboc_option_setup(config);
 	if (err || !strlen(config) || isspace(config[0]))
 		goto noconfig;
 
 	err = -ENODEV;
+	kgdboc_io_ops.is_console = 0;
 	kgdb_tty_driver = NULL;
 
 	if (kgdboc_register_kbd(&cptr))
@@ -108,6 +111,17 @@ static int configure_kgdboc(void)
 	if (!p)
 		goto noconfig;
 
+	cons = console_drivers;
+	while (cons) {
+		int idx;
+		if (cons->device && cons->device(cons, &idx) == p &&
+		    idx == tty_line) {
+			kgdboc_io_ops.is_console = 1;
+			break;
+		}
+		cons = cons->next;
+	}
+
 	kgdb_tty_driver = p;
 	kgdb_tty_line = tty_line;
 
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index ee007ea..6c784ab 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -247,6 +247,8 @@ struct kgdb_arch {
  * the I/O driver.
  * @post_exception: Pointer to a function that will do any cleanup work
  * for the I/O driver.
+ * @is_console: 1 if the end device is a console 0 if the I/O device is
+ * not a console
  */
 struct kgdb_io {
 	const char		*name;
@@ -256,6 +258,7 @@ struct kgdb_io {
 	int			(*init) (void);
 	void			(*pre_exception) (void);
 	void			(*post_exception) (void);
+	int			is_console;
 };
 
 extern struct kgdb_arch		arch_kgdb_ops;
diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 8339b29..58be7e9 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -673,6 +673,14 @@ kdb_printit:
 	if (!dbg_kdb_mode && kgdb_connected) {
 		gdbstub_msg_write(kdb_buffer, retlen);
 	} else {
+		if (!dbg_io_ops->is_console) {
+			len = strlen(kdb_buffer);
+			cp = kdb_buffer;
+			while (len--) {
+				dbg_io_ops->write_char(*cp);
+				cp++;
+			}
+		}
 		while (c) {
 			c->write(c, kdb_buffer, retlen);
 			touch_nmi_watchdog();
@@ -719,6 +727,14 @@ kdb_printit:
 		kdb_input_flush();
 		c = console_drivers;
 
+		if (!dbg_io_ops->is_console) {
+			len = strlen(moreprompt);
+			cp = moreprompt;
+			while (len--) {
+				dbg_io_ops->write_char(*cp);
+				cp++;
+			}
+		}
 		while (c) {
 			c->write(c, moreprompt, strlen(moreprompt));
 			touch_nmi_watchdog();
-- 
1.6.3.3

