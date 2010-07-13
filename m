Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab0GMVNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 17:13:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:46250 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076Ab0GMVNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 17:13:34 -0400
Date: Tue, 13 Jul 2010 21:12:50 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <4C3CCE05.4090505@kernel.org>
References: <4C3CCE05.4090505@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/setup] x86, setup: Make the setup code also accept console=uart8250
Message-ID: <tip-ce0aa5dd20e44372f9617dd67c984f41fcdbed88@git.kernel.org>
Git-Commit-ID: ce0aa5dd20e44372f9617dd67c984f41fcdbed88
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 13 Jul 2010 21:12:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce0aa5dd20e44372f9617dd67c984f41fcdbed88
Gitweb:     http://git.kernel.org/tip/ce0aa5dd20e44372f9617dd67c984f41fcdbed88
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 13 Jul 2010 13:35:17 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 13 Jul 2010 14:08:12 -0700

x86, setup: Make the setup code also accept console=uart8250

Make the boot code also accept the console=uart8250,io,0x2f8,115200n
form of early console.

Also add back simple_guess_base(), otherwise those simple_strtoull(,,0)
are not going to work.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4C3CCE05.4090505@kernel.org>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/string.c |   22 ++++++++++++++++++
 arch/x86/boot/tty.c    |   59 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 80 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/string.c b/arch/x86/boot/string.c
index aba29df..3cbc405 100644
--- a/arch/x86/boot/string.c
+++ b/arch/x86/boot/string.c
@@ -68,10 +68,32 @@ unsigned int atou(const char *s)
 /* Works only for digits and letters, but small and fast */
 #define TOLOWER(x) ((x) | 0x20)
 
+static unsigned int simple_guess_base(const char *cp)
+{
+	if (cp[0] == '0') {
+		if (TOLOWER(cp[1]) == 'x' && isxdigit(cp[2]))
+			return 16;
+		else
+			return 8;
+	} else {
+		return 10;
+	}
+}
+
+/**
+ * simple_strtoull - convert a string to an unsigned long long
+ * @cp: The start of the string
+ * @endp: A pointer to the end of the parsed string will be placed here
+ * @base: The number base to use
+ */
+
 unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base)
 {
 	unsigned long long result = 0;
 
+	if (!base)
+		base = simple_guess_base(cp);
+
 	if (base == 16 && cp[0] == '0' && TOLOWER(cp[1]) == 'x')
 		cp += 2;
 
diff --git a/arch/x86/boot/tty.c b/arch/x86/boot/tty.c
index f3ceee2..f6d52e6 100644
--- a/arch/x86/boot/tty.c
+++ b/arch/x86/boot/tty.c
@@ -170,7 +170,7 @@ static void early_serial_init(int baud)
 	outb(c & ~DLAB, early_serial_base + LCR);
 }
 
-void console_init(void)
+static int parse_earlyprintk(void)
 {
 	int baud = DEFAULT_BAUD;
 	char arg[32];
@@ -208,6 +208,63 @@ void console_init(void)
 			baud = DEFAULT_BAUD;
 	}
 
+	return baud;
+}
+
+#define BASE_BAUD (1843200/16)
+static unsigned int probe_baud(int port)
+{
+	unsigned char lcr, dll, dlh;
+	unsigned int quot;
+
+	lcr = inb(port + LCR);
+	outb(lcr | DLAB, port + LCR);
+	dll = inb(port + DLL);
+	dlh = inb(port + DLH);
+	outb(lcr, port + LCR);
+	quot = (dlh << 8) | dll;
+
+	return BASE_BAUD / quot;
+}
+
+static int parse_console_uart8250(void)
+{
+	char optstr[64], *options;
+	int baud = DEFAULT_BAUD;
+
+	/*
+	 * console=uart8250,io,0x3f8,115200n8
+	 * need to make sure it is last one console !
+	 */
+	if (cmdline_find_option("console", optstr, sizeof optstr) <= 0)
+		return baud;
+
+	options = optstr;
+
+	if (!strncmp(options, "uart8250,io,", 12))
+		early_serial_base = simple_strtoull(options + 12, &options, 0);
+	else if (!strncmp(options, "uart,io,", 8))
+		early_serial_base = simple_strtoull(options + 8, &options, 0);
+	else
+		return baud;
+
+	if (options && (options[0] == ','))
+		baud = simple_strtoull(options + 1, &options, 0);
+	else
+		baud = probe_baud(early_serial_base);
+
+	return baud;
+}
+
+void console_init(void)
+{
+	int baud;
+
+	baud = parse_earlyprintk();
+
+	if (!early_serial_base)
+		baud = parse_console_uart8250();
+
 	if (early_serial_base != 0)
 		early_serial_init(baud);
 }
