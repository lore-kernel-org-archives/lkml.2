Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab0H2XAQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 19:00:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61956 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab0H2XAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 19:00:14 -0400
Message-ID: <4C7AE63A.40709@kernel.org>
Date: Sun, 29 Aug 2010 15:59:06 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, setup: move out serial_putchar out of putchar
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


let puts to call serial_putchar directly.

So only need to check early_serial_base per string.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/boot/tty.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/boot/tty.c
===================================================================
--- linux-2.6.orig/arch/x86/boot/tty.c
+++ linux-2.6/arch/x86/boot/tty.c
@@ -52,16 +52,22 @@ static void __attribute__((section(".ini
 void __attribute__((section(".inittext"))) putchar(int ch)
 {
 	if (ch == '\n')
-		putchar('\r');	/* \n -> \r\n */
+		bios_putchar('\r');	/* \n -> \r\n */
 
 	bios_putchar(ch);
-
-	if (early_serial_base != 0)
-		serial_putchar(ch);
 }
 
 void __attribute__((section(".inittext"))) puts(const char *str)
 {
+	if (early_serial_base) {
+		const char *s = str;
+		while (*s) {
+			if (*s == '\n')
+				serial_putchar('\r');
+			serial_putchar(*s++);
+		}
+	}
+
 	while (*str)
 		putchar(*str++);
 }
