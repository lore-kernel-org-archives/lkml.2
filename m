Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760442Ab0FQRsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 13:48:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48652 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760361Ab0FQRsG (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 17 Jun 2010 13:48:06 -0400
Date: Thu, 17 Jun 2010 13:46:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeremy@goop.org" <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "ddutile@redhat.com" <ddutile@redhat.com>,
       "sheng@linux.intel.com" <sheng@linux.intel.com>
Subject: Re: [Xen-devel] [PATCH 12/12] Unplug emulated disks and nics
Message-ID: <20100617174622.GB17523@phenom.dumpdata.com>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <1275570645-27189-12-git-send-email-stefano.stabellini@eu.citrix.com>
 <20100614212017.GA8600@phenom.dumpdata.com>
 <alpine.DEB.2.00.1006171541490.3401@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1006171541490.3401@kaball-desktop>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4C1A5FC6.0046:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 04:42:14PM +0100, Stefano Stabellini wrote:
> On Mon, 14 Jun 2010, Konrad Rzeszutek Wilk wrote:
> > > +#if (defined(CONFIG_XEN_NETDEV_FRONTEND) || \
> > > +		defined(CONFIG_XEN_NETDEV_FRONTEND_MODULE)) && \
> > > +		(defined(CONFIG_XEN_PLATFORM_PCI) || \
> > > +		 defined(CONFIG_XEN_PLATFORM_PCI_MODULE))
> > > +		printk(KERN_INFO "Netfront and the Xen platform PCI driver have "
> > > +				"been compiled for this kernel: unplug emulated NICs.\n");
> > > +		xen_emul_unplug |= XEN_UNPLUG_ALL_NICS;
> > > +#endif
> > > +#if (defined(CONFIG_XEN_BLKDEV_FRONTEND) || \
> > > +		defined(CONFIG_XEN_BLKDEV_FRONTEND_MODULE)) && \
> > > +		(defined(CONFIG_XEN_PLATFORM_PCI) || \
> > > +		 defined(CONFIG_XEN_PLATFORM_PCI_MODULE))
> > > +		printk(KERN_INFO "Blkfront and the Xen platform PCI driver have "
> > > +				"been compiled for this kernel: unplug emulated disks.\n"
> > > +				"You might have to change the root device\n"
> > > +				"from /dev/hd[a-d] to /dev/xvd[a-d]\n"
> > > +				"in your root= kernel command line option\n");
> > > +		xen_emul_unplug |= XEN_UNPLUG_ALL_IDE_DISKS;
> > > +#endif
> > 
> > Wow. Can you move those checks to the header file and make it deal with
> > the #ifdef and setting of xen_emul_unplug?
> > 
> 
> I tried, but it didn't improve the elegance of the code, mainly because I
> want to keep the printk in place, so the code would look very much like
> this, but instead of being in platform-pci-unplug.c would be in
> platform_pci.h.

If was thinking of something like this in the header file:


int xen_must_unplug_nics() {
#if (defined(CONFIG_XEN_NETDEV_FRONTEND) || \
		defined(CONFIG_XEN_NETDEV_FRONTEND_MODULE)) && \
		(defined(CONFIG_XEN_PLATFORM_PCI) || \
		 defined(CONFIG_XEN_PLATFORM_PCI_MODULE))
	return 1;
#else
	return 0;
}

and then your code would be:

	if (xen_must_unplug_nics()) {
		printk(".. blah blah ");
		xen_emul_unplug |- XEN_unPLIG_ALL_NICS;
	}

and similar for the IDE disks.

> 
> 
> > > +	}
> > > +	/* Now unplug the emulated devices */
> > > +	if (xen_platform_pci_enabled && !(xen_emul_unplug & XEN_UNPLUG_IGNORE))
> > > +		outw(xen_emul_unplug, XEN_IOPORT_UNPLUG);
> > > +}
> > > +
> > > +static int __init parse_xen_emul_unplug(char *arg)
> > > +{
> > > +	char *p, *q;
> > > +
> > > +	for (p = arg; p; p = q) {
> > > +		q = strchr(arg, ',');
> > > +		if (q)
> > > +			*q++ = '\0';
> > > +		if (!strcmp(p, "all"))
> > > +			xen_emul_unplug |= XEN_UNPLUG_ALL;
> > 
> > strncmp..
> > 
> 
> is it really needed considering that we know that both strings are NULL
> terminated and one of them is a constant?

Please do.
