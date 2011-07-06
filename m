Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab1GFMKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 08:10:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38199 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab1GFMKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 08:10:18 -0400
Message-ID: <4E145061.3050009@mvista.com>
Date: Wed, 06 Jul 2011 16:09:05 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Vitaly Kuzmichev <vkuzmichev@mvista.com>
CC: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>, Wim Van Sebroeck <wim@iguana.be>,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
        arm@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V2 5/6] mpcore_wdt: Add cpufreq notifier to reload counter
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com> <1309892440-3260-6-git-send-email-vkuzmichev@mvista.com>
In-Reply-To: <1309892440-3260-6-git-send-email-vkuzmichev@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05-07-2011 23:00, Vitaly Kuzmichev wrote:

> In the case if CPU frequency is changed when watchdog is working it begins to
> acount faster or slower. To avoid watchdog triggering before the margin time
> the watchdog counter needs to be reloaded.

> Signed-off-by: Vitaly Kuzmichev<vkuzmichev@mvista.com>
> ---
>   drivers/watchdog/mpcore_wdt.c |   31 ++++++++++++++++++++++++++++++-
>   1 files changed, 30 insertions(+), 1 deletions(-)

> diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
> index 11c70df..38b9119 100644
> --- a/drivers/watchdog/mpcore_wdt.c
> +++ b/drivers/watchdog/mpcore_wdt.c
[...]
> @@ -426,6 +427,25 @@ static int __devexit mpcore_wdt_remove(struct platform_device *dev)
>   	return 0;
>   }
>
> +static int mpcore_wdt_notify(struct notifier_block *nb,
> +				unsigned long state, void *data)
> +{
> +	struct mpcore_wdt *wdt = platform_get_drvdata(mpcore_wdt_dev);

    Need empty line here...

> +	/*
> +	 * The mpcore_wdt counter register must be reloaded to account
> +	 * properly with the new frequency.
> +	 */
> +	if (mpcore_wdt_dev&&  wdt&&  (state == CPUFREQ_POSTCHANGE ||
> +					state == CPUFREQ_RESUMECHANGE))
> +		mpcore_wdt_keepalive(wdt);
> +
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block mpcore_wdt_nb = {
> +	.notifier_call = mpcore_wdt_notify,
> +};
> +
>   /* work with hotplug and coldplug */
>   MODULE_ALIAS("platform:mpcore_wdt");
>
> @@ -444,6 +464,7 @@ static char banner[] __initdata = KERN_INFO "MPcore Watchdog Timer: 0.1. "
>
>   static int __init mpcore_wdt_init(void)
>   {
> +	int ret = 0;

    ... and here.

>   	/*
>   	 * Check that the margin value is within it's range;
>   	 * if not reset to the default

WBR, Sergei
