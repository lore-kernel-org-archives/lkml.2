Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab1HJQc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 12:32:58 -0400
Received: from smtp-out.google.com ([74.125.121.67]:47205 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab1HJQcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 12:32:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:user-agent:x-system-of-record;
	b=nrHGiUDl8oF1r0TAEl3Ad1W65ZjUOcdG4D/Fo5DY8tTVi9Xlhx6l3qLTIso/obLLK
	1w+zvUSLVVoGTIEyDo4Xw==
Date: Wed, 10 Aug 2011 09:31:42 -0700
From: Todd Poynor <toddpoynor@google.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        khilman@ti.com, b-cousson@ti.com, paul@pwsan.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Subject: Re: [PATCH 5/5 v4] mfd: omap: usb: Runtime PM support
Message-ID: <20110810163142.GA10156@google.com>
References: <1312899309-24067-1-git-send-email-keshava_mgowda@ti.com>
 <1312899309-24067-2-git-send-email-keshava_mgowda@ti.com>
 <1312899309-24067-3-git-send-email-keshava_mgowda@ti.com>
 <1312899309-24067-4-git-send-email-keshava_mgowda@ti.com>
 <1312899309-24067-5-git-send-email-keshava_mgowda@ti.com>
 <1312899309-24067-6-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312899309-24067-6-git-send-email-keshava_mgowda@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 07:45:09PM +0530, Keshava Munegowda wrote:
> From: Keshava Munegowda <Keshava_mgowda@ti.com>
> 
> The usbhs core driver does not enable/disable the intefrace and


typo: interface

> fucntional clocks; These clocks are handled by hwmod and runtime pm,


typo: functional

> hence insted of the clock enable/disable, the runtime pm APIS are
> used. however,the port clocks are handled by the usbhs core.
> 
> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>

...
> @@ -913,12 +598,15 @@ static int usbhs_enable(struct device *dev)
>  				(pdata->ehci_data->reset_gpio_port[1], 1);
>  	}
>  
> -end_count:
> -	omap->count++;
> +	pm_runtime_put_sync(dev);
>  	spin_unlock_irqrestore(&omap->lock, flags);

Is pm_runtime_irq_safe() needed (else I think runtime PM callbacks may
re-enable IRQs... or there's the new *_suspend runtime PM calls that
may avoid this)?

...
> @@ -266,10 +261,12 @@ static int ehci_hcd_omap_remove(struct platform_device *pdev)
>  	struct usb_hcd *hcd	= dev_get_drvdata(dev);
>  
>  	usb_remove_hcd(hcd);
> -	omap_usbhs_disable(dev);
>  	disable_put_regulator(dev->platform_data);
> -	iounmap(hcd->regs);
>  	usb_put_hcd(hcd);
> +	iounmap(hcd->regs);


usb_put_hcd may release the hcd, needs to be after the deref for
iounmap.

> +	pm_runtime_put_sync(dev);
> +	pm_runtime_disable(dev);


Todd
