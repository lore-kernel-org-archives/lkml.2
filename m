Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab2KPVdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 16:33:17 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52803 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab2KPVdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 16:33:15 -0500
Date: Fri, 16 Nov 2012 13:33:10 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>,
        linux-acpi@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com, lenb@kernel.org, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 0/3] acpi: Introduce prepare_remove device
 operation
Message-ID: <20121116213310.GA12925@kroah.com>
References: <1352974970-6643-1-git-send-email-vasilis.liaskovitis@profitbricks.com>
 <11897248.2VNutIHaJi@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11897248.2VNutIHaJi@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 10:17:17PM +0100, Rafael J. Wysocki wrote:
> On Thursday, November 15, 2012 11:22:47 AM Vasilis Liaskovitis wrote:
> > As discussed in https://patchwork.kernel.org/patch/1581581/
> > the driver core remove function needs to always succeed. This means we need
> > to know that the device can be successfully removed before acpi_bus_trim / 
> > acpi_bus_hot_remove_device are called. This can cause panics when OSPM-initiated
> > eject or driver unbind of memory devices fails e.g with:
> > 
> > echo 1 >/sys/bus/pci/devices/PNP0C80:XX/eject
> > echo "PNP0C80:XX" > /sys/bus/acpi/drivers/acpi_memhotplug/unbind
> > 
> > since the ACPI core goes ahead and ejects the device regardless of whether the
> > the memory is still in use or not.
> > 
> > For this reason a new acpi_device operation called prepare_remove is introduced.
> > This operation should be registered for acpi devices whose removal (from kernel
> > perspective) can fail.  Memory devices fall in this category.
> > A similar operation is introduced in bus_type to safely handle driver unbind
> > from the device driver core.
> > 
> > acpi_bus_hot_remove_device and driver_unbind are changed to handle removal in 2
> > steps:
> > - preparation for removal i.e. perform part of removal that can fail. Should
> >   succeed for device and all its children.
> > - if above step was successfull, proceed to actual device removal
> > 
> > With this patchset, only acpi memory devices use the new prepare_remove
> > device operation. The actual memory removal (VM-related offline and other memory
> > cleanups) is moved to prepare_remove. The old remove operation just cleans up
> > the acpi structures. Directly ejecting PNP0C80 memory devices works safely. I
> > haven't tested yet with an ACPI container which contains memory devices.
> > 
> > v1->v2:
> > - new patch to introduce bus_type prepare_remove callback. Needed to prepare
> > removal on driver unbinding from device-driver core.
> > - v1 patches 1 and 2 simplified and merged in one. acpi_bus_trim does not require
> > argument changes.
> > 
> > Comments welcome.
> > 
> > Vasilis Liaskovitis (3):
> >   driver core: Introduce prepare_remove in bus_type
> >   acpi: Introduce prepare_remove operation in acpi_device_ops
> >   acpi_memhotplug: Add prepare_remove operation
> > 
> >  drivers/acpi/acpi_memhotplug.c |   22 ++++++++++++++++++++--
> >  drivers/acpi/scan.c            |   21 ++++++++++++++++++++-
> >  drivers/base/bus.c             |   36 ++++++++++++++++++++++++++++++++++++
> >  include/acpi/acpi_bus.h        |    2 ++
> >  include/linux/device.h         |    2 ++
> >  5 files changed, 80 insertions(+), 3 deletions(-)
> 
> CCs of all driver core patches have to go to Greg Kroah-Hartman.

I previously rejected this, so I don't see why I would take it this time
around :(

Please, no driver core changes for acpi, I don't see why it is suddenly
so special to need stuff like this that can't just be done in the ACPI
bus code itself.

thanks,

greg k-h
