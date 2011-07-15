Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab1GOOib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 10:38:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab1GOOia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 10:38:30 -0400
Date: Fri, 15 Jul 2011 10:38:20 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
Message-ID: <20110715143820.GG3428@redhat.com>
References: <20110708110121.5acfc3c9@mschwide>
 <20110711144255.GE30674@redhat.com>
 <20110711175626.121dcc58@mschwide>
 <20110713160239.GE4426@redhat.com>
 <20110713184611.6dcb09b4@mschwide>
 <20110713200004.GG4426@redhat.com>
 <20110714091800.720da848@mschwide>
 <20110714175532.GE6672@redhat.com>
 <20110714180528.GF6672@redhat.com>
 <1310739717.10789.31.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310739717.10789.31.camel@br98xy6r>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 04:21:57PM +0200, Michael Holzheu wrote:
> On Thu, 2011-07-14 at 14:05 -0400, Vivek Goyal wrote:
> > On Thu, Jul 14, 2011 at 01:55:32PM -0400, Vivek Goyal wrote:
> > 
> > [..]
> > > > > So we first try to take purgatory path which does the checksum and is
> > > > > consistent with other architectures. If that does not work in case
> > > > > of hard hang, you always have the option of IPLing the stand alone tool
> > > > > later manually.
> > > > 
> > > > How are we suddenly on the purgatory path again? The code that gets
> > > > control in case of a hard crash + IPL is the stand-alone dump tool,
> > > > not the purgatory code.
> > > 
> > > I think that's the biggest contetion point. From the start of discussion
> > > you have this hardcoded requirement that the moment panic() happens
> > > you are jumping to some IPL code and that's what I am questioning. Why
> > > can't you execute some more code after panic() (purgatory), before
> > > you jump to IPL code (only if you have to). 
> > > 
> > 
> > In your parlance of shutdown actions, I think it is equivalnet to saying
> > that "kdump" is a shutdown action and that that means is that for specific
> > trigger points we will execute "crash_kexec()" function which will try
> > to capture the dump.
> > 
> > In user space I think one can modify the kexec-tools infrastrucuture a
> > bit so that one is able to define an entry point in case checksum of
> > loaded segment failes. Once you are loding kdump kernel, you can define
> > that entry point. (And this would be jump to IPL etc.).
> 
> You mean to jump back into the crashed kernel code in case the kdump
> checksum failed?

No. I meant jump to entry point so that one can IPL the dump tools. I
am not sure how do initiate the IPL after panic. Similar thing needs
to be done here. If it is as simple as jumping to some location in
low memory, then purgatory should be able to do that. I think we
shall have to figure out the details here.

Basically I am saying that purgatory detected that kdump kernel is
corrupted. In x86_64 we spin in inifinite loop as we don't have a
backup plan. But s390 has a backup plan of being able to IPL dump
tools.

Or in first step we can keep it even simpler. We can spin in infinite
loop and wait for either hypervisor watchdog to kick in for automatic
IPL or wait for operator intervention. That would simplify it even
further. 

> 
> In the meantime I was looking a bit more into the kexec code to find
> out, what we would have to do, if we use the preallocated ELF header as
> you want us to do. With our actual solution, we do not have to reserve
> any special areas for the kdump kernel. Now we have to reserve the ELF
> header. So what are the options?

ELF headers go into same memory area as kdump kenrel. Anyway you are
doing to reserve memory for kdump kernel and ELF headers will go 
right there.

Once you swap the kernel I think ELF headers continue to remain in
original location. Or may be you can move ELF headers too depending
on what turns out to be easier.

> 
> The x86 implementation uses a kernel parameter "memmap=exactmap" to do
> that.

It tells second kernel to use a memory map defined on command line.
Kexec-tools prepares this memory map with the help of memap= options. This
is to limit the memory second kernel use to boot into so that it does not
overwrite in any piece of memory used by first kernel.

In your case I think you shall have to do little more so that second
kernel also seems some of the lower memory areas so that later swapping
of kernel can be done.

> 
> On ia64 - if I understood the code correctly - they seem to pass a kdump
> segment "EFI_memmap" to the kdump kernel that contains information about
> all loaded kexec segments. With this segment they can find out the size
> of the ELF header segment in the kdump kernel and then do the memory
> reservation at boot time. Is that correct?

Sorry, I don't know the details of IA64. May be somebody else on the list
can pitch in with some clarifications here.

Thanks
Vivek
