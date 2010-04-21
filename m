Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab0DUSKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 14:10:21 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:46560 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab0DUSKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 14:10:20 -0400
Message-id: <4BCF3F69.3050003@acm.org>
Date: Wed, 21 Apr 2010 13:09:45 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-version: 1.0
To: Matthew Garrett <mjg@redhat.com>
Cc: openipmi-developer@lists.sourceforge.net, bjorn.helgaas@hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ipmi: Only register one si per bmc
References: <1271788828-10231-1-git-send-email-mjg@redhat.com>
 <1271788828-10231-2-git-send-email-mjg@redhat.com>
In-reply-to: <1271788828-10231-2-git-send-email-mjg@redhat.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> Only register one si per bmc. Use any user-provided devices first, followed
> by the first device with an irq, followed by the first device discovered.
>   
If I understand this correctly, this would really be "Only register one 
si per system".  Unfortunately, there are systems that have more than 
one BMC each with their own interface.  Also, I believe the driver would 
not function between the previous patch and this patch, which isn't the 
best.

The spec is rather fuzzy about the whole subject of multiple BMCs and 
interfaces, but reality is that there are systems that will be broken 
with this.

-corey

> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/char/ipmi/ipmi_si_intf.c |   33 +++++++++++++++++++++++++++++++++
>  1 files changed, 33 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
> index d2bdf92..95af023 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -3258,6 +3258,7 @@ static __devinit int init_ipmi_si(void)
>  	int  i;
>  	char *str;
>  	int  rv;
> +	struct smi_info *e;
>  
>  	if (initialized)
>  		return 0;
> @@ -3292,6 +3293,14 @@ static __devinit int init_ipmi_si(void)
>  
>  	hardcode_find_bmc();
>  
> +	/* If the user gave us a device, they presumably want us to use it */
> +	mutex_lock(&smi_infos_lock);
> +	if (!list_empty(&smi_infos)) {
> +		mutex_unlock(&smi_infos_lock);
> +		return 0;
> +	}
> +	mutex_unlock(&smi_infos_lock);
> +
>  #ifdef CONFIG_DMI
>  	dmi_find_bmc();
>  #endif
> @@ -3315,6 +3324,30 @@ static __devinit int init_ipmi_si(void)
>  	of_register_platform_driver(&ipmi_of_platform_driver);
>  #endif
>  
> +	/* Try to register something with interrupts first */
> +
> +	mutex_lock(&smi_infos_lock);
> +	list_for_each_entry(e, &smi_infos, link) {
> +		if (e->irq) {
> +			if (!try_smi_init(e)) {
> +				mutex_unlock(&smi_infos_lock);
> +				return 0;
> +			}
> +		}
> +	}
> +
> +	/* Fall back to the preferred device */
> +
> +	list_for_each_entry(e, &smi_infos, link) {
> +		if (!e->irq) {
> +			if (!try_smi_init(e)) {
> +				mutex_unlock(&smi_infos_lock);
> +				return 0;
> +			}
> +		}
> +	}
> +	mutex_unlock(&smi_infos_lock);
> +
>  	if (si_trydefaults) {
>  		mutex_lock(&smi_infos_lock);
>  		if (list_empty(&smi_infos)) {
>   

