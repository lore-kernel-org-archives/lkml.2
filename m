Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809Ab1D0LrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 07:47:08 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:50395 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758770Ab1D0LrE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 07:47:04 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Greg KH <greg@kroah.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
Thread-Topic: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
Thread-Index: AQHMBGnbOdiUysHbTUGr026Sn7cwwZRw2pzQgADfZgD//9dIkA==
Date: Wed, 27 Apr 2011 11:47:03 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481DD266@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <20110426232843.GA31184@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DD185@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110427064550.GA597@infradead.org>
In-Reply-To: <20110427064550.GA597@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, April 27, 2011 2:46 AM
> To: KY Srinivasan
> Cc: Greg KH; gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
> 
> On Wed, Apr 27, 2011 at 01:54:02AM +0000, KY Srinivasan wrote:
> > I would prefer that we go through the  review process. What is the process for
> > this review? Is there a time window for people to respond. I am hoping I will be
> able
> > to address all the review comments well in advance of the  next closing of the
> tree,
> > with the hope of taking the vmbus driver out of staging this go around (hope
> springs
> > eternal in the human breast ...)!
> 
> It would be useful if you'd send one driver at a time to the list as the
> full source to review.

> 
> Did we make any progress on the naming discussion?  In my opinion hv is
> a far to generic name for your drivers.  Why not call it mshv dor the
> driver directory and prefixes?

This topic was discussed at some great length back in Feb/March when I 
did a bunch of cleanup with regards how the driver and device data structures
were layered. At that point, the consensus was to keep the hv prefix.

> 
> As far as the core code is concerned, can you explain the use of the
> dev_add, dev_rm and cleanup methods and how they relate to the
> normal probe/remove/shutdown methods?

While I am currently cleaning up our block drivers, my goal this go around is to
work on getting the vmbus driver out of  staging. I am hoping when I am ready for
having you guys review the storage drivers, I will have dealt with the issues you
raise here.

> 
> As far as the storage drivers are concerned I still have issues with the
> architecture.  I haven't seen any good explanation why you want to  have
> the blkvsc and storvsc drivers different from each other.  They both
> speak the same vmbus-level protocol and tunnel scsi commands over it.
> Why would you sometimes expose this SCSI protocol as a SCSI LLDD and
> sometimes as a block driver?  What decides that a device is exported
> in a way to that blkvsc is bound to them vs storvsc?  How do they look
> like on the windows side?  From my understanding of the windows driver
> models both the recent storport model and the older scsiport model are
> more or less talking scsi to the driver anyway, so what is the
> difference between the two for a Windows guest?

I had written up a brief note that I had sent out setting the stage for the
first patch-set for cleaning up the block drivers. I am copying it here for your
convenience:

From: K. Y. Srinivasan <kys@microsoft.com>
Date: Tue, 22 Mar 2011 11:54:46 -0700
Subject: [PATCH 00/16] Staging: hv: Cleanup storage drivers - Phase I

This is first in a series of patch-sets aimed at cleaning up the storage
drivers for Hyper-V. Before I get into the details of this patch-set, I think
it is  useful to give a brief overview of the storage related front-end
drivers currently in the tree for Linux on Hyper-V:

On the host side, Windows emulates the  standard PC hardware
to permit hosting of fully virtualized operating systems.
To enhance disk I/O performance, we support a virtual block driver.
This block driver currently handles disks that have been setup as IDE
disks for the guest - as specified in the guest configuration.

On the SCSI side, we emulate a SCSI HBA. Devices configured
under the SCSI controller for the guest are handled via this
emulated HBA (SCSI front-end). So, SCSI disks configured for
the guest are handled through native SCSI upper-level drivers.
If this SCSI front-end driver is not loaded, currently, the guest
cannot see devices that have been configured as SCSI devices.
So, while the virtual block driver described earlier could potentially
handle all block devices, the implementation choices made on the host
will not permit it. Also, the only SCSI device that can be currently configured
for the guest is a disk device.

Both the block device driver (hv_blkvsc) and the SCSI front-end
driver (hv_storvsc) communicate with the host via unique channels 
that are implemented as bi-directional ring buffers. Each (storage) 
channel carries with it enough state to uniquely identify the device on
the host side. Microsoft has chosen to use SCSI verbs for this storage channel 
communication. 
 
> 
> Also pleae get rid of struct storvsc_driver_object, it's just a very
> strange way to store file-scope variables, and useless indirection
> for the I/O submission handler.
> 

I will do this as part of storage cleanup I am currently doing. Thank you
for taking the time to review the code.

Regards,

K. Y
