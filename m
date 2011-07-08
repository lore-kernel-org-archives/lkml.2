Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab1GHNE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 09:04:28 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:49479 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab1GHNEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 09:04:25 -0400
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: oomichi@mxs.nes.nec.co.jp, linux-s390@vger.kernel.org,
        mahesh@linux.vnet.ibm.com, heiko.carstens@de.ibm.com,
        linux-kernel@vger.kernel.org, hbabu@us.ibm.com, horms@verge.net.au,
        ebiederm@xmission.com, schwidefsky@de.ibm.com,
        kexec@lists.infradead.org
In-Reply-To: <20110707193321.GE28850@redhat.com>
References: <20110704170922.976299676@linux.vnet.ibm.com>
	 <20110705202615.GJ24348@redhat.com>	<1309944287.3937.39.camel@br98xy6r>
	 <20110707193321.GE28850@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Fri, 08 Jul 2011 15:04:03 +0200
Message-ID: <1310130243.3508.230.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

On Thu, 2011-07-07 at 15:33 -0400, Vivek Goyal wrote:
> > Another advantage is
> > that since it is different code, it is much less likely that the dump
> > tool will run into the same problem than the previously crashed kernel.
> 
> I think in practice this is not really a problem. If your kernel
> is not stable enough to even boot and copy a file, then most likely
> it has not even been deployed. The very fact that a kernel has been
> up and running verifies that it is a stable kernel for that machine
> and is capable of capturing the dump.

I don't want to argue, about probabilities. Even if we gain only a
little more reliability this is important for us. Don't forget that we
write software for mainframes. We accept that the last 0.1 percent of
reliability can be very expensive compared to the first 99.9 percent.

[snip]

> > And last but not least, with the stand-alone dump tools you can
> > dump early kernel problems which is not possible using kdump, because
> > you can't dump before the kdump kernel has been loaded with kexec.
> > 
> 
> That is one limitation but again if your kernel can't even boot,
> it is not ready to ship and it is more of a development issue and
> there are other ways to debug problems. So I would not worry too
> much about it.

We worry about that. See the comment above regarding the 100 percent.

> On a side note, few months back there were folks who were trying
> to enhance bootloaders to be able to prepare basic environment so
> that a kdump kernel can boot even in the event of early first
> kernel boot.

This is one more argument to create the ELF header in the 2nd kernel.
With our approach loading the kdump kernel at boot time is almost
trivial.

Example (e.g. crashkernel=xxxM@256M):

1. The boot loader loads standard kernel and kdump kernel into memory.
The kdump kernel is loaded into crashkernel memory to 256M. No more
setup (e.g. creating ELF headers) is necessary.
2. We could add a kernel parameter "kexec_load=<segm addr>,<segm
size>, ..." that does an internal kexec_load(). After this kernel
parameter is processed, kdump is armed.

What do you think?

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
> has been corrupted in first kernel. 

Can you point me to the code where this is done and from where in the
kernel that code is called? Currently with our implementation we do not
use any purgatory code from kexec tools.

> So this additional meminfo strucutres
> and need of checksums sounds unnecessary. I think what you do need is
> that somehow invoking second hook (s390 specific stand alone kernel)
> in case primary kernel is corrupted.
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

Ok, where is this done and when?

> > Therefore the interface is there and can be used. Also
> > creating the ELF header in the 2nd kernel is more flexible and easier
> > IMHO:
> > * You do not have to care about memory or CPU hotplug.
> 
> Reloading the kernel upon memory or cpu hotplug should be trivial. This
> does not justify to move away from standard ELF interface and creation
> of a new one.
> 
> > * You do not have to preallocate CPU crash notes etc.
> 
> Its a small per cpu area. Looks like otherwise you will create meminfo
> areas otherwise.
> 
> > * It works independently from the tool/mechanism that loads the kdump
> > kernel into memory. E.g. we have the idea to load the kdump kernel at
> > boot time into the crashkernel memory (not via the kexec_load system
> > call). That would solve the main kdump problems: The kdump kernel can't
> > be overwritten by I/O and also early kernel problems could then be
> > dumped using kdump.
> 
> Can you give more details how exactly it works. I know very little about
> s390 dump mechanism.

Maybe I confused you here. What I wanted to describe is the following
idea:
1. The running production kernel starts with "crashkernel=" and reserves
memory for kdump. No kdump is loaded with kexec.
2. The system crashes
3. To create the dump, a prepared dump disk is booted. The boot loader
loads the kdump kernel into crashkernel memory.
4. The boot loader starts kdump kernel on s390 with entry point
<crashkernel base> + 0x10008
5. The kdump kernel creates ELF header etc...

So this is simple for the boot loader code because no preparation steps
like creating the ELF header are required. This is similar to scenario
of pre-loading the kdump kernel together with the standard kernel at
startup that I described above.

> 
> When do you load kdump kernel and who does it?

Currently we load the kdump kernel with kexec like it is done on all
other architectures. The other options I described above are currently
just ideas that we have for the future.

> Who gets the control first after crash?
> 
> To me it looked like that you regularly load kdump kernel and if that
> is corrupted then somehow you boot standalone kernel. So corruption
> of kdump kernel should not be a issue for you.

As Martin already said: It can be the other way round. The stand-alone
dump tool gets first control. We trust this code because it is freshly
loaded and has a different code base. This code verifies the kdump setup
and jumps into the pre-loaded kdump (crashkernel base + 0x10008) if
everything is ok. Otherwise it creates a traditional s390 dump.

> 
> Do you load kdump kenrel from some tape/storage after system crash. Where
> does bootloader lies and how do you make sure it is not corrupted and
> associated device is in good condition.
> 
> To me we should not create a arch specific way of passing information
> between kernels.

I agree that a common code solution would be better.

Michael

