Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab2DTBeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 21:34:20 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54190 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab2DTBeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 21:34:18 -0400
Date: Thu, 19 Apr 2012 18:34:11 -0700
From: Gerard Snitselaar <dev@snitselaar.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>
Subject: Re: [PATCH v2] staging: comedi: resolve section mismatch in s626
Message-ID: <20120420013411.GA3769@cantor.Home>
Reply-To: Gerard Snitselaar <dev@snitselaar.org>
Mail-Followup-To: Greg KH <gregkh@linuxfoundation.org>,
	Ian Abbott <abbotti@mev.co.uk>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Ian Abbott <ian.abbott@mev.co.uk>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>
References: <1332123921-14347-1-git-send-email-dev@snitselaar.org>
 <20120319030925.GB22956@perelman.Home>
 <20120319163103.GC3694@kroah.com>
 <20120319164325.GA31833@perelman.Home>
 <20120319224649.GA7679@perelman.Home>
 <20120319232656.GB6386@kroah.com>
 <4F798416.8040709@mev.co.uk>
 <20120410182438.GB2052@kroah.com>
 <4F86D294.3050108@mev.co.uk>
 <20120418232824.GA9419@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120418232824.GA9419@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed Apr 18 12, Greg KH wrote:
> On Thu, Apr 12, 2012 at 02:03:16PM +0100, Ian Abbott wrote:
> > On 2012/04/10 07:24 PM, Greg KH wrote:
> > >On Mon, Apr 02, 2012 at 11:48:54AM +0100, Ian Abbott wrote:
> > >>On 2012-03-19 23:26, Greg KH wrote:
> > >>>On Mon, Mar 19, 2012 at 03:46:49PM -0700, Gerard Snitselaar wrote:
> > >>>>I looked at this a bit more. It looks like they lose visibility to the
> > >>>>pci_dev structure.
> > >>>>
> > >>>>*_probe()
> > >>>>   comedi_pci_auto_config()     pci_dev
> > >>>>      comedi_auto_config()      pci_dev->dev
> > >>>>         comedi_device_attach() ??
> > >>>>            driv->attach()      ??<= iterate through pci devices.
> > >>>>
> > >>>>Most of the examples I have looked at so far use for_each_pci_dev() to
> > >>>>find the device, and s626 shortcuts it a bit by directly making calls
> > >>>>to pci_get_subsys() with specific ids. They all verify they have the
> > >>>>right device by checking the bus and slot that are grabbed from the
> > >>>>pci_dev in comedi_pci_auto_config() and passed down.
> > >>>
> > >>>Ugh, surely there's a way to keep the pci dev through the
> > >>>comedi_device_attach() call, right?
> > >>
> > >>comedi_device_attach() is also called for the COMEDI_DEVCONFIG ioctl
> > >>for "manually" configuring a comedi device, and that has no idea
> > >>about struct pci_dev, etc.
> > >>
> > >>I recently posted a series of patches that allows lower-level comedi
> > >>drivers to supply separate hooks for auto-configuring PCI devices or
> > >>USB devices without abusing the old "manual configuration" code
> > >>paths, see <http://driverdev.linuxdriverproject.org/pipermail/devel/2012-March/025331.html>.
> > >>
> > >>The old loop that searches the PCI bus is still needed for the
> > >>"manual configuration" code path.
> > >
> > >So, now that I've applied your patches, this patch isn't needed anymore,
> > >right?  Or should it be reworked to use the new interfaces?
> > 
> > I think it's still needed as that the comedi_driver->attach() hook
> > is still needed to support manual configuration by the
> > COMEDI_DEVCONFIG ioctl, and the existing code really shouldn't be
> > looking in s626_pci_table[] as it's tagged __devinitconst.
> > 
> > I never saw any mismatched section warnings when I compiled a
> > linux-next kernel on my system with a full set of comedi drivers,
> > even with CONFIG_DEBUG_SECTION_MISMATCH configured.  I'm not sure
> > why not, unless it has something to do with me building the kernel
> > with a separate build directory.
> 
> Yes, I don't see the mismatch either, so I'm not going to apply this
> patch, sorry, as I don't see what it is trying to fix at all.
> 
> greg k-h

I am getting an error when doing a build of the latest linux-next
before it gets to modpost so I need to look at that, but when I do an
allyesconfig build on master I get the following:

WARNING: drivers/staging/comedi/drivers/s626.o(.text+0x2ec8): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table
The function s626_attach() references
the variable __devinitconst s626_pci_table.
This is often because s626_attach lacks a __devinitconst 
annotation or the annotation of s626_pci_table is wrong.

WARNING: drivers/staging/comedi/drivers/s626.o(.text+0x2ece): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table
The function s626_attach() references
the variable __devinitconst s626_pci_table.
This is often because s626_attach lacks a __devinitconst 
annotation or the annotation of s626_pci_table is wrong.

WARNING: drivers/staging/comedi/drivers/s626.o(.text+0x2ed7): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table
The function s626_attach() references
the variable __devinitconst s626_pci_table.
This is often because s626_attach lacks a __devinitconst 
annotation or the annotation of s626_pci_table is wrong.

WARNING: drivers/staging/comedi/drivers/s626.o(.text+0x2edd): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table
The function s626_attach() references
the variable __devinitconst s626_pci_table.
This is often because s626_attach lacks a __devinitconst 
annotation or the annotation of s626_pci_table is wrong.
