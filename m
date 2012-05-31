Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab2EaAkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 20:40:07 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:34350 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab2EaAkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 20:40:06 -0400
Message-ID: <1338424803.3569.5.camel@lorien2>
Subject: [PATCH RESEND] x86: kernel/early_printk.c simple_strtoul cleanup
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Joe Perches <joe@perches.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Cc: shuahkhan@gmail.com, x86@kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 30 May 2012 18:40:03 -0600
In-Reply-To: <1338324091.2722.9.camel@lorien2>
References: <1338137317.2968.27.camel@lorien2>
	 <1338151872.28188.16.camel@joe2Laptop> <1338324091.2722.9.camel@lorien2>
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
 arch/x86/kernel/early_printk.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 9b9f18b..5e47712 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -119,7 +119,7 @@ static __init void early_serial_init(char *s)
 	unsigned char c;
 	unsigned divisor;
 	unsigned baud = DEFAULT_BAUD;
-	char *e;
+	ssize_t ret;
 
 	if (*s == ',')
 		++s;
@@ -127,14 +127,14 @@ static __init void early_serial_init(char *s)
 	if (*s) {
 		unsigned port;
 		if (!strncmp(s, "0x", 2)) {
-			early_serial_base = simple_strtoul(s, &e, 16);
+			ret = kstrtoint(s, 16, &early_serial_base);
 		} else {
 			static const int __initconst bases[] = { 0x3f8, 0x2f8 };
 
 			if (!strncmp(s, "ttyS", 4))
 				s += 4;
-			port = simple_strtoul(s, &e, 10);
-			if (port > 1 || s == e)
+			ret = kstrtouint(s, 10, &port);
+			if (ret || port > 1)
 				port = 0;
 			early_serial_base = bases[port];
 		}
@@ -149,8 +149,8 @@ static __init void early_serial_init(char *s)
 	outb(0x3, early_serial_base + MCR);	/* DTR + RTS */
 
 	if (*s) {
-		baud = simple_strtoul(s, &e, 0);
-		if (baud == 0 || s == e)
+		ret = kstrtouint(s, 0, &baud);
+		if (ret || baud == 0)
 			baud = DEFAULT_BAUD;
 	}
 
-- 
1.7.9.5



