Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab1DYAOC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 20:14:02 -0400
Received: from cantor.suse.de ([195.135.220.2]:49539 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757834Ab1DYAOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 20:14:01 -0400
Date: Sun, 24 Apr 2011 17:13:44 -0700
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <greg@kroah.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: Hyper-V vmbus driver
Message-ID: <20110425001344.GA7046@suse.de>
References: <6E21E5352C11B742B20C142EB499E0481C8D35@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110411190708.GA21355@suse.de>
 <20110423152055.GA29109@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481D3562@TK5EX14MBXC122.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481D3562@TK5EX14MBXC122.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 24, 2011 at 04:18:24PM +0000, KY Srinivasan wrote:
> > On Mon, Apr 11, 2011 at 12:07:08PM -0700, Greg KH wrote:
> > 
> > Due to other external issues, my patch backlog is still not gotten
> > through yet, sorry.  Sometimes "real life" intrudes on the best of
> > plans.
> > 
> > I'll get to this when I get through the rest of your hv patches, and the
> > other patches pending that I have in my queues.
> 
> Thanks Greg. The latest re-send of my hv patches are against the tree:
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6.git
> that I picked up on April 22, 2011.  I hope there won't be any issues
> this time around.

Me too :)

> > But, I would recommend you going through and looking at the code and
> > verifying that you feel the bus code is "ready".  At a very quick
> > glance, you should not have individual drivers have to set their 'struct
> > device' pointers directly, that is something that the bus does, not the
> > driver.  The driver core will call your bus and your bus will then do
> > the matching and call the probe function of the driver if needed.
> 
> Are you referring to the fact that in the vmbus_match function,
> the current code binds the device specific driver to the
> corresponding hv_device structure?

Yes, that's the problem (well, kind of the problem.)

You seem to be doing things a bit "odd" and that's due to the old way
the code was written.

First off, don't embed a struct bus_type in another structure, that's
not needed at all.  Why is that done?  Anyway...

In your vmbus_match function, you should be matching to see if your
device matches the driver that is passed to you.  You do this by looking
at some type of "id".  For the vmbus you should do this by looking at
the GUID, right?  And it looks like you do do this, so that's fine.

And then your vmbus_probe() function calls the driver probe function,
with the device it is to bind to.  BUT, you need to have your probe
function pass in the correct device type (i.e. struct hv_device, NOT
struct device.)

That way, your hv_driver will have a type all its own, with probe
functions that look nothing like the probe functions that 'struct
driver' has in it.  Look at 'struct pci_driver' for an example of this.
Don't try to overload the probe/remove/suspend/etc functions of your
hv_driver by using the "base" 'struct device_driver' callbacks, that's
putting knowledge of the driver core into the individual hv drivers,
where it's not needed at all.

And, by doing that, you should be able to drop your private pointer in
the hv_driver function completly, right?  That shouldn't be needed at
all.

> > See the PCI driver structure for an example of this if you are curious.
> > It should also allow you to get rid of that unneeded *priv pointer in
> > the struct hv_driver.
> 
> I am pretty sure, I can get rid of this. The way this code was originally
> structured, in the vmbus_match() function, you needed to get at the
> device specific driver pointer so that we could do the binding between
> the hv_device and the correspond device specific driver. The earlier code 
> depended on the structure layout to map a pointer to the hv_driver to
> the corresponding device specific driver (net, block etc.) To get rid of 
> this layout dependency, I introduced an addition field (priv) in the hv_driver.
> 
> There is, I suspect sufficient state available to:
> 
> (a) Not require the vmbus_match() function to do the binding.

No, you still want that, see above.

> (b) And to get at the device specific driver structure from the generic
>        driver structure without having to have an explicit mapping 
>        maintained in the   hv_driver structure.

Kind of, see above for more details.

If you want a good example, again, look at the PCI core code, it's
pretty simple in this area (hint, don't look at the USB code, it does
much more complex things than you want, due to things that the USB bus
imposes on devices, that's never a good example to look at.)

Hope this helps.  Please let me know if it doesn't :)

thanks,

greg k-h
