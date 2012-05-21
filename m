Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409Ab2EUWBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 18:01:32 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:57245 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab2EUWBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 18:01:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Drake <dsd@laptop.org>
Subject: Re: [PATCH] firmware_class: improve suspend handling
Date: Tue, 22 May 2012 00:06:31 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20120518222148.E80C09D401E@zog.reactivated.net>
In-Reply-To: <20120518222148.E80C09D401E@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201205220006.31481.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 19, 2012, Daniel Drake wrote:
> libertas kicks off asynchronous firmware loading from its probe routine.
> The probe routine is run on every system resume, because we choose to
> (cleanly) shut down the device during suspend.
> 
> As the libertas suspend routine can be called before the asynchronous
> firmware loading has completed (i.e. when the system is suspended very soon
> after probe), the libertas suspend routine must wait for any ongoing
> firmware loads to complete before suspending the device (which would
> involve sending some commands to it under normal circumstances - so the
> firmware must be running first).
> 
> This is proving problematic. Testing by suspending the system very soon
> after system resume, i.e.:
> 	echo mem > /sys/power/state; echo mem > /sys/power/state
> 
> The first problematic case is that userspace is busy loading the firmware
> when the suspend kicks in. Userspace gets frozen, no more firmware data
> arrives at the kernel, so we hit a long timeout before the system
> eventually suspends.
> 
> This patch adds a pm_notifier to the firmware loader to detect this case
> and immediately abort any in-progress firmware loads.
> 
> The second problematic case is that the asynchronous firmware loading
> work item gets scheduled and executed after userspace has frozen,
> but before kernel tasks have been frozen. This results in the kernel
> trying to ask a frozen userspace for a firmware file, invoking another
> long timeout before the system eventually suspends.
> 
> This patch uses the pm_notifier to track when userspace is frozen and
> immediately aborts any attempted firmware loads while userspace is frozen.

If I remember correctly, we used to have an equivalent of this, but it
didn't work.  The reason is that there are situations in which
request_firmware_nowait() shouldn't be aborted even if system suspend is
in progress (or more generally user space is frozen).

By definition, request_firmware_nowait() should not interfere with the
suspend process, because it is asynchronous with respect to it, but
if the driver actually waits for it to complete, it should simply use
request_firmware() instead.

Thanks,
Rafael


> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  drivers/base/firmware_class.c |   54 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 54 insertions(+)
> 
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 72c644b..cc6679d 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -20,6 +20,7 @@
>  #include <linux/highmem.h>
>  #include <linux/firmware.h>
>  #include <linux/slab.h>
> +#include <linux/suspend.h>
>  
>  #define to_dev(obj) container_of(obj, struct device, kobj)
>  
> @@ -90,6 +91,9 @@ static inline long firmware_loading_timeout(void)
>   * guarding for corner cases a global lock should be OK */
>  static DEFINE_MUTEX(fw_lock);
>  
> +/* Is userspace frozen? */
> +static bool is_suspended;
> +
>  struct firmware_priv {
>  	struct completion completion;
>  	struct firmware *fw;
> @@ -186,6 +190,45 @@ static struct class firmware_class = {
>  	.dev_release	= fw_dev_release,
>  };
>  
> +static int cancel_active_request(struct device *dev, void *data)
> +{
> +	struct firmware_priv *fw_priv = to_firmware_priv(dev);
> +	dev_dbg(dev, "Cancelling firmware load of %s due to suspend",
> +		fw_priv->fw_id);
> +	fw_load_abort(fw_priv);
> +	return 0;
> +}
> +
> +static int fw_pm_notify(struct notifier_block *notifier, unsigned long action,
> +			void *ptr)
> +{
> +	switch (action) {
> +	case PM_SUSPEND_PREPARE:
> +		/*
> +		 * When going into suspend, abort all active firmware loads
> +		 * from userspace. Userspace will now be frozen and would
> +		 * hence be unable to continue loading the firmware.
> +		 */
> +		mutex_lock(&fw_lock);
> +		is_suspended = true;
> +		class_for_each_device(&firmware_class, NULL, NULL,
> +				      cancel_active_request);
> +		mutex_unlock(&fw_lock);
> +		break;
> +
> +	case PM_POST_SUSPEND:
> +		mutex_lock(&fw_lock);
> +		is_suspended = false;
> +		mutex_unlock(&fw_lock);
> +		break;
> +	}
> +	return 0;
> +}
> +
> +static struct notifier_block fw_pm_notifier = {
> +	.notifier_call = fw_pm_notify,
> +};
> +
>  static ssize_t firmware_loading_show(struct device *dev,
>  				     struct device_attribute *attr, char *buf)
>  {
> @@ -535,6 +578,15 @@ static int _request_firmware_prepare(const struct firmware **firmware_p,
>  		return 0;
>  	}
>  
> +	mutex_lock(&fw_lock);
> +	if (is_suspended) {
> +		dev_dbg(device, "firmware: not loading %s, we're suspending\n",
> +			name);
> +		mutex_unlock(&fw_lock);
> +		return -ENODATA;
> +	}
> +	mutex_unlock(&fw_lock);
> +
>  	return 1;
>  }
>  
> @@ -738,11 +790,13 @@ request_firmware_nowait(
>  
>  static int __init firmware_class_init(void)
>  {
> +	register_pm_notifier(&fw_pm_notifier);
>  	return class_register(&firmware_class);
>  }
>  
>  static void __exit firmware_class_exit(void)
>  {
> +	unregister_pm_notifier(&fw_pm_notifier);
>  	class_unregister(&firmware_class);
>  }
>  
> 

