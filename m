Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab1GRMcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 08:32:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab1GRMb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 08:31:59 -0400
Date: Mon, 18 Jul 2011 08:31:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
Message-ID: <20110718123140.GB31986@redhat.com>
References: <20110711175626.121dcc58@mschwide>
 <20110713160239.GE4426@redhat.com>
 <20110713184611.6dcb09b4@mschwide>
 <20110713200004.GG4426@redhat.com>
 <20110714091800.720da848@mschwide>
 <20110714175532.GE6672@redhat.com>
 <20110714180528.GF6672@redhat.com>
 <1310739717.10789.31.camel@br98xy6r>
 <20110715143820.GG3428@redhat.com>
 <1310744603.10789.79.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310744603.10789.79.camel@br98xy6r>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 05:43:23PM +0200, Michael Holzheu wrote:
> Hello Vivek,
> 
> On Fri, 2011-07-15 at 10:38 -0400, Vivek Goyal wrote:
> > > > In user space I think one can modify the kexec-tools infrastrucuture a
> > > > bit so that one is able to define an entry point in case checksum of
> > > > loaded segment failes. Once you are loding kdump kernel, you can define
> > > > that entry point. (And this would be jump to IPL etc.).
> > > 
> > > You mean to jump back into the crashed kernel code in case the kdump
> > > checksum failed?
> > 
> > No. I meant jump to entry point so that one can IPL the dump tools. I
> > am not sure how do initiate the IPL after panic. Similar thing needs
> > to be done here. If it is as simple as jumping to some location in
> > low memory, then purgatory should be able to do that. I think we
> > shall have to figure out the details here.
> 
> We have a machine instruction to IPL a dump tool from a device. The
> parameters (e.g. device number, or WWPN/LUN for SCSI devices) are
> currently configured via a s390 sysfs interface and an etc config file.
> In theory we could read the sysfs files or the config file from the
> kexec tool and patch the parameters into the purgatory code. The user
> would then have to restart kexec each time when the configuration is
> changed.

I think reading WWPN/LUN of scsi device from /sys and patching purgatory
makes sense. I think restarting kexec-tools on device set/change should
not be a big problem. There area already many events now when a user
is supposed to do that.

> 
> > Basically I am saying that purgatory detected that kdump kernel is
> > corrupted. In x86_64 we spin in inifinite loop as we don't have a
> > backup plan. But s390 has a backup plan of being able to IPL dump
> > tools.
> > 
> > Or in first step we can keep it even simpler. We can spin in infinite
> > loop
> 
> Looping is probably not a good option in a hypervisor environment like
> we have it on s390. At least we should load a disabled wait PSW.

What is "disabled wait PSW"?

> 
> > and wait for either hypervisor watchdog to kick in for automatic
> > IPL or wait for operator intervention.
> > That would simplify it even
> > further. 
> > > 
> > > In the meantime I was looking a bit more into the kexec code to find
> > > out, what we would have to do, if we use the preallocated ELF header as
> > > you want us to do. With our actual solution, we do not have to reserve
> > > any special areas for the kdump kernel. Now we have to reserve the ELF
> > > header. So what are the options?
> > 
> > ELF headers go into same memory area as kdump kenrel.
> 
> sure
> 
> > Anyway you are
> > doing to reserve memory for kdump kernel and ELF headers will go 
> > right there.
> > Once you swap the kernel I think ELF headers continue to remain in
> > original location. Or may be you can move ELF headers too depending
> > on what turns out to be easier.
> > 
> > > 
> > > The x86 implementation uses a kernel parameter "memmap=exactmap" to do
> > > that.
> > 
> > It tells second kernel to use a memory map defined on command line.
> > Kexec-tools prepares this memory map with the help of memap= options. This
> > is to limit the memory second kernel use to boot into so that it does not
> > overwrite in any piece of memory used by first kernel.
> 
> And to reserve the ELF header that is prepared by kexec tools, no?

Kind of. It just tells second kernel what memory can be used for boot. ELF
headers prepared by kexec-tools are part of that memory so that second
kernel can map that memory and can read the ELF headers and figure
out the layout of memory as seen by first kernel. These headers also
save the cpu state and bunch of kernel config options.

> 
> > In your case I think you shall have to do little more so that second
> > kernel also seems some of the lower memory areas so that later swapping
> > of kernel can be done.
> 
> After the swap the ELF header is contained in the same memory than the
> kdump kernel. When the kdump kernel starts, the ELF header has to be
> saved from being overwritten (as kernel and ramdisk). I get the address
> from the "elfcorehdr=" kernel parameter. How will I get the size?

By parsing the ELF header. It will give you information about how many
program headers and notes are there, their sizes and locations etc.

When kexec-tools loads ELF headers, it knows what's the total size of
ELF headers and it removes that chunk of memory from the memory map
passed to second kernel with memmap= options. IOW, some memory out
of reserved region is not usable by second kernel because we have
stored information in that memory. Kdump kernel maps that memory and
gets to read the ELF headers.

So you shall have to do something similar where you need to tell second
kernel what memory areas it can use for boot and remove ELF header
memory area from the map.

 
> Looking at the ia64 and x86 implementations I have the feeling there are
> different mechanism available to do that.
> 
> > 
> > > 
> > > On ia64 - if I understood the code correctly - they seem to pass a kdump
> > > segment "EFI_memmap" to the kdump kernel that contains information about
> > > all loaded kexec segments. With this segment they can find out the size
> > > of the ELF header segment in the kdump kernel and then do the memory
> > > reservation at boot time. Is that correct?
> > 
> > Sorry, I don't know the details of IA64. May be somebody else on the list
> > can pitch in with some clarifications here.
> 
> For me it looks like a mechanism where a block of information is
> prepared by kexec tools and a pointer to that block is passed somehow to
> the second kernel. I would assume that the definition of this block is
> ia64 kernel ABI. 

It is possible. Even in x86, we prepare a block of information, one
4K page and fill lots of x86 boot protocol information.

Look at.

kexec-tools/include/x86/x86-linux.h
kexec-tools/kexec/arch/i386/x86-linux-setup.c

Above header information contains information about e820 memory map also
and we fill that map info for normal kexec (fastboot, not kdump) also and
that's how second kernel comes to know about memory map of system.

I think one could possibly truncate the same map for kdump kernel to
tell second kernel about the memory to use. But IIRC, original memory
map is also used to determine max_pfn present in first kernel so that
in second kernel we don't try to map a memory beyond that and access
it, etc. Hence it was decided to leave it that way and pass the memory
map for second kernel on command line. 

So its possible that IA64 is doing preparing boot protocal specific
block and passing all the releavant information in that block instead
of making use of commnad line.

Thanks
Vivek
