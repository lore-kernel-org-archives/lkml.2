Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab2A0SsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:48:20 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:24720 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab2A0SsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:48:19 -0500
Date: Fri, 27 Jan 2012 13:45:39 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] hvc_xen: implement multiconsole support
Message-ID: <20120127184538.GA18321@phenom.dumpdata.com>
References: <alpine.DEB.2.00.1201271823240.3196@kaball-desktop>
 <1327689097-12788-2-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327689097-12788-2-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F22F167.0050,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static void xencons_disconnect_backend(struct xencons_info *info)
> +{
> +	if (info->irq > 0)
> +		unbind_from_irqhandler(info->irq, NULL);
> +	info->irq = 0;
> +	if (info->evtchn > 0)
> +		xenbus_free_evtchn(info->xbdev, info->evtchn);
> +	info->evtchn = 0;
> +	if (info->gntref > 0)
> +		gnttab_free_grant_references(info->gntref);
> +	info->gntref = 0;
> +	if (info->hvc != NULL)
> +		hvc_remove(info->hvc);
> +	info->hvc = NULL;
> +}
> +
> +static void xencons_free(struct xencons_info *info)
> +{
> +	xencons_disconnect_backend(info);
> +	free_page((unsigned long)info->intf);
> +	info->intf = NULL;
> +	info->vtermno = 0;
> +	kfree(info);
> +}
> +
> +static int xencons_remove(struct xenbus_device *dev)
> +{
> +	struct xencons_info *info = dev_get_drvdata(&dev->dev);
> +

I would say put
	xencons_disconnect_backend(info)

here, that way it calls hvc_remove first, and then this would
delete an "not-called" anymore structure.

> +	spin_lock(&xencons_lock);
> +	list_del(&info->list);
> +	spin_unlock(&xencons_lock);
> +	xencons_free(info);

>  	return 0;
>  }
>

.. snip..
> +
> +static const struct xenbus_device_id xencons_ids[] = {
> +	{ "console" },
> +	{ "" }
> +};
> +
> +
>  static void __exit xen_hvc_fini(void)
>  {
> -	if (hvc)
> -		hvc_remove(hvc);
> +	struct xencons_info *entry, *next;
> +
> +	if (list_empty(&xenconsoles))
> +			return;
> +
> +	spin_lock(&xencons_lock);

Take that spin-lock out.

> +	list_for_each_entry_safe(entry, next, &xenconsoles, list) {
> +		list_del(&entry->list);
> +		if (entry->xbdev)
> +			xencons_remove(entry->xbdev);

This guy deletes itself from the list..
> +		else {
> +			if (entry->irq > 0)
> +				unbind_from_irqhandler(entry->irq, NULL);
> +			if (entry->hvc);
> +				hvc_remove(entry->hvc);
> +			kfree(entry);

..but this one does not.  You could make xencons_remove just remove
itself from the list and nothing else. Then rename it to 'xencons_remove_itself' perhaps?

After that, introduce a new function 'xencons_delete' that would call
xecons_disconnect_backend, xencons_remove_itself, and xencons_free?

> +		}
> +	}
> +	spin_unlock(&xencons_lock);
>  }
>  
>  static int xen_cons_init(void)
> @@ -256,18 +566,31 @@ static int xen_cons_init(void)
>  	if (xen_initial_domain())
>  		ops = &dom0_hvc_ops;
>  	else {
> +		int r;
>  		ops = &domU_hvc_ops;
>  
> -		if (xen_pv_domain())
> -			console_evtchn = xen_start_info->console.domU.evtchn;
> +		if (xen_hvm_domain())
> +			r = xen_hvm_console_init();
>  		else
> -			xen_hvm_console_init();
> +			r = xen_pv_console_init();
> +		if (r < 0)
> +			return r;
>  	}
>  
>  	hvc_instantiate(HVC_COOKIE, 0, ops);
>  	return 0;
>  }
>  
> +static struct xenbus_driver xencons_driver = {

This needs to be wrapped in the new macro that Jan prepared.
DEFINE_XENBUS_DRIVER (73db144b58a32fc39733db6a7e1fe582072ad26a)

> +	.name = "xenconsole",
> +	.owner = THIS_MODULE,
> +	.ids = xencons_ids,
> +	.probe = xencons_probe,
> +	.remove = xencons_remove,
> +	.resume = xencons_resume,
> +	.otherend_changed = xencons_backend_changed,
> +};
> +
>  module_init(xen_hvc_init);
>  module_exit(xen_hvc_fini);
>  console_initcall(xen_cons_init);
> -- 
> 1.7.2.5
