Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329Ab0GVLSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:18:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:12860 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759260Ab0GVLSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:18:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,242,1278313200"; 
   d="scan'208";a="640712589"
Subject: [RFC][PATCH v1 15/15] perf: export tracepoint events via sysfs:
 mac80211
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>
Cc: Robert Richter <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "eranian@gmail.com" <eranian@gmail.com>,
        "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
        Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 19:18:16 +0800
Message-ID: <1279797496.20942.98.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mac80211 tracepoint events are exported like below,

/sys/class/ieee80211/events/
|-- api_beacon_loss
|   |-- config
|   |-- type
....
....
|-- drv_add_interface
|   |-- config
|   |-- type
....
....
|-- stop_queue
|   |-- config
|   |-- type
|-- wake_queue
|   |-- config
|   |-- type
---
 drivers/base/class.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 8e231d0..57ada53 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -19,6 +19,7 @@
 #include <linux/slab.h>
 #include <linux/genhd.h>
 #include <linux/mutex.h>
+#include <linux/perf_event.h>
 #include "base.h"
 
 #define to_class_attr(_attr) container_of(_attr, struct class_attribute, attr)
@@ -160,6 +161,14 @@ static void klist_class_dev_put(struct klist_node *n)
 	put_device(dev);
 }
 
+extern struct class ieee80211_class;
+
+static void class_sys_add_tp(struct kobject *class_kobj, struct class *cls)
+{
+	if (cls == &ieee80211_class)
+		perf_sys_add_tp(class_kobj, "mac80211");
+}
+
 int __class_register(struct class *cls, struct lock_class_key *key)
 {
 	struct class_private *cp;
@@ -202,6 +211,9 @@ int __class_register(struct class *cls, struct lock_class_key *key)
 	}
 	error = add_class_attrs(class_get(cls));
 	class_put(cls);
+
+	class_sys_add_tp(&cp->class_subsys.kobj, cls);
+
 	return error;
 }
 EXPORT_SYMBOL_GPL(__class_register);



