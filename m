Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab2F1J56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 05:57:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64024 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932519Ab2F1J54 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 05:57:56 -0400
X-IronPort-AV: E=Sophos;i="4.77,490,1336320000"; 
   d="scan'208";a="5284079"
Message-ID: <4FEC29D6.5020109@cn.fujitsu.com>
Date: Thu, 28 Jun 2012 17:54:30 +0800
From: Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com, ebiederm@xmission.com,
        luto@mit.edu, Joerg Roedel <joerg.roedel@amd.com>, dzickus@redhat.com,
        paul.gortmaker@windriver.com, ludwig.nussel@suse.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kexec@lists.infradead.org
Subject: Re: [PATCH v3 4/5] Sysfs: Export VMCSINFO via sysfs
References: <4FEAC945.50700@cn.fujitsu.com> <4FEACA5E.4090009@cn.fujitsu.com> <20120627192236.GB1965@kroah.com>
In-Reply-To: <20120627192236.GB1965@kroah.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/28 17:57:59,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/28 17:58:04
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年06月28日 03:22, Greg KH 写道:
> On Wed, Jun 27, 2012 at 04:54:54PM +0800, Yanfei Zhang wrote:
>> This patch export offsets of fields via /sys/devices/cpu/vmcs/.
>> Individual offsets are contained in subfiles named by the filed's
>> encoding, e.g.: /sys/devices/cpu/vmcs/0800
>>
>> Signed-off-by: zhangyanfei <zhangyanfei@cn.fujitsu.com>
>> ---
>>  drivers/base/core.c |   13 +++++++++++++
>>  1 files changed, 13 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>> index 346be8b..dd05ee7 100644
>> --- a/drivers/base/core.c
>> +++ b/drivers/base/core.c
>> @@ -26,6 +26,7 @@
>>  #include <linux/async.h>
>>  #include <linux/pm_runtime.h>
>>  #include <linux/netdevice.h>
>> +#include <asm/vmcsinfo.h>
> 
> Did you just break the build on all other arches?  Not nice.
> 
>> @@ -1038,6 +1039,11 @@ int device_add(struct device *dev)
>>  	error = dpm_sysfs_add(dev);
>>  	if (error)
>>  		goto DPMError;
>> +#if defined(CONFIG_KVM_INTEL) || defined(CONFIG_KVM_INTEL_MODULE)
>> +	error = vmcs_sysfs_add(dev);
>> +	if (error)
>> +		goto VMCSError;
>> +#endif
> 
> Oh my no, that's no way to ever do this, you know better than that,
> please fix.
> 
> greg k-h
> 

Sorry for my thoughtless, Here is the new patch.

---
 drivers/base/core.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 346be8b..7b5266a 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -30,6 +30,13 @@
 #include "base.h"
 #include "power/power.h"
 
+#if defined(CONFIG_KVM_INTEL) || defined(CONFIG_KVM_INTEL_MODULE)
+#include <asm/vmcsinfo.h>
+#else
+static inline int vmcs_sysfs_add(struct device *dev) { return 0; }
+static inline void vmcs_sysfs_remove(struct device *dev) { }
+#endif
+
 #ifdef CONFIG_SYSFS_DEPRECATED
 #ifdef CONFIG_SYSFS_DEPRECATED_V2
 long sysfs_deprecated = 1;
@@ -1038,6 +1045,9 @@ int device_add(struct device *dev)
 	error = dpm_sysfs_add(dev);
 	if (error)
 		goto DPMError;
+	error = vmcs_sysfs_add(dev);
+	if (error)
+		goto VMCSError;
 	device_pm_add(dev);
 
 	/* Notify clients of device addition.  This call must come
@@ -1069,6 +1079,8 @@ int device_add(struct device *dev)
 done:
 	put_device(dev);
 	return error;
+ VMCSError:
+	dpm_sysfs_remove(dev);
  DPMError:
 	bus_remove_device(dev);
  BusError:
@@ -1171,6 +1183,7 @@ void device_del(struct device *dev)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_DEL_DEVICE, dev);
 	device_pm_remove(dev);
+	vmcs_sysfs_remove(dev);
 	dpm_sysfs_remove(dev);
 	if (parent)
 		klist_del(&dev->p->knode_parent);
-- 
1.7.1

