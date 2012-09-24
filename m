Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167Ab2IXVbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 17:31:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58183 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab2IXVbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 17:31:34 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Alan Cox <alan@linux.intel.com>, Jason Wessel <jason.wessel@windriver.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: [PATCH 02/11] kdb: Implement disable_nmi command
Date: Mon, 24 Sep 2012 14:27:51 -0700
Message-Id: <1348522080-32629-2-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <20120924212648.GA27605@lizard>
References: <20120924212648.GA27605@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This command disables NMI-entry. If NMI source has been previously shared
with a serial console ("debug port"), this effectively releases the port
from KDB exclusive use, and makes the console available for normal use.

Of course, NMI can be reenabled, enable_nmi modparam is used for that:

	echo 1 > /sys/module/kdb/parameters/enable_nmi

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Acked-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/kdb/kdb_main.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 31df170..1261dc7 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -21,6 +21,7 @@
 #include <linux/smp.h>
 #include <linux/utsname.h>
 #include <linux/vmalloc.h>
+#include <linux/atomic.h>
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/init.h>
@@ -2107,6 +2108,32 @@ static int kdb_dmesg(int argc, const char **argv)
 	return 0;
 }
 #endif /* CONFIG_PRINTK */
+
+/* Make sure we balance enable/disable calls, must disable first. */
+static atomic_t kdb_nmi_disabled;
+
+static int kdb_disable_nmi(int argc, const char *argv[])
+{
+	if (atomic_read(&kdb_nmi_disabled))
+		return 0;
+	atomic_set(&kdb_nmi_disabled, 1);
+	arch_kgdb_ops.enable_nmi(0);
+	return 0;
+}
+
+static int kdb_param_enable_nmi(const char *val, const struct kernel_param *kp)
+{
+	if (!atomic_add_unless(&kdb_nmi_disabled, -1, 0))
+		return -EINVAL;
+	arch_kgdb_ops.enable_nmi(1);
+	return 0;
+}
+
+static const struct kernel_param_ops kdb_param_ops_enable_nmi = {
+	.set = kdb_param_enable_nmi,
+};
+module_param_cb(enable_nmi, &kdb_param_ops_enable_nmi, NULL, 0600);
+
 /*
  * kdb_cpu - This function implements the 'cpu' command.
  *	cpu	[<cpunum>]
@@ -2851,6 +2878,10 @@ static void __init kdb_inittab(void)
 	kdb_register_repeat("dmesg", kdb_dmesg, "[lines]",
 	  "Display syslog buffer", 0, KDB_REPEAT_NONE);
 #endif
+	if (arch_kgdb_ops.enable_nmi) {
+		kdb_register_repeat("disable_nmi", kdb_disable_nmi, "",
+		  "Disable NMI entry to KDB", 0, KDB_REPEAT_NONE);
+	}
 	kdb_register_repeat("defcmd", kdb_defcmd, "name \"usage\" \"help\"",
 	  "Define a set of commands, down to endefcmd", 0, KDB_REPEAT_NONE);
 	kdb_register_repeat("kill", kdb_kill, "<-signal> <pid>",
-- 
1.7.12

