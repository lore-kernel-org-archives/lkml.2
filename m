Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab1BWVmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:42:03 -0500
Received: from smtp-out.google.com ([216.239.44.51]:32271 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab1BWVmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:42:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=O92svcrpy6AoQVKdtn+T1DbPCFQMlMsLzV27VZIi0k3wEyx5dIMxO4iefdG42bYisN
         l1hobCfAqD2zJ0rXe4fQ==
Message-ID: <4D657F24.2000402@google.com>
Date: Wed, 23 Feb 2011 13:41:56 -0800
From: Mike Waychison <mikew@google.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] [PATCH 3/10] Generic Watchdog Timer Driver
References: <20110223204253.GA7385@infomag.iguana.be>
In-Reply-To: <20110223204253.GA7385@infomag.iguana.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/11 12:42, Wim Van Sebroeck wrote:
> commit 87af8029a114af16d696047167d482624a1c9334
> Author: Wim Van Sebroeck<wim@iguana.be>
> Date:   Fri Jun 18 09:03:14 2010 +0000
>
>      watchdog: WatchDog Timer Driver Core - Part 3
>
>      This part add's the WDIOC_KEEPALIVE ioctl functionality to the
>      WatchDog Timer Driver Core framework. Please note that the
>      WDIOF_KEEPALIVEPING bit has to be set in the watchdog_info
>      options field.
>
>      Signed-off-by: Alan Cox<alan@lxorguk.ukuu.org.uk>
>      Signed-off-by: Wim Van Sebroeck<wim@iguana.be>
>
> diff --git a/Documentation/watchdog/src/watchdog-with-timer-example.c b/Documentation/watchdog/src/watchdog-with-timer-example.c
> index ed7852a..d64cac6 100644
> --- a/Documentation/watchdog/src/watchdog-with-timer-example.c
> +++ b/Documentation/watchdog/src/watchdog-with-timer-example.c
> @@ -117,6 +117,7 @@ static int wdt_stop(struct watchdog_device *wdd)
>    */
>   static const struct watchdog_info wdt_info = {
>   	.identity =	DRV_NAME,
> +	.options =	WDIOF_KEEPALIVEPING,
>   };
>
>   static const struct watchdog_ops wdt_ops = {
> diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
> index 9418d4c..4a68e5e 100644
> --- a/Documentation/watchdog/watchdog-kernel-api.txt
> +++ b/Documentation/watchdog/watchdog-kernel-api.txt
> @@ -96,6 +96,9 @@ they are supported. These optional routines/operations are:
>     the watchdog timer driver core does: to send a keepalive ping to the watchdog
>     timer hardware it will either use the ping operation (when available) or the
>     start operation (when the ping operation is not available).
> +  (Note: the WDIOC_KEEPALIVE ioctl call will only be active when the
> +  WDIOF_KEEPALIVEPING bit has been set in the option field on the watchdog's
> +  info structure).
>   * status: this routine checks the status of the watchdog timer device. The
>     status of the device is reported with watchdog WDIOF_* status flags/bits.
>
> diff --git a/drivers/watchdog/core/watchdog_dev.c b/drivers/watchdog/core/watchdog_dev.c
> index ad08a93..0d2ed1d 100644
> --- a/drivers/watchdog/core/watchdog_dev.c
> +++ b/drivers/watchdog/core/watchdog_dev.c
> @@ -151,6 +151,11 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
>   		return put_user(val, p);
>   	case WDIOC_GETBOOTSTATUS:
>   		return put_user(wdd->bootstatus, p);
> +	case WDIOC_KEEPALIVE:
> +		if (!(wdd->info->options&  WDIOF_MAGICCLOSE))

Is this meant to be WDIOF_KEEPALIVEPING ?


> +			return -EOPNOTSUPP;
> +		watchdog_ping(wdd);
> +		return 0;
>   	default:
>   		return -ENOTTY;
>   	}
> diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
> index 4d00bf8..a41dca3 100644
> --- a/include/linux/watchdog.h
> +++ b/include/linux/watchdog.h
> @@ -69,12 +69,15 @@ struct watchdog_ops {
>   	int (*stop)(struct watchdog_device *);
>   	/* optional operations */
>   	int (*ping)(struct watchdog_device *);
> +	int (*status)(struct watchdog_device *);
>   };
>
>   /* The structure that defines a watchdog device */
>   struct watchdog_device {
>   	char *name;
> +	const struct watchdog_info *info;
>   	const struct watchdog_ops *ops;
> +	int bootstatus;
>   	long status;
>   #define WDOG_DEV_OPEN		1	/* is the watchdog opened via
>   					 * /dev/watchdog */

