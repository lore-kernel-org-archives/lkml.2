Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab0DTQV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 12:21:56 -0400
Received: from imr3.ericy.com ([198.24.6.13]:40817 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499Ab0DTQVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 12:21:54 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi, mingo@redhat.com,
       x86@kernel.org
CC: Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v3] x86: Do not write into VGA memory space if there is no VGA device in the system
Date: Tue, 20 Apr 2010 09:16:57 -0700
Message-ID: <1271780217-27472-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that early_printk() does not write into VGA memory space
if there is not VGA device in the system.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
v3:
Changes are now limited to early_printk.c. Functionality is retained, meaning
there will still be output on the VGA console before setup_early_printk()
is called, but only if a VGA device is known to exist in the system.

 arch/x86/kernel/early_printk.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index b9c830c..783cb25 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -170,10 +170,13 @@ asmlinkage void early_printk(const char *fmt, ...)
 	int n;
 	va_list ap;
 
-	va_start(ap, fmt);
-	n = vscnprintf(buf, sizeof(buf), fmt, ap);
-	early_console->write(early_console, buf, n);
-	va_end(ap);
+	if (early_console && (early_console_initialized ||
+			      boot_params.screen_info.orig_video_isVGA == 1)) {
+		va_start(ap, fmt);
+		n = vscnprintf(buf, sizeof(buf), fmt, ap);
+		early_console->write(early_console, buf, n);
+		va_end(ap);
+	}
 }
 
 static inline void early_console_register(struct console *con, int keep_early)
@@ -233,6 +236,12 @@ static int __init setup_early_printk(char *buf)
 #endif
 		buf++;
 	}
+
+	/* If there is no VGA device, don't try to use it as early console. */
+	if (early_console == &early_vga_console &&
+	    boot_params.screen_info.orig_video_isVGA != 1)
+		early_console = NULL;
+
 	return 0;
 }
 
-- 
1.7.0.87.g0901d

