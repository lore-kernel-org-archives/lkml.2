Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab2A0Shm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:37:42 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:49738 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab2A0Shk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:37:40 -0500
Date: Fri, 27 Jan 2012 14:37:34 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com
Subject: Re: [Xen-devel] [PATCH 2/2] hvc_xen: implement multiconsole support
Message-ID: <20120127183734.GA10175@andromeda.dapyr.net>
References: <alpine.DEB.2.00.1201261233050.3196@kaball-desktop> <1327581807-17276-2-git-send-email-stefano.stabellini@eu.citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327581807-17276-2-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int xencons_remove(struct xenbus_device *dev)
> +{
> +	struct xencons_info *info = dev_get_drvdata(&dev->dev);
> +
> +	spin_lock(&xencons_lock);
> +	list_del(&info->list);
> +	spin_unlock(&xencons_lock);
> +	xencons_free(info);
>  	return 0;
>  }
.. snip..
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

You take a lock.
> +	list_for_each_entry_safe(entry, next, &xenconsoles, list) {
> +		list_del(&entry->list);
> +		if (entry->xbdev)
> +			xencons_remove(entry->xbdev);

And then call xencons_remove which also takes the same lock.
> +		else {
> +			if (entry->irq > 0)
> +				unbind_from_irqhandler(entry->irq, NULL);
> +			if (entry->hvc);
> +				hvc_remove(entry->hvc);
> +			kfree(entry);
> +		}
> +	}
> +	spin_unlock(&xencons_lock);
