Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510Ab0ERR17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:27:59 -0400
Received: from claw.goop.org ([74.207.240.146]:54661 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab0ERR14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:27:56 -0400
Message-ID: <4BF2CE1A.4090607@goop.org>
Date: Tue, 18 May 2010 10:27:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>
Subject: Re: [PATCH 05/12] unplug emulated disks and nics
References: <alpine.DEB.2.00.1005181054260.11380@kaball-desktop> <1274178187-20602-5-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1274178187-20602-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2010 03:23 AM, Stefano Stabellini wrote:
> add a xen_unplug command line option to the kernel to unplug
> xen emulated disks and nics.
>   

I think it would be nice to call it something like "xen_emul_unplug" to
clarify what this actually means.  And is it really necessary to make it
a command-line option?  Can't we unplug these things once the pv drivers
are brought up?  What happens if the user doesn't specify this?

> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/xen/enlighten.c             |   66 ++++++++++++++++++++++++++++++++++
>  include/xen/hvm.h                    |    2 +
>  include/xen/interface/platform_pci.h |   46 +++++++++++++++++++++++
>  include/xen/platform_pci.h           |   32 ++++++++++++++++
>  4 files changed, 146 insertions(+), 0 deletions(-)
>  create mode 100644 include/xen/interface/platform_pci.h
>  create mode 100644 include/xen/platform_pci.h
>
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 502c4f8..aac47b0 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -31,6 +31,7 @@
>  #include <linux/gfp.h>
>  
>  #include <xen/xen.h>
> +#include <xen/platform_pci.h>
>  #include <xen/interface/xen.h>
>  #include <xen/interface/version.h>
>  #include <xen/interface/physdev.h>
> @@ -38,6 +39,7 @@
>  #include <xen/interface/memory.h>
>  #include <xen/interface/hvm/hvm_op.h>
>  #include <xen/interface/hvm/params.h>
> +#include <xen/interface/platform_pci.h>
>  #include <xen/features.h>
>  #include <xen/page.h>
>  #include <xen/hvm.h>
> @@ -83,6 +85,8 @@ struct shared_info xen_dummy_shared_info;
>  void *xen_initial_gdt;
>  
>  int xen_have_vector_callback;
> +int xen_platform_pci;
> +static int unplug;
>  
>  /*
>   * Point at some empty memory to start with. We map the real shared_info
> @@ -1309,6 +1313,39 @@ static void xen_callback_vector(void)
>  	}
>  }
>  
> +static int __init check_platform_magic(void)
>   

I'd prefer not to put all this in enlighten.c unless it really needs to
be here.  Given that all this is dependent on the Xen platform PCI
device being enabled, it would probably be happy in a separate
conditionally compiled file.

> +{
> +	short magic;
> +	char protocol;
> +
> +	magic = inw(XEN_IOPORT_MAGIC);
>   

Does this get run only once we've established we're running on Xen, or
could this be run in an arbitrary environment?

> +	if (magic != XEN_IOPORT_MAGIC_VAL) {
> +		printk(KERN_ERR "Xen Platform Pci: unrecognised magic value\n");
> +		return -1;
> +	}
> +
> +	protocol = inb(XEN_IOPORT_PROTOVER);
> +
> +	printk(KERN_DEBUG "Xen Platform Pci: I/O protocol version %d\n",
>   

"PCI" please.  Also, is that really accurate since we're doing random IO
port stuff with no obvious connection to PCI?  "Xen Platform Device"
perhaps?  (Though given that we have a proper fake PCI device, why all
this random IO port hackery anyway?)


> +			protocol);
> +
> +	switch (protocol) {
> +	case 1:
> +		outw(XEN_IOPORT_LINUX_PRODNUM, XEN_IOPORT_PRODNUM);
> +		outl(XEN_IOPORT_LINUX_DRVVER, XEN_IOPORT_DRVVER);
> +		if (inw(XEN_IOPORT_MAGIC) != XEN_IOPORT_MAGIC_VAL) {
> +			printk(KERN_ERR "Xen Platform: blacklisted by host\n");
> +			return -3;
> +		}
> +		break;
> +	default:
> +		printk(KERN_WARNING "Xen Platform Pci: unknown I/O protocol version");
> +		return -2;
> +	}
> +
> +	return 0;
> +}
> +
>  void __init xen_guest_init(void)
>  {
>  	int r;
> @@ -1325,6 +1362,35 @@ void __init xen_guest_init(void)
>  
>  	xen_callback_vector();
>  
> +	r = check_platform_magic();
> +	if (!r || (r == -1 && (unplug & UNPLUG_IGNORE)))
> +		xen_platform_pci = 1;
> +	if (xen_platform_pci && !(unplug & UNPLUG_IGNORE))
> +		outw(unplug, XEN_IOPORT_UNPLUG);
>   

What does all this do?  A comment would be nice.

>  	have_vcpu_info_placement = 0;
>  	x86_init.irqs.intr_init = xen_init_IRQ;
>  }
> +
> +static int __init parse_unplug(char *arg)
> +{
> +	char *p, *q;
> +
> +	for (p = arg; p; p = q) {
> +		q = strchr(arg, ',');
> +		if (q)
> +			*q++ = '\0';
> +		if (!strcmp(p, "all"))
> +			unplug |= UNPLUG_ALL;
> +		else if (!strcmp(p, "ide-disks"))
> +			unplug |= UNPLUG_ALL_IDE_DISKS;
> +		else if (!strcmp(p, "aux-ide-disks"))
> +			unplug |= UNPLUG_AUX_IDE_DISKS;
> +		else if (!strcmp(p, "nics"))
> +			unplug |= UNPLUG_ALL_NICS;
> +		else
> +			printk(KERN_WARNING "unrecognised option '%s' "
> +				 "in module parameter 'dev_unplug'\n", p);
>   

"xen_unplug" (or whatever it becomes).

> +	}
> +	return 0;
> +}
> +early_param("xen_unplug", parse_unplug);
>   

If we must have this kernel command line parameter, make sure you update
Documentation/kernel-parameters.txt.

> diff --git a/include/xen/hvm.h b/include/xen/hvm.h
> index 5940ee5..777d2ce 100644
> --- a/include/xen/hvm.h
> +++ b/include/xen/hvm.h
> @@ -30,4 +30,6 @@ extern int xen_have_vector_callback;
>  #define HVM_CALLBACK_VECTOR(x) (((uint64_t)HVM_CALLBACK_VIA_TYPE_VECTOR)<<\
>                                 HVM_CALLBACK_VIA_TYPE_SHIFT | (x))
>  
> +extern int xen_platform_pci;
> +
>  #endif /* XEN_HVM_H__ */
> diff --git a/include/xen/interface/platform_pci.h b/include/xen/interface/platform_pci.h
> new file mode 100644
> index 0000000..720eaf5
> --- /dev/null
> +++ b/include/xen/interface/platform_pci.h
> @@ -0,0 +1,46 @@
> +/******************************************************************************
> + * platform_pci.h
> + *
> + * Interface for granting foreign access to page frames, and receiving
> + * page-ownership transfers.
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a copy
> + * of this software and associated documentation files (the "Software"), to
> + * deal in the Software without restriction, including without limitation the
> + * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
> + * sell copies of the Software, and to permit persons to whom the Software is
> + * furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice shall be included in
> + * all copies or substantial portions of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> + * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
> + * DEALINGS IN THE SOFTWARE.
> + */
> +
> +#ifndef __XEN_PUBLIC_PLATFORM_PCI_H__
> +#define __XEN_PUBLIC_PLATFORM_PCI_H__
> +
> +#define XEN_IOPORT_BASE 0x10
> +
> +#define XEN_IOPORT_PLATFLAGS	(XEN_IOPORT_BASE + 0) /* 1 byte access (R/W) */
> +#define XEN_IOPORT_MAGIC	(XEN_IOPORT_BASE + 0) /* 2 byte access (R) */
> +#define XEN_IOPORT_UNPLUG	(XEN_IOPORT_BASE + 0) /* 2 byte access (W) */
> +#define XEN_IOPORT_DRVVER	(XEN_IOPORT_BASE + 0) /* 4 byte access (W) */
> +
> +#define XEN_IOPORT_SYSLOG	(XEN_IOPORT_BASE + 2) /* 1 byte access (W) */
> +#define XEN_IOPORT_PROTOVER	(XEN_IOPORT_BASE + 2) /* 1 byte access (R) */
> +#define XEN_IOPORT_PRODNUM	(XEN_IOPORT_BASE + 2) /* 2 byte access (W) */
> +
> +#define UNPLUG_ALL_IDE_DISKS 1
> +#define UNPLUG_ALL_NICS 2
> +#define UNPLUG_AUX_IDE_DISKS 4
> +#define UNPLUG_ALL 7
> +#define UNPLUG_IGNORE 8
> +
> +#endif /* __XEN_PUBLIC_PLATFORM_PCI_H__ */
> diff --git a/include/xen/platform_pci.h b/include/xen/platform_pci.h
> new file mode 100644
> index 0000000..f39f4d3
> --- /dev/null
> +++ b/include/xen/platform_pci.h
> @@ -0,0 +1,32 @@
> +/******************************************************************************
> + * platform-pci.h
> + *
> + * Xen platform PCI device driver
> + * Copyright (c) 2004, Intel Corporation. <xiaofeng.ling@intel.com>
> + * Copyright (c) 2007, XenSource Inc.
> + * Copyright (c) 2010, Citrix
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
> + * Place - Suite 330, Boston, MA 02111-1307 USA.
> + */
> +
> +#ifndef _XEN_PLATFORM_PCI_H
> +#define _XEN_PLATFORM_PCI_H
> +
> +#include <linux/version.h>
> +
> +#define XEN_IOPORT_MAGIC_VAL 0x49d2
> +#define XEN_IOPORT_LINUX_PRODNUM 0xffff
> +#define XEN_IOPORT_LINUX_DRVVER  ((LINUX_VERSION_CODE << 8) + 0x0)
>   

Can't these two headers be folded together?  There doesn't seem much
point in splitting these XEN_IOPORT definitions across two files.

    J
