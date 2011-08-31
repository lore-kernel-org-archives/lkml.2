Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab1HaJMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 05:12:00 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:43750 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab1HaJL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 05:11:59 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFJhy0GFrI=
X-RZG-CLASS-ID: mo00
Date: Wed, 31 Aug 2011 11:11:56 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Greg KH <greg@kroah.com>
Cc: KY Srinivasan <kys@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 0000/0046] Staging: hv: Driver cleanup
Message-ID: <20110831091156.GA16104@aepfle.de>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <20110830124856.GA17520@aepfle.de>
 <6E21E5352C11B742B20C142EB499E048081B5363@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110830174330.GE22868@kroah.com>
 <20110830180434.GA10090@aepfle.de>
 <20110830181945.GC24865@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110830181945.GC24865@kroah.com>
User-Agent: Mutt/1.5.21.rev5535 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, Greg KH wrote:

> On Tue, Aug 30, 2011 at 08:04:34PM +0200, Olaf Hering wrote:
> > On Tue, Aug 30, Greg KH wrote:
> > 
> > > > > In my test system, the IDE drives are now discovered twice, once by
> > > > > hv_storvsc and once by libata:
> > > > 
> > > > This is a known (old problem). The way this was handled earlier was to have the 
> > > > modprobe rules in place to setup a dependency that would force the load of the
> > > > hyper-v driver (blk / stor) ahead of the native driver and if the load of the PV
> > > > driver succeeded, we would not load the native driver. In sles11 sp1, we had a rule for 
> > > > loading blkvsc. With the merge of blkvsc and storvsc, the only change we need to make
> > > > is to have storvsc in the rule (instaed of blkvsc).
> > > 
> > > Why do we need a rule at all?  Shouldn't the module dependancy stuff
> > > handle the autoloading of the drivers properly from the initrd now that
> > > the hotplug logic is hooked up properly?
> > 
> > There is no plan to load hv_vmbus (or xen-platform-pci) earlier than
> > native drivers.
> 
> Wait, what do you mean by "native drivers"?

native means drivers for emulated hardware: ata_piix, piix.

> Isn't the hv_vmbus drivers the "native drivers" happening here?
> Or are you referring to the "emulated-slow-as-hell drivers" that are
> used to boot the machine?

Not really. The virtual IDE controllers are emulated hardware, while the
virtual SCSI controllers are paravirtualized hardware. KY, correct my if
I'm wrong here.

> > That was the purpose of the modprobe.conf files. Now
> > that there is a vmbus, that fact could be checked before any other
> > attempt to load drivers is made and hv_vmbus should be loaded and all of
> > its devices have to be probed manually by modprobe `cat modulealias`.
> 
> I agree with the first part, but no modprobe should ever need to be
> done, the hotplug boot process should properly load those modules when
> the vmbus devices are seen by the vmbus core and the hotplug events
> generated, which in turn calls modprobe, right?

With the IDE disks, the module loading order matters because both
ata_piix/piix and hv_storvsc will bind to them. 
With the SCSI disks, only hv_storvsc will bind to them.
 
> So there should not need to be any special module.conf file changes for
> hv systems, with the exception that the "emulated" drivers should be
> added to the blacklist.

I agree, the modprobe.conf rules for hv should be removed. With this
patchset a rule to prevent ata_piix loading would hide all cdrom devices.

> > KY, can hv_vmbus shutdown emulated hardware? At least the disks, because
> > cdroms are appearently still be handled by native drivers?
> 
> They are?  Ick, why can't the vmbus storage driver see a cdrom device?
> It's just a scsi device, right?

The GUI does not seem to offer a way to attach an iso to a virtual SCSI
controller. It looks like one can add up to 4 SCSI controllers, each one
can have up to 64 disk images.
DVD devices can only be attached to the 2 virtual IDE controllers, one
can either attach iso images or physical hardware.


After some more testing it looks like the hv_blkvsc driver claimed the
ide major #3, so the ide_core could not bind to the emulated IDE
hardware. The modprobe.conf rules prevented that ata_piix gets loaded.
If I force a module load order of 'ata_piix ;hv_blkvsc' both ata_piix
and hv_blkvsc will bind to the same drive, just as shown in my previous
mail. So there is appearently no way to shutdown the IDE ports like it
is done with xen_emul_unplug= option for Xen guests.

Maybe some hack is needed for a hyper-v specific unplug if Windows does
indeed lack that feature. Now that ata_piix is compiled into the kernel,
there is nothing to a modprobe.conf rule can "fix".


Olaf
