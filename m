Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab2GHAZZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 20:25:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54685 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab2GHAYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 20:24:52 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Dave Jones <davej@redhat.com>
Subject: [PATCH -mm 2/3] notifier error injection documentation
Date: Sun,  8 Jul 2012 09:24:25 +0900
Message-Id: <1341707066-10742-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341707066-10742-1-git-send-email-akinobu.mita@gmail.com>
References: <1341707066-10742-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fault-injection-notifier-error-injection.patch in -mm tree adds
notifier error injection.

This adds Documentation/fault-injection/notifier-error-inject.txt
which describes its feature and usage examples.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Dave Jones <davej@redhat.com>
---
 .../fault-injection/notifier-error-inject.txt      |   99 ++++++++++++++++++++
 1 file changed, 99 insertions(+)
 create mode 100644 Documentation/fault-injection/notifier-error-inject.txt

diff --git a/Documentation/fault-injection/notifier-error-inject.txt b/Documentation/fault-injection/notifier-error-inject.txt
new file mode 100644
index 0000000..c83526c
--- /dev/null
+++ b/Documentation/fault-injection/notifier-error-inject.txt
@@ -0,0 +1,99 @@
+Notifier error injection
+========================
+
+Notifier error injection provides the ability to inject artifical errors to
+specified notifier chain callbacks. It is useful to test the error handling of
+notifier call chain failures which is rarely executed.  There are kernel
+modules that can be used to test the following notifiers.
+
+ * CPU notifier
+ * PM notifier
+ * Memory hotplug notifier
+ * powerpc pSeries reconfig notifier
+
+CPU notifier error injection module
+-----------------------------------
+This feature can be used to test the error handling of the CPU notifiers by
+injecting artifical errors to CPU notifier chain callbacks.
+
+If the notifier call chain should be failed with some events notified, write
+the error code to debugfs interface
+/sys/kernel/debug/notifier-error-inject/cpu/actions/<notifier event>/error
+
+Possible CPU notifier events to be failed are:
+
+ * CPU_UP_PREPARE
+ * CPU_UP_PREPARE_FROZEN
+ * CPU_DOWN_PREPARE
+ * CPU_DOWN_PREPARE_FROZEN
+
+Example1: Inject CPU offline error (-1 == -EPERM)
+
+	# cd /sys/kernel/debug/notifier-error-inject/cpu
+	# echo -1 > actions/CPU_DOWN_PREPARE/error
+	# echo 0 > /sys/devices/system/cpu/cpu1/online
+	bash: echo: write error: Operation not permitted
+
+Example2: inject CPU online error (-2 == -ENOENT)
+
+	# echo -2 > actions/CPU_UP_PREPARE/error
+	# echo 1 > /sys/devices/system/cpu/cpu1/online
+	bash: echo: write error: No such file or directory
+
+PM notifier error injection module
+----------------------------------
+This feature is controlled through debugfs interface
+/sys/kernel/debug/notifier-error-inject/pm/actions/<notifier event>/error
+
+Possible PM notifier events to be failed are:
+
+ * PM_HIBERNATION_PREPARE
+ * PM_SUSPEND_PREPARE
+ * PM_RESTORE_PREPARE
+
+Example: Inject PM suspend error (-12 = -ENOMEM)
+
+	# cd /sys/kernel/debug/notifier-error-inject/pm/
+	# echo -12 > actions/PM_SUSPEND_PREPARE/error
+	# echo mem > /sys/power/state
+	bash: echo: write error: Cannot allocate memory
+
+Memory hotplug notifier error injection module
+----------------------------------------------
+This feature is controlled through debugfs interface
+/sys/kernel/debug/notifier-error-inject/memory/actions/<notifier event>/error
+
+Possible memory notifier events to be failed are:
+
+ * MEM_GOING_ONLINE
+ * MEM_GOING_OFFLINE
+
+Example: Inject memory hotplug offline error (-12 == -ENOMEM)
+
+	# cd /sys/kernel/debug/notifier-error-inject/memory
+	# echo -12 > actions/MEM_GOING_OFFLINE/error
+	# echo offline > /sys/devices/system/memory/memoryXXX/state
+	bash: echo: write error: Cannot allocate memory
+
+powerpc pSeries reconfig notifier error injection module
+--------------------------------------------------------
+This feature is controlled through debugfs interface
+/sys/kernel/debug/notifier-error-inject/pSeries-reconfig/actions/<notifier event>/error
+
+Possible pSeries reconfig notifier events to be failed are:
+
+ * PSERIES_RECONFIG_ADD
+ * PSERIES_RECONFIG_REMOVE
+ * PSERIES_DRCONF_MEM_ADD
+ * PSERIES_DRCONF_MEM_REMOVE
+
+For more usage examples
+-----------------------
+There are tools/testing/selftests using the notifier error injection features
+for CPU and memory notifiers.
+
+ * tools/testing/selftests/cpu-hotplug/on-off-test.sh
+ * tools/testing/selftests/memory-hotplug/on-off-test.sh
+
+These scripts first do simple online and offline tests and then do fault
+injection tests if notifier error injection module is available.
-- 
1.7.10.4

