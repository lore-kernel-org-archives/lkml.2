Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631Ab0GOPov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 11:44:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:63298 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933621Ab0GOPos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:44:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,209,1278313200"; 
   d="scan'208";a="818452733"
Message-ID: <4C3F2CEF.2090404@linux.intel.com>
Date: Thu, 15 Jul 2010 08:44:47 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Arjan van de Ven <arjan@infradead.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ming Lei <tom.leiming@gmail.com>
Subject: Re: Re: [PATCH v2] pm: Add runtime PM statistics
References: <20100710095254.5ab7291c@infradead.org> <201007112326.07541.rjw@sisk.pl> <20100711221646.35f11b70@infradead.org> <201007132328.28853.rjw@sisk.pl>
In-Reply-To: <201007132328.28853.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:59 AM, Rafael J. Wysocki wrote:
> On Monday, July 12, 2010, Arjan van de Ven wrote:
>    
>> On Sun, 11 Jul 2010 23:26:07 +0200
>> "Rafael J. Wysocki"<rjw@sisk.pl>  wrote:
>>
>>      
>>>> +
>>>>   static DEVICE_ATTR(runtime_usage, 0444, rtpm_usagecount_show,
>>>> NULL); static DEVICE_ATTR(runtime_active_kids, 0444,
>>>> rtpm_children_show, NULL); static DEVICE_ATTR(runtime_status, 0444,
>>>> rtpm_status_show, NULL); +static DEVICE_ATTR(runtime_active_time,
>>>> 0444, rtpm_active_time_show, NULL); +static
>>>> DEVICE_ATTR(runtime_suspended_time, 0444, rtpm_suspended_time_show,
>>>> NULL); static DEVICE_ATTR(runtime_enabled, 0444, rtpm_enabled_show,
>>>> NULL);
>>>>          
>>> On a second thought, "active_time" and "suspended_time" should be
>>> sufficient (ie. the "runtime_" prefix is not really necessary).
>>>        
>> it's not necessary but it's consistent with the others... so yes
>> I can change it but then it's no longer consistent naming.. are you sure
>> you want this changed?
>>      
> No, you're right, sorry.
>
> But can you rebase your patch on top of linux-next, please, and move the
> definitions of the new attributes next to 'control' and 'runtime_status' (so
> that they don't depend on 'debug')?
>
> Rafael
>    
From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH v3] pm: Add runtime PM statistics

In order for PowerTOP to be able to report how well the new runtime PM is
working for the various drivers, the kernel needs to export some basic
statistics in sysfs.

This patch adds two sysfs files in the runtime PM domain that expose the
total time a device has been active, and the time a device has been
suspended.

With this PowerTOP can compute the activity percentage

Active %age = 100 * (delta active) / (delta active + delta suspended)

and present the information to the user.

I've written the PowerTOP code (slated for version 1.12) already, and the
output looks like this:

Runtime Device Power Management statistics
Active  Device name
  10.0%    06:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL8101E/RTL8102E PCI Express Fast Ethernet controller


[version 2: fix stat update bugs noticed by Alan Stern]
[version 3: rebase to -next and move the sysfs declaration]

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index b0ec0e9..b78c401 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -123,6 +123,45 @@ int pm_runtime_idle(struct device *dev)
  }
  EXPORT_SYMBOL_GPL(pm_runtime_idle);

+
+/**
+ * update_pm_runtime_accounting - Update the time accounting of power 
states
+ * @dev: Device to update the accounting for
+ *
+ * In order to be able to have time accounting of the various power states
+ * (as used by programs such as PowerTOP to show the effectiveness of 
runtime
+ * PM), we need to track the time spent in each state.
+ * update_pm_runtime_accounting must be called each time before the
+ * runtime_status field is updated, to account the time in the old state
+ * correctly.
+ */
+void update_pm_runtime_accounting(struct device *dev)
+{
+    unsigned long now = jiffies;
+    int delta;
+
+    delta = now - dev->power.accounting_timestamp;
+
+    if (delta < 0)
+        delta = 0;
+
+    dev->power.accounting_timestamp = now;
+
+    if (dev->power.disable_depth > 0)
+        return;
+
+    if (dev->power.runtime_status == RPM_SUSPENDED)
+        dev->power.suspended_jiffies += delta;
+    else
+        dev->power.active_jiffies += delta;
+}
+
+static void __update_runtime_status(struct device *dev, enum rpm_status 
status)
+{
+    update_pm_runtime_accounting(dev);
+    dev->power.runtime_status = status;
+}
+
  /**
   * __pm_runtime_suspend - Carry out run-time suspend of given device.
   * @dev: Device to suspend.
@@ -197,7 +236,7 @@ int __pm_runtime_suspend(struct device *dev, bool 
from_wq)
          goto repeat;
      }

-    dev->power.runtime_status = RPM_SUSPENDING;
+    __update_runtime_status(dev, RPM_SUSPENDING);
      dev->power.deferred_resume = false;

      if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_suspend) {
@@ -228,7 +267,7 @@ int __pm_runtime_suspend(struct device *dev, bool 
from_wq)
      }

      if (retval) {
-        dev->power.runtime_status = RPM_ACTIVE;
+        __update_runtime_status(dev, RPM_ACTIVE);
          if (retval == -EAGAIN || retval == -EBUSY) {
              if (dev->power.timer_expires == 0)
                  notify = true;
@@ -237,7 +276,7 @@ int __pm_runtime_suspend(struct device *dev, bool 
from_wq)
              pm_runtime_cancel_pending(dev);
          }
      } else {
-        dev->power.runtime_status = RPM_SUSPENDED;
+        __update_runtime_status(dev, RPM_SUSPENDED);
          pm_runtime_deactivate_timer(dev);

          if (dev->parent) {
@@ -381,7 +420,7 @@ int __pm_runtime_resume(struct device *dev, bool 
from_wq)
          goto repeat;
      }

-    dev->power.runtime_status = RPM_RESUMING;
+    __update_runtime_status(dev, RPM_RESUMING);

      if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_resume) {
          spin_unlock_irq(&dev->power.lock);
@@ -411,10 +450,10 @@ int __pm_runtime_resume(struct device *dev, bool 
from_wq)
      }

      if (retval) {
-        dev->power.runtime_status = RPM_SUSPENDED;
+        __update_runtime_status(dev, RPM_SUSPENDED);
          pm_runtime_cancel_pending(dev);
      } else {
-        dev->power.runtime_status = RPM_ACTIVE;
+        __update_runtime_status(dev, RPM_ACTIVE);
          if (parent)
              atomic_inc(&parent->power.child_count);
      }
@@ -848,7 +887,7 @@ int __pm_runtime_set_status(struct device *dev, 
unsigned int status)
      }

   out_set:
-    dev->power.runtime_status = status;
+    __update_runtime_status(dev, status);
      dev->power.runtime_error = 0;
   out:
      spin_unlock_irqrestore(&dev->power.lock, flags);
@@ -1077,6 +1116,7 @@ void pm_runtime_init(struct device *dev)
      dev->power.request_pending = false;
      dev->power.request = RPM_REQ_NONE;
      dev->power.deferred_resume = false;
+    dev->power.accounting_timestamp = jiffies;
      INIT_WORK(&dev->power.work, pm_runtime_work);

      dev->power.timer_expires = 0;
diff --git a/drivers/base/power/sysfs.c b/drivers/base/power/sysfs.c
index 1eca50c..e56b438 100644
--- a/drivers/base/power/sysfs.c
+++ b/drivers/base/power/sysfs.c
@@ -6,6 +6,7 @@
  #include <linux/string.h>
  #include <linux/pm_runtime.h>
  #include <asm/atomic.h>
+#include <linux/jiffies.h>
  #include "power.h"

  /*
@@ -111,6 +112,33 @@ static ssize_t control_store(struct device * dev, 
struct device_attribute *attr,

  static DEVICE_ATTR(control, 0644, control_show, control_store);

+static ssize_t rtpm_active_time_show(struct device *dev,
+                struct device_attribute *attr, char *buf)
+{
+    int ret;
+    spin_lock_irq(&dev->power.lock);
+    update_pm_runtime_accounting(dev);
+    ret = sprintf(buf, "%i\n", 
jiffies_to_msecs(dev->power.active_jiffies));
+    spin_unlock_irq(&dev->power.lock);
+    return ret;
+}
+
+static DEVICE_ATTR(runtime_active_time, 0444, rtpm_active_time_show, NULL);
+
+static ssize_t rtpm_suspended_time_show(struct device *dev,
+                struct device_attribute *attr, char *buf)
+{
+    int ret;
+    spin_lock_irq(&dev->power.lock);
+    update_pm_runtime_accounting(dev);
+    ret = sprintf(buf, "%i\n",
+        jiffies_to_msecs(dev->power.suspended_jiffies));
+    spin_unlock_irq(&dev->power.lock);
+    return ret;
+}
+
+static DEVICE_ATTR(runtime_suspended_time, 0444, 
rtpm_suspended_time_show, NULL);
+
  static ssize_t rtpm_status_show(struct device *dev,
                  struct device_attribute *attr, char *buf)
  {
@@ -254,6 +282,8 @@ static struct attribute * power_attrs[] = {
  #ifdef CONFIG_PM_RUNTIME
&dev_attr_control.attr,
&dev_attr_runtime_status.attr,
+ &dev_attr_runtime_suspended_time.attr,
+ &dev_attr_runtime_active_time.attr,
  #endif
&dev_attr_wakeup.attr,
  #ifdef CONFIG_PM_SLEEP
diff --git a/include/linux/pm.h b/include/linux/pm.h
index b417fc4..52e8c55 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -477,9 +477,15 @@ struct dev_pm_info {
      enum rpm_request    request;
      enum rpm_status        runtime_status;
      int            runtime_error;
+    unsigned long        active_jiffies;
+    unsigned long        suspended_jiffies;
+    unsigned long        accounting_timestamp;
  #endif
  };

+extern void update_pm_runtime_accounting(struct device *dev);
+
+
  /*
   * The PM_EVENT_ messages are also used by drivers implementing the legacy
   * suspend framework, based on the ->suspend() and ->resume() 
callbacks common

