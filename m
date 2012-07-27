Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab2G0SZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 14:25:50 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46539 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441Ab2G0SZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 14:25:49 -0400
X-Sasl-enc: BAZBvo+plubMPbK2a1Y/9BDd9HPfsQDwKdpuY9AZJKde 1343413548
Date: Fri, 27 Jul 2012 11:25:46 -0700
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Keith Busch <keith.busch@intel.com>, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] NVMe: Add a character device for each nvme device
Message-ID: <20120727182546.GA23874@kroah.com>
References: <1343407458-29909-1-git-send-email-keith.busch@intel.com>
 <20120727181212.GM22985@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120727181212.GM22985@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 02:12:12PM -0400, Matthew Wilcox wrote:
> On Fri, Jul 27, 2012 at 10:44:18AM -0600, Keith Busch wrote:
> > Registers a character device for the nvme module and creates character
> > files as /dev/nvmeN for each nvme device probed, where N is the device
> > instance. The character devices support nvme admin ioctl commands so
> > that nvme devices without namespaces can be managed.
> 
> I don't see a problem here, but I'm no expert at sysfs / character devices.
> Alan, Greg, anyone else see any problems with how this character device is
> created / destroyed?

Yes, see below:

> > +	device_create(nvme_char_cl, NULL, MKDEV(nvme_char_major, dev->instance),
> > +						NULL, "nvme%d", dev->instance);

You just created a device at the "root" of sysfs, which is wrong,
especially when you do have a parent device here.  Please use it.

Also, why are you creating your own class?  Can't this just be a misc
device?  And if you want to create your own class, please don't, use a
bus, as that is what is really happening here, right?  We are trying to
move away from using 'struct class' wherever possible (one of these days
we'll just remove it...)

thanks,

greg k-h
