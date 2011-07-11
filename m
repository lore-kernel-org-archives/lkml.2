Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab1GKP5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 11:57:06 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:50487 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757966Ab1GKP5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 11:57:03 -0400
Date: Mon, 11 Jul 2011 17:56:26 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
Message-ID: <20110711175626.121dcc58@mschwide>
In-Reply-To: <20110711144255.GE30674@redhat.com>
References: <20110704170922.976299676@linux.vnet.ibm.com>
	<20110705202615.GJ24348@redhat.com>
	<1309944287.3937.39.camel@br98xy6r>
	<20110707193321.GE28850@redhat.com>
	<20110708110121.5acfc3c9@mschwide>
	<20110711144255.GE30674@redhat.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011 10:42:55 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Fri, Jul 08, 2011 at 11:01:21AM +0200, Martin Schwidefsky wrote:
> 
> [..]
> > > 
> > > kexec-tools purgatory code also checks the checksum of loaded kernel
> > > and other information and next kernel boot starts only if nothing
> > > has been corrupted in first kernel. So this additional meminfo strucutres
> > > and need of checksums sounds unnecessary. I think what you do need is
> > > that somehow invoking second hook (s390 specific stand alone kernel)
> > > in case primary kernel is corrupted.
> > 
> > Yes, but what do you do if the checksum tells you that the kexec kernel
> > has been compromised? If the independent stand-alone dumper does the
> > check it can fall back to the "dump-all" case.
> 
> So this independent dump (which takes the decision whether to continue
> to boot kdump kernel or stand alone dumper) is loaded where?  On x86,
> every thing is loaded in crashkernel memory and at run time we update
> purgatory with entry point of kernel.

The dasd stand-alone dumper is loaded into the first 64KB of memory that
is specifically left unused for a tool like that. It is our "if all breaks
use that one" dumper. It is written in assembler and is really small,
currently its size is 8KB.

> I guess you could write s390 specific purgatory code where you do
> the checksum on loaded kdump kernel and if it corrupted, then you
> can continue to jump to boot stand alone kernel.

Basically yes, with the current implementation is a pre-purgatory piece
of code that is included into the dumper. After the checksums turn out
ok it branches to the purgatory code.

> BTW, you seem to have capability of doing IPL of stand alone kernel
> from disk/tape after kernel crash. If yes, then why not IPL the
> regular linux kernel in case its copy in memory is corrupted.

We played with the idea to load the kdump kernel into its designated
area and make the startup code recognize this situation. It then swaps
the memory starting at zero with the kdump memory area. We need to do
that because on s390 all kernels start at zero (and that is not easy
to change). The trouble here is that we would have to set up a boot
disk with the exact kdump area memory address for each system. 
This is a) error prone and b) our customers are used to have a single
dump device for all their servers on a single system. 

> What happens if kdump kernel is not corrupted and later it fails to boot
> due to some platform issue or device driver issue etc? I am assuming
> that dump capture will fail. If yes, then backup mechanism is designed
> only to protect against kdump kernel's corruption while loaded in
> memory?

The kdump kernel is limited in it functionality. Yes it is bigger than
the stand-alone dumper but it is still very small compared to a production
system. As in 256 MB of memory, one disk, probably a single network
connection. The likelihood of a failure is indeed bigger compared to the
stand-alone dumper, you basically trade a bit of reliability for advanced
functions (like dump to network) and speed thanks to filtering. With the
checksum the reliability should be really good though.

> In Michael's doc, I noticed he talked about unmapping the crashkernel
> memory so that kernel. That should protect against kernel but he
> mentioned about the possibility of device being able to DMA to said
> memory reason. I am wondering that is it possible to program IOMMU
> in such a way that any DMA attempt to said memory reason fails. If
> yes, then I guess corruption problem will be solved without one
> being worried about crating a backup plan for stand alone kernel and
> one can just focus on making kdump kernel work.

We unmap the crashkernel from the kernel address space to make it harder
to corrupt the kdump kernel with a wild pointer. The only way how the
crashkernel can go bad is via DMA. I/O addresses are absolute, with a
bad address you can overwrite any piece of memory. Thats why we want that
check-summing mechanism before passing control to anything that has been
in memory at the time of the crash.

> > 
> > > > 
> > > > With this approach we still keep our s390 dump reliability and gain the
> > > > great kdump features, e.g. distributor installer support, dump filtering
> > > > with makedumpfile, etc.
> 
> So reliability only comes from the fact that stand alone kernel is booted
> from the disk? So as long as kdump kernel is not corrupted, it is as
> realiable as stand alone kernel?

Yes, reliability comes from a fresh IPL/boot. It resets everything to a sane
state and we can then collect the memory content. As long as you don't get
fancy with kdump (e.g. with dump to network), a checksum verified kdump
kernel should be close to the stand-alone dumper as far as reliability is
concerned.

> How many a time in practice we have run into kdump kernel corruption
> issues? Will unmapping from kernel page tables and doing something at
> IOMMU level not take care of that issue?

Well as we do not use kdump at customer sites yet we do not have a lot of
practice with it. But we did have a few real cases with broken I/O going
on a rampage.

> > > > 
> > > > > why the existing
> > > > > mechanism of preparing ELF headers to describe all the above info
> > > > > and just passing the address of header on kernel commnad line
> > > > > (crashkernel=) will not work for s390. Introducing an entirely new
> > > > > infrastructure for communicating the same information does not
> > > > > sound too exciting.
> > > > 
> > > > We need the meminfo interface anyway for the two stage approach. The
> > > > stand-alone dump tools have to find and verify the kdump kernel in order
> > > > to start it.
> 
> kexec-tools purgatory code already has the checksum logic. So you don't
> have to redo that in stand alone tools. I think you probably need to
> s390 specic purgatory and jump to IPLing stand alone kernel if kdump
> kernel is corrupted instead of rebooting back or spinning infinitely
> in the loop/

I can not quite follow you here. The purgatory code is part of the kdump kernel,
no? When we trigger a dump with the stand-alone tools we will start executing
code in the assembler function of that stand-alone tools. We can not trust
the kdump kernel yet, not without doing the checksums first.

> > > 
> > > kexec-tools does this verification already. We verify the checksum of
> > > all the loaded information in reserved area. So why introduce this
> > > meminfo interface.
> > 
> > Again, what do you do if the verification fails? Fail to dump the borked
> > system? Imho not a good option.
> 
> On regular systems we did not have any backup plan so IIRC, we spin in
> infinite loop. 

Even worse, going to an infinite loop is VERY bad. One of the things we will
do after the checksum of the kdump kernel turned out ok is to write to some
field in the kdump kernel to invalidate the checksum. If we crash again the
stand-alone dumper will find the checksum to be bad the second time around.
No infinite loop here.

> If one can do something about it, fine. But this again takes me back to
> original question, then instead of creating backup plan, why not IPL
> the kdump kernel from disk/tape the way you do for stand alone kernels.

As outlined above it is basically a setup issue.

> > 
> > > > Therefore the interface is there and can be used. Also
> > > > creating the ELF header in the 2nd kernel is more flexible and easier
> > > > IMHO:
> > > > * You do not have to care about memory or CPU hotplug.
> > > 
> > > Reloading the kernel upon memory or cpu hotplug should be trivial. This
> > > does not justify to move away from standard ELF interface and creation
> > > of a new one.
> > 
> > We do not move away from the ELF interface, we just create the ELF headers
> > at a different time, no?
> 
> Existing kernel already provides a way to communicate relevant information
> to new kernel/binary about the first kernel and that is through ELF. You
> are moving away from that and creating one more interface, meminfo to
> get all the info about first kernel. What's wrong with continue parsing
> ELF to get all the needed info. Is there any piece of information missing
> which you require?

I'll have to discuss this with Michael once more. 
 
> > 
> > > > * You do not have to preallocate CPU crash notes etc.
> > > 
> > > Its a small per cpu area. Looks like otherwise you will create meminfo
> > > areas otherwise.
> > 
> > Probably doesn't matter.
> > 
> > > > * It works independently from the tool/mechanism that loads the kdump
> > > > kernel into memory. E.g. we have the idea to load the kdump kernel at
> > > > boot time into the crashkernel memory (not via the kexec_load system
> > > > call). That would solve the main kdump problems: The kdump kernel can't
> > > > be overwritten by I/O and also early kernel problems could then be
> > > > dumped using kdump.
> 
> So looks like you are loading two kernels at a time. One primary kernel
> and other kernel in crashkernel memory area. But that would solve only
> early crash dump problem and not the corruption problem?

That would solve both the early crash dump problem and the I/O corruption
problem -- if we would know where we can load the kdump kernel.
Remember: one stand-alone dump disk for all the servers in a server farm.
They might have different kdump memory area addresses.

> I think we are trying to solve multiple problems at one go. We want
> the regular capability to boot a kdump kernel and also solve the problem
> of eary boot crash.
> 
> Why not solve the bigger problem in first step (and that is capturing
> filtered dump of big RAM systems fast) and do the integration with
> regular kexec-tools (create ELF headers etc) and s390 specific purgatory
> code. 

Consider that problem solved. kdump support for s390 is just around the
corner.

> Once all this is done, then you can look at how to capture early 
> kernel crashes (if it turns out to be a real problem).

The patches to solve the early kernel crash / I/O corruption are on the table.
It is just the order of the patches in the set we are talking about, no?

> > > 
> > > Can you give more details how exactly it works. I know very little about
> > > s390 dump mechanism.
> > 
> > Before we started working on kdump the only way to get a dump is to boot
> > a stand-alone dumper. That is a small piece of assembler code that is
> > loaded into the first 64KB of memory (which is reserved for these kind of
> > things). This assembler code will then write everything to the dump device.
> > This works very reliable (which is of utmost importance to us) but has the
> > problem that it will be awfully slow for large memory sizes.
> 
> When and who loads this assembler code into memory and how do we make
> sure this code is not corrupted.

A fresh IPL / boot does that.

> I got the part about being slow because you have to write specific
> drivers for saving dump and you don't have filtering capabilty. In
> today's big memory systems it makes sense to reuse kdump's capability
> to use first kernel's drivers and filtering in user space.

That is exactly what we are trying to achieve.
 
> >  
> > > When do you load kdump kernel and who does it?
> > 
> > If the crashed kernel is still operational enough to call panic it can
> > cause an IPL to the stand-alone dump tool (or do a reset of the I/O
> > subsystem and directly call kdump with the new code if the checksums
> > turn out ok).
> > If the crashed kernel is totally bust then the administrator has to do
> > a manual IPL from the disk where the stand-alone dumper has been installed.
> >  
> > > Who gets the control first after crash?
> > 
> > Depends. If the kernel can recognize the crash as such it can proceed to
> > execute the configured "on_panic" shutdown action. If the kernel is bust
> > the code loaded by the next IPL gets control. This can be a "normal" boot
> > or a stand-alone dumper.
> > 
> > > To me it looked like that you regularly load kdump kernel and if that
> > > is corrupted then somehow you boot standalone kernel. So corruption
> > > of kdump kernel should not be a issue for you.
> > 
> > It is the other way round. We load the standalone dumper, then check if
> > the kdump kernel looks good. Only if all the checksums turn out ok we
> > jump to the purgatory code from the standalone dump code.
> 
> Ok. So again why not reuse the checksump capability of kexec-tools and
> instead of infinite looping you can jump to stand alone tools + IPL etc.
> I understand this will require a tighter integration with kexec-tools
> and using ELF header mechanism and will not cover the early kernel
> crashes.

Imho the checksum of kexec-tools is in the wrong place.

> > 
> > > Do you load kdump kenrel from some tape/storage after system crash. Where
> > > does bootloader lies and how do you make sure it is not corrupted and
> > > associated device is in good condition.
> > 
> > The bootloader sits on the boot disk / tape. If you are able to boot from
> > that device then it is reasonable to assume that the device is in good
> > condition. To get a corrupted bootloader you'd need a stray I/O to that
> > device. The stand-alone dumper sits on its own disk / tape which is not in
> > use for normal operation. Very unlikely that this device will get hit.
> >  
> > > To me we should not create a arch specific way of passing information
> > > between kernels. Stand alone kernel should be able to parse the
> > > ELF headers which contains all the relevant info. They have already
> > > been checksum verified.
> > 
> > Ok, so this seems to be the main point of discussion. When to create the
> > ELF headers and how to pass all the required information from the crashed
> > system to the kdump kernel.
> 
> To me we seem to be diverging a lot from existing kdump+kexec-tools
> mechanism just to solve the case of early crash dumping. If we break
> down the problem in two parts and do thing kexec-tools way (with a
> backup path of booting stand alone kernel if kdump kenrel is corrupted),
> things might be better.

The "backup path of booting stand alone kernel" would result in passing
the control twice, once from the stand-alone dumper to the kexec purgatory
(after the purgatory checksum has been verified), then doing more checks 
in the kdump kernel, only to return to the stand-alone dumper if some check
fails. Does not really sound enticing to me.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

