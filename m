Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab2E0Qsk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 12:48:40 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:33427 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab2E0Qsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 12:48:39 -0400
Message-ID: <1338137317.2968.27.camel@lorien2>
Subject: [PATCH] x86: kernel/early_printk.c simple_strtoul cleanup
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: shuahkhan@gmail.com, x86@kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Sun, 27 May 2012 10:48:37 -0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change early_serial_init() to call kstrtoul() instead of calling obsoleted
simple_strtoul().

Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
---
 arch/x86/kernel/early_printk.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 9b9f18b..a078f4d 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -119,22 +119,27 @@ static __init void early_serial_init(char *s)
 	unsigned char c;
 	unsigned divisor;
 	unsigned baud = DEFAULT_BAUD;
-	char *e;
+	unsigned long val;
+	ssize_t ret;
 
 	if (*s == ',')
 		++s;
 
 	if (*s) {
-		unsigned port;
+		unsigned port = 0;
 		if (!strncmp(s, "0x", 2)) {
-			early_serial_base = simple_strtoul(s, &e, 16);
+			ret = kstrtoul(s, 16, &val);
+			if (!ret)
+				early_serial_base = val;
 		} else {
 			static const int __initconst bases[] = { 0x3f8, 0x2f8 };
 
 			if (!strncmp(s, "ttyS", 4))
 				s += 4;
-			port = simple_strtoul(s, &e, 10);
-			if (port > 1 || s == e)
+			ret = kstrtoul(s, 10, &val);
+			if (!ret)
+				port = val;
+			if (port > 1)
 				port = 0;
 			early_serial_base = bases[port];
 		}
@@ -149,8 +154,10 @@ static __init void early_serial_init(char *s)
 	outb(0x3, early_serial_base + MCR);	/* DTR + RTS */
 
 	if (*s) {
-		baud = simple_strtoul(s, &e, 0);
-		if (baud == 0 || s == e)
+		ret = kstrtoul(s, 0, &val);
+		if (!ret)
+			baud = val;
+		if (baud == 0)
 			baud = DEFAULT_BAUD;
 	}
 
-- 
1.7.9.5



