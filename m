Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab1GROUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 10:20:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415Ab1GROUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 10:20:17 -0400
Date: Mon, 18 Jul 2011 10:19:43 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
Message-ID: <20110718141943.GE31986@redhat.com>
References: <20110713184611.6dcb09b4@mschwide>
 <20110713200004.GG4426@redhat.com>
 <20110714091800.720da848@mschwide>
 <20110714175532.GE6672@redhat.com>
 <20110714180528.GF6672@redhat.com>
 <1310739717.10789.31.camel@br98xy6r>
 <20110715143820.GG3428@redhat.com>
 <1310744603.10789.79.camel@br98xy6r>
 <20110718123140.GB31986@redhat.com>
 <1310997641.4427.10.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310997641.4427.10.camel@br98xy6r>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 04:00:41PM +0200, Michael Holzheu wrote:
> Hello Vivek,
> 
> On Mon, 2011-07-18 at 08:31 -0400, Vivek Goyal wrote:
> > On Fri, Jul 15, 2011 at 05:43:23PM +0200, Michael Holzheu wrote:
> > > > Or in first step we can keep it even simpler. We can spin in infinite
> > > > loop
> > > 
> > > Looping is probably not a good option in a hypervisor environment like
> > > we have it on s390. At least we should load a disabled wait PSW.
> > 
> > What is "disabled wait PSW"?
> 
> This is a PSW where interrupts are disabled and the wait bit is on. This
> ensures that the virtual CPU is stopped and does not consume any CPU
> time.
>  
> > > > In your case I think you shall have to do little more so that second
> > > > kernel also seems some of the lower memory areas so that later swapping
> > > > of kernel can be done.
> > > 
> > > After the swap the ELF header is contained in the same memory than the
> > > kdump kernel. When the kdump kernel starts, the ELF header has to be
> > > saved from being overwritten (as kernel and ramdisk). I get the address
> > > from the "elfcorehdr=" kernel parameter. How will I get the size?
> > 
> > By parsing the ELF header. It will give you information about how many
> > program headers and notes are there, their sizes and locations etc.
> 
> The only thing we need is the size of the preallocated header that is in
> kdump memory. All other architectures seem to pass this information
> somehow with different mechanisms to the kdump kernel (memmap kernel
> parameter, boot parameters, etc.). Why should *we* parse the ELF header?

ELF headers and memmap parameters are communicating two different pieces
of information to second kenrel.

- memap tells what memory second kernel can use to boot.
- ELF headers tell what memory areas first kernel was using and using
  that information how to construct ELF headers for /proc/vmcore interface
  in second kernel. On x86, ELF headers also communicate where the saved
  cpu state is for the first kernel.

Arch independent code in kdump kenrel (fs/proc/vmcore.c) is parsing those
ELF headers to export /proc/vmcore. So if you set up the headers right
you get that arch independent code for free without any changes to generic
code.

*Why should you not try to use what is avaialble already*

> 
> > When kexec-tools loads ELF headers, it knows what's the total size of
> > ELF headers and it removes that chunk of memory from the memory map
> > passed to second kernel with memmap= options. IOW, some memory out
> > of reserved region is not usable by second kernel because we have
> > stored information in that memory. Kdump kernel maps that memory and
> > gets to read the ELF headers.
> > 
> > So you shall have to do something similar where you need to tell second
> > kernel what memory areas it can use for boot and remove ELF header
> > memory area from the map.
> 
> So if we do that, why should we parse the ELF header?

To know three things.

- Memory areas being used by first kernel.
- Cpu states at the time of crash of first kernel.
- Some config options exported by first kernel with the help of ELF notes.

fs/proc/vmcore.c already does it for you. You just need to make sure that
you tell it following.

- Where to find the headers in memory (elfcorehdr=)
- A way to map that memory and access contents.
- Make sure these headers are not overwritten by newly booted kernel.

[..]
> > It is possible. Even in x86, we prepare a block of information, one
> > 4K page and fill lots of x86 boot protocol information.
> > 
> > Look at.
> > 
> > kexec-tools/include/x86/x86-linux.h
> > kexec-tools/kexec/arch/i386/x86-linux-setup.c
> > 
> > Above header information contains information about e820 memory map also
> > and we fill that map info for normal kexec (fastboot, not kdump) also and
> > that's how second kernel comes to know about memory map of system.
> > 
> > I think one could possibly truncate the same map for kdump kernel to
> > tell second kernel about the memory to use. But IIRC, original memory
> > map is also used to determine max_pfn present in first kernel so that
> > in second kernel we don't try to map a memory beyond that and access
> > it, etc. Hence it was decided to leave it that way and pass the memory
> > map for second kernel on command line. 
> > 
> > So its possible that IA64 is doing preparing boot protocal specific
> > block and passing all the releavant information in that block instead
> > of making use of commnad line.
> 
> Just to come back to your initial argumentation against our meminfo
> approach: It looks like that there are already other mechanisms besides
> of ELF-header and kernel parameters to pass information to the kdump
> kernel. Where is the conceptional difference to our meminfo interface?

That's well defined boot-loader and kernel protocol to on x86. kexec-tools
is just another boot loader and it uses that block to fill the information
a normal boot loader will do.

So if you have s390 specific boot loader/kernel protocol and if you extend
that, I think that should still be fine. Just keep the code in kexec-tools
for filling up the information which s390 specific code can parse. In
that case we should not require any generic changes to either kexec-tools
or kernel code. All the protocol specific details should be well hidden
in arch specific code.

Thanks
Vivek
