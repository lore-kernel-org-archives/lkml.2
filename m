Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab1H3ST4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 14:19:56 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:50859 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755981Ab1H3STw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 14:19:52 -0400
X-Sasl-enc: sRBje0AQkLbK32zJacoZGN7WjUOIuS5OpknlzdpvISZ/ 1314728391
Date: Tue, 30 Aug 2011 11:19:45 -0700
From: Greg KH <greg@kroah.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: KY Srinivasan <kys@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 0000/0046] Staging: hv: Driver cleanup
Message-ID: <20110830181945.GC24865@kroah.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <20110830124856.GA17520@aepfle.de>
 <6E21E5352C11B742B20C142EB499E048081B5363@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110830174330.GE22868@kroah.com>
 <20110830180434.GA10090@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110830180434.GA10090@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 08:04:34PM +0200, Olaf Hering wrote:
> On Tue, Aug 30, Greg KH wrote:
> 
> > > > In my test system, the IDE drives are now discovered twice, once by
> > > > hv_storvsc and once by libata:
> > > 
> > > This is a known (old problem). The way this was handled earlier was to have the 
> > > modprobe rules in place to setup a dependency that would force the load of the
> > > hyper-v driver (blk / stor) ahead of the native driver and if the load of the PV
> > > driver succeeded, we would not load the native driver. In sles11 sp1, we had a rule for 
> > > loading blkvsc. With the merge of blkvsc and storvsc, the only change we need to make
> > > is to have storvsc in the rule (instaed of blkvsc).
> > 
> > Why do we need a rule at all?  Shouldn't the module dependancy stuff
> > handle the autoloading of the drivers properly from the initrd now that
> > the hotplug logic is hooked up properly?
> 
> There is no plan to load hv_vmbus (or xen-platform-pci) earlier than
> native drivers.

Wait, what do you mean by "native drivers"?

Isn't the hv_vmbus drivers the "native drivers" happening here?

Or are you referring to the "emulated-slow-as-hell drivers" that are
used to boot the machine?

> That was the purpose of the modprobe.conf files. Now
> that there is a vmbus, that fact could be checked before any other
> attempt to load drivers is made and hv_vmbus should be loaded and all of
> its devices have to be probed manually by modprobe `cat modulealias`.

I agree with the first part, but no modprobe should ever need to be
done, the hotplug boot process should properly load those modules when
the vmbus devices are seen by the vmbus core and the hotplug events
generated, which in turn calls modprobe, right?

So there should not need to be any special module.conf file changes for
hv systems, with the exception that the "emulated" drivers should be
added to the blacklist.

> > Or is the hotplug code not working correctly?
> 
> There is nothing to hotplug. hv_vmbus has to be loaded first so that it
> can take over the devices. But it seems that there is no shutdown of the
> emulated hardware, thats why the disk "sda" is shown twice.
> 
> I spot a flaw here.

I agree :)

> KY, can hv_vmbus shutdown emulated hardware? At least the disks, because
> cdroms are appearently still be handled by native drivers?

They are?  Ick, why can't the vmbus storage driver see a cdrom device?
It's just a scsi device, right?

thanks

greg k-h
