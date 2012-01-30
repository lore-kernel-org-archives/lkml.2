Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2A3PcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 10:32:19 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:64108 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab2A3PcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 10:32:18 -0500
X-IronPort-AV: E=Sophos;i="4.71,592,1320624000"; 
   d="scan'208";a="10369648"
Date: Mon, 30 Jan 2012 15:33:48 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] hvc_xen: implement multiconsole support
In-Reply-To: <20120127184538.GA18321@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1201301510240.3196@kaball-desktop>
References: <alpine.DEB.2.00.1201271823240.3196@kaball-desktop> <1327689097-12788-2-git-send-email-stefano.stabellini@eu.citrix.com> <20120127184538.GA18321@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jan 2012, Konrad Rzeszutek Wilk wrote:
> > +static void xencons_disconnect_backend(struct xencons_info *info)
> > +{
> > +	if (info->irq > 0)
> > +		unbind_from_irqhandler(info->irq, NULL);
> > +	info->irq = 0;
> > +	if (info->evtchn > 0)
> > +		xenbus_free_evtchn(info->xbdev, info->evtchn);
> > +	info->evtchn = 0;
> > +	if (info->gntref > 0)
> > +		gnttab_free_grant_references(info->gntref);
> > +	info->gntref = 0;
> > +	if (info->hvc != NULL)
> > +		hvc_remove(info->hvc);
> > +	info->hvc = NULL;
> > +}
> > +
> > +static void xencons_free(struct xencons_info *info)
> > +{
> > +	xencons_disconnect_backend(info);
> > +	free_page((unsigned long)info->intf);
> > +	info->intf = NULL;
> > +	info->vtermno = 0;
> > +	kfree(info);
> > +}
> > +
> > +static int xencons_remove(struct xenbus_device *dev)
> > +{
> > +	struct xencons_info *info = dev_get_drvdata(&dev->dev);
> > +
> 
> I would say put
> 	xencons_disconnect_backend(info)
> 
> here, that way it calls hvc_remove first, and then this would
> delete an "not-called" anymore structure.
> 
> > +	spin_lock(&xencons_lock);
> > +	list_del(&info->list);
> > +	spin_unlock(&xencons_lock);
> > +	xencons_free(info);
> 
> >  	return 0;
> >  }
> >
> 
> .. snip..
> > +
> > +static const struct xenbus_device_id xencons_ids[] = {
> > +	{ "console" },
> > +	{ "" }
> > +};
> > +
> > +
> >  static void __exit xen_hvc_fini(void)
> >  {
> > -	if (hvc)
> > -		hvc_remove(hvc);
> > +	struct xencons_info *entry, *next;
> > +
> > +	if (list_empty(&xenconsoles))
> > +			return;
> > +
> > +	spin_lock(&xencons_lock);
> 
> Take that spin-lock out.
> 
> > +	list_for_each_entry_safe(entry, next, &xenconsoles, list) {
> > +		list_del(&entry->list);
> > +		if (entry->xbdev)
> > +			xencons_remove(entry->xbdev);
> 
> This guy deletes itself from the list..
> > +		else {
> > +			if (entry->irq > 0)
> > +				unbind_from_irqhandler(entry->irq, NULL);
> > +			if (entry->hvc);
> > +				hvc_remove(entry->hvc);
> > +			kfree(entry);
> 
> ..but this one does not.  You could make xencons_remove just remove
> itself from the list and nothing else. Then rename it to 'xencons_remove_itself' perhaps?
> 
> After that, introduce a new function 'xencons_delete' that would call
> xecons_disconnect_backend, xencons_remove_itself, and xencons_free?

Thanks for spotting the deadlock and the useful suggestions.
I have reworked the shutdown path a bit, making sure that we don't take
any locks twice and that we call hvc_remove before list_del (see next
version of the patch, to be posted soon).



> >  
> > +static struct xenbus_driver xencons_driver = {
> 
> This needs to be wrapped in the new macro that Jan prepared.
> DEFINE_XENBUS_DRIVER (73db144b58a32fc39733db6a7e1fe582072ad26a)

OK
