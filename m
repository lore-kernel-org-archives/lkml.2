Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab1I0WHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 18:07:11 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:41786 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751871Ab1I0WHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 18:07:09 -0400
Message-ID: <4E82490B.2040805@xenotime.net>
Date: Tue, 27 Sep 2011 15:07:07 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: linux-next: Tree for Sept 27 (power/qos.c)
References: <20110927173530.ceae2e49537a81da65287bf3@canb.auug.org.au> <4E81FA1E.3060702@xenotime.net> <201109272205.12021.rjw@sisk.pl>
In-Reply-To: <201109272205.12021.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2011 01:05 PM, Rafael J. Wysocki wrote:
> On Tuesday, September 27, 2011, Randy Dunlap wrote:
>> On 09/27/2011 12:35 AM, Stephen Rothwell wrote:
>>> Hi all,
>>
>>
>> When CONFIG_PM_SLEEP is not enabled:
>>
>> drivers/base/power/qos.c:231:29: error: 'struct dev_pm_info' has no member named 'entry'
> 
> Thanks for the report.
> 
> Below is a patch and it should be fixed in linux-next now.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> Rafael
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / QoS: Fix build issue for CONFIG_PM_SLEEP unset
> 
> Commit d41a041b58684710638cbc0d5342a661b50db124 "PM / QoS: Add
> function dev_pm_qos_read_value() (v2)" introduced a build problem
> for CONFIG_PM_SLEEP, because it overlooked this case entirely.
> 
> To fix this issue, use the power.power_state in struct device to
> indicate whether or not PM QoS constraints can be applied to the
> device object in question instead of checking the device's
> power.entry field that is valid only for CONFIG_PM_SLEEP set.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/power/main.c  |    2 +-
>  drivers/base/power/power.h |   10 +++++++++-
>  drivers/base/power/qos.c   |   11 ++++-------
>  include/linux/pm.h         |    2 ++
>  include/linux/pm_qos.h     |    9 +++++++--
>  5 files changed, 23 insertions(+), 11 deletions(-)
> 
> Index: linux/drivers/base/power/main.c
> ===================================================================
> --- linux.orig/drivers/base/power/main.c
> +++ linux/drivers/base/power/main.c
> @@ -22,7 +22,6 @@
>  #include <linux/mutex.h>
>  #include <linux/pm.h>
>  #include <linux/pm_runtime.h>
> -#include <linux/pm_qos.h>
>  #include <linux/resume-trace.h>
>  #include <linux/interrupt.h>
>  #include <linux/sched.h>
> @@ -67,6 +66,7 @@ void device_pm_init(struct device *dev)
>  	spin_lock_init(&dev->power.lock);
>  	pm_runtime_init(dev);
>  	INIT_LIST_HEAD(&dev->power.entry);
> +	dev->power.power_state = PMSG_INVALID;
>  }
>  
>  /**
> Index: linux/include/linux/pm.h
> ===================================================================
> --- linux.orig/include/linux/pm.h
> +++ linux/include/linux/pm.h
> @@ -326,6 +326,7 @@ extern struct dev_pm_ops generic_subsys_
>   *			requested by a driver.
>   */
>  
> +#define PM_EVENT_INVALID	(-1)
>  #define PM_EVENT_ON		0x0000
>  #define PM_EVENT_FREEZE 	0x0001
>  #define PM_EVENT_SUSPEND	0x0002
> @@ -346,6 +347,7 @@ extern struct dev_pm_ops generic_subsys_
>  #define PM_EVENT_AUTO_SUSPEND	(PM_EVENT_AUTO | PM_EVENT_SUSPEND)
>  #define PM_EVENT_AUTO_RESUME	(PM_EVENT_AUTO | PM_EVENT_RESUME)
>  
> +#define PMSG_INVALID	((struct pm_message){ .event = PM_EVENT_INVALID, })
>  #define PMSG_ON		((struct pm_message){ .event = PM_EVENT_ON, })
>  #define PMSG_FREEZE	((struct pm_message){ .event = PM_EVENT_FREEZE, })
>  #define PMSG_QUIESCE	((struct pm_message){ .event = PM_EVENT_QUIESCE, })
> Index: linux/drivers/base/power/power.h
> ===================================================================
> --- linux.orig/drivers/base/power/power.h
> +++ linux/drivers/base/power/power.h
> @@ -1,3 +1,5 @@
> +#include <linux/pm_qos.h>
> +
>  #ifdef CONFIG_PM_RUNTIME
>  
>  extern void pm_runtime_init(struct device *dev);
> @@ -35,15 +37,21 @@ extern void device_pm_move_last(struct d
>  static inline void device_pm_init(struct device *dev)
>  {
>  	spin_lock_init(&dev->power.lock);
> +	dev->power.power_state = PMSG_INVALID;
>  	pm_runtime_init(dev);
>  }
>  
> +static inline void device_pm_add(struct device *dev)
> +{
> +	dev_pm_qos_constraints_init(dev);
> +}
> +
>  static inline void device_pm_remove(struct device *dev)
>  {
> +	dev_pm_qos_constraints_destroy(dev);
>  	pm_runtime_remove(dev);
>  }
>  
> -static inline void device_pm_add(struct device *dev) {}
>  static inline void device_pm_move_before(struct device *deva,
>  					 struct device *devb) {}
>  static inline void device_pm_move_after(struct device *deva,
> Index: linux/include/linux/pm_qos.h
> ===================================================================
> --- linux.orig/include/linux/pm_qos.h
> +++ linux/include/linux/pm_qos.h
> @@ -7,6 +7,7 @@
>  #include <linux/plist.h>
>  #include <linux/notifier.h>
>  #include <linux/miscdevice.h>
> +#include <linux/device.h>
>  
>  #define PM_QOS_RESERVED 0
>  #define PM_QOS_CPU_DMA_LATENCY 1
> @@ -142,9 +143,13 @@ static inline int dev_pm_qos_remove_glob
>  					struct notifier_block *notifier)
>  			{ return 0; }
>  static inline void dev_pm_qos_constraints_init(struct device *dev)
> -			{ return; }
> +{
> +	dev->power.power_state = PMSG_ON;
> +}
>  static inline void dev_pm_qos_constraints_destroy(struct device *dev)
> -			{ return; }
> +{
> +	dev->power.power_state = PMSG_INVALID;
> +}
>  #endif
>  
>  #endif
> Index: linux/drivers/base/power/qos.c
> ===================================================================
> --- linux.orig/drivers/base/power/qos.c
> +++ linux/drivers/base/power/qos.c
> @@ -149,6 +149,7 @@ void dev_pm_qos_constraints_init(struct
>  {
>  	mutex_lock(&dev_pm_qos_mtx);
>  	dev->power.constraints = NULL;
> +	dev->power.power_state = PMSG_ON;
>  	mutex_unlock(&dev_pm_qos_mtx);
>  }
>  
> @@ -165,6 +166,7 @@ void dev_pm_qos_constraints_destroy(stru
>  
>  	mutex_lock(&dev_pm_qos_mtx);
>  
> +	dev->power.power_state = PMSG_INVALID;
>  	c = dev->power.constraints;
>  	if (!c)
>  		goto out;
> @@ -222,20 +224,15 @@ int dev_pm_qos_add_request(struct device
>  
>  	req->dev = dev;
>  
> -	device_pm_lock();
>  	mutex_lock(&dev_pm_qos_mtx);
>  
> -	if (dev->power.constraints) {
> -		device_pm_unlock();
> -	} else {
> -		if (list_empty(&dev->power.entry)) {
> +	if (!dev->power.constraints) {
> +		if (dev->power.power_state.event == PM_EVENT_INVALID) {
>  			/* The device has been removed from the system. */
> -			device_pm_unlock();
>  			req->dev = NULL;
>  			ret = -ENODEV;
>  			goto out;
>  		} else {
> -			device_pm_unlock();
>  			/*
>  			 * Allocate the constraints data on the first call to
>  			 * add_request, i.e. only if the data is not already
> --


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
