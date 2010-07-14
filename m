Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab0GNTNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:13:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:34528 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab0GNTN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:13:29 -0400
Date: Wed, 14 Jul 2010 19:12:49 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <4C3E0171.6050008@kernel.org>
References: <4C3E0171.6050008@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/setup] x86, setup: Only set early_serial_base after port is initialized
Message-ID: <tip-70b0d22d581a5deef7b2876b0c3774635b8d846c@git.kernel.org>
Git-Commit-ID: 70b0d22d581a5deef7b2876b0c3774635b8d846c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 14 Jul 2010 19:12:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70b0d22d581a5deef7b2876b0c3774635b8d846c
Gitweb:     http://git.kernel.org/tip/70b0d22d581a5deef7b2876b0c3774635b8d846c
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 14 Jul 2010 11:26:57 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 14 Jul 2010 12:07:16 -0700

x86, setup: Only set early_serial_base after port is initialized

putchar is using early_serial_base to check if port is initialized.

So we only assign it after early_serial_init() is called,
in case we need use VGA to debug early serial console.

Also add display for port addr and baud.

-v2: update to current tip

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4C3E0171.6050008@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/tty.c |   63 ++++++++++++++++++++++++++------------------------
 1 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/arch/x86/boot/tty.c b/arch/x86/boot/tty.c
index f6d52e6..ff4b27a 100644
--- a/arch/x86/boot/tty.c
+++ b/arch/x86/boot/tty.c
@@ -152,35 +152,40 @@ int getchar_timeout(void)
 	return 0;		/* Timeout! */
 }
 
-static void early_serial_init(int baud)
+static void early_serial_init(int port, int baud)
 {
 	unsigned char c;
 	unsigned divisor;
 
-	outb(0x3, early_serial_base + LCR);	/* 8n1 */
-	outb(0, early_serial_base + IER);	/* no interrupt */
-	outb(0, early_serial_base + FCR);	/* no fifo */
-	outb(0x3, early_serial_base + MCR);	/* DTR + RTS */
+	outb(0x3, port + LCR);	/* 8n1 */
+	outb(0, port + IER);	/* no interrupt */
+	outb(0, port + FCR);	/* no fifo */
+	outb(0x3, port + MCR);	/* DTR + RTS */
 
 	divisor	= 115200 / baud;
-	c = inb(early_serial_base + LCR);
-	outb(c | DLAB, early_serial_base + LCR);
-	outb(divisor & 0xff, early_serial_base + DLL);
-	outb((divisor >> 8) & 0xff, early_serial_base + DLH);
-	outb(c & ~DLAB, early_serial_base + LCR);
+	c = inb(port + LCR);
+	outb(c | DLAB, port + LCR);
+	outb(divisor & 0xff, port + DLL);
+	outb((divisor >> 8) & 0xff, port + DLH);
+	outb(c & ~DLAB, port + LCR);
+
+	early_serial_base = port;
+
+	printf("Early serial console at I/O port 0x%x baud: %d\n", port, baud);
 }
 
-static int parse_earlyprintk(void)
+static void parse_earlyprintk(void)
 {
 	int baud = DEFAULT_BAUD;
 	char arg[32];
 	int pos = 0;
+	int port = 0;
 
 	if (cmdline_find_option("earlyprintk", arg, sizeof arg) > 0) {
 		char *e;
 
 		if (!strncmp(arg, "serial", 6)) {
-			early_serial_base = DEFAULT_SERIAL_PORT;
+			port = DEFAULT_SERIAL_PORT;
 			pos += 6;
 		}
 
@@ -189,15 +194,15 @@ static int parse_earlyprintk(void)
 
 		if (!strncmp(arg, "ttyS", 4)) {
 			static const int bases[] = { 0x3f8, 0x2f8 };
-			int port = 0;
+			int idx = 0;
 
 			if (!strncmp(arg + pos, "ttyS", 4))
 				pos += 4;
 
 			if (arg[pos++] == '1')
-				port = 1;
+				idx = 1;
 
-			early_serial_base = bases[port];
+			port = bases[idx];
 		}
 
 		if (arg[pos] == ',')
@@ -208,7 +213,8 @@ static int parse_earlyprintk(void)
 			baud = DEFAULT_BAUD;
 	}
 
-	return baud;
+	if (port)
+		early_serial_init(port, baud);
 }
 
 #define BASE_BAUD (1843200/16)
@@ -227,44 +233,41 @@ static unsigned int probe_baud(int port)
 	return BASE_BAUD / quot;
 }
 
-static int parse_console_uart8250(void)
+static void parse_console_uart8250(void)
 {
 	char optstr[64], *options;
 	int baud = DEFAULT_BAUD;
+	int port = 0;
 
 	/*
 	 * console=uart8250,io,0x3f8,115200n8
 	 * need to make sure it is last one console !
 	 */
 	if (cmdline_find_option("console", optstr, sizeof optstr) <= 0)
-		return baud;
+		return;
 
 	options = optstr;
 
 	if (!strncmp(options, "uart8250,io,", 12))
-		early_serial_base = simple_strtoull(options + 12, &options, 0);
+		port = simple_strtoull(options + 12, &options, 0);
 	else if (!strncmp(options, "uart,io,", 8))
-		early_serial_base = simple_strtoull(options + 8, &options, 0);
+		port = simple_strtoull(options + 8, &options, 0);
 	else
-		return baud;
+		return;
 
 	if (options && (options[0] == ','))
 		baud = simple_strtoull(options + 1, &options, 0);
 	else
-		baud = probe_baud(early_serial_base);
+		baud = probe_baud(port);
 
-	return baud;
+	if (port)
+		early_serial_init(port, baud);
 }
 
 void console_init(void)
 {
-	int baud;
-
-	baud = parse_earlyprintk();
+	parse_earlyprintk();
 
 	if (!early_serial_base)
-		baud = parse_console_uart8250();
-
-	if (early_serial_base != 0)
-		early_serial_init(baud);
+		parse_console_uart8250();
 }
