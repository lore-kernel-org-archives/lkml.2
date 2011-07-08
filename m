Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab1GHJBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 05:01:46 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:33645 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab1GHJBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 05:01:43 -0400
Date: Fri, 8 Jul 2011 11:01:21 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
Message-ID: <20110708110121.5acfc3c9@mschwide>
In-Reply-To: <20110707193321.GE28850@redhat.com>
References: <20110704170922.976299676@linux.vnet.ibm.com>
 <20110705202615.GJ24348@redhat.com>
 <1309944287.3937.39.camel@br98xy6r>
 <20110707193321.GE28850@redhat.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jul 2011 15:33:21 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Wed, Jul 06, 2011 at 11:24:47AM +0200, Michael Holzheu wrote:
> > Hello Vivec,
> > 
> > On Tue, 2011-07-05 at 16:26 -0400, Vivek Goyal wrote:
> > > On Mon, Jul 04, 2011 at 07:09:22PM +0200, Michael Holzheu wrote:
> > 
> > [snip]
> > 
> > > I don't understand what is stand-alone dump tools and 
> > 
> > S390 stand-alone dump tools are independent mini operating systems that
> > are installed on disks or tapes. When a dump should be created, these
> > stand-alone dump tools are booted. All that they do is to write the dump
> > (current memory plus the CPU registers) to the disk/tape device.
> > 
> > The advantage compared to kdump is that since they are freshly loaded
> > into memory they can't be overwritten in memory.
> 
> > Another advantage is
> > that since it is different code, it is much less likely that the dump
> > tool will run into the same problem than the previously crashed kernel.
> 
> I think in practice this is not really a problem. If your kernel
> is not stable enough to even boot and copy a file, then most likely
> it has not even been deployed. The very fact that a kernel has been
> up and running verifies that it is a stable kernel for that machine
> and is capable of capturing the dump.

Yes, this is a theoretical consideration. In practice the kdump kernel will
work if it has not been corrupted.
 
> > Also the boot process ensures that the hardware is in a initialized
> > state.
> 
> Who makes sure that hardware is in initiliazed state? Kdump kernel,
> stand alone kernel or BIOS.

The machine does that on IPL. Call it the BIOS, although we use different
names for all that code that runs below the OS.

> > And last but not least, with the stand-alone dump tools you can
> > dump early kernel problems which is not possible using kdump, because
> > you can't dump before the kdump kernel has been loaded with kexec.
> > 
> 
> That is one limitation but again if your kernel can't even boot,
> it is not ready to ship and it is more of a development issue and
> there are other ways to debug problems. So I would not worry too
> much about it.
> 
> On a side note, few months back there were folks who were trying
> to enhance bootloaders to be able to prepare basic environment so
> that a kdump kernel can boot even in the event of early first
> kernel boot.

Well, here it is not only about the kernel code. The IPL could be
prevented by a setup problem as well. And if you can not get the system
to boot far enough to load the kdump kernel you are bust.
 
> > That were more or less the arguments, why we did not support kdump in
> > the past.
> > 
> > In order to increase dump reliability with kdump, we now implemented a
> > two stage approach. The stand-alone dump tools first check via meminfo,
> > if kdump is valid using checksums. If kdump is loaded and healthy it is
> > started. Otherwise the stand-alone dump tools create a full-blown
> > stand-alone dump.
> 
> kexec-tools purgatory code also checks the checksum of loaded kernel
> and other information and next kernel boot starts only if nothing
> has been corrupted in first kernel. So this additional meminfo strucutres
> and need of checksums sounds unnecessary. I think what you do need is
> that somehow invoking second hook (s390 specific stand alone kernel)
> in case primary kernel is corrupted.

Yes, but what do you do if the checksum tells you that the kexec kernel
has been compromised? If the independent stand-alone dumper does the
check it can fall back to the "dump-all" case.

> > 
> > With this approach we still keep our s390 dump reliability and gain the
> > great kdump features, e.g. distributor installer support, dump filtering
> > with makedumpfile, etc.
> > 
> > > why the existing
> > > mechanism of preparing ELF headers to describe all the above info
> > > and just passing the address of header on kernel commnad line
> > > (crashkernel=) will not work for s390. Introducing an entirely new
> > > infrastructure for communicating the same information does not
> > > sound too exciting.
> > 
> > We need the meminfo interface anyway for the two stage approach. The
> > stand-alone dump tools have to find and verify the kdump kernel in order
> > to start it.
> 
> kexec-tools does this verification already. We verify the checksum of
> all the loaded information in reserved area. So why introduce this
> meminfo interface.

Again, what do you do if the verification fails? Fail to dump the borked
system? Imho not a good option.

> > Therefore the interface is there and can be used. Also
> > creating the ELF header in the 2nd kernel is more flexible and easier
> > IMHO:
> > * You do not have to care about memory or CPU hotplug.
> 
> Reloading the kernel upon memory or cpu hotplug should be trivial. This
> does not justify to move away from standard ELF interface and creation
> of a new one.

We do not move away from the ELF interface, we just create the ELF headers
at a different time, no?

> > * You do not have to preallocate CPU crash notes etc.
> 
> Its a small per cpu area. Looks like otherwise you will create meminfo
> areas otherwise.

Probably doesn't matter.

> > * It works independently from the tool/mechanism that loads the kdump
> > kernel into memory. E.g. we have the idea to load the kdump kernel at
> > boot time into the crashkernel memory (not via the kexec_load system
> > call). That would solve the main kdump problems: The kdump kernel can't
> > be overwritten by I/O and also early kernel problems could then be
> > dumped using kdump.
> 
> Can you give more details how exactly it works. I know very little about
> s390 dump mechanism.

Before we started working on kdump the only way to get a dump is to boot
a stand-alone dumper. That is a small piece of assembler code that is
loaded into the first 64KB of memory (which is reserved for these kind of
things). This assembler code will then write everything to the dump device.
This works very reliable (which is of utmost importance to us) but has the
problem that it will be awfully slow for large memory sizes.
 
> When do you load kdump kernel and who does it?

If the crashed kernel is still operational enough to call panic it can
cause an IPL to the stand-alone dump tool (or do a reset of the I/O
subsystem and directly call kdump with the new code if the checksums
turn out ok).
If the crashed kernel is totally bust then the administrator has to do
a manual IPL from the disk where the stand-alone dumper has been installed.
 
> Who gets the control first after crash?

Depends. If the kernel can recognize the crash as such it can proceed to
execute the configured "on_panic" shutdown action. If the kernel is bust
the code loaded by the next IPL gets control. This can be a "normal" boot
or a stand-alone dumper.

> To me it looked like that you regularly load kdump kernel and if that
> is corrupted then somehow you boot standalone kernel. So corruption
> of kdump kernel should not be a issue for you.

It is the other way round. We load the standalone dumper, then check if
the kdump kernel looks good. Only if all the checksums turn out ok we
jump to the purgatory code from the standalone dump code.

> Do you load kdump kenrel from some tape/storage after system crash. Where
> does bootloader lies and how do you make sure it is not corrupted and
> associated device is in good condition.

The bootloader sits on the boot disk / tape. If you are able to boot from
that device then it is reasonable to assume that the device is in good
condition. To get a corrupted bootloader you'd need a stray I/O to that
device. The stand-alone dumper sits on its own disk / tape which is not in
use for normal operation. Very unlikely that this device will get hit.
 
> To me we should not create a arch specific way of passing information
> between kernels. Stand alone kernel should be able to parse the
> ELF headers which contains all the relevant info. They have already
> been checksum verified.

Ok, so this seems to be the main point of discussion. When to create the
ELF headers and how to pass all the required information from the crashed
system to the kdump kernel.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

