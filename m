Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab2FFPPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:15:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39861 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab2FFPPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:15:31 -0400
Date: Wed, 6 Jun 2012 08:15:17 -0700
From: tip-bot for Shuah Khan <shuahkhan@gmail.com>
Message-ID: <tip-fbd24153c48b8425b09c161a020483cd77da870e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        joe@perches.com, shuahkhan@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com, joe@perches.com, tglx@linutronix.de
In-Reply-To: <1338424803.3569.5.camel@lorien2>
References: <1338424803.3569.5.camel@lorien2>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86/early_printk:
  Replace obsolete simple_strtoul() usage with kstrtoint()
Git-Commit-ID: fbd24153c48b8425b09c161a020483cd77da870e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:15:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fbd24153c48b8425b09c161a020483cd77da870e
Gitweb:     http://git.kernel.org/tip/fbd24153c48b8425b09c161a020483cd77da870e
Author:     Shuah Khan <shuahkhan@gmail.com>
AuthorDate: Wed, 30 May 2012 18:40:03 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 11:44:22 +0200

x86/early_printk: Replace obsolete simple_strtoul() usage with kstrtoint()

Change early_serial_init() to call kstrtoul() instead of calling
obsoleted simple_strtoul().

Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
Cc: Joe Perches <joe@perches.com>
Link: http://lkml.kernel.org/r/1338424803.3569.5.camel@lorien2
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/early_printk.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

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
 
