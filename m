Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1GROAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 10:00:51 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:59037 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab1GROAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 10:00:50 -0400
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
In-Reply-To: <20110718123140.GB31986@redhat.com>
References: <20110711175626.121dcc58@mschwide>
	 <20110713160239.GE4426@redhat.com> <20110713184611.6dcb09b4@mschwide>
	 <20110713200004.GG4426@redhat.com> <20110714091800.720da848@mschwide>
	 <20110714175532.GE6672@redhat.com> <20110714180528.GF6672@redhat.com>
	 <1310739717.10789.31.camel@br98xy6r> <20110715143820.GG3428@redhat.com>
	 <1310744603.10789.79.camel@br98xy6r>  <20110718123140.GB31986@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Mon, 18 Jul 2011 16:00:41 +0200
Message-ID: <1310997641.4427.10.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

On Mon, 2011-07-18 at 08:31 -0400, Vivek Goyal wrote:
> On Fri, Jul 15, 2011 at 05:43:23PM +0200, Michael Holzheu wrote:
> > > Or in first step we can keep it even simpler. We can spin in infinite
> > > loop
> > 
> > Looping is probably not a good option in a hypervisor environment like
> > we have it on s390. At least we should load a disabled wait PSW.
> 
> What is "disabled wait PSW"?

This is a PSW where interrupts are disabled and the wait bit is on. This
ensures that the virtual CPU is stopped and does not consume any CPU
time.
 
> > > In your case I think you shall have to do little more so that second
> > > kernel also seems some of the lower memory areas so that later swapping
> > > of kernel can be done.
> > 
> > After the swap the ELF header is contained in the same memory than the
> > kdump kernel. When the kdump kernel starts, the ELF header has to be
> > saved from being overwritten (as kernel and ramdisk). I get the address
> > from the "elfcorehdr=" kernel parameter. How will I get the size?
> 
> By parsing the ELF header. It will give you information about how many
> program headers and notes are there, their sizes and locations etc.

The only thing we need is the size of the preallocated header that is in
kdump memory. All other architectures seem to pass this information
somehow with different mechanisms to the kdump kernel (memmap kernel
parameter, boot parameters, etc.). Why should *we* parse the ELF header?

> When kexec-tools loads ELF headers, it knows what's the total size of
> ELF headers and it removes that chunk of memory from the memory map
> passed to second kernel with memmap= options. IOW, some memory out
> of reserved region is not usable by second kernel because we have
> stored information in that memory. Kdump kernel maps that memory and
> gets to read the ELF headers.
> 
> So you shall have to do something similar where you need to tell second
> kernel what memory areas it can use for boot and remove ELF header
> memory area from the map.

So if we do that, why should we parse the ELF header?

> > Looking at the ia64 and x86 implementations I have the feeling there are
> > different mechanism available to do that.
> > 
> > > 
> > > > 
> > > > On ia64 - if I understood the code correctly - they seem to pass a kdump
> > > > segment "EFI_memmap" to the kdump kernel that contains information about
> > > > all loaded kexec segments. With this segment they can find out the size
> > > > of the ELF header segment in the kdump kernel and then do the memory
> > > > reservation at boot time. Is that correct?
> > > 
> > > Sorry, I don't know the details of IA64. May be somebody else on the list
> > > can pitch in with some clarifications here.
> > 
> > For me it looks like a mechanism where a block of information is
> > prepared by kexec tools and a pointer to that block is passed somehow to
> > the second kernel. I would assume that the definition of this block is
> > ia64 kernel ABI. 
> 
> It is possible. Even in x86, we prepare a block of information, one
> 4K page and fill lots of x86 boot protocol information.
> 
> Look at.
> 
> kexec-tools/include/x86/x86-linux.h
> kexec-tools/kexec/arch/i386/x86-linux-setup.c
> 
> Above header information contains information about e820 memory map also
> and we fill that map info for normal kexec (fastboot, not kdump) also and
> that's how second kernel comes to know about memory map of system.
> 
> I think one could possibly truncate the same map for kdump kernel to
> tell second kernel about the memory to use. But IIRC, original memory
> map is also used to determine max_pfn present in first kernel so that
> in second kernel we don't try to map a memory beyond that and access
> it, etc. Hence it was decided to leave it that way and pass the memory
> map for second kernel on command line. 
> 
> So its possible that IA64 is doing preparing boot protocal specific
> block and passing all the releavant information in that block instead
> of making use of commnad line.

Just to come back to your initial argumentation against our meminfo
approach: It looks like that there are already other mechanisms besides
of ELF-header and kernel parameters to pass information to the kdump
kernel. Where is the conceptional difference to our meminfo interface?

Michael

