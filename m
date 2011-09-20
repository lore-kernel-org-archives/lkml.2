Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab1ITJEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 05:04:15 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:56640 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab1ITJEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 05:04:13 -0400
Subject: Re: [patch 1/2] kdump: Initialize vmcoreinfo note at startup
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20110919183656.GC3373@redhat.com>
References: <20110909102659.320220628@linux.vnet.ibm.com>
	 <20110909102732.497569031@linux.vnet.ibm.com>
	 <20110915184637.GF32658@redhat.com> <1316161277.3507.8.camel@br98xy6r>
	 <20110919183656.GC3373@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Tue, 20 Sep 2011 11:04:10 +0200
Message-ID: <1316509450.2793.32.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

On Mon, 2011-09-19 at 14:36 -0400, Vivek Goyal wrote:
> On Fri, Sep 16, 2011 at 10:21:17AM +0200, Michael Holzheu wrote:
> > > Curious that how these two dump schemes make use vmcoreinfo data?
> > 
> > We have a tool named zgetdump. With this tool it is possible to convert
> > dump formats on the fly using fuse. E.g. you can mount a s390
> > stand-alone dump as ELF dump. When this is done, the tool finds the
> > vmcoreinfo in the stand-alone dump via our well known ABI defined
> > address and it creates the respective VMCOREINFO ELF note in the output
> > ELF dump. This then can be used e.g. by makedumpfile for dump filtering.
> > No more need for a vmlinux file with debug information.
> 
> Ok, so you basically need it so that makedumpfile can do filtering without
> debug info.
> 
> Well, if zgetdump is doing everything and you are stashing away an arch
> specific pointer, I guss you could have saved pointer directly to
> vmcoreinfo_data and then zgetdump could have made an ELF note out of it
> for use of makedumpfile.

Yes that would also be an option. But still you have to initialize the
data at startup.

> But anyway, having kernel exported the note does not harm.

Correct.

> > So this will look like the following:
> > 
> > # zgetdump --mount standalone.dump -f elf /mnt
> > # ls /mnt
> > # dump.elf
> > # readelf -n /mnt/dump.elf
> > # ...
> >   VMCOREINFO		0x00000474	Unknown note type: (0x00000000)
> > # makedumpfile -c -d 31 /mnt/dump.elf dump.kdump
> 
> If you can do this easily, then you really did not need kdump in kernel? 
> Just use stand alone dump to take dump and then do this to filter dump.

For large systems we still need kdump to do the the filtering while
dumping. Currently with stand-alone dump tools we first have to dump all
the memory (which takes a long time) and afterwards do the filtering.

And with kdump we just can reuse all the installer stuff that is already
available.

> But what happens to ELF headers which map kernel virtual address to
> physical addresses? kexec-tools prepares those. So in this case when
> you are capturing the dump, who prepares those? IOW, how does zgetdump
> creates a mapping between kernel virtual and physical addresses?

On s390 we have a 1:1 mapping for the kernel. For the ELF header loads
created by zgetdump virtual=real.

I hope this answers your questions.

So do you agree now with the patch and give us your ACK?

Thanks
Michael

