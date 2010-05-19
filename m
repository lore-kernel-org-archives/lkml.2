Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab0ESM4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 08:56:52 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:12437 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab0ESM4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 08:56:51 -0400
X-IronPort-AV: E=Sophos;i="4.53,263,1272859200"; 
   d="scan'208";a="97697336"
Date: Wed, 19 May 2010 14:00:10 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>
Subject: Re: [PATCH 05/12] unplug emulated disks and nics
In-Reply-To: <4BF2CE1A.4090607@goop.org>
Message-ID: <alpine.DEB.2.00.1005191324170.11380@kaball-desktop>
References: <alpine.DEB.2.00.1005181054260.11380@kaball-desktop> <1274178187-20602-5-git-send-email-stefano.stabellini@eu.citrix.com> <4BF2CE1A.4090607@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010, Jeremy Fitzhardinge wrote:
> On 05/18/2010 03:23 AM, Stefano Stabellini wrote:
> > add a xen_unplug command line option to the kernel to unplug
> > xen emulated disks and nics.
> >   
> 
> I think it would be nice to call it something like "xen_emul_unplug" to
> clarify what this actually means.  And is it really necessary to make it
> a command-line option?  Can't we unplug these things once the pv drivers
> are brought up?  What happens if the user doesn't specify this?
> 

We have to do it before PCI is initialized to make sure the unplug
doesn't create any issues, for this reason we cannot wait for the PV
frontends to come up.
Also the PV frontends might be compiled as modules or even missing so we
cannot just unplug any emulated device as soon as we detect that we are
running on Xen.
As a conclusion we thought that deferring the decision to the user might
be the safest way of doing it.

If the user doesn't specify this, both the PV frontends and the drivers
for the emulated network card and disk could come up, and this might
lead to data corruptions (especially in the disk case).

Probably I should prevent the xen platform pci driver from loading
(that in turn would prevent the PV frontends from loading) if the
option is not specified.

s/xen_unplug/xen_emul_unplug is fine by me.



> > +static int __init check_platform_magic(void)
> >   
> 
> I'd prefer not to put all this in enlighten.c unless it really needs to
> be here.  Given that all this is dependent on the Xen platform PCI
> device being enabled, it would probably be happy in a separate
> conditionally compiled file.

OK


> 
> > +{
> > +	short magic;
> > +	char protocol;
> > +
> > +	magic = inw(XEN_IOPORT_MAGIC);
> >   
> 
> Does this get run only once we've established we're running on Xen, or
> could this be run in an arbitrary environment?
> 

only once we know we are running on Xen


> > +	if (magic != XEN_IOPORT_MAGIC_VAL) {
> > +		printk(KERN_ERR "Xen Platform Pci: unrecognised magic value\n");
> > +		return -1;
> > +	}
> > +
> > +	protocol = inb(XEN_IOPORT_PROTOVER);
> > +
> > +	printk(KERN_DEBUG "Xen Platform Pci: I/O protocol version %d\n",
> >   
> 
> "PCI" please.  Also, is that really accurate since we're doing random IO
> port stuff with no obvious connection to PCI?  "Xen Platform Device"
> perhaps?  (Though given that we have a proper fake PCI device, why all
> this random IO port hackery anyway?)
> 
> 

That's because the ioports even though they are static, they still
belong to the Xen platform PCI device.
The ioports are static so that they can be probed before the PCI bus is
even initialized.


> > +			protocol);
> > +
> > +	switch (protocol) {
> > +	case 1:
> > +		outw(XEN_IOPORT_LINUX_PRODNUM, XEN_IOPORT_PRODNUM);
> > +		outl(XEN_IOPORT_LINUX_DRVVER, XEN_IOPORT_DRVVER);
> > +		if (inw(XEN_IOPORT_MAGIC) != XEN_IOPORT_MAGIC_VAL) {
> > +			printk(KERN_ERR "Xen Platform: blacklisted by host\n");
> > +			return -3;
> > +		}
> > +		break;
> > +	default:
> > +		printk(KERN_WARNING "Xen Platform Pci: unknown I/O protocol version");
> > +		return -2;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  void __init xen_guest_init(void)
> >  {
> >  	int r;
> > @@ -1325,6 +1362,35 @@ void __init xen_guest_init(void)
> >  
> >  	xen_callback_vector();
> >  
> > +	r = check_platform_magic();
> > +	if (!r || (r == -1 && (unplug & UNPLUG_IGNORE)))
> > +		xen_platform_pci = 1;
> > +	if (xen_platform_pci && !(unplug & UNPLUG_IGNORE))
> > +		outw(unplug, XEN_IOPORT_UNPLUG);
> >   
> 
> What does all this do?  A comment would be nice.
>

OK.
The idea is that xen_platform_pci is set to 1 (meaning: the xen platform
pci device driver is enabled) if the xen platform protocol
version matches our check or if it doesn't match because we are running
on a very old version of Xen and the user told us to continue anyway.

After my comment above on preventing the PV frontends from loading if no
unplug is done, I think the whole thing should be changed to:

/* check the version of the xen platform PCI device */
r = check_platform_magic();
/* If the version matches and the user told us to unplug the emulated
 * devices, enable the Xen platform PCI driver. 
 * Also enable the Xen platform PCI driver if the version is really old
 * and the user told us to ignore it.
 */
if (!r && unplug || (r == -1 && (unplug & UNPLUG_IGNORE)))
    xen_platform_pci = 1;
/* Now unplug the emulated devices */
if (xen_platform_pci && !(unplug & UNPLUG_IGNORE))
    outw(unplug, XEN_IOPORT_UNPLUG);


> >  	have_vcpu_info_placement = 0;
> >  	x86_init.irqs.intr_init = xen_init_IRQ;
> >  }
> > +
> > +static int __init parse_unplug(char *arg)
> > +{
> > +	char *p, *q;
> > +
> > +	for (p = arg; p; p = q) {
> > +		q = strchr(arg, ',');
> > +		if (q)
> > +			*q++ = '\0';
> > +		if (!strcmp(p, "all"))
> > +			unplug |= UNPLUG_ALL;
> > +		else if (!strcmp(p, "ide-disks"))
> > +			unplug |= UNPLUG_ALL_IDE_DISKS;
> > +		else if (!strcmp(p, "aux-ide-disks"))
> > +			unplug |= UNPLUG_AUX_IDE_DISKS;
> > +		else if (!strcmp(p, "nics"))
> > +			unplug |= UNPLUG_ALL_NICS;
> > +		else
> > +			printk(KERN_WARNING "unrecognised option '%s' "
> > +				 "in module parameter 'dev_unplug'\n", p);
> >   
> 
> "xen_unplug" (or whatever it becomes).

OK


> 
> > +	}
> > +	return 0;
> > +}
> > +early_param("xen_unplug", parse_unplug);
> >   
> 
> If we must have this kernel command line parameter, make sure you update
> Documentation/kernel-parameters.txt.
> 

Sure


> > diff --git a/include/xen/hvm.h b/include/xen/hvm.h
> > index 5940ee5..777d2ce 100644
> > --- a/include/xen/hvm.h
> > +++ b/include/xen/hvm.h
> > @@ -30,4 +30,6 @@ extern int xen_have_vector_callback;
> >  #define HVM_CALLBACK_VECTOR(x) (((uint64_t)HVM_CALLBACK_VIA_TYPE_VECTOR)<<\
> >                                 HVM_CALLBACK_VIA_TYPE_SHIFT | (x))
> >  
> > +extern int xen_platform_pci;
> > +
> >  #endif /* XEN_HVM_H__ */
> > diff --git a/include/xen/interface/platform_pci.h b/include/xen/interface/platform_pci.h
> > new file mode 100644
> > index 0000000..720eaf5
> > --- /dev/null
> > +++ b/include/xen/interface/platform_pci.h
> > @@ -0,0 +1,46 @@
> > +/******************************************************************************
> > + * platform_pci.h
> > + *
> > + * Interface for granting foreign access to page frames, and receiving
> > + * page-ownership transfers.
> > + *
> > + * Permission is hereby granted, free of charge, to any person obtaining a copy
> > + * of this software and associated documentation files (the "Software"), to
> > + * deal in the Software without restriction, including without limitation the
> > + * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
> > + * sell copies of the Software, and to permit persons to whom the Software is
> > + * furnished to do so, subject to the following conditions:
> > + *
> > + * The above copyright notice and this permission notice shall be included in
> > + * all copies or substantial portions of the Software.
> > + *
> > + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> > + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> > + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> > + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> > + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> > + * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
> > + * DEALINGS IN THE SOFTWARE.
> > + */
> > +
> > +#ifndef __XEN_PUBLIC_PLATFORM_PCI_H__
> > +#define __XEN_PUBLIC_PLATFORM_PCI_H__
> > +
> > +#define XEN_IOPORT_BASE 0x10
> > +
> > +#define XEN_IOPORT_PLATFLAGS	(XEN_IOPORT_BASE + 0) /* 1 byte access (R/W) */
> > +#define XEN_IOPORT_MAGIC	(XEN_IOPORT_BASE + 0) /* 2 byte access (R) */
> > +#define XEN_IOPORT_UNPLUG	(XEN_IOPORT_BASE + 0) /* 2 byte access (W) */
> > +#define XEN_IOPORT_DRVVER	(XEN_IOPORT_BASE + 0) /* 4 byte access (W) */
> > +
> > +#define XEN_IOPORT_SYSLOG	(XEN_IOPORT_BASE + 2) /* 1 byte access (W) */
> > +#define XEN_IOPORT_PROTOVER	(XEN_IOPORT_BASE + 2) /* 1 byte access (R) */
> > +#define XEN_IOPORT_PRODNUM	(XEN_IOPORT_BASE + 2) /* 2 byte access (W) */
> > +
> > +#define UNPLUG_ALL_IDE_DISKS 1
> > +#define UNPLUG_ALL_NICS 2
> > +#define UNPLUG_AUX_IDE_DISKS 4
> > +#define UNPLUG_ALL 7
> > +#define UNPLUG_IGNORE 8
> > +
> > +#endif /* __XEN_PUBLIC_PLATFORM_PCI_H__ */
> > diff --git a/include/xen/platform_pci.h b/include/xen/platform_pci.h
> > new file mode 100644
> > index 0000000..f39f4d3
> > --- /dev/null
> > +++ b/include/xen/platform_pci.h
> > @@ -0,0 +1,32 @@
> > +/******************************************************************************
> > + * platform-pci.h
> > + *
> > + * Xen platform PCI device driver
> > + * Copyright (c) 2004, Intel Corporation. <xiaofeng.ling@intel.com>
> > + * Copyright (c) 2007, XenSource Inc.
> > + * Copyright (c) 2010, Citrix
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms and conditions of the GNU General Public License,
> > + * version 2, as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope it will be useful, but WITHOUT
> > + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> > + * more details.
> > + *
> > + * You should have received a copy of the GNU General Public License along with
> > + * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
> > + * Place - Suite 330, Boston, MA 02111-1307 USA.
> > + */
> > +
> > +#ifndef _XEN_PLATFORM_PCI_H
> > +#define _XEN_PLATFORM_PCI_H
> > +
> > +#include <linux/version.h>
> > +
> > +#define XEN_IOPORT_MAGIC_VAL 0x49d2
> > +#define XEN_IOPORT_LINUX_PRODNUM 0xffff
> > +#define XEN_IOPORT_LINUX_DRVVER  ((LINUX_VERSION_CODE << 8) + 0x0)
> >   
> 
> Can't these two headers be folded together?  There doesn't seem much
> point in splitting these XEN_IOPORT definitions across two files.
> 

One is supposed to be a common header file shared with the hypervisor
(actually the device model in this case), the other is the Xen platform
PCI driver header file.
I don't think they should be merged.

