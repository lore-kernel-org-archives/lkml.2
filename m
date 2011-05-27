Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab1E0SAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 14:00:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756912Ab1E0SAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 14:00:06 -0400
Date: Fri, 27 May 2011 13:59:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        kexec@lists.infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        anderson@redhat.com
Subject: Re: [RFC Patch 5/6] slimdump: Capture slimdump for fatal MCE
 generated crashes
Message-ID: <20110527175949.GG8053@redhat.com>
References: <20110526170722.GB23266@in.ibm.com>
 <20110526172305.GA18295@in.ibm.com>
 <20110526174447.GC29496@redhat.com>
 <20110527165736.GC2384@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527165736.GC2384@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 10:27:36PM +0530, K.Prasad wrote:
> On Thu, May 26, 2011 at 01:44:47PM -0400, Vivek Goyal wrote:
> > On Thu, May 26, 2011 at 10:53:05PM +0530, K.Prasad wrote:
> > > 
> > > slimdump: Capture slimdump for fatal MCE generated crashes
> > > 
> > > System crashes resulting from fatal hardware errors (such as MCE) don't need
> > > all the contents from crashing-kernel's memory. Generate a new 'slimdump' that
> > > retains only essential information while discarding the old memory.
> > > 
> > 
> > Why to enforce zeroing out of rest of the vmcore data in kernel. Why not
> > leave it to user space. 
> > 
> 
> Our concern comes from the fact that it is unsafe for the OS to read
> any part of the corrupt memory region, so the kernel does not have to make
> that address space available for read/write.

The very fact you are booting into second kernel you are reading lots
of address space already. The assumption is that whole of the reserved
region is fine otherwise kernel will not even boot. Then even in older
kernel you are accessing memory used for saving the elf headers and
mce registers.

> 
> > As Andi said, you anyway will require disabling MCE temporarily in second
> > kernel. So that should allay the concern that we might run into second
> > MCE while trying to read the vmcore.
> > 
> 
> The processor manuals don't define the behaviour for a read operation
> upon a corrupt memory location. So the consequences for a read after
> disabling MCE is unknown (as I've mentioned here:
> https://lkml.org/lkml/2011/5/27/258). 
> 

First of all a user can simply have a configuration to extract MCE
registers and your concern is addressed. Eric W. Biederman said that
he had got bunch of MCE triggered dumps also and things were fine. I think
we are over engineering this. In the first step lets just keep it simple
and just export MCE registers as a note. If accessing rest of regions
becomes a issue in real life, then we can have a look at this again.


> > A user might want to extract just the dmesg buffers also after MCE from
> > vmcore.
> >
> > What I am saying is that this sounds more like a policy. Don't enforce
> > it in kernel. Probably give user MCE registers as part of ELF note of
> > vmcore. Now leave it up to user what data he wants to extract from vmcore.
> > Just the MCE registers or something more then that.
> 
> I'm unsure, at the moment, as to what it actually entails to extract
> dmesg buffers from the old kernel's memory; but given that there exists
> a corrupt memory region with unknown consequences for read operations
> upon it, I doubt if it is a safe idea to allow user-space application to
> navigate through the kernel data-structures to extract the dmesg.
> 
> Alternatively, we might leave MCE enabled for the kdump kernel and
> modify the user-space application to turn resilient to SIGBUS signal. So
> if it reads a corrupt memory region, it will receive a signal from
> do_machine_check() upon which it can skip that particular address and/or
> fill it with zeroes (or somesuch). We haven't gone through the
> details....but just some loud thinking

Again, I think simplest would be to disable MCE while we are accessing
previous kernel's memory and configure user space to either just extract
MCE registers. If you are too paranoid, you can do it in two steps. First
save MCE registes and make sure these are on disk and then go for
extracting rest of the info like dmesg and in the process if you go down,
anyway it was best effort thing.

Thanks
Vivek
