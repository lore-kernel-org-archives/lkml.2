Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab2F0I6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 04:58:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:22329 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab2F0I6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 04:58:11 -0400
X-IronPort-AV: E=Sophos;i="4.77,483,1336320000"; 
   d="scan'208";a="5273749"
Message-ID: <4FEACA5E.4090009@cn.fujitsu.com>
Date: Wed, 27 Jun 2012 16:54:54 +0800
From: Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com
CC: ebiederm@xmission.com, luto@mit.edu, Joerg Roedel <joerg.roedel@amd.com>,
        dzickus@redhat.com, paul.gortmaker@windriver.com,
        ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH v3 4/5] Sysfs: Export VMCSINFO via sysfs
References: <4FEAC945.50700@cn.fujitsu.com>
In-Reply-To: <4FEAC945.50700@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/27 16:58:19,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/27 16:58:22,
	Serialize complete at 2012/06/27 16:58:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch export offsets of fields via /sys/devices/cpu/vmcs/.
Individual offsets are contained in subfiles named by the filed's
encoding, e.g.: /sys/devices/cpu/vmcs/0800

Signed-off-by: zhangyanfei <zhangyanfei@cn.fujitsu.com>
---
 drivers/base/core.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 346be8b..dd05ee7 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -26,6 +26,7 @@
 #include <linux/async.h>
 #include <linux/pm_runtime.h>
 #include <linux/netdevice.h>
+#include <asm/vmcsinfo.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -1038,6 +1039,11 @@ int device_add(struct device *dev)
 	error = dpm_sysfs_add(dev);
 	if (error)
 		goto DPMError;
+#if defined(CONFIG_KVM_INTEL) || defined(CONFIG_KVM_INTEL_MODULE)
+	error = vmcs_sysfs_add(dev);
+	if (error)
+		goto VMCSError;
+#endif
 	device_pm_add(dev);
 
 	/* Notify clients of device addition.  This call must come
@@ -1069,6 +1075,10 @@ int device_add(struct device *dev)
 done:
 	put_device(dev);
 	return error;
+#if defined(CONFIG_KVM_INTEL) || defined(CONFIG_KVM_INTEL_MODULE)
+ VMCSError:
+	dpm_sysfs_remove(dev);
+#endif
  DPMError:
 	bus_remove_device(dev);
  BusError:
@@ -1171,6 +1181,9 @@ void device_del(struct device *dev)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_DEL_DEVICE, dev);
 	device_pm_remove(dev);
+#if defined(CONFIG_KVM_INTEL) || defined(CONFIG_KVM_INTEL_MODULE)
+	vmcs_sysfs_remove(dev);
+#endif
 	dpm_sysfs_remove(dev);
 	if (parent)
 		klist_del(&dev->p->knode_parent);
-- 
1.7.1

