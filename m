Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab2HBTqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 15:46:16 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44551 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab2HBTqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 15:46:14 -0400
From: Vikram Pandita <vikram.pandita@ti.com>
To: <gregkh@linuxfoundation.org>, <kay@vrfy.org>
CC: <linux-kernel@vger.kernel.org>, Vikram Pandita <vikram.pandita@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Subject: [PATCH] printk: add option to print cpu id
Date: Thu, 2 Aug 2012 12:46:04 -0700
Message-ID: <1343936764-6461-1-git-send-email-vikram.pandita@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vikram Pandita <vikram.pandita@ti.com>

Introduce config option to enable CPU id reporting for printk() calls.

Its sometimes very useful to have printk also print the CPU Identifier
that executed the call. This has helped to debug various SMP issues on shipping
products.

Known limitation is, if the system gets preempted between function call and
actual printk, the reported cpu-id might not be accurate. But most of the
times its seen to give a good feel of how the N cpu's in the system are
getting loaded.

Signed-off-by: Vikram Pandita <vikram.pandita@ti.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
---
 kernel/printk.c   |   20 ++++++++++++++++++++
 lib/Kconfig.debug |   13 +++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/kernel/printk.c b/kernel/printk.c
index 6a76ab9..50feb82 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -855,6 +855,25 @@ static size_t print_time(u64 ts, char *buf)
 		       (unsigned long)ts, rem_nsec / 1000);
 }
 
+#if defined(CONFIG_PRINTK_CPUID)
+static bool printk_cpuid = 1;
+#else
+static bool printk_cpuid;
+#endif
+module_param_named(cpuid, printk_cpuid, bool, S_IRUGO | S_IWUSR);
+
+static size_t print_cpuid(char *buf)
+{
+
+	if (!printk_cpuid)
+		return 0;
+
+	if (!buf)
+		return 4;
+
+	return sprintf(buf, "[%1d] ", smp_processor_id());
+}
+
 static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
 {
 	size_t len = 0;
@@ -874,6 +893,7 @@ static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
 		}
 	}
 
+	len += print_cpuid(buf ? buf + len : NULL);
 	len += print_time(msg->ts_nsec, buf ? buf + len : NULL);
 	return len;
 }
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2403a63..139b2b1 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -14,6 +14,19 @@ config PRINTK_TIME
 	  The behavior is also controlled by the kernel command line
 	  parameter printk.time=1. See Documentation/kernel-parameters.txt
 
+config PRINTK_CPUID
+	bool "Show cpu id information on printks"
+	depends on PRINTK
+	help
+	  Selecting this option causes cpu identifier to be added to the
+	  output of the syslog() system call and at the console.
+
+	  This flag just specifies if the cpu-id should
+	  be included.
+
+	  The behavior is also controlled by the kernel command line
+	  parameter printk.cpuid=1.
+
 config DEFAULT_MESSAGE_LOGLEVEL
 	int "Default message log level (1-7)"
 	range 1 7
-- 
1.7.9.5

