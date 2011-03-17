Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab1CQUN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 16:13:28 -0400
Received: from kroah.org ([198.145.64.141]:52608 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204Ab1CQUNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 16:13:25 -0400
Date: Thu, 17 Mar 2011 13:07:01 -0700
From: Greg KH <greg@kroah.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, dzickus@redhat.com
Subject: Re: [PATCH]: SMBIOS: Add initial code and export version via sysfs
Message-ID: <20110317200701.GB17827@kroah.com>
References: <20110317135754.25241.88177.sendpatchset@prarit.bos.redhat.com>
 <20110317193023.GA16790@kroah.com>
 <4D826718.3030001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D826718.3030001@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 03:55:04PM -0400, Prarit Bhargava wrote:
> 
> 
> On 03/17/2011 03:30 PM, Greg KH wrote:
> > On Thu, Mar 17, 2011 at 09:57:54AM -0400, Prarit Bhargava wrote:
> >   
> >> The existing DMI code, drivers/firmware/dmi.c, is not really parsing DMI.  It
> >> is actually SMBIOS code that is using the old DMI infrastructure to expose
> >> SMBIOS entries.
> >>
> >> We should be doing the following:
> >>
> >> 1.  Looking for SMBIOS (either EFI or mapped to it's standard location,
> >>     0xF0000)
> >> 2.  If found, look for the SMBIOS' Intermediate Structure (aka "DMI" entry)
> >> 3.  If not found, look for an "old" DMI structure.
> >>
> >> DMI is a predecessor of SMBIOS, so we should start treating it as such.
> >>     
> > Why?  What is this change going to buy us in the end?  Heck, right now,
> > what's the benefit?
> >   
> 
> It's wrong.  DMI doesn't give us SMBIOS information -- it's the other
> way around.  There's also a bunch of other stuff from SMBIOS being used
> in the kernel (see pci slots and hotplug drivers).
> 
> It would be nice to have a single place for this, no?

Ok, yes it would.

> >> For this patch I have introduced drivers/firmware/smbios.c, exported the
> >> SMBIOS version through sysfs, and modified the DMI code such that
> >>
> >> a) dmi_scan_machine() is now called from init_smbios(), and
> >> b) if an SMBIOS is found, the values in the SMBIOS STEP structure are used
> >> in dmi_scan_machine().
> >>
> >> Right now, removing the DMI code is not an option.  It is used by common
> >> initscripts, etc., to bringup the system.  Later modifications in this area will
> >> include additional parsing of the SMBIOS structs and a simultaneous cleanup
> >> of the DMI code.
> >>     
> > Care to show follow-on patches that convert things to a manner which you
> > think it should look like?
> >
> >   
> 
> I haven't written anything yet :) -- I was planning on exporting the
> SMBIOS structs (all types) though.

Sounds good, how are you going to do this?  In binary way (like efivars
does it) or in text files like the current DMI code does?

> >> --- /dev/null
> >> +++ b/drivers/firmware/smbios.c
> >> @@ -0,0 +1,175 @@
> >> +#include <linux/dmi.h>
> >> +#include <linux/efi.h>
> >> +#include <linux/init.h>
> >> +#include <linux/io.h>
> >> +#include <linux/kernel.h>
> >> +#include <linux/smbios.h>
> >> +
> >> +#include <asm/setup.h>
> >> +
> >> +int smbios_present = 0;
> >> +struct smbios_step *smbios_step;
> >> +static struct device *smbios_dev;
> >>     
> > A "raw" struct device?  Why?  You should never do this, that's not the
> > way to use a 'struct device'.
> >
> >   
> 
> Ah, okay -- my familiarity with sysfs is very minimal.  I'll ask on
> kernel-mentors for a pointer to "good" code.

It all depends on what you are trying to do.  What exactly are you
trying to achive?  What do you want to show in sysfs and how do you
expect it to look?

>From there we can then work backwards and create the code to do this.

thanks,

greg k-h
