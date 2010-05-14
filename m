Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab0ENRZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 13:25:58 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:39523 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344Ab0ENRZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 13:25:56 -0400
Message-id: <4BED878F.9010905@acm.org>
Date: Fri, 14 May 2010 12:25:35 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-version: 1.0
To: Tomas Henzl <thenzl@redhat.com>, "'akpm@osdl.org'" <akpm@osdl.org>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       mjg@redhat.com, openipmi-developer@lists.sourceforge.net
Subject: Re: [PATCH] ipm: fix mutex use
References: <4BED80C5.7030503@redhat.com>
In-reply-to: <4BED80C5.7030503@redhat.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, you are correct, we need this patch.

Acked-by: Corey Minyard <cminyard@mvista.com>

Thanks.

Tomas Henzl wrote:
> It looks like there is an unbalance with the mutexes after the latest 
> IPMI patchset applied. For example in 
> "static __devinit int init_ipmi_si(void)"
> ....
> 	list_for_each_entry(e, &smi_infos, link) {
> 		if (!e->irq && (!type || e->addr_source == type)) {
> 			if (!try_smi_init(e)) {
> 				type = e->addr_source;
> 			}
> 		}
> 	}
> 	mutex_unlock(&smi_infos_lock);
>
> we are calling mutex_unlock twice, because the mutex_unlock(&smi_infos_lock)
> is also called from try_smi_init.
>
> If the lock in try_smi_init is not needed this can be then solved
> by removing the mutex_unlock(&smi_infos_lock) from try_smi_init.
>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
>
> ---
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
> index 8d7b879..c6af8e0 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -3060,8 +3060,6 @@ static int try_smi_init(struct smi_info *new_smi)
>  		goto out_err_stop_timer;
>  	}
>  
> -	mutex_unlock(&smi_infos_lock);
> -
>  	printk(KERN_INFO "IPMI %s interface initialized\n",
>  	       si_to_str[new_smi->si_type]);
>  
> @@ -3111,8 +3109,6 @@ static int try_smi_init(struct smi_info *new_smi)
>  		new_smi->dev_registered = 0;
>  	}
>  
> -	mutex_unlock(&smi_infos_lock);
> -
>  	return rv;
>  }
>  
>
>
>   

