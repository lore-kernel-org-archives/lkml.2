Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031750Ab2COQd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:33:58 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28837 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030656Ab2COQdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:33:54 -0400
Date: Thu, 15 Mar 2012 12:29:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: linux-next: manual merge of the tty tree with the xen-two tree
Message-ID: <20120315162939.GE30250@phenom.dumpdata.com>
References: <20120315163740.c51aed0e3c10234fa3f37a46@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315163740.c51aed0e3c10234fa3f37a46@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090207.4F6219E7.0042,ss=1,re=3.899,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 04:37:40PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the tty tree got a conflict in
> drivers/tty/hvc/hvc_xen.c between commits 02e19f9c7cac ("hvc_xen:
> implement multiconsole support") and cf8e019b523a ("hvc_xen: introduce
> HVC_XEN_FRONTEND") from the xen-two tree and commit d4e33fac2408
> ("serial: Kill off NO_IRQ") from the tty tree.
> 
> The code was moved around.  I fixed it up (see below) and can carry the
> fix as necessary.

Please do. Thanks!

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/tty/hvc/hvc_xen.c
> index 83d5c88,a1b0a75..0000000
> --- a/drivers/tty/hvc/hvc_xen.c
> +++ b/drivers/tty/hvc/hvc_xen.c
> @@@ -299,262 -193,8 +299,262 @@@ static int xen_initial_domain_console_i
>   
>   void xen_console_resume(void)
>   {
>  -	if (xencons_irq)
>  -		rebind_evtchn_irq(xen_start_info->console.domU.evtchn, xencons_irq);
>  +	struct xencons_info *info = vtermno_to_xencons(HVC_COOKIE);
>  +	if (info != NULL && info->irq)
>  +		rebind_evtchn_irq(info->evtchn, info->irq);
>  +}
>  +
>  +static void xencons_disconnect_backend(struct xencons_info *info)
>  +{
>  +	if (info->irq > 0)
>  +		unbind_from_irqhandler(info->irq, NULL);
>  +	info->irq = 0;
>  +	if (info->evtchn > 0)
>  +		xenbus_free_evtchn(info->xbdev, info->evtchn);
>  +	info->evtchn = 0;
>  +	if (info->gntref > 0)
>  +		gnttab_free_grant_references(info->gntref);
>  +	info->gntref = 0;
>  +	if (info->hvc != NULL)
>  +		hvc_remove(info->hvc);
>  +	info->hvc = NULL;
>  +}
>  +
>  +static void xencons_free(struct xencons_info *info)
>  +{
>  +	free_page((unsigned long)info->intf);
>  +	info->intf = NULL;
>  +	info->vtermno = 0;
>  +	kfree(info);
>  +}
>  +
>  +static int xen_console_remove(struct xencons_info *info)
>  +{
>  +	xencons_disconnect_backend(info);
>  +	spin_lock(&xencons_lock);
>  +	list_del(&info->list);
>  +	spin_unlock(&xencons_lock);
>  +	if (info->xbdev != NULL)
>  +		xencons_free(info);
>  +	else {
>  +		if (xen_hvm_domain())
>  +			iounmap(info->intf);
>  +		kfree(info);
>  +	}
>  +	return 0;
>  +}
>  +
>  +#ifdef CONFIG_HVC_XEN_FRONTEND
>  +static struct xenbus_driver xencons_driver;
>  +
>  +static int xencons_remove(struct xenbus_device *dev)
>  +{
>  +	return xen_console_remove(dev_get_drvdata(&dev->dev));
>  +}
>  +
>  +static int xencons_connect_backend(struct xenbus_device *dev,
>  +				  struct xencons_info *info)
>  +{
>  +	int ret, evtchn, devid, ref, irq;
>  +	struct xenbus_transaction xbt;
>  +	grant_ref_t gref_head;
>  +	unsigned long mfn;
>  +
>  +	ret = xenbus_alloc_evtchn(dev, &evtchn);
>  +	if (ret)
>  +		return ret;
>  +	info->evtchn = evtchn;
>  +	irq = bind_evtchn_to_irq(evtchn);
>  +	if (irq < 0)
>  +		return irq;
>  +	info->irq = irq;
>  +	devid = dev->nodename[strlen(dev->nodename) - 1] - '0';
>  +	info->hvc = hvc_alloc(xenbus_devid_to_vtermno(devid),
>  +			irq, &domU_hvc_ops, 256);
>  +	if (IS_ERR(info->hvc))
>  +		return PTR_ERR(info->hvc);
>  +	if (xen_pv_domain())
>  +		mfn = virt_to_mfn(info->intf);
>  +	else
>  +		mfn = __pa(info->intf) >> PAGE_SHIFT;
>  +	ret = gnttab_alloc_grant_references(1, &gref_head);
>  +	if (ret < 0)
>  +		return ret;
>  +	info->gntref = gref_head;
>  +	ref = gnttab_claim_grant_reference(&gref_head);
>  +	if (ref < 0)
>  +		return ref;
>  +	gnttab_grant_foreign_access_ref(ref, info->xbdev->otherend_id,
>  +			mfn, 0);
>  +
>  + again:
>  +	ret = xenbus_transaction_start(&xbt);
>  +	if (ret) {
>  +		xenbus_dev_fatal(dev, ret, "starting transaction");
>  +		return ret;
>  +	}
>  +	ret = xenbus_printf(xbt, dev->nodename, "ring-ref", "%d", ref);
>  +	if (ret)
>  +		goto error_xenbus;
>  +	ret = xenbus_printf(xbt, dev->nodename, "port", "%u",
>  +			    evtchn);
>  +	if (ret)
>  +		goto error_xenbus;
>  +	ret = xenbus_printf(xbt, dev->nodename, "type", "ioemu");
>  +	if (ret)
>  +		goto error_xenbus;
>  +	ret = xenbus_transaction_end(xbt, 0);
>  +	if (ret) {
>  +		if (ret == -EAGAIN)
>  +			goto again;
>  +		xenbus_dev_fatal(dev, ret, "completing transaction");
>  +		return ret;
>  +	}
>  +
>  +	xenbus_switch_state(dev, XenbusStateInitialised);
>  +	return 0;
>  +
>  + error_xenbus:
>  +	xenbus_transaction_end(xbt, 1);
>  +	xenbus_dev_fatal(dev, ret, "writing xenstore");
>  +	return ret;
>  +}
>  +
>  +static int __devinit xencons_probe(struct xenbus_device *dev,
>  +				  const struct xenbus_device_id *id)
>  +{
>  +	int ret, devid;
>  +	struct xencons_info *info;
>  +
>  +	devid = dev->nodename[strlen(dev->nodename) - 1] - '0';
>  +	if (devid == 0)
>  +		return -ENODEV;
>  +
>  +	info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL | __GFP_ZERO);
>  +	if (!info)
>  +		goto error_nomem;
>  +	dev_set_drvdata(&dev->dev, info);
>  +	info->xbdev = dev;
>  +	info->vtermno = xenbus_devid_to_vtermno(devid);
>  +	info->intf = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
>  +	if (!info->intf)
>  +		goto error_nomem;
>  +
>  +	ret = xencons_connect_backend(dev, info);
>  +	if (ret < 0)
>  +		goto error;
>  +	spin_lock(&xencons_lock);
>  +	list_add_tail(&info->list, &xenconsoles);
>  +	spin_unlock(&xencons_lock);
>  +
>  +	return 0;
>  +
>  + error_nomem:
>  +	ret = -ENOMEM;
>  +	xenbus_dev_fatal(dev, ret, "allocating device memory");
>  + error:
>  +	xencons_disconnect_backend(info);
>  +	xencons_free(info);
>  +	return ret;
>  +}
>  +
>  +static int xencons_resume(struct xenbus_device *dev)
>  +{
>  +	struct xencons_info *info = dev_get_drvdata(&dev->dev);
>  +
>  +	xencons_disconnect_backend(info);
>  +	memset(info->intf, 0, PAGE_SIZE);
>  +	return xencons_connect_backend(dev, info);
>  +}
>  +
>  +static void xencons_backend_changed(struct xenbus_device *dev,
>  +				   enum xenbus_state backend_state)
>  +{
>  +	switch (backend_state) {
>  +	case XenbusStateReconfiguring:
>  +	case XenbusStateReconfigured:
>  +	case XenbusStateInitialising:
>  +	case XenbusStateInitialised:
>  +	case XenbusStateUnknown:
>  +	case XenbusStateClosed:
>  +		break;
>  +
>  +	case XenbusStateInitWait:
>  +		break;
>  +
>  +	case XenbusStateConnected:
>  +		xenbus_switch_state(dev, XenbusStateConnected);
>  +		break;
>  +
>  +	case XenbusStateClosing:
>  +		xenbus_frontend_closed(dev);
>  +		break;
>  +	}
>  +}
>  +
>  +static const struct xenbus_device_id xencons_ids[] = {
>  +	{ "console" },
>  +	{ "" }
>  +};
>  +
>  +
>  +static DEFINE_XENBUS_DRIVER(xencons, "xenconsole",
>  +	.probe = xencons_probe,
>  +	.remove = xencons_remove,
>  +	.resume = xencons_resume,
>  +	.otherend_changed = xencons_backend_changed,
>  +);
>  +#endif /* CONFIG_HVC_XEN_FRONTEND */
>  +
>  +static int __init xen_hvc_init(void)
>  +{
>  +	int r;
>  +	struct xencons_info *info;
>  +	const struct hv_ops *ops;
>  +
>  +	if (!xen_domain())
>  +		return -ENODEV;
>  +
>  +	if (xen_initial_domain()) {
>  +		ops = &dom0_hvc_ops;
>  +		r = xen_initial_domain_console_init();
>  +		if (r < 0)
>  +			return r;
>  +		info = vtermno_to_xencons(HVC_COOKIE);
>  +	} else {
>  +		ops = &domU_hvc_ops;
>  +		if (xen_hvm_domain())
>  +			r = xen_hvm_console_init();
>  +		else
>  +			r = xen_pv_console_init();
>  +		if (r < 0)
>  +			return r;
>  +
>  +		info = vtermno_to_xencons(HVC_COOKIE);
>  +		info->irq = bind_evtchn_to_irq(info->evtchn);
>  +	}
>  +	if (info->irq < 0)
> - 		info->irq = 0; /* NO_IRQ */
> ++		info->irq = 0;
>  +	else
>  +		irq_set_noprobe(info->irq);
>  +
>  +	info->hvc = hvc_alloc(HVC_COOKIE, info->irq, ops, 256);
>  +	if (IS_ERR(info->hvc)) {
>  +		r = PTR_ERR(info->hvc);
>  +		spin_lock(&xencons_lock);
>  +		list_del(&info->list);
>  +		spin_unlock(&xencons_lock);
>  +		if (info->irq)
>  +			unbind_from_irqhandler(info->irq, NULL);
>  +		kfree(info);
>  +		return r;
>  +	}
>  +
>  +	r = 0;
>  +#ifdef CONFIG_HVC_XEN_FRONTEND
>  +	r = xenbus_register_frontend(&xencons_driver);
>  +#endif
>  +	return r;
>   }
>   
>   static void __exit xen_hvc_fini(void)


