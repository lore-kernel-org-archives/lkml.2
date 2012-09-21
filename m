Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab2IUB7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 21:59:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:39275 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558Ab2IUB7R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 21:59:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,458,1344236400"; 
   d="scan'208";a="224705529"
From: "Zhang, LongX" <longx.zhang@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
CC: "rjw@sisk.pl" <rjw@sisk.pl>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>
Subject: Subject: [PATCH] drivers-core: move device_pm_remove behind
 bus_remove_device
Thread-Topic: Subject: [PATCH] drivers-core: move device_pm_remove behind
 bus_remove_device
Thread-Index: Ac2XnKU8M2BpbkxvRzeBJShuo8J8XA==
Date: Fri, 21 Sep 2012 01:58:51 +0000
Message-ID: <F7B8FD780A346D46A0042F5C63B06AE775B2B0@SHSMSX102.ccr.corp.intel.com>
Accept-Language: en-US
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

From: LongX Zhang <longx.zhang@intel.com>

device_pm_remove will call pm_runtime_remove which would disable
runtime PM of the device. After that pm_runtime_get* or
pm_runtime_put* will be ingored. So if we disable the runtime PM
before device really be removed, drivers' _remove callback may
access HW even pm_runtime_get* fails. That is bad.

Signed-off-by: LongX Zhang <longx.zhang@intel.com>
---
 drivers/base/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 5e6e00b..81ea7f2 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1169,7 +1169,6 @@ void device_del(struct device *dev)
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_DEL_DEVICE, dev);
-	device_pm_remove(dev);
 	dpm_sysfs_remove(dev);
 	if (parent)
 		klist_del(&dev->p->knode_parent);
@@ -1194,6 +1193,7 @@ void device_del(struct device *dev)
 	device_remove_file(dev, &uevent_attr);
 	device_remove_attrs(dev);
 	bus_remove_device(dev);
+	device_pm_remove(dev);
 	driver_deferred_probe_del(dev);
 
 	/*
-- 
1.7.10

