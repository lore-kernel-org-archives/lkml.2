Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab0CYW6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 18:58:45 -0400
Received: from mga12.intel.com ([143.182.124.36]:63361 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750760Ab0CYW6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 18:58:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,309,1267430400"; 
   d="scan'208";a="258801492"
Date: Thu, 25 Mar 2010 23:59:30 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       socketcan-core@lists.berlios.de
Subject: Re: [PATCH 1/3] mfd: add support for Janz CMOD-IO PCI MODULbus
 Carrier Board
Message-ID: <20100325225929.GA20618@sortiz.org>
References: <>
 <1268930324-29841-2-git-send-email-iws@ovro.caltech.edu>
 <20100319163849.GB30409@sortiz.org>
 <20100319182209.GD13672@ovro.caltech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100319182209.GD13672@ovro.caltech.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ira,

First of all, sorry for the late reply. Then my answers:

On Fri, Mar 19, 2010 at 11:22:09AM -0700, Ira W. Snyder wrote:
> 
> > > +/*
> > > + * Subdevice Support
> > > + */
> > Please use the mfd-core API for building and registering platform sub devices.
> > The pieces of code below should shrink significantly.
> > 
> 
> Using this framework, how is it possible to create  the devices that I
> do down below. For each subdevice, I need three resources:
> 
> 1) MODULbus registers -- PCI BAR3 + (0x200 * module_num)
> 2) PLX Control Registers -- PCI BAR4
> 3) IRQ
> 
> Specifically, the way IORESOURCE_MEM resources are copied seems wrong.
> They start at the base address of only one resource and use the offsets
> provided in the struct mfd_cell. See the if-statement at
> drivers/mfd/mfd-core.c line 48.
> 
> I need two use two different parent resources. The mfd_add_devices()
> function doesn't support this.
I would still like you to use the mfd-core API. Here is my proposal:

1) I modify mfd_add_device() to support a NULL mem_base argument. When
mem_base is NULL, we would have:

res[r].parent = NULL and res[r].start = cell->resources[r].start;

The platform code will use iomem_resource as the parent for this resource.

2) Your mfd_cell cells would have 3 resources, and you just need to set the
IORESOURCE_MEM ones at probe time, with pci->resource[n]->start + offset as
the start field.

Would that make sense to you ?

> > > +	/* Onboard configuration registers */
> > > +	priv->ctrl = pci_ioremap_bar(dev, 4);
> > Why 4 ?
> > 
> > 
> 
> Because that is how the device works ;) There is a comment up above that
> describes them as the "PLX control registers". Are you suggesting that I
> add a comment here too?
No, that's ok, I missed the comment.

> > > +#define PCI_VENDOR_ID_JANZ		0x13c3
> > That probably belongs to pci_ids.h
> > 
> 
> Should I add a patch to the series for this?
Either that or merge the pci_ids.h changes with this patch.

Cheers,
Samuel.
 
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
