Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab1JKAPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 20:15:32 -0400
Received: from netrider.rowland.org ([192.131.102.5]:42274 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753885Ab1JKAPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 20:15:30 -0400
Date: Mon, 10 Oct 2011 20:15:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: "Munegowda, Keshava" <keshava_mgowda@ti.com>,
        Paul Walmsley <paul@pwsan.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <khilman@ti.com>, <b-cousson@ti.com>, <gadiyar@ti.com>,
        <sameo@linux.intel.com>, <parthab@india.ti.com>, <tony@atomide.com>,
        <johnstul@us.ibm.com>, <vishwanath.bs@ti.com>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
In-Reply-To: <20111010201055.GB8808@legolas.emea.dhcp.ti.com>
Message-ID: <Pine.LNX.4.44L0.1110102010310.28007-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Oct 2011, Felipe Balbi wrote:

> > > > In fact we do already have sibling lists.  They are maintained as part 
> > > > of the device_private structure.  What we are missing is a 
> > > > device_for_each_sibling() routine.  It could be added pretty easily; it 
> > > > would be similar to device_for_each_child().
> > > 
> > > care to point out where is ?
> > > 
> > > 68 struct device_private {
> > > 69         struct klist klist_children;
> > > 70         struct klist_node knode_parent;
> > -------------^  Here.  The "parent" in the name refers to where the
> >                 head of the list is stored.
> > 
> > > 71         struct klist_node knode_driver;
> > > 72         struct klist_node knode_bus;
> > > 73         void *driver_data;
> > > 74         struct device *device;
> > > 75 };
> > 
> > From device_add():
> > 
> > 	if (parent)
> > 		klist_add_tail(&dev->p->knode_parent,
> > 			       &parent->p->klist_children);
> 
> that's a parent -> child relationship. What we have on this case is:
> 
>  --------------                ---------------
> |              |              |               |          |\
> |   UHH        |  clocks, etc |    USBTLL     |          | |
> |              | <==========> |               | <======> | | <====> ports
> |     -------  |              | (Transceiver- |          | |
> |    |  EHCI | |              | less Link)    |          |/
> |     -------  |              |               |         Port MUX
> |              |              |               |
> |     -------  |              |               |
> |    |  OHCI | |              |               |
> |     -------  |              |               |
> |              |              |               |
>  --------------                ---------------
> 
> It doesn't shown here, but the TLL link is completely optional. It's
> mainly used for modem integration, IIRC. Still, if we're using TLL, EHCI
> and OHCI will depend on a clock provided by the USBTLL block.
> 
> Clearly, USBTLL isn't either a parent of UHH, nor a parent of EHCI/OHCI
> blocks. We can, from a code perspective, make USBTLL into a parent of
> UHH to make things simpler, but this will mean that calling
> pm_runtime_get() will also unconditionaly turn on TLL clock, unless we
> add some nasty hacks to allow TLL know if *HCI port is in TLL mode.
> 
> That's why I decided for making TLL and UHH siblings, because that's a
> closer relationship than parent-child.
> 
> Can you see the problem now ?

Okay, now I understand better.  The word "sibling" implies that the two 
objects have the same parent, so a different word would describe this 
relationship better.  Something like "friend" or "associate".

Or maybe, following Paul's suggestion, the driver core doesn't have to 
be changed at all.

Alan Stern

