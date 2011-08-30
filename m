Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab1H3Rnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 13:43:52 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:57048 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755868Ab1H3Rnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 13:43:49 -0400
X-Sasl-enc: u1JEayGa6LYwPtHlcf0V5FeqP4Pl0CSxrGh5dUuE4XZ1 1314726228
Date: Tue, 30 Aug 2011 10:43:30 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: Olaf Hering <olaf@aepfle.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 0000/0046] Staging: hv: Driver cleanup
Message-ID: <20110830174330.GE22868@kroah.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <20110830124856.GA17520@aepfle.de>
 <6E21E5352C11B742B20C142EB499E048081B5363@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048081B5363@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 05:22:54PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Olaf Hering [mailto:olaf@aepfle.de]
> > Sent: Tuesday, August 30, 2011 8:49 AM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org
> > Subject: Re: [PATCH 0000/0046] Staging: hv: Driver cleanup
> > 
> > On Sat, Aug 27, K. Y. Srinivasan wrote:
> > 
> > > 	2) Handle all block devices using the storvsc driver. I have modified
> > > 	   the implementation here based on Christoph's feedback on my earlier
> > > 	   implementation.
> > 
> > The upgrade path from hv_blkvsc to hv_storvsc is difficult.
> > 
> > hv_storvsc does not provide the vmbus:hv_block modalias, so mkinitrd
> > does not know what module to choose when mkinitrd is called in a
> > previous kernel (like sles11sp1).
> > 
> > 
> > In a guest with both SCSI and IDE controllers the IDE disks are
> > discovered first, so the SCSI drives will also change their names.
> > Thats not a problem for data partitions because they could be mounted by
> > UUID or LABEL in fstab.
> > But its difficult to adjust /boot/grub/device.map for example because
> > the old  IDE drives do not provide an identifier. What is the best way
> > to make sure the rename from hd* to sd* in such config files is done
> > correctly? Is it safe to assume that all drives with a class_id of
> > 32412632-86cb-44a2-9b5c50d1417354f5 are connected to IDE ports?
> 
> The class_id is invariant as we are returning the guid of the device under class_id.
> 
> So, if you see a IDE guid under class_id, you can be sure (a) it is an ide device and (b)
> it is a device managed via the PV drivers.
> 
> > 
> > localhost:~ # head /sys/bus/vmbus/devices/vmbus_0_{1,2,3,10,11}/class_id
> > ==> /sys/bus/vmbus/devices/vmbus_0_1/class_id <==
> > {32412632-86cb-44a2-9b5c50d1417354f5}
> > 
> > ==> /sys/bus/vmbus/devices/vmbus_0_2/class_id <==
> > {32412632-86cb-44a2-9b5c50d1417354f5}
> > 
> > ==> /sys/bus/vmbus/devices/vmbus_0_3/class_id <==
> > {32412632-86cb-44a2-9b5c50d1417354f5}
> > 
> > ==> /sys/bus/vmbus/devices/vmbus_0_10/class_id <==
> > {ba6163d9-04a1-4d29-b60572e2ffb1dc7f}
> > 
> > ==> /sys/bus/vmbus/devices/vmbus_0_11/class_id <==
> > {ba6163d9-04a1-4d29-b60572e2ffb1dc7f}
> > 
> > 
> > In my test system, the IDE drives are now discovered twice, once by
> > hv_storvsc and once by libata:
> 
> This is a known (old problem). The way this was handled earlier was to have the 
> modprobe rules in place to setup a dependency that would force the load of the
> hyper-v driver (blk / stor) ahead of the native driver and if the load of the PV
> driver succeeded, we would not load the native driver. In sles11 sp1, we had a rule for 
> loading blkvsc. With the merge of blkvsc and storvsc, the only change we need to make
> is to have storvsc in the rule (instaed of blkvsc).

Why do we need a rule at all?  Shouldn't the module dependancy stuff
handle the autoloading of the drivers properly from the initrd now that
the hotplug logic is hooked up properly?

What am I missing here?

Or is the hotplug code not working correctly?

greg k-h
