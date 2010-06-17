Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab0FQPo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 11:44:27 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:59730 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab0FQPoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 11:44:21 -0400
X-IronPort-AV: E=Sophos;i="4.53,432,1272844800"; 
   d="scan'208";a="462510"
Date: Thu, 17 Jun 2010 16:42:14 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeremy@goop.org" <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "ddutile@redhat.com" <ddutile@redhat.com>,
       "sheng@linux.intel.com" <sheng@linux.intel.com>
Subject: Re: [Xen-devel] [PATCH 12/12] Unplug emulated disks and nics
In-Reply-To: <20100614212017.GA8600@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1006171541490.3401@kaball-desktop>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com> <1275570645-27189-12-git-send-email-stefano.stabellini@eu.citrix.com> <20100614212017.GA8600@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010, Konrad Rzeszutek Wilk wrote:
> > +#if (defined(CONFIG_XEN_NETDEV_FRONTEND) || \
> > +		defined(CONFIG_XEN_NETDEV_FRONTEND_MODULE)) && \
> > +		(defined(CONFIG_XEN_PLATFORM_PCI) || \
> > +		 defined(CONFIG_XEN_PLATFORM_PCI_MODULE))
> > +		printk(KERN_INFO "Netfront and the Xen platform PCI driver have "
> > +				"been compiled for this kernel: unplug emulated NICs.\n");
> > +		xen_emul_unplug |= XEN_UNPLUG_ALL_NICS;
> > +#endif
> > +#if (defined(CONFIG_XEN_BLKDEV_FRONTEND) || \
> > +		defined(CONFIG_XEN_BLKDEV_FRONTEND_MODULE)) && \
> > +		(defined(CONFIG_XEN_PLATFORM_PCI) || \
> > +		 defined(CONFIG_XEN_PLATFORM_PCI_MODULE))
> > +		printk(KERN_INFO "Blkfront and the Xen platform PCI driver have "
> > +				"been compiled for this kernel: unplug emulated disks.\n"
> > +				"You might have to change the root device\n"
> > +				"from /dev/hd[a-d] to /dev/xvd[a-d]\n"
> > +				"in your root= kernel command line option\n");
> > +		xen_emul_unplug |= XEN_UNPLUG_ALL_IDE_DISKS;
> > +#endif
> 
> Wow. Can you move those checks to the header file and make it deal with
> the #ifdef and setting of xen_emul_unplug?
> 

I tried, but it didn't improve the elegance of the code, mainly because I
want to keep the printk in place, so the code would look very much like
this, but instead of being in platform-pci-unplug.c would be in
platform_pci.h.


> > +	}
> > +	/* Now unplug the emulated devices */
> > +	if (xen_platform_pci_enabled && !(xen_emul_unplug & XEN_UNPLUG_IGNORE))
> > +		outw(xen_emul_unplug, XEN_IOPORT_UNPLUG);
> > +}
> > +
> > +static int __init parse_xen_emul_unplug(char *arg)
> > +{
> > +	char *p, *q;
> > +
> > +	for (p = arg; p; p = q) {
> > +		q = strchr(arg, ',');
> > +		if (q)
> > +			*q++ = '\0';
> > +		if (!strcmp(p, "all"))
> > +			xen_emul_unplug |= XEN_UNPLUG_ALL;
> 
> strncmp..
> 

is it really needed considering that we know that both strings are NULL
terminated and one of them is a constant?


