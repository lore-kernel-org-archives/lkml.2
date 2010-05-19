Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab0ESBm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:42:28 -0400
Received: from mail.windriver.com ([147.11.1.11]:41229 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721Ab0ESBkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:23 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, linux-usb@vger.kernel.org
Subject: [PATCH 7/7] echi-dbgp: Add kernel debugger support for the usb debug port
Date: Tue, 18 May 2010 20:40:02 -0500
Message-Id: <1274233202-3734-8-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233202-3734-1-git-send-email-jason.wessel@windriver.com>
References: <1274233202-3734-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:40:12.0048 (UTC) FILETIME=[38E53900:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the capability to use the usb debug port with the
kernel debugger.  It is also still possible to use this functionality
with or without the earlyprintk=dbgpX.  It is possible to use the
kgdbwait boot argument to debug very early in the kernel start up code.

There are two ways to use this driver extension with a kernel boot argument.

1) kgdbdbgp=#   -- Where # is the number of the usb debug controller

   You must use sysrq-g to break into the kernel debugger on another
   connection type other than the dbgp.

2) kgdbdbgp=#debugControlNum#,#Seconds#

   In this mode, the usb debug port is polled every #Seconds# for
   character input.  It is possible to use gdb or press control-c to
   break into the kernel debugger.

>From the implementation perspective there are 3 high level changes.

1) Allow variable retries for the the hardware via dbgp_bulk_read().

   The amount of retries for the dbgp_bulk_read() needed to be
   variable instead of fixed.  We do not want to poll at all when the
   kernel is operating in interrupt driven mode.  The polling only
   occurs if the kernel was booted when specifying some number of
   seconds via the kgdbdbgp boot argument (IE kgdbdbgp=0,1).  In this
   case the loop count is reduced to 1 so as introduce the smallest
   amount of latency as possible.

2) Save the bulk IN endpoint address for use by the kgdb code.

3) The addition of the kgdb interface code.

   This consisted of adding in a character read function for the dbgp
   as well as a polling thread to allow the dbgp to interrupt the
   kernel execution.  The rest is the typical kgdb I/O api.

CC: Eric Biederman <ebiederm@xmission.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>
CC: linux-usb@vger.kernel.org
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/kernel-parameters.txt |   11 +++
 drivers/usb/early/ehci-dbgp.c       |  120 ++++++++++++++++++++++++++++++++---
 2 files changed, 122 insertions(+), 9 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e618c75..472fb85 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1119,6 +1119,17 @@ and is between 256 and 4096 characters. It is defined in the file
 			use the HighMem zone if it exists, and the Normal
 			zone if it does not.
 
+	kgdbdbgp=	[KGDB,HW] kgdb over EHCI usb debug port.
+			Format: <Controller#>[,poll interval]
+			The controller # is the number of the ehci usb debug
+			port as it is probed via PCI.  The poll interval is
+			optional and is the number seconds in between
+			each poll cycle to the debug port in case you need
+			the functionality for interrupting the kernel with
+			gdb or control-c on the dbgp connection.  When
+			not using this parameter you use sysrq-g to break into
+			the kernel debugger.
+
 	kgdboc=		[KGDB,HW] kgdb over consoles.
 			Requires a tty driver that supports console polling,
 			or a supported polling keyboard driver (non-usb).
diff --git a/drivers/usb/early/ehci-dbgp.c b/drivers/usb/early/ehci-dbgp.c
index 6e98a36..94ecdbc 100644
--- a/drivers/usb/early/ehci-dbgp.c
+++ b/drivers/usb/early/ehci-dbgp.c
@@ -19,6 +19,9 @@
 #include <linux/usb/ch9.h>
 #include <linux/usb/ehci_def.h>
 #include <linux/delay.h>
+#include <linux/serial_core.h>
+#include <linux/kgdb.h>
+#include <linux/kthread.h>
 #include <asm/io.h>
 #include <asm/pci-direct.h>
 #include <asm/fixmap.h>
@@ -55,6 +58,7 @@ static struct ehci_regs __iomem *ehci_regs;
 static struct ehci_dbg_port __iomem *ehci_debug;
 static int dbgp_not_safe; /* Cannot use debug device during ehci reset */
 static unsigned int dbgp_endpoint_out;
+static unsigned int dbgp_endpoint_in;
 
 struct ehci_dev {
 	u32 bus;
@@ -91,6 +95,13 @@ static inline u32 dbgp_len_update(u32 x, u32 len)
 	return (x & ~0x0f) | (len & 0x0f);
 }
 
+#ifdef CONFIG_KGDB
+static struct kgdb_io kgdbdbgp_io_ops;
+#define dbgp_kgdb_mode (dbg_io_ops == &kgdbdbgp_io_ops)
+#else
+#define dbgp_kgdb_mode (0)
+#endif
+
 /*
  * USB Packet IDs (PIDs)
  */
@@ -182,11 +193,10 @@ static void dbgp_breath(void)
 	/* Sleep to give the debug port a chance to breathe */
 }
 
-static int dbgp_wait_until_done(unsigned ctrl)
+static int dbgp_wait_until_done(unsigned ctrl, int loop)
 {
 	u32 pids, lpid;
 	int ret;
-	int loop = DBGP_LOOPS;
 
 retry:
 	writel(ctrl | DBGP_GO, &ehci_debug->control);
@@ -276,13 +286,13 @@ static int dbgp_bulk_write(unsigned devnum, unsigned endpoint,
 	dbgp_set_data(bytes, size);
 	writel(addr, &ehci_debug->address);
 	writel(pids, &ehci_debug->pids);
-	ret = dbgp_wait_until_done(ctrl);
+	ret = dbgp_wait_until_done(ctrl, DBGP_LOOPS);
 
 	return ret;
 }
 
 static int dbgp_bulk_read(unsigned devnum, unsigned endpoint, void *data,
-				 int size)
+			  int size, int loops)
 {
 	u32 pids, addr, ctrl;
 	int ret;
@@ -302,7 +312,7 @@ static int dbgp_bulk_read(unsigned devnum, unsigned endpoint, void *data,
 
 	writel(addr, &ehci_debug->address);
 	writel(pids, &ehci_debug->pids);
-	ret = dbgp_wait_until_done(ctrl);
+	ret = dbgp_wait_until_done(ctrl, loops);
 	if (ret < 0)
 		return ret;
 
@@ -343,12 +353,12 @@ static int dbgp_control_msg(unsigned devnum, int requesttype,
 	dbgp_set_data(&req, sizeof(req));
 	writel(addr, &ehci_debug->address);
 	writel(pids, &ehci_debug->pids);
-	ret = dbgp_wait_until_done(ctrl);
+	ret = dbgp_wait_until_done(ctrl, DBGP_LOOPS);
 	if (ret < 0)
 		return ret;
 
 	/* Read the result */
-	return dbgp_bulk_read(devnum, 0, data, size);
+	return dbgp_bulk_read(devnum, 0, data, size, DBGP_LOOPS);
 }
 
 /* Find a PCI capability */
@@ -559,6 +569,7 @@ try_again:
 		goto err;
 	}
 	dbgp_endpoint_out = dbgp_desc.bDebugOutEndpoint;
+	dbgp_endpoint_in = dbgp_desc.bDebugInEndpoint;
 
 	/* Move the device to 127 if it isn't already there */
 	if (devnum != USB_DEBUG_DEVNUM) {
@@ -968,8 +979,9 @@ int dbgp_reset_prep(void)
 	if (!ehci_debug)
 		return 0;
 
-	if (early_dbgp_console.index != -1 &&
-		!(early_dbgp_console.flags & CON_BOOT))
+	if ((early_dbgp_console.index != -1 &&
+	     !(early_dbgp_console.flags & CON_BOOT)) ||
+	    dbgp_kgdb_mode)
 		return 1;
 	/* This means the console is not initialized, or should get
 	 * shutdown so as to allow for reuse of the usb device, which
@@ -982,3 +994,93 @@ int dbgp_reset_prep(void)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dbgp_reset_prep);
+
+#ifdef CONFIG_KGDB
+
+static char kgdbdbgp_buf[DBGP_MAX_PACKET];
+static int kgdbdbgp_buf_sz;
+static int kgdbdbgp_buf_idx;
+static int kgdbdbgp_loop_cnt = DBGP_LOOPS;
+
+static int kgdbdbgp_read_char(void)
+{
+	int ret;
+
+	if (kgdbdbgp_buf_idx < kgdbdbgp_buf_sz) {
+		char ch = kgdbdbgp_buf[kgdbdbgp_buf_idx++];
+		return ch;
+	}
+
+	ret = dbgp_bulk_read(USB_DEBUG_DEVNUM, dbgp_endpoint_in,
+			     &kgdbdbgp_buf, DBGP_MAX_PACKET,
+			     kgdbdbgp_loop_cnt);
+	if (ret <= 0)
+		return NO_POLL_CHAR;
+	kgdbdbgp_buf_sz = ret;
+	kgdbdbgp_buf_idx = 1;
+	return kgdbdbgp_buf[0];
+}
+
+static void kgdbdbgp_write_char(u8 chr)
+{
+	early_dbgp_write(NULL, &chr, 1);
+}
+
+static struct kgdb_io kgdbdbgp_io_ops = {
+	.name = "kgdbdbgp",
+	.read_char = kgdbdbgp_read_char,
+	.write_char = kgdbdbgp_write_char,
+};
+
+static int kgdbdbgp_wait_time;
+
+static int __init kgdbdbgp_parse_config(char *str)
+{
+	char *ptr;
+
+	if (!ehci_debug) {
+		if (early_dbgp_init(str))
+			return -1;
+	}
+	ptr = strchr(str, ',');
+	if (ptr) {
+		ptr++;
+		kgdbdbgp_wait_time = simple_strtoul(ptr, &ptr, 10);
+	}
+	kgdb_register_io_module(&kgdbdbgp_io_ops);
+	kgdbdbgp_io_ops.is_console = early_dbgp_console.index != -1;
+
+	return 0;
+}
+early_param("kgdbdbgp", kgdbdbgp_parse_config);
+
+static int kgdbdbgp_reader_thread(void *ptr)
+{
+	int ret;
+
+	while (readl(&ehci_debug->control) & DBGP_ENABLED) {
+		kgdbdbgp_loop_cnt = 1;
+		ret = kgdbdbgp_read_char();
+		kgdbdbgp_loop_cnt = DBGP_LOOPS;
+		if (ret != NO_POLL_CHAR) {
+			if (ret == 0x3 || ret == '$') {
+				if (ret == '$')
+					kgdbdbgp_buf_idx--;
+				kgdb_breakpoint();
+			}
+			continue;
+		}
+		schedule_timeout_interruptible(kgdbdbgp_wait_time * HZ);
+	}
+	return 0;
+}
+
+static int __init kgdbdbgp_start_thread(void)
+{
+	if (dbgp_kgdb_mode && kgdbdbgp_wait_time)
+		kthread_run(kgdbdbgp_reader_thread, NULL, "%s", "dbgp");
+
+	return 0;
+}
+module_init(kgdbdbgp_start_thread);
+#endif /* CONFIG_KGDB */
-- 
1.6.3.3

