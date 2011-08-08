Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab1HHRkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 13:40:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:50271 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab1HHRkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 13:40:16 -0400
From: Sergiu Iordache <sergiu@chromium.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergiu Iordache <sergiu@chromium.org>
Subject: [PATCH v3] char drivers: ramoops documentation
Date: Mon,  8 Aug 2011 10:40:03 -0700
Message-Id: <1312825203-22909-1-git-send-email-sergiu@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a documentation file describing the usage of Ramoops

Signed-off-by: Sergiu Iordache <sergiu@chromium.org>
---
 Documentation/00-INDEX    |    2 +
 Documentation/ramoops.txt |   76 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ramoops.txt

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 8dfc670..9bc0f9e 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -276,6 +276,8 @@ printk-formats.txt
 	- how to get printk format specifiers right
 prio_tree.txt
 	- info on radix-priority-search-tree use for indexing vmas.
+ramoops.txt
+	- documentation of the ramoops oops/panic logging module.
 rbtree.txt
 	- info on what red-black trees are and what they are for.
 robust-futex-ABI.txt
diff --git a/Documentation/ramoops.txt b/Documentation/ramoops.txt
new file mode 100644
index 0000000..8fb1ba7
--- /dev/null
+++ b/Documentation/ramoops.txt
@@ -0,0 +1,76 @@
+Ramoops oops/panic logger
+=========================
+
+Sergiu Iordache <sergiu@chromium.org>
+
+Updated: 8 August 2011
+
+0. Introduction
+
+Ramoops is an oops/panic logger that writes its logs to RAM before the system
+crashes. It works by logging oopses and panics in a circular buffer. Ramoops
+needs a system with persistent RAM so that the content of that area can
+survive after a restart.
+
+1. Ramoops concepts
+
+Ramoops uses a predefined memory area to store the dump. The start and size of
+the memory area are set using two variables:
+  * "mem_address" for the start
+  * "mem_size" for the size. The memory size will be rounded down to a
+  power of two.
+
+The memory area is divided into "record_size" chunks (also rounded down to
+power of two) and each oops/panic writes a "record_size" chunk of
+information.
+
+Dumping both oopses and panics can be done by setting 1 in the "dump_oops"
+variable while setting 0 in that variable dumps only the panics.
+
+The module uses a counter to record multiple dumps but the counter gets reset
+on restart (i.e. new dumps after the restart will overwrite old ones).
+
+2. Setting the parameters
+
+Setting the ramoops parameters can be done in 2 different manners:
+ 1. Use the module parameters (which have the names of the variables described
+ as before).
+ 2. Use a platform device and set the platform data. The parameters can then
+ be set through that platform data. An example of doing that is:
+
+#include <linux/ramoops.h>
+[...]
+
+static struct ramoops_platform_data ramoops_data = {
+        .mem_size               = <...>,
+        .mem_address            = <...>,
+        .record_size            = <...>,
+        .dump_oops              = <...>,
+};
+
+static struct platform_device ramoops_dev = {
+        .name = "ramoops",
+        .dev = {
+                .platform_data = &ramoops_data,
+        },
+};
+
+[... inside a function ...]
+int ret;
+
+ret = platform_device_register(&ramoops_dev);
+if (ret) {
+	printk(KERN_ERR "unable to register platform device\n");
+	return ret;
+}
+
+3. Dump format
+
+The data dump begins with a header, currently defined as "====" followed by a
+timestamp and a new line. The dump then continues with the actual data.
+
+4. Reading the data
+
+The dump data can be read from memory (through /dev/mem or other means).
+Getting the module parameters, which are needed in order to parse the data, can
+be done through /sys/module/ramoops/parameters/* .
-- 
1.7.2.3

