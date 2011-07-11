Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab1GKOnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:43:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229Ab1GKOnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:43:17 -0400
Date: Mon, 11 Jul 2011 10:42:55 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
Message-ID: <20110711144255.GE30674@redhat.com>
References: <20110704170922.976299676@linux.vnet.ibm.com>
 <20110705202615.GJ24348@redhat.com>
 <1309944287.3937.39.camel@br98xy6r>
 <20110707193321.GE28850@redhat.com>
 <20110708110121.5acfc3c9@mschwide>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708110121.5acfc3c9@mschwide>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 11:01:21AM +0200, Martin Schwidefsky wrote:

[..]
> > 
> > kexec-tools purgatory code also checks the checksum of loaded kernel
> > and other information and next kernel boot starts only if nothing
> > has been corrupted in first kernel. So this additional meminfo strucutres
> > and need of checksums sounds unnecessary. I think what you do need is
> > that somehow invoking second hook (s390 specific stand alone kernel)
> > in case primary kernel is corrupted.
> 
> Yes, but what do you do if the checksum tells you that the kexec kernel
> has been compromised? If the independent stand-alone dumper does the
> check it can fall back to the "dump-all" case.

So this independent dump (which takes the decision whether to continue
to boot kdump kernel or stand alone dumper) is loaded where?  On x86,
every thing is loaded in crashkernel memory and at run time we update
purgatory with entry point of kernel.

I guess you could write s390 specific purgatory code where you do
the checksum on loaded kdump kernel and if it corrupted, then you
can continue to jump to boot stand alone kernel.

BTW, you seem to have capability of doing IPL of stand alone kernel
from disk/tape after kernel crash. If yes, then why not IPL the
regular linux kernel in case its copy in memory is corrupted.

What happens if kdump kernel is not corrupted and later it fails to boot
due to some platform issue or device driver issue etc? I am assuming
that dump capture will fail. If yes, then backup mechanism is designed
only to protect against kdump kernel's corruption while loaded in
memory?

In Michael's doc, I noticed he talked about unmapping the crashkernel
memory so that kernel. That should protect against kernel but he
mentioned about the possibility of device being able to DMA to said
memory reason. I am wondering that is it possible to program IOMMU
in such a way that any DMA attempt to said memory reason fails. If
yes, then I guess corruption problem will be solved without one
being worried about crating a backup plan for stand alone kernel and
one can just focus on making kdump kernel work.

> 
> > > 
> > > With this approach we still keep our s390 dump reliability and gain the
> > > great kdump features, e.g. distributor installer support, dump filtering
> > > with makedumpfile, etc.

So reliability only comes from the fact that stand alone kernel is booted
from the disk? So as long as kdump kernel is not corrupted, it is as
realiable as stand alone kernel?

How many a time in practice we have run into kdump kernel corruption
issues? Will unmapping from kernel page tables and doing something at
IOMMU level not take care of that issue?

> > > 
> > > > why the existing
> > > > mechanism of preparing ELF headers to describe all the above info
> > > > and just passing the address of header on kernel commnad line
> > > > (crashkernel=) will not work for s390. Introducing an entirely new
> > > > infrastructure for communicating the same information does not
> > > > sound too exciting.
> > > 
> > > We need the meminfo interface anyway for the two stage approach. The
> > > stand-alone dump tools have to find and verify the kdump kernel in order
> > > to start it.

kexec-tools purgatory code already has the checksum logic. So you don't
have to redo that in stand alone tools. I think you probably need to
s390 specic purgatory and jump to IPLing stand alone kernel if kdump
kernel is corrupted instead of rebooting back or spinning infinitely
in the loop/

> > 
> > kexec-tools does this verification already. We verify the checksum of
> > all the loaded information in reserved area. So why introduce this
> > meminfo interface.
> 
> Again, what do you do if the verification fails? Fail to dump the borked
> system? Imho not a good option.

On regular systems we did not have any backup plan so IIRC, we spin in
infinite loop. 

If one can do something about it, fine. But this again takes me back to
original question, then instead of creating backup plan, why not IPL
the kdump kernel from disk/tape the way you do for stand alone kernels.

> 
> > > Therefore the interface is there and can be used. Also
> > > creating the ELF header in the 2nd kernel is more flexible and easier
> > > IMHO:
> > > * You do not have to care about memory or CPU hotplug.
> > 
> > Reloading the kernel upon memory or cpu hotplug should be trivial. This
> > does not justify to move away from standard ELF interface and creation
> > of a new one.
> 
> We do not move away from the ELF interface, we just create the ELF headers
> at a different time, no?

Existing kernel already provides a way to communicate relevant information
to new kernel/binary about the first kernel and that is through ELF. You
are moving away from that and creating one more interface, meminfo to
get all the info about first kernel. What's wrong with continue parsing
ELF to get all the needed info. Is there any piece of information missing
which you require?

> 
> > > * You do not have to preallocate CPU crash notes etc.
> > 
> > Its a small per cpu area. Looks like otherwise you will create meminfo
> > areas otherwise.
> 
> Probably doesn't matter.
> 
> > > * It works independently from the tool/mechanism that loads the kdump
> > > kernel into memory. E.g. we have the idea to load the kdump kernel at
> > > boot time into the crashkernel memory (not via the kexec_load system
> > > call). That would solve the main kdump problems: The kdump kernel can't
> > > be overwritten by I/O and also early kernel problems could then be
> > > dumped using kdump.

So looks like you are loading two kernels at a time. One primary kernel
and other kernel in crashkernel memory area. But that would solve only
early crash dump problem and not the corruption problem?

I think we are trying to solve multiple problems at one go. We want
the regular capability to boot a kdump kernel and also solve the problem
of eary boot crash.

Why not solve the bigger problem in first step (and that is capturing
filtered dump of big RAM systems fast) and do the integration with
regular kexec-tools (create ELF headers etc) and s390 specific purgatory
code. 

Once all this is done, then you can look at how to capture early 
kernel crashes (if it turns out to be a real problem).

> > 
> > Can you give more details how exactly it works. I know very little about
> > s390 dump mechanism.
> 
> Before we started working on kdump the only way to get a dump is to boot
> a stand-alone dumper. That is a small piece of assembler code that is
> loaded into the first 64KB of memory (which is reserved for these kind of
> things). This assembler code will then write everything to the dump device.
> This works very reliable (which is of utmost importance to us) but has the
> problem that it will be awfully slow for large memory sizes.

When and who loads this assembler code into memory and how do we make
sure this code is not corrupted.

I got the part about being slow because you have to write specific
drivers for saving dump and you don't have filtering capabilty. In
today's big memory systems it makes sense to reuse kdump's capability
to use first kernel's drivers and filtering in user space.

>  
> > When do you load kdump kernel and who does it?
> 
> If the crashed kernel is still operational enough to call panic it can
> cause an IPL to the stand-alone dump tool (or do a reset of the I/O
> subsystem and directly call kdump with the new code if the checksums
> turn out ok).
> If the crashed kernel is totally bust then the administrator has to do
> a manual IPL from the disk where the stand-alone dumper has been installed.
>  
> > Who gets the control first after crash?
> 
> Depends. If the kernel can recognize the crash as such it can proceed to
> execute the configured "on_panic" shutdown action. If the kernel is bust
> the code loaded by the next IPL gets control. This can be a "normal" boot
> or a stand-alone dumper.
> 
> > To me it looked like that you regularly load kdump kernel and if that
> > is corrupted then somehow you boot standalone kernel. So corruption
> > of kdump kernel should not be a issue for you.
> 
> It is the other way round. We load the standalone dumper, then check if
> the kdump kernel looks good. Only if all the checksums turn out ok we
> jump to the purgatory code from the standalone dump code.

Ok. So again why not reuse the checksump capability of kexec-tools and
instead of infinite looping you can jump to stand alone tools + IPL etc.
I understand this will require a tighter integration with kexec-tools
and using ELF header mechanism and will not cover the early kernel
crashes.

> 
> > Do you load kdump kenrel from some tape/storage after system crash. Where
> > does bootloader lies and how do you make sure it is not corrupted and
> > associated device is in good condition.
> 
> The bootloader sits on the boot disk / tape. If you are able to boot from
> that device then it is reasonable to assume that the device is in good
> condition. To get a corrupted bootloader you'd need a stray I/O to that
> device. The stand-alone dumper sits on its own disk / tape which is not in
> use for normal operation. Very unlikely that this device will get hit.
>  
> > To me we should not create a arch specific way of passing information
> > between kernels. Stand alone kernel should be able to parse the
> > ELF headers which contains all the relevant info. They have already
> > been checksum verified.
> 
> Ok, so this seems to be the main point of discussion. When to create the
> ELF headers and how to pass all the required information from the crashed
> system to the kdump kernel.

To me we seem to be diverging a lot from existing kdump+kexec-tools
mechanism just to solve the case of early crash dumping. If we break
down the problem in two parts and do thing kexec-tools way (with a
backup path of booting stand alone kernel if kdump kenrel is corrupted),
things might be better.

Thanks
Vivek
