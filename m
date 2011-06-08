Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab1FHRAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 13:00:25 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:51695 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab1FHRAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 13:00:22 -0400
Date: Wed, 8 Jun 2011 22:30:08 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        kexec@lists.infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        anderson@redhat.com
Subject: Re: [RFC Patch 5/6] slimdump: Capture slimdump for fatal MCE
 generated crashes
Message-ID: <20110608170008.GA2851@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20110526170722.GB23266@in.ibm.com>
 <20110526172305.GA18295@in.ibm.com>
 <20110526174447.GC29496@redhat.com>
 <20110527165736.GC2384@in.ibm.com>
 <20110527175949.GG8053@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527175949.GG8053@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 01:59:49PM -0400, Vivek Goyal wrote:
> On Fri, May 27, 2011 at 10:27:36PM +0530, K.Prasad wrote:
> > On Thu, May 26, 2011 at 01:44:47PM -0400, Vivek Goyal wrote:
> > > On Thu, May 26, 2011 at 10:53:05PM +0530, K.Prasad wrote:
> > > > 
> > > > slimdump: Capture slimdump for fatal MCE generated crashes
> > > > 
> > > > System crashes resulting from fatal hardware errors (such as MCE) don't need
> > > > all the contents from crashing-kernel's memory. Generate a new 'slimdump' that
> > > > retains only essential information while discarding the old memory.
> > > > 
> > > 
> > > Why to enforce zeroing out of rest of the vmcore data in kernel. Why not
> > > leave it to user space. 
> > > 
> > 
> > Our concern comes from the fact that it is unsafe for the OS to read
> > any part of the corrupt memory region, so the kernel does not have to make
> > that address space available for read/write.
> 
> The very fact you are booting into second kernel you are reading lots
> of address space already. The assumption is that whole of the reserved
> region is fine otherwise kernel will not even boot. Then even in older
> kernel you are accessing memory used for saving the elf headers and
> mce registers.

The difference, IMHO, is that we avoid a deliberate access of the memory
location which has previously experienced an unrecoverable memory error
and upon which a read operation can cause fatal MCE.

While older kernel's memory is used to save elf headers, it is not a
location that is known to have a memory error.

There could be a case where either a new memory error surfaces in the
older kernel/inside the kdump kernel's memory region or a previously
hw-poisoned memory is consumed by the new kernel, during which
we suspect that the kdump kernel would reboot...but given the small time
window during which it operates such a situation is going to be very
rare.

> > 
> > > As Andi said, you anyway will require disabling MCE temporarily in second
> > > kernel. So that should allay the concern that we might run into second
> > > MCE while trying to read the vmcore.
> > > 
> > 
> > The processor manuals don't define the behaviour for a read operation
> > upon a corrupt memory location. So the consequences for a read after
> > disabling MCE is unknown (as I've mentioned here:
> > https://lkml.org/lkml/2011/5/27/258). 
> > 
> 
> First of all a user can simply have a configuration to extract MCE
> registers and your concern is addressed. Eric W. Biederman said that
> he had got bunch of MCE triggered dumps also and things were fine. I think
> we are over engineering this. In the first step lets just keep it simple
> and just export MCE registers as a note. If accessing rest of regions
> becomes a issue in real life, then we can have a look at this again.

Again, this suggestion is based on the fact that the coredump from the
first kernel is available...but the as stated before, capturing the
coredump from first kernel involves a compulsory read operation over a
memory location that is known to have an uncorrected error with the
problems described above.

> > > A user might want to extract just the dmesg buffers also after MCE from
> > > vmcore.
> > >
> > > What I am saying is that this sounds more like a policy. Don't enforce
> > > it in kernel. Probably give user MCE registers as part of ELF note of
> > > vmcore. Now leave it up to user what data he wants to extract from vmcore.
> > > Just the MCE registers or something more then that.
> > 
> > I'm unsure, at the moment, as to what it actually entails to extract
> > dmesg buffers from the old kernel's memory; but given that there exists
> > a corrupt memory region with unknown consequences for read operations
> > upon it, I doubt if it is a safe idea to allow user-space application to
> > navigate through the kernel data-structures to extract the dmesg.
> > 
> > Alternatively, we might leave MCE enabled for the kdump kernel and
> > modify the user-space application to turn resilient to SIGBUS signal. So
> > if it reads a corrupt memory region, it will receive a signal from
> > do_machine_check() upon which it can skip that particular address and/or
> > fill it with zeroes (or somesuch). We haven't gone through the
> > details....but just some loud thinking
> 
> Again, I think simplest would be to disable MCE while we are accessing
> previous kernel's memory and configure user space to either just extract
> MCE registers. If you are too paranoid, you can do it in two steps. First
> save MCE registes and make sure these are on disk and then go for
> extracting rest of the info like dmesg and in the process if you go down,
> anyway it was best effort thing.
>

The problem here is that the effect of a read operation over a location
with memory error (with MCEs disabled) is unknown. We are making
attempts to characterise the behaviour in conjunction with the hardware
folks and I will share any information that we learn in this regard.

Thanks,
K.Prasad

