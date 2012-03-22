Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab2CVA7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 20:59:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:21000 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab2CVA7r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 20:59:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="80182021"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
Thread-Topic: [PATCH] Fix the race between smp_call_function and CPU booting
Thread-Index: AQHNB125/xsoHqoXeU+Ih9PUlOlVxJZ1feJA
Date: Thu, 22 Mar 2012 00:59:40 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A05C092@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A053BE8@SHSMSX101.ccr.corp.intel.com>
	 <1331546307.18960.26.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A054D70@SHSMSX101.ccr.corp.intel.com>
	 <1331654251.18960.78.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A0556FA@SHSMSX101.ccr.corp.intel.com>
	 <1331718197.18960.106.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A056F47@SHSMSX101.ccr.corp.intel.com>
	 <1331808391.18960.160.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05806B@SHSMSX101.ccr.corp.intel.com>
	 <1331891364.18960.221.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A058AAE@SHSMSX101.ccr.corp.intel.com>
	 <1332151397.18960.252.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05A6BF@SHSMSX101.ccr.corp.intel.com>
	 <1332245842.18960.413.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05B485@SHSMSX101.ccr.corp.intel.com>
 <1332332739.18960.488.camel@twins>
In-Reply-To: <1332332739.18960.488.camel@twins>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the complete test patch. Just run the simpl_loop_onoffline.sh and simpl_loop_smpcalling.sh concurrently
to reproduce the race.

From: liu chuansheng <chuansheng.liu@intel.com>
Subject: [PATCH] Test scripts to verify the race between CPU booting and smp_call

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/misc/Makefile            |    1 +
 drivers/misc/smp_call_test.c     |   61 ++++++++++++++++++++++++++++++++++++++
 scripts/simpl_loop_onoffline.sh  |    5 +++
 scripts/simpl_loop_smpcalling.sh |    5 +++
 4 files changed, 72 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/smp_call_test.c
 create mode 100644 scripts/simpl_loop_onoffline.sh
 create mode 100644 scripts/simpl_loop_smpcalling.sh

diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 571ffd1..003f883 100755
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -59,3 +59,4 @@ obj-$(CONFIG_MID_I2S_DEV)     += mid_i2s_dev/
 obj-$(CONFIG_EMMC_IPANIC)      += emmc_ipanic.o
 obj-$(CONFIG_SCU_LOGGING)      += intel_fabric_logging.o
 obj-$(CONFIG_UUID)     += uuid.o
+obj-y                          += smp_call_test.o
diff --git a/drivers/misc/smp_call_test.c b/drivers/misc/smp_call_test.c
new file mode 100644
index 0000000..95a14fc
--- /dev/null
+++ b/drivers/misc/smp_call_test.c
@@ -0,0 +1,61 @@
+/*
+ * drivers/misc/smp_call_test.c
+ *
+ * Author: chuansheng.liu@intel.com
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/types.h>
+#include <linux/delay.h>
+#include <linux/sched.h>
+#include <linux/debugfs.h>
+#include <linux/fs.h>
+#include <linux/proc_fs.h>
+
+static int smp_call_dbg_get(void *data, u64 *val)
+{
+       return 0;
+}
+
+static void smp_call_func(void *info)
+{
+       return;
+}
+
+static int smp_call_dbg_set(void *data, u64 val)
+{
+       smp_call_function(smp_call_func, NULL, 1);
+       printk(KERN_ERR "test smp_call_function\n");
+       return 0;
+}
+
+
+DEFINE_SIMPLE_ATTRIBUTE(smp_call_dbg_fops, smp_call_dbg_get, smp_call_dbg_set, "%llu\n");
+
+
+int __init smp_call_test_init(void)
+{
+       debugfs_create_file("smp_call_test", 0644, NULL, NULL, &smp_call_dbg_fops);
+       return 0;
+}
+
+module_init(smp_call_test_init);
+
diff --git a/scripts/simpl_loop_onoffline.sh b/scripts/simpl_loop_onoffline.sh
new file mode 100644
index 0000000..c2c640d
--- /dev/null
+++ b/scripts/simpl_loop_onoffline.sh
@@ -0,0 +1,5 @@
+while true
+do
+ echo 0 > /sys/devices/system/cpu/cpu1/online
+ echo 1 > /sys/devices/system/cpu/cpu1/online
+done
diff --git a/scripts/simpl_loop_smpcalling.sh b/scripts/simpl_loop_smpcalling.sh
new file mode 100644
index 0000000..37cef74
--- /dev/null
+++ b/scripts/simpl_loop_smpcalling.sh
@@ -0,0 +1,5 @@
+while true
+do
+echo 1 > /sys/kernel/debug/smp_call_test
+usleep 500000
+done
-- 
1.7.0.4

> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Wednesday, March 21, 2012 8:26 PM
> To: Liu, Chuansheng
> Cc: linux-kernel@vger.kernel.org; Yanmin Zhang; tglx@linutronix.de
> Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
> 
> 
> Can you send me your exact kernel patch (the sysfs knob you use to trigger this)
> and test scripts?
