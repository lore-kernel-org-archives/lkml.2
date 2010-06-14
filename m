Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab0FONo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:44:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27891 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713Ab0FONoY (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 15 Jun 2010 09:44:24 -0400
Date: Mon, 14 Jun 2010 17:20:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org,
       xen-devel@lists.xensource.com, ddutile@redhat.com,
       sheng@linux.intel.com
Subject: Re: [Xen-devel] [PATCH 12/12] Unplug emulated disks and nics
Message-ID: <20100614212017.GA8600@phenom.dumpdata.com>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <1275570645-27189-12-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275570645-27189-12-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090201.4C1783AC.014D:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#if (defined(CONFIG_XEN_NETDEV_FRONTEND) || \
> +		defined(CONFIG_XEN_NETDEV_FRONTEND_MODULE)) && \
> +		(defined(CONFIG_XEN_PLATFORM_PCI) || \
> +		 defined(CONFIG_XEN_PLATFORM_PCI_MODULE))
> +		printk(KERN_INFO "Netfront and the Xen platform PCI driver have "
> +				"been compiled for this kernel: unplug emulated NICs.\n");
> +		xen_emul_unplug |= XEN_UNPLUG_ALL_NICS;
> +#endif
> +#if (defined(CONFIG_XEN_BLKDEV_FRONTEND) || \
> +		defined(CONFIG_XEN_BLKDEV_FRONTEND_MODULE)) && \
> +		(defined(CONFIG_XEN_PLATFORM_PCI) || \
> +		 defined(CONFIG_XEN_PLATFORM_PCI_MODULE))
> +		printk(KERN_INFO "Blkfront and the Xen platform PCI driver have "
> +				"been compiled for this kernel: unplug emulated disks.\n"
> +				"You might have to change the root device\n"
> +				"from /dev/hd[a-d] to /dev/xvd[a-d]\n"
> +				"in your root= kernel command line option\n");
> +		xen_emul_unplug |= XEN_UNPLUG_ALL_IDE_DISKS;
> +#endif

Wow. Can you move those checks to the header file and make it deal with
the #ifdef and setting of xen_emul_unplug?

> +	}
> +	/* Now unplug the emulated devices */
> +	if (xen_platform_pci_enabled && !(xen_emul_unplug & XEN_UNPLUG_IGNORE))
> +		outw(xen_emul_unplug, XEN_IOPORT_UNPLUG);
> +}
> +
> +static int __init parse_xen_emul_unplug(char *arg)
> +{
> +	char *p, *q;
> +
> +	for (p = arg; p; p = q) {
> +		q = strchr(arg, ',');
> +		if (q)
> +			*q++ = '\0';
> +		if (!strcmp(p, "all"))
> +			xen_emul_unplug |= XEN_UNPLUG_ALL;

strncmp..
