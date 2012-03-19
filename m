Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284Ab2CSWq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:46:57 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52427 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab2CSWqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:46:54 -0400
Date: Mon, 19 Mar 2012 15:46:49 -0700
From: Gerard Snitselaar <dev@snitselaar.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, fmhess@users.sourceforge.net,
        abbotti@mev.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: comedi: resolve section mismatch in s626
Message-ID: <20120319224649.GA7679@perelman.Home>
Reply-To: Gerard Snitselaar <dev@snitselaar.org>
References: <1332123921-14347-1-git-send-email-dev@snitselaar.org>
 <20120319030925.GB22956@perelman.Home>
 <20120319163103.GC3694@kroah.com>
 <20120319164325.GA31833@perelman.Home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319164325.GA31833@perelman.Home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 09:43:25AM -0700, Gerard Snitselaar wrote:
> On Mon, Mar 19, 2012 at 09:31:03AM -0700, Greg KH wrote:
> > 
> > Ick, why is this loop even needed?  We are only here if the pci device
> > is present in the system so this shouldn't be needed at all, right?
> > 
> > Or is this a bit more complex than I am making it out to be?
> > 
> > greg k-h
> 
> Most likely not. I will take a look at some of the other drivers in
> comedi and see how the attach code looks there. I believe the code
> section in hpdi_attach() was written by the same person. Unfortunately
> I don't have a device to actually play around and see what changes are
> doing.
> 

I looked at this a bit more. It looks like they lose visibility to the
pci_dev structure.

*_probe() 
   comedi_pci_auto_config()     pci_dev
      comedi_auto_config()      pci_dev->dev
         comedi_device_attach() ??
            driv->attach()      ?? <= iterate through pci devices.

Most of the examples I have looked at so far use for_each_pci_dev() to
find the device, and s626 shortcuts it a bit by directly making calls
to pci_get_subsys() with specific ids. They all verify they have the
right device by checking the bus and slot that are grabbed from the
pci_dev in comedi_pci_auto_config() and passed down.

