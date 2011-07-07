Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab1GGVOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 17:14:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36679 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab1GGVOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 17:14:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 5/7] PM: PM notifier error injection
Date: Thu, 7 Jul 2011 23:14:58 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org
References: <1309702581-16863-1-git-send-email-akinobu.mita@gmail.com> <1309702581-16863-6-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1309702581-16863-6-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201107072314.59052.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 03, 2011, Akinobu Mita wrote:
> This provides the ability to inject artifical errors to PM notifier
> chain callbacks.  It is controlled through debugfs interface under
> /sys/kernel/debug/pm-notifier-error-inject/
> 
> Each of the files in the directory represents an event which can be
> failed and contains the error code.  If the notifier call chain should
> be failed with some events notified, write the error code to the files.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: linux-pm@lists.linux-foundation.org
> ---
>  kernel/power/main.c |   30 ++++++++++++++++++++++++++++++
>  lib/Kconfig.debug   |    8 ++++++++
>  2 files changed, 38 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/power/main.c b/kernel/power/main.c
> index 6c601f8..04b3774 100644
> --- a/kernel/power/main.c
> +++ b/kernel/power/main.c
> @@ -42,6 +42,36 @@ int pm_notifier_call_chain(unsigned long val)
>  	return notifier_to_errno(ret);
>  }
>  
> +#ifdef CONFIG_PM_NOTIFIER_ERROR_INJECTION
> +
> +static struct err_inject_notifier_block err_inject_pm_notifier = {
> +	.actions = {
> +		{ ERR_INJECT_NOTIFIER_ACTION(PM_HIBERNATION_PREPARE) },
> +		{ ERR_INJECT_NOTIFIER_ACTION(PM_SUSPEND_PREPARE) },
> +		{ ERR_INJECT_NOTIFIER_ACTION(PM_RESTORE_PREPARE) },
> +		{}

Why have you omitted the PM_POST_* actions?

> +	}
> +};
> +
> +static int __init err_inject_pm_notifier_init(void)
> +{
> +	int err;
> +
> +	err = err_inject_notifier_block_init(&err_inject_pm_notifier,
> +				"pm-notifier-error-inject", -1);
> +	if (err)
> +		return err;
> +
> +	err = register_pm_notifier(&err_inject_pm_notifier.nb);
> +	if (err)
> +		err_inject_notifier_block_cleanup(&err_inject_pm_notifier);
> +
> +	return err;
> +}
> +late_initcall(err_inject_pm_notifier_init);
> +
> +#endif /* CONFIG_PM_NOTIFIER_ERROR_INJECTION */
> +
>  /* If set, devices may be suspended and resumed asynchronously. */
>  int pm_async_enabled = 1;
>  
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index d944b32..3ffb38b 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1043,6 +1043,14 @@ config CPU_NOTIFIER_ERROR_INJECTION
>  	  # echo 0 > /sys/devices/system/cpu/cpu1/online
>  	  bash: echo: write error: Operation not permitted
>  
> +config PM_NOTIFIER_ERROR_INJECTION
> +	bool "PM notifier error injection"
> +	depends on PM_DEBUG && NOTIFIER_ERROR_INJECTION
> +	help
> +	  This option provides the ability to inject artifical errors to
> +	  PM notifier chain callbacks.  It is controlled through debugfs
> +	  interface under /sys/kernel/debug/pm-notifier-error-inject/

I'm not sure the help is necessary.  I think it should be selected
automatically if both PM_DEBUG and NOTIFIER_ERROR_INJECTION are set.

> +
>  config CPU_NOTIFIER_ERROR_INJECT
>  	tristate "CPU notifier error injection module"
>  	depends on HOTPLUG_CPU && DEBUG_KERNEL

Thanks,
Rafael

