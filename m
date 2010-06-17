Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab0FQXf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 19:35:57 -0400
Received: from claw.goop.org ([74.207.240.146]:46831 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704Ab0FQXfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 19:35:55 -0400
Message-ID: <4C1AB152.107@goop.org>
Date: Fri, 18 Jun 2010 00:35:46 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "ddutile@redhat.com" <ddutile@redhat.com>,
       "sheng@linux.intel.com" <sheng@linux.intel.com>
Subject: Re: [Xen-devel] [PATCH 12/12] Unplug emulated disks and nics
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com> <1275570645-27189-12-git-send-email-stefano.stabellini@eu.citrix.com> <20100614212017.GA8600@phenom.dumpdata.com> <alpine.DEB.2.00.1006171541490.3401@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1006171541490.3401@kaball-desktop>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2010 04:42 PM, Stefano Stabellini wrote:
> On Mon, 14 Jun 2010, Konrad Rzeszutek Wilk wrote:
>   
>>> +#if (defined(CONFIG_XEN_NETDEV_FRONTEND) || \
>>> +		defined(CONFIG_XEN_NETDEV_FRONTEND_MODULE)) && \
>>> +		(defined(CONFIG_XEN_PLATFORM_PCI) || \
>>> +		 defined(CONFIG_XEN_PLATFORM_PCI_MODULE))
>>> +		printk(KERN_INFO "Netfront and the Xen platform PCI driver have "
>>> +				"been compiled for this kernel: unplug emulated NICs.\n");
>>> +		xen_emul_unplug |= XEN_UNPLUG_ALL_NICS;
>>> +#endif
>>> +#if (defined(CONFIG_XEN_BLKDEV_FRONTEND) || \
>>> +		defined(CONFIG_XEN_BLKDEV_FRONTEND_MODULE)) && \
>>> +		(defined(CONFIG_XEN_PLATFORM_PCI) || \
>>> +		 defined(CONFIG_XEN_PLATFORM_PCI_MODULE))
>>> +		printk(KERN_INFO "Blkfront and the Xen platform PCI driver have "
>>> +				"been compiled for this kernel: unplug emulated disks.\n"
>>> +				"You might have to change the root device\n"
>>> +				"from /dev/hd[a-d] to /dev/xvd[a-d]\n"
>>> +				"in your root= kernel command line option\n");
>>> +		xen_emul_unplug |= XEN_UNPLUG_ALL_IDE_DISKS;
>>> +#endif
>>>       
>> Wow. Can you move those checks to the header file and make it deal with
>> the #ifdef and setting of xen_emul_unplug?
>>
>>     
> I tried, but it didn't improve the elegance of the code, mainly because I
> want to keep the printk in place, so the code would look very much like
> this, but instead of being in platform-pci-unplug.c would be in
> platform_pci.h.
>   

What about using Kconfig to define an appropriate symbol and just #ifdef
on that?

>>> +	}
>>> +	/* Now unplug the emulated devices */
>>> +	if (xen_platform_pci_enabled && !(xen_emul_unplug & XEN_UNPLUG_IGNORE))
>>> +		outw(xen_emul_unplug, XEN_IOPORT_UNPLUG);
>>> +}
>>> +
>>> +static int __init parse_xen_emul_unplug(char *arg)
>>> +{
>>> +	char *p, *q;
>>> +
>>> +	for (p = arg; p; p = q) {
>>> +		q = strchr(arg, ',');
>>> +		if (q)
>>> +			*q++ = '\0';
>>> +		if (!strcmp(p, "all"))
>>> +			xen_emul_unplug |= XEN_UNPLUG_ALL;
>>>       
>> strncmp..
>>
>>     
> is it really needed considering that we know that both strings are NULL
> terminated and one of them is a constant?
>   

strncmp would avoid having to modify the string in place.

    J
