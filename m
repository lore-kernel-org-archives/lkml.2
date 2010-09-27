Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859Ab0I0HLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 03:11:04 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:44004 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab0I0HLB convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Mon, 27 Sep 2010 03:11:01 -0400
Message-Id: <4CA05FA10200007800018F8B@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 27 Sep 2010 08:10:57 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Chen Gong" <gong.chen@linux.intel.com>, <lm-sensors@lm-sensors.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] hwmon: uniform the init style of pkgtemp
References: <1285480800-14558-1-git-send-email-gong.chen@linux.intel.com>
 <1285480800-14558-2-git-send-email-gong.chen@linux.intel.com>
In-Reply-To: <1285480800-14558-2-git-send-email-gong.chen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 26.09.10 at 07:59, Chen Gong <gong.chen@linux.intel.com> wrote:
> pkgtemp is derived from coretemp, so some reasonable
> logics should be applied onto pkgtemp, too. Such as
> the init logic here.
> 
> Signed-off-by: Chen Gong <gong.chen@linux.intel.com>

Acked-by: Jan Beulich <jbeulich@novell.com>

> ---
>  drivers/hwmon/pkgtemp.c |   23 +++++++----------------
>  1 files changed, 7 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/hwmon/pkgtemp.c b/drivers/hwmon/pkgtemp.c
> index f119039..6186041 100644
> --- a/drivers/hwmon/pkgtemp.c
> +++ b/drivers/hwmon/pkgtemp.c
> @@ -392,7 +392,6 @@ static struct notifier_block pkgtemp_cpu_notifier 
> __refdata = {
>  static int __init pkgtemp_init(void)
>  {
>  	int i, err = -ENODEV;
> -	struct pdev_entry *p, *n;
>  
>  	/* quick check if we run Intel */
>  	if (cpu_data(0).x86_vendor != X86_VENDOR_INTEL)
> @@ -402,31 +401,23 @@ static int __init pkgtemp_init(void)
>  	if (err)
>  		goto exit;
>  
> -	for_each_online_cpu(i) {
> -		err = pkgtemp_device_add(i);
> -		if (err)
> -			goto exit_devices_unreg;
> -	}
> +	for_each_online_cpu(i)
> +		pkgtemp_device_add(i);
> +
> +#ifndef CONFIG_HOTPLUG_CPU
>  	if (list_empty(&pdev_list)) {
>  		err = -ENODEV;
>  		goto exit_driver_unreg;
>  	}
> +#endif
>  
> -#ifdef CONFIG_HOTPLUG_CPU
>  	register_hotcpu_notifier(&pkgtemp_cpu_notifier);
> -#endif
>  	return 0;
>  
> -exit_devices_unreg:
> -	mutex_lock(&pdev_list_mutex);
> -	list_for_each_entry_safe(p, n, &pdev_list, list) {
> -		platform_device_unregister(p->pdev);
> -		list_del(&p->list);
> -		kfree(p);
> -	}
> -	mutex_unlock(&pdev_list_mutex);
> +#ifndef CONFIG_HOTPLUG_CPU
>  exit_driver_unreg:
>  	platform_driver_unregister(&pkgtemp_driver);
> +#endif
>  exit:
>  	return err;
>  }




