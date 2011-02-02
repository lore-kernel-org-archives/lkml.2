Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab1BBAnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:43:52 -0500
Received: from mga03.intel.com ([143.182.124.21]:11107 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002Ab1BBAnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960495"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [44/139] sparc: Write to prom console using indirect buffer.
Message-Id: <20110202004359.D0BC73E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 595a251c0740785fd3c0d2156d78578c7479811e ]

sparc64 systems have a restriction in that passing in buffer
addressses above 4GB to prom calls is not reliable.

We end up violating this when we do prom console writes, because we
use an on-stack buffer to translate '\n' into '\r\n'.

So instead, do this translation into an intermediate buffer, which is
in the kernel image and thus below 4GB, then pass that to the PROM
console write calls.

On the 32-bit side we don't have to deal with any of these issues, so
the new prom_console_write_buf() uses the existing prom_nbputchar()
implementation.  However we can now mark those routines static.

Since the 64-bit side completely uses new code we can delete the
putchar bits as they are now completely unused.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/sparc/include/asm/oplib_32.h |    4 ++--
 arch/sparc/include/asm/oplib_64.h |    4 ++--
 arch/sparc/prom/console_32.c      |   14 ++++++++------
 arch/sparc/prom/console_64.c      |   27 +++++++++++++--------------
 arch/sparc/prom/printf.c          |   32 +++++++++++++++++++++++++++-----
 5 files changed, 52 insertions(+), 29 deletions(-)

Index: linux-2.6.35.y/arch/sparc/include/asm/oplib_32.h
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/include/asm/oplib_32.h
+++ linux-2.6.35.y/arch/sparc/include/asm/oplib_32.h
@@ -102,8 +102,8 @@ extern int prom_getrev(void);
 /* Get the prom firmware revision. */
 extern int prom_getprev(void);
 
-/* Blocking put character to console. */
-extern void prom_putchar(const char *buf);
+/* Write a buffer of characters to the console. */
+extern void prom_console_write_buf(const char *buf, int len);
 
 /* Prom's internal routines, don't use in kernel/boot code. */
 extern void prom_printf(const char *fmt, ...);
Index: linux-2.6.35.y/arch/sparc/include/asm/oplib_64.h
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/include/asm/oplib_64.h
+++ linux-2.6.35.y/arch/sparc/include/asm/oplib_64.h
@@ -94,8 +94,8 @@ extern void prom_halt_power_off(void) __
  */
 extern unsigned char prom_get_idprom(char *idp_buffer, int idpbuf_size);
 
-/* Blocking put character to console. */
-extern void prom_putchar(const char *buf);
+/* Write a buffer of characters to the console. */
+extern void prom_console_write_buf(const char *buf, int len);
 
 /* Prom's internal routines, don't use in kernel/boot code. */
 extern void prom_printf(const char *fmt, ...);
Index: linux-2.6.35.y/arch/sparc/prom/console_32.c
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/prom/console_32.c
+++ linux-2.6.35.y/arch/sparc/prom/console_32.c
@@ -43,12 +43,14 @@ static int prom_nbputchar(const char *bu
 	return i; /* Ugh, we could spin forever on unsupported proms ;( */
 }
 
-/* Blocking version of put character routine above. */
-void prom_putchar(const char *buf)
+void prom_console_write_buf(const char *buf, int len)
 {
-	while (1) {
-		int err = prom_nbputchar(buf);
-		if (!err)
-			break;
+	while (len) {
+		int n = prom_nbputchar(buf);
+		if (n)
+			continue;
+		len--;
+		buf++;
 	}
 }
+
Index: linux-2.6.35.y/arch/sparc/prom/console_64.c
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/prom/console_64.c
+++ linux-2.6.35.y/arch/sparc/prom/console_64.c
@@ -15,35 +15,34 @@
 
 extern int prom_stdin, prom_stdout;
 
-/* Non blocking put character to console device, returns -1 if
- * unsuccessful.
- */
-static int prom_nbputchar(const char *buf)
+static int __prom_console_write_buf(const char *buf, int len)
 {
 	unsigned long args[7];
+	int ret;
 
 	args[0] = (unsigned long) "write";
 	args[1] = 3;
 	args[2] = 1;
 	args[3] = (unsigned int) prom_stdout;
 	args[4] = (unsigned long) buf;
-	args[5] = 1;
+	args[5] = (unsigned int) len;
 	args[6] = (unsigned long) -1;
 
 	p1275_cmd_direct(args);
 
-	if (args[6] == 1)
-		return 0;
-	else
+	ret = (int) args[6];
+	if (ret < 0)
 		return -1;
+	return ret;
 }
 
-/* Blocking version of put character routine above. */
-void prom_putchar(const char *buf)
+void prom_console_write_buf(const char *buf, int len)
 {
-	while (1) {
-		int err = prom_nbputchar(buf);
-		if (!err)
-			break;
+	while (len) {
+		int n = __prom_console_write_buf(buf, len);
+		if (n < 0)
+			continue;
+		len -= n;
+		buf += len;
 	}
 }
Index: linux-2.6.35.y/arch/sparc/prom/printf.c
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/prom/printf.c
+++ linux-2.6.35.y/arch/sparc/prom/printf.c
@@ -15,23 +15,45 @@
 
 #include <linux/kernel.h>
 #include <linux/compiler.h>
+#include <linux/spinlock.h>
 
 #include <asm/openprom.h>
 #include <asm/oplib.h>
 
+#define CONSOLE_WRITE_BUF_SIZE	1024
+
 static char ppbuf[1024];
+static char console_write_buf[CONSOLE_WRITE_BUF_SIZE];
+static DEFINE_RAW_SPINLOCK(console_write_lock);
 
 void notrace prom_write(const char *buf, unsigned int n)
 {
+	unsigned int dest_len;
+	unsigned long flags;
+	char *dest;
+
+	dest = console_write_buf;
+	raw_spin_lock_irqsave(&console_write_lock, flags);
+
+	dest_len = 0;
 	while (n-- != 0) {
-		char ch = *buf;
+		char ch = *buf++;
 		if (ch == '\n') {
-			char tmp = '\r';
-			prom_putchar(&tmp);
+			*dest++ = '\r';
+			dest_len++;
+		}
+		*dest++ = ch;
+		dest_len++;
+		if (dest_len >= CONSOLE_WRITE_BUF_SIZE - 1) {
+			prom_console_write_buf(console_write_buf, dest_len);
+			dest = console_write_buf;
+			dest_len = 0;
 		}
-		prom_putchar(buf);
-		buf++;
 	}
+	if (dest_len)
+		prom_console_write_buf(console_write_buf, dest_len);
+
+	raw_spin_unlock_irqrestore(&console_write_lock, flags);
 }
 
 void notrace prom_printf(const char *fmt, ...)
