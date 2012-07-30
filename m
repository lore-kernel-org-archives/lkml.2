Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab2G3MCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 08:02:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47107 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab2G3MB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 08:01:57 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 08/11] ARM: kgdb_fiq: Implement knocking into KDB via escape command
Date: Mon, 30 Jul 2012 04:58:17 -0700
Message-Id: <1343649500-18491-8-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120730115719.GA5742@lizard>
References: <20120730115719.GA5742@lizard>
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

	Type $3#33 to enter the debugger>

This is the exactly the same command we use to escape from KGDB to KDB,
so it should be all pretty familiar.

For convenience, there is a kgdb_fiq.knock kernel command line option,
when set to 0, this turns the special command to just a return key
press, so the kernel will be printing this:

	Hit <return> to enter the debugger>

And for the cases when NMI connected to a dedicated button, the knocking
can be disabled altogether by setting kgdb_fiq.knock to -1.

Suggested-by: Colin Cross <ccross@android.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 arch/arm/kernel/kgdb_fiq.c |   58 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/arch/arm/kernel/kgdb_fiq.c b/arch/arm/kernel/kgdb_fiq.c
index 72a62c7..2bf4467 100644
--- a/arch/arm/kernel/kgdb_fiq.c
+++ b/arch/arm/kernel/kgdb_fiq.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/hardirq.h>
+#include <linux/kdb.h>
 #include <linux/kgdb.h>
 #include <asm/fiq.h>
 #include <asm/exception.h>
@@ -26,6 +27,60 @@ static int kgdb_fiq_enabled;
 module_param_named(enable, kgdb_fiq_enabled, int, 0600);
 MODULE_PARM_DESC(enable, "set to 1 to enable FIQ KGDB");
 
+static int kgdb_fiq_knock = 1;
+module_param_named(knock, kgdb_fiq_knock, int, 0600);
+MODULE_PARM_DESC(knock, "if set to 1 (default), the special '$3#33' command "
+			"must be used to enter the debugger; when set to 0, "
+			"hitting return key is enough to enter the debugger; "
+			"when set to -1, the debugger is entered immediately "
+			"upon NMI");
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
+	char magic[] = "$3#33";
+	size_t m = strlen(magic);
+
+	if (kgdb_fiq_knock < 0)
+		return 1;
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
+		kdb_printf("\r%s %s to enter the debugger> %*s",
+			   kgdb_fiq_knock ? "Type" : "Hit",
+			   kgdb_fiq_knock ? magic  : "<return>", m, "");
+		memset(magic, '\b', m);
+		kdb_printf("%s", magic);
+	}
+	return 0;
+}
+
 static unsigned int kgdb_fiq;
 static void (*kgdb_enable_fiq)(unsigned int irq, bool on);
 static bool (*is_kgdb_fiq)(unsigned int irq);
@@ -36,6 +91,9 @@ asmlinkage void __exception_irq_entry kgdb_fiq_do_handle(struct pt_regs *regs)
 		return;
 	dbg_io_ops->clear_irqs();
 
+	if (!kgdb_fiq_poll_knock())
+		return;
+
 	nmi_enter();
 	kgdb_handle_exception(1, 0, 0, regs);
 	nmi_exit();
-- 
1.7.10.4

