Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab2EDIOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 04:14:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:6829 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab2EDINw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 04:13:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="138801422"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>, Zheng Yan <zheng.z.yan@intel.com>
Subject: [RFC v2 1/5] PM, Runtime, Add power_must_be_on flag
Date: Fri,  4 May 2012 16:13:37 +0800
Message-Id: <1336119221-21146-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336119221-21146-1-git-send-email-ying.huang@intel.com>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The extreme way to save device power in runtime is to turn off power
of device.  For example, D3cold for PCIe bus and ZPODD (Zero Power
Optical Disk Drive) for SATA bus will do that.

But sometimes power off is not expected, some possible reason is as
follow

- power off device usually incurs longer resume latency, if it exceeds
  power QoS requirement, power off should be disabled.

- For some buses, device in power off state can not support remote
  wakeup.  If remote wakeup is desired, power off should be disabled.

In general, whether to put a device into power off state should be
decided by the driver of the device, but for some buses, whether to
put a device into power off state may be done by the parent of the
device.  For example, a PCIe end point device may be put into power
off state by the PCIe port connected to it.

So a flag is introduced for the children devices to tell the parent
device, whether it should be put into power off state.

This flag is also used for device driver to tell bus layer whether it
is OK to be powered off.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 include/linux/pm.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -536,6 +536,7 @@ struct dev_pm_info {
 	unsigned int		irq_safe:1;
 	unsigned int		use_autosuspend:1;
 	unsigned int		timer_autosuspends:1;
+	unsigned int		power_must_be_on:1;
 	enum rpm_request	request;
 	enum rpm_status		runtime_status;
 	int			runtime_error;
