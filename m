Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab0IGU3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 16:29:13 -0400
Received: from ns2.cypress.com ([157.95.67.5]:42778 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260Ab0IGU3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 16:29:10 -0400
Subject: Re: [PATCH] west bridge, cyasgadget fixes
From: David Cross <david.cross@cypress.com>
Reply-To: david.cross@cypress.com
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
In-Reply-To: <20100907124855.8ff2a789.randy.dunlap@oracle.com>
References: <1283888647.7250.28.camel@odc-laptop>
	 <20100907124855.8ff2a789.randy.dunlap@oracle.com>
Content-Type: text/plain
Organization: Cypress
Date: Tue, 07 Sep 2010 13:28:54 -0700
Message-Id: <1283891334.8865.4.camel@odc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-07 at 12:48 -0700, Randy Dunlap wrote:
> On Tue, 07 Sep 2010 12:44:07 -0700 David Cross wrote:
> 
> > This patch contains update to the gadget driver, some of which are based
> > on feedback from the Linux community concerning the usage of fat_get_block.
> > This function call has since been removed along with all file system 
> > specific calls.
> > It also contains some fixes for locking issues.
> > Please let me know if there are issues or concerns with this patch.
> > Thanks,
> > David
> > 
> > Signed-off-by: David Cross <david.cross@cypress.com>
> 
> 
> Is there a patch or patch series description where the west bridge is described?
The initial patch had a description of the device itself. I am repeating
it here for convenience:

This is a driver for the Cypress West Bridge companion chip. Its
function is analogous to the North/South Bridges of PC environments
applied to embedded devices, in that it expands I/O and storage
capabilities of an embedded processor. The Astoria version, which this
driver applies to, functions as a USB, embedded memory and SDIO
controller. The kernel that this patch was applied to is linux-2.6.35,
although it was tested using the android kernel 2.6.29 running on the
Zoom 2 platform. In this system, it was used primarily as a sideloading
accelerator enabling direct data transfers between a USB host PC and
embedded memory without system overheads. Minor modifications were also
made to the kernel for this patch. Another function, mpage_cleardirty
was also added to the memory management code. This function is used to
clear the dirty pages from a specific inode. This allows for direct,
file based DMA. None of these changes are believed to have any negative
impact on the kernel and may provide additional benefit for other
developers and drivers. The driver, as submitted, was placed into the
drivers/staging/westbridge folder as the directory structure it will
eventually reside in is not yet defined. The driver, as placed in
staging is divided into four parts:
1) gadget - this implements a gadget peripheral controller and includes
IOCTLs for MTP transfers
2) block -this implements a generic block device driver to enable access
to embedded memory
3) api -this is the Cypress SDK, and includes USB and Storage specific
functions. In addition, it includes common code for low level routines
such as message passing and common data transfer routines
4) hal - this should likely be included in the arch directory as it
needs to be modified for a given platform. The directory structure in
the staging area is meant to reflect the eventual location of where this
code likely should be. It is platform specific. In this case, the HAL
included is for the Android Zoom 2 platform. Here, West Bridge is
connected to the GPMC (general purpose memory controller) of the OMAP3.
Specific timing needs to be enabled to ensure reliable communication.

> I'm asking mostly because some of the code (in the block driver patch)
> looks like it should be in userspace, so I'm wondering why it's in the kernel tree?

Can you please be more specific concerning what you think should be in
userspace?

> 
> > diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/gadget/cyasgadget.c linux-next-incl-sdk/drivers/staging/westbridge/astoria/gadget/cyasgadget.c
> > --- linux-next-vanilla/drivers/staging/westbridge/astoria/gadget/cyasgadget.c	2010-08-31 19:32:51.000000000 -0700
> > +++ linux-next-incl-sdk/drivers/staging/westbridge/astoria/gadget/cyasgadget.c	2010-09-07 11:12:44.000000000 -0700
> > @@ -154,7 +154,7 @@ static void cy_as_gadget_usb_event_callb
> >  		#ifndef WESTBRIDGE_NDEBUG
> >  		ctrlreq = (struct usb_ctrlrequest *)evdata;
> >  
> > -		cy_as_hal_print_message("<1>_cy_as_event_usb_setup_packet "
> > +		printk(KERN_INFO "<1>_cy_as_event_usb_setup_packet "
> 
> Drop the "<1>" ??
> 
> But lots of these are purely debug messages anyway, and shouldn't be printed
> with printk(KERN_INFO ...)
> 
You are probably right on both counts, I can change this for the next patch.
The current version in linux-next has both of these issues already
though, so I am not sure if it makes sense to redo this patch just for
these items.

> >  							"received"
> >  							"bRequestType=0x%x,"
> >  							"bRequest=0x%x,"
> 
thanks,
david


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

