Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab2AISgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 13:36:48 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:62697 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab2AISgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 13:36:46 -0500
Date: Mon, 9 Jan 2012 13:34:14 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Michael Buesch <m@bues.ch>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Incorrect uses of get_driver()/put_driver()
Message-ID: <20120109183414.GB1287@phenom.dumpdata.com>
References: <Pine.LNX.4.44L0.1201091133400.1541-100000@iolanthe.rowland.org>
 <Pine.LNX.4.44L0.1201091202090.1541-100000@iolanthe.rowland.org>
 <20120109174836.GA32181@phenom.dumpdata.com>
 <20120109182045.GG15083@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120109182045.GG15083@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F0B3392.00BE,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 10:20:45AM -0800, Dmitry Torokhov wrote:
> On Mon, Jan 09, 2012 at 12:48:36PM -0500, Konrad Rzeszutek Wilk wrote:
> > On Mon, Jan 09, 2012 at 12:35:09PM -0500, Alan Stern wrote:
> > > The get_driver() and put_driver() routines in the device core are not
> > > documented well, and what they really do is quite different from what
> > > people might think they do.  In particular, get_driver() does not
> > > prevent a driver from being unregistered or unloaded -- the API which 
> > > comes closest to doing that is try_module_get().
> > > 
> > > In fact, get_driver() and put_driver() are pretty much useless for
> > > normal purposes, and Dmitry and I have been discussing getting rid of
> > > them entirely.  But first we need to make sure that doing so won't mess
> > > anything up.
> > > 
> > > The purpose of this email is to check with the maintainers of the
> > > various drivers that seem to be using these routines in questionable
> > > ways, to make sure nothing will go wrong.  Here are the places we have 
> > > identified:
> > > 
> > > lib/dma-debug.c:173:  drv = get_driver(dev->driver);
> > > lib/dma-debug.c:188:  put_driver(drv);
> > > 
> > > Joerg, these calls don't seem to do anything, as far as I can tell.  
> > > Is there any reason to keep them?
> > > 
> > > drivers/pci/xen-pcifront.c:596:       if (get_driver(&pdrv->driver)) {
> > > drivers/pci/xen-pcifront.c:626:               put_driver(&pdrv->driver);
> > > 
> > > Konrad, these calls don't seem to do anything either.
> > > 
> > 
> > Looks like they should be replaced with the try_module_get() equivalant
> > for the 'struct pci_driver'? Is there such one?
> 
> You seem to need stronger guarantees that the driver simply present in
> memory. You need to make sure that the driver you fetched is kept being
> bound to the device for entire duration of pcifront_common_process().

OK, any suggestions?
