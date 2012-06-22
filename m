Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145Ab2FVOkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 10:40:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60387 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055Ab2FVOk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 10:40:29 -0400
Date: Fri, 22 Jun 2012 07:40:16 -0700
From: tip-bot for Ingo Molnar <mingo@kernel.org>
Message-ID: <tip-3f44392e7872bdc9470134f29cead2e06ed4d426@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        shuahkhan@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com, tglx@linutronix.de
In-Reply-To: <1338424803.3569.5.camel@lorien2>
References: <1338424803.3569.5.camel@lorien2>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] Revert "x86/early_printk:
  Replace obsolete simple_strtoul() usage with kstrtoint()"
Git-Commit-ID: 3f44392e7872bdc9470134f29cead2e06ed4d426
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 22 Jun 2012 07:40:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f44392e7872bdc9470134f29cead2e06ed4d426
Gitweb:     http://git.kernel.org/tip/3f44392e7872bdc9470134f29cead2e06ed4d426
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Fri, 22 Jun 2012 16:25:19 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 22 Jun 2012 16:25:19 +0200

Revert "x86/early_printk: Replace obsolete simple_strtoul() usage with kstrtoint()"

This reverts commit fbd24153c48b8425b09c161a020483cd77da870e.

This commit is subtly buggy: kstrto*int() can return an error but
it's not checked in every path. simple_strtoul() on the other hand
could not fail, so this patch subtly intruduces new failure modes.

Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
Link: http://lkml.kernel.org/r/1338424803.3569.5.camel@lorien2
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/early_printk.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 5e47712..9b9f18b 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -119,7 +119,7 @@ static __init void early_serial_init(char *s)
 	unsigned char c;
 	unsigned divisor;
 	unsigned baud = DEFAULT_BAUD;
-	ssize_t ret;
+	char *e;
 
 	if (*s == ',')
 		++s;
@@ -127,14 +127,14 @@ static __init void early_serial_init(char *s)
 	if (*s) {
 		unsigned port;
 		if (!strncmp(s, "0x", 2)) {
-			ret = kstrtoint(s, 16, &early_serial_base);
+			early_serial_base = simple_strtoul(s, &e, 16);
 		} else {
 			static const int __initconst bases[] = { 0x3f8, 0x2f8 };
 
 			if (!strncmp(s, "ttyS", 4))
 				s += 4;
-			ret = kstrtouint(s, 10, &port);
-			if (ret || port > 1)
+			port = simple_strtoul(s, &e, 10);
+			if (port > 1 || s == e)
 				port = 0;
 			early_serial_base = bases[port];
 		}
@@ -149,8 +149,8 @@ static __init void early_serial_init(char *s)
 	outb(0x3, early_serial_base + MCR);	/* DTR + RTS */
 
 	if (*s) {
-		ret = kstrtouint(s, 0, &baud);
-		if (ret || baud == 0)
+		baud = simple_strtoul(s, &e, 0);
+		if (baud == 0 || s == e)
 			baud = DEFAULT_BAUD;
 	}
 
