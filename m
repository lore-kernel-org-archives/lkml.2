Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759228Ab0GVLNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:13:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:21557 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759288Ab0GVLND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:13:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,242,1278313200"; 
   d="scan'208";a="537789536"
Subject: [RFC][PATCH v1 05/15] perf: export tracepoint events via sysfs:
 i915
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Dave Airlie <airlied@redhat.com>
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
Date: Thu, 22 Jul 2010 19:13:18 +0800
Message-ID: <1279797198.20942.86.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i915 tracepoint events are exported like below,

/sys/devices/pci0000:00/0000:00:02.0/drm/card0/events
|-- i915_gem_object_bind
|   |-- config
|   |-- type
|-- i915_gem_object_change_domain
|   |-- config
|   |-- type
....
....
---
 drivers/gpu/drm/i915/i915_drv.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 423dc90..185b502 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -28,6 +28,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/perf_event.h>
 #include "drmP.h"
 #include "drm.h"
 #include "i915_drm.h"
@@ -413,7 +414,17 @@ int i965_reset(struct drm_device *dev, u8 flags)
 static int __devinit
 i915_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	return drm_get_dev(pdev, ent, &driver);
+	struct drm_device *drm_dev;
+	int ret;
+
+	ret = drm_get_dev(pdev, ent, &driver);
+
+	if (!ret) {
+		drm_dev = pci_get_drvdata(pdev);
+		perf_sys_add_tp(&drm_dev->primary->kdev.kobj, "i915");
+	}
+
+	return ret;
 }
 
 static void




