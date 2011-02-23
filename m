Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab1BWV7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:59:17 -0500
Received: from smtp-out.google.com ([216.239.44.51]:45563 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226Ab1BWV7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:59:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SoB17vni4kwP3xGENQpNMLBIL7DkSk52XasX313DcZPqfGAEy7WUD5nv28kUaomCKX
         zpsLs9nkE0qnZu2fhwOQ==
Message-ID: <4D65832C.9020203@google.com>
Date: Wed, 23 Feb 2011 13:59:08 -0800
From: Mike Waychison <mikew@google.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] [PATCH 5/10] Generic Watchdog Timer Driver
References: <20110223204330.GA7417@infomag.iguana.be>
In-Reply-To: <20110223204330.GA7417@infomag.iguana.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/11 12:43, Wim Van Sebroeck wrote:
> commit 1959ea403c69af855f5cd13e5c9b33123d2137b2
> Author: Wim Van Sebroeck<wim@iguana.be>
> Date:   Fri Jun 18 09:45:49 2010 +0000
>
>      watchdog: WatchDog Timer Driver Core - Part 5
>
>      This part add's the WDIOC_SETTIMEOUT and WDIOC_GETTIMEOUT ioctl
>      functionality to the WatchDog Timer Driver Core framework.
>
>      Signed-off-by: Alan Cox<alan@lxorguk.ukuu.org.uk>
>      Signed-off-by: Wim Van Sebroeck<wim@iguana.be>
>
> diff --git a/Documentation/watchdog/src/watchdog-with-timer-example.c b/Documentation/watchdog/src/watchdog-with-timer-example.c
> index 6a4af47..f1d4f217 100644
> --- a/Documentation/watchdog/src/watchdog-with-timer-example.c
> +++ b/Documentation/watchdog/src/watchdog-with-timer-example.c
> @@ -110,18 +110,27 @@ static int wdt_stop(struct watchdog_device *wdd)
>   	return 0;
>   }
>
> +static int wdt_set_timeout(struct watchdog_device *wdd, int new_timeout)
> +{
> +	if (new_timeout<  1)
> +		return -EINVAL;
> +	return 0;
> +}
> +
>   /*
>    * The watchdog kernel structures
>    */
>   static const struct watchdog_info wdt_info = {
>   	.identity =	DRV_NAME,
> -	.options =	WDIOF_KEEPALIVEPING,
> +	.options =	WDIOF_SETTIMEOUT |
> +			WDIOF_KEEPALIVEPING,
>   };
>
>   static const struct watchdog_ops wdt_ops = {
>   	.start =	wdt_start,
>   	.stop =		wdt_stop,
>   	.ping =		wdt_ping,
> +	.set_timeout =	wdt_set_timeout,
>   };
>
>   static struct watchdog_device wdt_dev = {
> @@ -139,6 +148,9 @@ static int __devinit wdt_probe(struct platform_device *pdev)
>
>   	/* Register other stuff */
>
> +	/* Set watchdog_device parameters */
> +	wdt_dev.timeout = timeout;
> +
>   	/* Register the watchdog timer device */
>   	res = register_watchdogdevice(&wdt_dev);
>   	if (res) {
> diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
> index 3de69e7..f15e8d4 100644
> --- a/Documentation/watchdog/watchdog-kernel-api.txt
> +++ b/Documentation/watchdog/watchdog-kernel-api.txt
> @@ -42,6 +42,7 @@ struct watchdog_device {
>   	char *name;
>   	const struct watchdog_info *info;
>   	const struct watchdog_ops *ops;
> +	int timeout;
>   	int bootstatus;
>   	long status;
>   };
> @@ -51,6 +52,7 @@ It contains following fields:
>   * info: a pointer to a watchdog_info structure. This structure gives some
>     additional information about the watchdog timer itself.
>   * ops: a pointer to the list of watchdog operations that the watchdog supports.
> +* timeout: the watchdog timer's timeout value (in seconds).
>   * bootstatus: status of the device after booting (reported with watchdog
>     WDIOF_* status bits).
>   * status: this field contains a number of status bits that give extra
> @@ -67,6 +69,7 @@ struct watchdog_ops {
>   	/* optional operations */
>   	int (*ping)(struct watchdog_device *);
>   	int (*status)(struct watchdog_device *);
> +	int (*set_timeout)(struct watchdog_device *, int);
>   };
>
>   Some operations are mandatory and some are optional. The mandatory operations
> @@ -102,6 +105,12 @@ they are supported. These optional routines/operations are:
>     info structure).
>   * status: this routine checks the status of the watchdog timer device. The
>     status of the device is reported with watchdog WDIOF_* status flags/bits.
> +* set_timeout: this routine checks and changes the timeout of the watchdog
> +  timer device. It returns 0 on success and an errno code on failure. On success
> +  the timeout value of the watchdog_device will be changed to the value that
> +  was just used to re-program the watchdog timer device.
> +  (Note: the WDIOF_SETTIMEOUT needs to be set in the options field of the
> +  watchdog's info structure).
>
>   The status bits should (preferably) be set with the set_bit and clear_bit alike
>   bit-operations. The status bit's that are defined are:
> diff --git a/drivers/watchdog/core/watchdog_dev.c b/drivers/watchdog/core/watchdog_dev.c
> index 2bf4f67..b80c6e6 100644
> --- a/drivers/watchdog/core/watchdog_dev.c
> +++ b/drivers/watchdog/core/watchdog_dev.c
> @@ -221,6 +221,26 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
>   			return -EOPNOTSUPP;
>   		watchdog_ping(wdd);
>   		return 0;
> +	case WDIOC_SETTIMEOUT:
> +		if ((wdd->ops->set_timeout == NULL) ||
> +		    !(wdd->info->options&  WDIOF_SETTIMEOUT))
> +			return -EOPNOTSUPP;
> +		if (get_user(val, p))
> +			return -EFAULT;

Should we sanity check that val > 0 here?  I realize that the driver 
would need to do it's own sanity checking, but a value of 0 or < 0 makes 
no sense to the core itself.

Maybe timeout is best expressed as u32 if this is the case.

> +		err = wdd->ops->set_timeout(wdd, val);
> +		if (err<  0)
> +			return err;
> +		wdd->timeout = val;
> +		/* If the watchdog is active then we sent a keepalive ping
> +		 * to make sure that the watchdog keep's running (and if
> +		 * possible that it takes the new timeout) */
> +		watchdog_ping(wdd);
> +		/* Fall */
> +	case WDIOC_GETTIMEOUT:
> +		/* timeout == 0 means that we don't know the timeout */
> +		if (wdd->timeout)
> +			return put_user(wdd->timeout, p);
> +		return -EOPNOTSUPP;
>   	default:
>   		return -ENOTTY;
>   	}
> diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
> index 736814f..e35f51f 100644
> --- a/include/linux/watchdog.h
> +++ b/include/linux/watchdog.h
> @@ -70,6 +70,7 @@ struct watchdog_ops {
>   	/* optional operations */
>   	int (*ping)(struct watchdog_device *);
>   	int (*status)(struct watchdog_device *);
> +	int (*set_timeout)(struct watchdog_device *, int);
>   };
>
>   /* The structure that defines a watchdog device */
> @@ -78,6 +79,7 @@ struct watchdog_device {
>   	const struct watchdog_info *info;
>   	const struct watchdog_ops *ops;
>   	int bootstatus;
> +	int timeout;
>   	long status;
>   #define WDOG_ACTIVE		0	/* is the watchdog running/active */
>   #define WDOG_DEV_OPEN		1	/* is the watchdog opened via

