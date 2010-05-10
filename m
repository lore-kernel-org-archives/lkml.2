Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab0EJJ1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 05:27:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:43471 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195Ab0EJJ1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 05:27:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,361,1270450800"; 
   d="scan'208";a="796952168"
Subject: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 10 May 2010 17:27:03 +0800
Message-Id: <1273483623.15998.57.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export pmus via sysfs /sys/devices/system/cpu/pmus/0...N
The file name is the pmu id, ie, /sys/devices/system/cpu/pmus/N
represents pmu id N.
So perf tool can use it to initialize perf_event_attr. 

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 kernel/perf_event.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index f19d40e..003b632 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5744,6 +5744,52 @@ static int __init perf_event_sysfs_init(void)
 }
 device_initcall(perf_event_sysfs_init);
 
+#define PMU_ID_LEN 5
+static int __init perf_pmu_sysfs_init(void)
+{
+	struct kobject *pmu_kobj;
+	struct pmu *pmu;
+	struct bin_attribute *bin_attr;
+	char *pmu_id;
+	int err;
+	int i = 0;
+
+	pmu_kobj = kobject_create_and_add("pmus", &cpu_sysdev_class.kset.kobj);
+	if (!pmu_kobj) {
+		printk(KERN_WARNING "%s: kset create error\n", __func__);
+		return -ENOMEM;
+	}
+
+	list_for_each_entry(pmu, &pmus, entry) {
+		bin_attr = kzalloc(sizeof(*bin_attr), GFP_KERNEL);
+		pmu_id = kzalloc(PMU_ID_LEN, GFP_KERNEL);
+
+		if (!bin_attr || !pmu_id) {
+			if (bin_attr)
+				kfree(bin_attr);
+			if (pmu_id)
+				kfree(pmu_id);
+			return -ENOMEM;
+		}
+
+		sysfs_attr_init(&bin_attr.attr);
+		sprintf(pmu_id, "%d\n", i++);
+		bin_attr->size = 0;
+		bin_attr->attr.name = pmu_id;
+		bin_attr->attr.mode = 0444;
+
+		err = sysfs_create_bin_file(pmu_kobj, bin_attr);
+		if (err) {
+			kfree(bin_attr);
+			kfree(pmu_id);
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+device_initcall(perf_pmu_sysfs_init);
+
 void perf_event_register_pmu(struct pmu *pmu)
 {
 	pmu->id = pmu_id_curr++;


