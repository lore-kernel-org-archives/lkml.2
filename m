Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab2JQDZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 23:25:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:52431 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690Ab2JQDZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 23:25:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,597,1344236400"; 
   d="scan'208";a="206962664"
Message-ID: <507D7D08.7010903@intel.com>
Date: Tue, 16 Oct 2012 23:28:08 +0800
From: zhanglong <longzhax@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, yanmin_zhang@linux.intel.com,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Subject: [PATCH v2] drivers-core: move the calling to device_pm_remove behind
 the calling to bus_remove_device
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We hit an hang issue when removing a mmc device on Medfield Android phone by sysfs interface.

device_pm_remove will call pm_runtime_remove which would disable
runtime PM of the device. After that pm_runtime_get* or
pm_runtime_put* will be ignored. So if we disable the runtime PM
before device really be removed, drivers' _remove callback may
access HW even pm_runtime_get* fails. That is bad.

Consider below call sequence when removing a device:
device_del => device_pm_remove
             => class_intf->remove_dev(dev, class_intf)  => pm_runtime_get_sync/put_sync
             => bus_remove_device => device_release_driver => pm_runtime_get_sync/put_sync

remove_dev might call pm_runtime_get_sync/put_sync.
Then, generic device_release_driver also calls pm_runtime_get_sync/put_sync.
Since device_del => device_pm_remove firstly, later _get_sync wouldn't really wake up the device. 

I git log -p to find the patch which moves the calling to device_pm_remove ahead.
It's below patch:

commit  775b64d2b6ca37697de925f70799c710aab5849a
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Jan 12 20:40:46 2008 +0100

     PM: Acquire device locks on suspend

     This patch reorganizes the way suspend and resume notifications are
     sent to drivers.  The major changes are that now the PM core acquires
     every device semaphore before calling the methods, and calls to
     device_add() during suspends will fail, while calls to device_del()
     during suspends will block.

     It also provides a way to safely remove a suspended device with the
     help of the PM core, by using the device_pm_schedule_removal() callback
     introduced specifically for this purpose, and updates two drivers (msr
     and cpuid) that need to use it. 


As device_pm_schedule_removal is deleted by another patch, we need also revert other parts of the patch,
i.e. move the calling of device_pm_remove after the calling to bus_remove_device.

Signed-off-by: LongX Zhang <longx.zhang@intel.com>
---
 drivers/base/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index abea76c..150a415 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1180,7 +1180,6 @@ void device_del(struct device *dev)
        if (dev->bus)
                blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
                                             BUS_NOTIFY_DEL_DEVICE, dev);
-       device_pm_remove(dev);
        dpm_sysfs_remove(dev);
        if (parent)
                klist_del(&dev->p->knode_parent);
@@ -1205,6 +1204,7 @@ void device_del(struct device *dev)
        device_remove_file(dev, &uevent_attr);
        device_remove_attrs(dev);
        bus_remove_device(dev);
+       device_pm_remove(dev);
        driver_deferred_probe_del(dev);

        /* Notify the platform of the removal, in case they
-- 
1.7.10
