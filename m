Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab0IOHer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 03:34:47 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:53720 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab0IOHeq convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Wed, 15 Sep 2010 03:34:46 -0400
Message-Id: <4C90935D020000780001630D@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 15 Sep 2010 08:35:25 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Fenghua Yu" <fenghua.yu@intel.com>
Cc: "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/hwmon: avoid deadlock on CPU removal in
	 pkgtemp
References: <4C8E14D90200007800015AAE@vpn.id2.novell.com>
 <20100915001259.GA1237@fenghua-desk.sc.intel.com>
In-Reply-To: <20100915001259.GA1237@fenghua-desk.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 15.09.10 at 02:13, Fenghua Yu <fenghua.yu@intel.com> wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> When a sibling is added to dev_list after a cpu is hot-removed, 
> pdev_list_mutex
> has been locked already. But pkgtemp_device_add() tries to lock 
> pdev_list_mutex
> again. This is incorrect. The patch fixes this issue.
> 
> The patch also removes __cpuinit for pkgtemp_device_add() to avoid section
> mismatch warning.

But that the wrong direction of a change - __cpuinit should be added
to pkgtemp_device_remove() instead.

> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  drivers/hwmon/pkgtemp.c |   18 +++++++++++++-----
>  1 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/hwmon/pkgtemp.c b/drivers/hwmon/pkgtemp.c
> index 74157fc..928a016 100644
> --- a/drivers/hwmon/pkgtemp.c
> +++ b/drivers/hwmon/pkgtemp.c
> @@ -276,7 +276,7 @@ struct pdev_entry {
>  static LIST_HEAD(pdev_list);
>  static DEFINE_MUTEX(pdev_list_mutex);
>  
> -static int __cpuinit pkgtemp_device_add(unsigned int cpu)
> +static int pkgtemp_device_add(unsigned int cpu)
>  {
>  	int err;
>  	struct platform_device *pdev;
> @@ -341,26 +341,34 @@ static void pkgtemp_device_remove(unsigned int cpu)
>  {
>  	struct pdev_entry *p, *n;
>  	unsigned int i;
> -	int err;
>  
> -	mutex_lock(&pdev_list_mutex);
>  	list_for_each_entry_safe(p, n, &pdev_list, list) {
>  		if (p->cpu != cpu)
>  			continue;
>  
> +		mutex_lock(&pdev_list_mutex);
>  		platform_device_unregister(p->pdev);
>  		list_del(&p->list);
>  		kfree(p);
> +		mutex_unlock(&pdev_list_mutex);

While probably not very important, it's nevertheless unclear why you
need to do the kfree() with the mutex held.

Jan

> +		/*
> +		 * Select one of removed cpu's siblings to represent sensor
> +		 * for this package.
> +		 * If there is no more running sibling in a package, the
> +		 * package sensor for this package is not available to user
> +		 * space any more.
> +		 */
>  		for_each_cpu(i, cpu_core_mask(cpu)) {
> +			int err;
> +
>  			if (i != cpu) {
>  				err = pkgtemp_device_add(i);
>  				if (!err)
>  					break;
>  			}
>  		}
> -		break;
> +		return;
>  	}
> -	mutex_unlock(&pdev_list_mutex);
>  }
>  
>  static int __cpuinit pkgtemp_cpu_callback(struct notifier_block *nfb,


