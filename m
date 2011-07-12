Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab1GLRaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 13:30:13 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:54412 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab1GLRaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 13:30:11 -0400
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: oomichi@mxs.nes.nec.co.jp, linux-s390@vger.kernel.org,
        mahesh@linux.vnet.ibm.com, heiko.carstens@de.ibm.com,
        linux-kernel@vger.kernel.org, hbabu@us.ibm.com, horms@verge.net.au,
        ebiederm@xmission.com, schwidefsky@de.ibm.com,
        kexec@lists.infradead.org
In-Reply-To: <20110711153625.GF30674@redhat.com>
References: <20110704170922.976299676@linux.vnet.ibm.com>
	 <20110705202615.GJ24348@redhat.com> <1309944287.3937.39.camel@br98xy6r>
	 <20110707193321.GE28850@redhat.com> <1310130243.3508.230.camel@br98xy6r>
	 <20110711153625.GF30674@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Tue, 12 Jul 2011 19:29:49 +0200
Message-ID: <1310491789.3665.512.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

On Mon, 2011-07-11 at 11:36 -0400, Vivek Goyal wrote:
> > > On a side note, few months back there were folks who were trying
> > > to enhance bootloaders to be able to prepare basic environment so
> > > that a kdump kernel can boot even in the event of early first
> > > kernel boot.
> > 
> > This is one more argument to create the ELF header in the 2nd kernel.
> > With our approach loading the kdump kernel at boot time is almost
> > trivial.
> 
> I think ELF header is just the way of passing some required information
> from first kernel to second kernel. In second kernel, we anyway prepare
> fresh headers for /proc/vmcore.
> 
> So in your mechanism if you don't need any info from second kernel it
> is fine to not use ELF. But if you do need, then it makes sense to
> use existing mechanism instead of creating a new one (seems to be
> meminfo in your case).

Ok fine. Let's concentrate on the information that we have to pass from
the old to the new kernel. We have two ways to start the dump mechanism
to consider. First, direct call to kdump from the crashed system and
second, the detour via the stand-alone dump. In both cases we need the
following information from the old kernel:
* Pointer to vmcoreinfo
* Pointer to reboot (re-IPL) information (s390 specific)
* Boot CPU registers

The vmcoreinfo pointer is required for creating the vmcoreinfo ELF note
that is used afterwards by tools like makedumpfile.

The reboot information is required to ensure that a reboot of the kdump
kernel will restart the original production system.

The boot CPU registers are needed for the ELF CPU note of the IPL CPU. 

CPU registers of non-boot CPUs and the memory layout can be determined
in the 2nd kernel on s390.

Now let's see how we can transfer that information for the two cases we
have:

Case 1: Direct call via panic()

More or less we could do it the same way as on x86. The kexec tool
prepares the ELF header with ELF notes for vmcoreinfo, s390 reboot
information, ELF loads for the memory areas, and the containers for the
CPU notes. Panic writes the CPU registers to the prepared location and
jumps to purgatory code. Purgatory code start loaded kdump kernel with
"elfcorehdr=" parameter.

Case 2: Indirect call via stand-alone dump

When the stand-alone dump is started, it knows nothing about the crashed
system. We need to pass at least the address of the kdump entry point
and the address of the ELF header at a well defined location in order to
start kdump from the stand-alone dump tool. So it think we still need
something like meminfo.

To convert case 2 to the ELF header approach, we now would need to do
something like the following in the stand-alone tools code:
* Verify that kdump kernel is present.
* Save all non-boot CPU registers and then copy the registers of all
CPUs to the prepared ELF Notes. To do that the tools need to parse the
ELF header and to find the location of the required ELF notes.
* Call purgatory entry point.

We cannot trust anything in memory including the purgatory code. To
verify that the purgatory code is unmodified, we need the address and
the length of purgatory together with the checksum.

The s390 reboot information is *already* stored at a well defined
location that is used today by the stand-alone dump tools to reboot the
production system after dump (independent from kdump). This information
is protected by a checksum as well and is needed for the backup case
reboot, if we do not have a pre-loaded kdump or the purgatory checksum
fails.

In the following I describe the changes that (I think) I have to do, if
we switch to the ELF header communication.

1st kernel (crashed production system)
--------------------------------------
* Add information about kdump/purgatory entry point, address of ELF
header, purgatory start, length and checksum at some well defined
address so that stand-alone dump tools can find it.
* Communicate re-IPL block via ELF header:
  - Either new ELF note: Add /sys/kernel/s390_reboot_info with
    address of re-IPL info block 
  - Or perhaps add re-IPL block pointer to vmcoreinfo
* Fill CPU registers into ELF notes at crash time and call purgatory
* If purgatory returns, stop machine.

kexec tools
-----------
* Create and load ELF header + purgatory
* Create new ELF NOTE for s390 re-IPL info. Maybe not required,
  if we use vmcoreinfo.
* Change purgatory code:
  - Checksum failed: Return to caller instead of looping?
  - Checksum ok: jump to crashk base + 0x10008 and start kdump

2nd kernel (kdump)
------------------
* Prevent ELF header memory from being overwritten (how do we get the
ELF header size?)
* Parse ELF header and/or vmcoreinfo to get s390 re-IPL info

Stand-alone dump tools:
-----------------------
* Find ELF header, purgatory start/length/checksum, and kdump entry
point (meminfo?)
* Verify the purgatory.
* Parse ELF header and find location of pre-allocated ELF notes to store
CPU register sets.
* Jump to purgatory.
* If purgatory returns, write stand-alone dump.

Is that something that you had in mind? IMHO this does not eliminate the
need of something like meminfo. Also we have to consider that the
stand-alone dump tools are written in assembler and it is always hard to
add complex code here.

But perhaps I just can't see the forest for the trees and you have a
better idea?

Michael

