Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab1ISShK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:37:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932341Ab1ISShH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:37:07 -0400
Date: Mon, 19 Sep 2011 14:36:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [patch 1/2] kdump: Initialize vmcoreinfo note at startup
Message-ID: <20110919183656.GC3373@redhat.com>
References: <20110909102659.320220628@linux.vnet.ibm.com>
 <20110909102732.497569031@linux.vnet.ibm.com>
 <20110915184637.GF32658@redhat.com>
 <1316161277.3507.8.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316161277.3507.8.camel@br98xy6r>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 10:21:17AM +0200, Michael Holzheu wrote:
> Hello Vivek,
> 
> On Thu, 2011-09-15 at 14:46 -0400, Vivek Goyal wrote:
> > On Fri, Sep 09, 2011 at 12:27:00PM +0200, Michael Holzheu wrote:
> > > From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> > > 
> > > Currently the vmcoreinfo note is only initialized in case of kdump. On s390
> > > it is possible to create kernel dumps with other dump mechanisms than kdump
> > > (e.g. via hypervisor dump or stand-alone dump tools).
> > 
> > Both of these will be invoked through panic notifiers because kdump kernel
> > is not loaded?
> 
> This is only one possibility. The other is that they are invoked
> manually or by hypervisor watchdog without any Linux kernel involvement.
> 
> > 
> > >For those dumps it
> > > would also be desirable to include the vmcoreinfo data.
> > 
> > Curious that how these two dump schemes make use vmcoreinfo data?
> 
> We have a tool named zgetdump. With this tool it is possible to convert
> dump formats on the fly using fuse. E.g. you can mount a s390
> stand-alone dump as ELF dump. When this is done, the tool finds the
> vmcoreinfo in the stand-alone dump via our well known ABI defined
> address and it creates the respective VMCOREINFO ELF note in the output
> ELF dump. This then can be used e.g. by makedumpfile for dump filtering.
> No more need for a vmlinux file with debug information.

Ok, so you basically need it so that makedumpfile can do filtering without
debug info.

Well, if zgetdump is doing everything and you are stashing away an arch
specific pointer, I guss you could have saved pointer directly to
vmcoreinfo_data and then zgetdump could have made an ELF note out of it
for use of makedumpfile.

But anyway, having kernel exported the note does not harm.

> So this will look like the following:
> 
> # zgetdump --mount standalone.dump -f elf /mnt
> # ls /mnt
> # dump.elf
> # readelf -n /mnt/dump.elf
> # ...
>   VMCOREINFO		0x00000474	Unknown note type: (0x00000000)
> # makedumpfile -c -d 31 /mnt/dump.elf dump.kdump

If you can do this easily, then you really did not need kdump in kernel? 
Just use stand alone dump to take dump and then do this to filter dump.

But what happens to ELF headers which map kernel virtual address to
physical addresses? kexec-tools prepares those. So in this case when
you are capturing the dump, who prepares those? IOW, how does zgetdump
creates a mapping between kernel virtual and physical addresses?

Thanks
Vivek
