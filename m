Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab2K2Q0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 11:26:54 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:39098 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab2K2Q0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 11:26:53 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of: When constructing the bus id consider assigned-addresses as well
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <20121126182054.GA30177@obsidianresearch.com>
References: <20121121210240.GC15285@obsidianresearch.com> <20121126140316.99FE23E194B@localhost> <20121126182054.GA30177@obsidianresearch.com>
Date: Thu, 29 Nov 2012 16:26:48 +0000
Message-Id: <20121129162648.80DBC3E0912@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2012 11:20:54 -0700, Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
> On Mon, Nov 26, 2012 at 02:03:16PM +0000, Grant Likely wrote:
> > On Wed, 21 Nov 2012 14:02:40 -0700, Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
> > > 'assigned-addresses' is used for certain PCI device type nodes in
> > > lieu of 'reg',  since this is enforced by of/address.c, have
> > > of_device_make_bus_id look there as well.
> > > 
> > > Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> > 
> > If it is a PCI device, then of_device_make_bus_id() shouldn't come into
> > play. PCI devices already have their own naming scheme. Only
> > platform_bus device creation uses of_device_make_bus_id(). What am I
> > missing?
> 
> In my embedded case I have a complex PCI-E connected SOC device.
> 
> This is modeled in OF by having a PCI-E bus, a PCI-E device node, and
> then all of the SOC devices (I2C, GPIO, drivers, etc) placed under the
> PCI-E device node.
> 
> The PCI driver that matches the device just turns it on and calls
> of_platform_populate(..) with its own node as an argument.
> 
> So of_device_make_bus_id isn't called on a PCI-E device node, it is
> called on the platform_device children of that node, and due to the
> way the other code works, and what the OF rules seem to be, those
> childen all use assigned-addresses. Without this patch the code just
> assigns monotonic ids to those nodes.

Hmmm. okay that makes sense, but something still isn't quite right. So
of_translate_address should take care of drilling down through the bus
layers, and when it gets to the PCI node it /should/ use
of_bus_pci_translate to handle traversing down to the parent node (which
uses the 'assigned-addresses' for the pci node.

However, in your case, of_device_make_bus_id() isn't using that code
path and you're getting a generic name instead (with no relation to the
device address).  Correct?

If that is the case, then the solution is to figure out why
of_translate_address() doesn't currently handle your situation and fix
it. It is not a good idea to add assigned-addresses specific parsing
code to that function since that won't work for any of the other bus
types.

g.

