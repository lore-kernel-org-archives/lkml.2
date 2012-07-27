Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab2G0TIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 15:08:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:17920 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab2G0TIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 15:08:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="199064633"
Date: Fri, 27 Jul 2012 15:08:21 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Greg KH <greg@kroah.com>
Cc: Keith Busch <keith.busch@intel.com>, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] NVMe: Add a character device for each nvme device
Message-ID: <20120727190821.GO22985@linux.intel.com>
References: <1343407458-29909-1-git-send-email-keith.busch@intel.com>
 <20120727181212.GM22985@linux.intel.com>
 <20120727182546.GA23874@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120727182546.GA23874@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 11:25:46AM -0700, Greg KH wrote:
> On Fri, Jul 27, 2012 at 02:12:12PM -0400, Matthew Wilcox wrote:
> > I don't see a problem here, but I'm no expert at sysfs / character devices.
> > Alan, Greg, anyone else see any problems with how this character device is
> > created / destroyed?
> 
> Yes, see below:

Thanks!

> > > +	device_create(nvme_char_cl, NULL, MKDEV(nvme_char_major, dev->instance),
> > > +						NULL, "nvme%d", dev->instance);
> 
> You just created a device at the "root" of sysfs, which is wrong,
> especially when you do have a parent device here.  Please use it.

OK, that makes sense; this device should be the child of the pci_dev that
it belongs to.

> Also, why are you creating your own class?  Can't this just be a misc
> device?  And if you want to create your own class, please don't, use a
> bus, as that is what is really happening here, right?  We are trying to
> move away from using 'struct class' wherever possible (one of these days
> we'll just remove it...)

What we're trying to achieve here is to create one character device
per NVMe controller that gets plugged in.  Each NVMe controller is-a
PCI function.  The reason we're trying to do this is so that we can send
commands to the NVMe controller, even when there is no storage present
(eg a drive is shipped from the factory with no configured storage).

So we have no particular desire to create a new struct class, or struct
bus.  If we can create a misc device per PCIe function that's bound to our
driver, that's great!  Can you recommend a driver that does this already?
