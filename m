Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab1HEXeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 19:34:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26702 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab1HEXeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 19:34:07 -0400
From: Sergiu Iordache <sergiu@chromium.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergiu Iordache <sergiu@chromium.org>
Subject: [PATCH] char drivers: ramoops documentation
Date: Fri,  5 Aug 2011 16:33:49 -0700
Message-Id: <1312587229-30105-1-git-send-email-sergiu@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a documentation file describing the usage of Ramoops

Signed-off-by: Sergiu Iordache <sergiu@chromium.org>
---
 Documentation/ramoops.txt |   73 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 73 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ramoops.txt

diff --git a/Documentation/ramoops.txt b/Documentation/ramoops.txt
new file mode 100644
index 0000000..0575177
--- /dev/null
+++ b/Documentation/ramoops.txt
@@ -0,0 +1,73 @@
+Ramoops oops/panic logger
+=========================
+
+Sergiu Iordache <sergiu@chromium.org>
+
+Updated: 5 August 2011
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
+  multiple of two.
+
+The memory area is divided into "record_size" chunks (also rounded down to
+multiple of two) and each oops/panic writes a "record_size" chunk of
+information.
+
+Dumping both oopses and panics can be done by setting 1 in the "dump_oops"
+variable while setting 0 in that variable dumps only the panics.
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
+timestamp and then continues with the actual dump data.
+
+4. Reading the data
+
+The dump data can be read from memory (through /dev/mem or other means).
+Getting the module parameters, which are needed in order to parse the data, can
+be done through /sys/module/ramoops/parameters/* .
-- 
1.7.2.3

