Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855Ab2GMKTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 06:19:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50565 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482Ab2GMKTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 06:19:19 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 5/8] ARM: kgdb_fiq: Implement knocking into KDB via escape command
Date: Fri, 13 Jul 2012 03:16:45 -0700
Message-Id: <1342174608-22407-5-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120713101605.GA16139@lizard>
References: <20120713101605.GA16139@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Colin Cross noticed, serial ports could be noisy, so occasional
characters once in a while are possible. So, considering the noise
possibility, entering the debugger on any received byte is unacceptable
for production devices.

This changes KGDB FIQ behaviour in a such way so that we have to type the
GDB-protocol "$3#33" command to actually enter the debugger, the kernel
will print the following prompt:

	Type $3#33 to enter the debugger.

This is the exactly the same command we use to escape from KGDB to KDB,
so it should be all pretty familiar.

For convenience, there is a kgdb_fiq.knock kernel command line option,
when set to 0, this turns the special command to just a return key
press, so the kernel will be printing this:

	Hit <return> to enter the debugger.

Suggested-by: Colin Cross <ccross@android.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 arch/arm/kernel/kgdb_fiq.c |   48 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/arch/arm/kernel/kgdb_fiq.c b/arch/arm/kernel/kgdb_fiq.c
index 7ec9979..5308697 100644
--- a/arch/arm/kernel/kgdb_fiq.c
+++ b/arch/arm/kernel/kgdb_fiq.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/hardirq.h>
+#include <linux/kdb.h>
 #include <linux/kgdb.h>
 #include <asm/fiq.h>
 #include <asm/exception.h>
@@ -25,6 +26,51 @@ static int kgdb_fiq_enabled;
 module_param_named(enable, kgdb_fiq_enabled, int, 0600);
 MODULE_PARM_DESC(enable, "set to 1 to enable FIQ KGDB");
 
+static bool kgdb_fiq_knock = 1;
+module_param_named(knock, kgdb_fiq_knock, bool, 0600);
+MODULE_PARM_DESC(knock, "'$3#33' command must be used to enter the debugger");
+
+/*
+ * "Serial ports are often noisy, especially when muxed over another port (we
+ * often use serial over the headset connector). Noise on the async command
+ * line just causes characters that are ignored, on a command line that blocked
+ * execution noise would be catastrophic." -- Colin Cross
+ *
+ * So, this small function implements KGDB/KDB knocking on the serial line: we
+ * won't enter the debugger until we receive a known magic phrase (which is
+ * actually "$3#33", known as "escape to KDB" command. If knocking is disabled,
+ * just pressing the return key is enough to enter the debugger.
+ */
+static bool kgdb_fiq_poll_knock(void)
+{
+	static int n;
+	int c = -1;
+	get_char_func *getc;
+	const char *magic = "$3#33";
+	size_t m = strlen(magic);
+
+	for (getc = &kdb_poll_funcs[0]; *getc; ++getc) {
+		c = (*getc)();
+		if (c >= 0)
+			break;
+	}
+
+	if (!kgdb_fiq_knock && (c == '\r' || c == '\n')) {
+		return 1;
+	} else if (c == magic[n]) {
+		kdb_printf("%c", c);
+		n = (n + 1) % m;
+		if (!n)
+			return 1;
+	} else {
+		n = 0;
+		kdb_printf("\n%s %s to enter the debugger.\n",
+			   kgdb_fiq_knock ? "Type" : "Hit",
+			   kgdb_fiq_knock ? magic  : "<return>");
+	}
+	return 0;
+}
+
 static unsigned int kgdb_fiq;
 static void (*kgdb_enable_fiq)(unsigned int irq, bool on);
 static bool (*is_kgdb_fiq)(unsigned int irq);
@@ -33,6 +79,8 @@ asmlinkage void __exception_irq_entry kgdb_fiq_do_handle(struct pt_regs *regs)
 {
 	if (!is_kgdb_fiq(kgdb_fiq))
 		return;
+	if (!kgdb_fiq_poll_knock())
+		return;
 
 	nmi_enter();
 	kgdb_handle_exception(1, 0, 0, regs);
-- 
1.7.10.4

