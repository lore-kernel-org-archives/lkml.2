Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab2JJDfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 23:35:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50978 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab2JJDfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 23:35:05 -0400
Date: Tue, 9 Oct 2012 20:35:03 -0700
From: mark gross <markgross@thegnar.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Huang Ying <ying.huang@intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        Jean Pihet <j-pihet@ti.com>, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] PM / Domains: Check device PM QoS flags in
 pm_genpd_poweroff()
Message-ID: <20121010033502.GD21067@MGROSS-X220VM>
Reply-To: markgross@thegnar.org
References: <201209282351.10663.rjw@sisk.pl>
 <1413438.1MkXj8vjQK@vostro.rjw.lan>
 <3595636.rclQsqiayj@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3595636.rclQsqiayj@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 10:08:39AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Make the generic PM domains pm_genpd_poweroff() function take
> device PM QoS flags into account when deciding whether or not to
> remove power from the domain.
> 
> After this change the routine will return -EBUSY without executing
> the domain's .power_off() callback if there is at least one PM QoS
> flags request for at least one device in the domain and at least of
> those request has at least one of the NO_POWER_OFF and REMOTE_WAKEUP
> flags set.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Reviewed-by: Jean Pihet <j-pihet@ti.com>
> ---
>  drivers/base/power/domain.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> Index: linux/drivers/base/power/domain.c
> ===================================================================
> --- linux.orig/drivers/base/power/domain.c
> +++ linux/drivers/base/power/domain.c
> @@ -470,10 +470,19 @@ static int pm_genpd_poweroff(struct gene
>  		return -EBUSY;
>  
>  	not_suspended = 0;
> -	list_for_each_entry(pdd, &genpd->dev_list, list_node)
> +	list_for_each_entry(pdd, &genpd->dev_list, list_node) {
> +		enum pm_qos_flags_status stat;
> +
> +		stat = dev_pm_qos_flags(pdd->dev,
> +					PM_QOS_FLAG_NO_POWER_OFF
> +						| PM_QOS_FLAG_REMOTE_WAKEUP);
> +		if (stat > PM_QOS_FLAGS_NONE)
> +			return -EBUSY;
> +
>  		if (pdd->dev->driver && (!pm_runtime_suspended(pdd->dev)
>  		    || pdd->dev->power.irq_safe))
>  			not_suspended++;
> +	}
>  
>  	if (not_suspended > genpd->in_progress)
>  		return -EBUSY;
>
looks ok to me.
Reviewed-by: mark gross <markgross@thegnar.org>

--mrak
