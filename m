Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459Ab1GKXCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 19:02:14 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:33518 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758227Ab1GKXCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 19:02:13 -0400
Message-ID: <4E1B8089.90103@metafoo.de>
Date: Tue, 12 Jul 2011 01:00:25 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110702 Icedove/3.0.11
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 01/11] watchdog: WatchDog Timer Driver Core - Add basic
 framework
References: <1310392522-9949-1-git-send-email-wim@iguana.be>
In-Reply-To: <1310392522-9949-1-git-send-email-wim@iguana.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2011 04:19 PM, Wim Van Sebroeck wrote:
> [...]
> +
> +
> +static int watchdog_release(struct inode *inode, struct file *file)
> +{
> +	int err;
> +
> +	/* stop the watchdog */
> +	err = wdd->ops->stop(wdd);
Does it really make sense to allow stop() to fail? Will this ever happen, and
if yes do we gain anything by sending a additional ping?

> +	if (err != 0) {
> +		pr_crit("%s: watchdog did not stop!\n", wdd->info->identity);
> +		watchdog_ping(wdd);
> +	}
> +
> +	/* Allow the owner module to be unloaded again */
> +	module_put(wdd->ops->owner);
> +
> +	/* make sure that /dev/watchdog can be re-opened */
> +	clear_bit(WDOG_DEV_OPEN, &wdd->status);
> +
> +	return 0;
> +}
> +
> [...]
> +
> +int watchdog_dev_unregister(struct watchdog_device *watchdog)
> +{
> +	/* Check that a watchdog device was registered in the past */
> +	if (!test_bit(0, &watchdog_dev_busy) || !wdd)
> +		return -ENODEV;
> +
> +	/* We can only unregister the watchdog device that was registered */
> +	if (watchdog != wdd) {
> +		pr_err("%s: watchdog was not registered as /dev/watchdog.\n",
> +			watchdog->info->identity);
> +		return -ENODEV;
> +	}
> +
> +	/* Unregister the miscdevice */
> +	misc_deregister(&watchdog_miscdev);
> +	wdd = NULL;
> +	clear_bit(0, &watchdog_dev_busy);
> +	return 0;
> +}

What happens if the watchdog gets unregistered if the device is still opened?
Even though if you'd check wdd for not being NULL in the file callbacks there
is still a chance for races if the devices is unregistered at the same time as
the callback is running. You'd either need a big lock to protect from having a
file callback and unregister running concurrently or add ref-counting to the
watchdog_device, the later best done by embedding a struct device and using the
device driver model.

> +
> +MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
> diff --git a/drivers/watchdog/watchdog_dev.h b/drivers/watchdog/watchdog_dev.h
> new file mode 100644
> index 0000000..bc7612b
> --- /dev/null
> +++ b/drivers/watchdog/watchdog_dev.h
> @@ -0,0 +1,33 @@
> [...]
>  
> +struct watchdog_ops;
> +struct watchdog_device;
> +
> +/* The watchdog-devices operations */
> +struct watchdog_ops {
> +	struct module *owner;
> +	/* mandatory operations */
> +	int (*start)(struct watchdog_device *);
> +	int (*stop)(struct watchdog_device *);
> +	/* optional operations */
> +	int (*ping)(struct watchdog_device *);
> +};
> +
> +/* The structure that defines a watchdog device */
> +struct watchdog_device {
> +	const struct watchdog_info *info;
> +	const struct watchdog_ops *ops;
> +	void *priv;

You should provide getter/setter methods for priv, so that when the watchdog
API is changed to make use of the device driver model it becomes easier to get
rid of the priv field and use dev_{get,set}_drvdata instead.

> +	unsigned long status;
> +/* Bit numbers for status flags */
> +#define WDOG_DEV_OPEN		1	/* Opened via /dev/watchdog ? */
> +};

Kernel-doc style documentation for the structs would be nice.

> +
> +/* drivers/watchdog/core/watchdog_core.c */
> +extern int watchdog_register_device(struct watchdog_device *);
> +extern void watchdog_unregister_device(struct watchdog_device *);
> +
>  #endif	/* __KERNEL__ */
>  
>  #endif  /* ifndef _LINUX_WATCHDOG_H */

