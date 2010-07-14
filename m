Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab0GNSbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:31:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39335 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab0GNSbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:31:21 -0400
Message-ID: <4C3E0171.6050008@kernel.org>
Date: Wed, 14 Jul 2010 11:26:57 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -v2] x86: only set early_serial_base after port is initialized
 in setup code
References: <4C3A3B27.7020009@oracle.com>	<4C3AD94C.7070807@cs.helsinki.fi>	<4C3B38F7.1050400@zytor.com>	<4C3B40F3.6070009@kernel.org>	<4C3CA5A9.6000607@cs.helsinki.fi>	<4C3CCE05.4090505@kernel.org>	<AANLkTimYQPaF6YH2aMBf3nprmxLFVDDYLG4gxxD3VyBa@mail.gmail.com>	<4C3D1BC4.5020102@kernel.org> <AANLkTimki4lRVJZDGB8RHldtEgj1f1MpAFt0hfbdwmcl@mail.gmail.com>
In-Reply-To: <AANLkTimki4lRVJZDGB8RHldtEgj1f1MpAFt0hfbdwmcl@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C3E0209.0281,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


putchar is using early_serial_base to check if port is initialized.

So we only assign it after early_serial_init() is called.

in case we need use VGA to debug early serial console.

Also add display for port addr and baud.

-v2: update to current tip

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/boot/tty.c |   63 +++++++++++++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 30 deletions(-)

Index: linux-2.6/arch/x86/boot/tty.c
===================================================================
--- linux-2.6.orig/arch/x86/boot/tty.c
+++ linux-2.6/arch/x86/boot/tty.c
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
