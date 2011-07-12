Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab1GLNxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 09:53:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551Ab1GLNxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 09:53:02 -0400
Date: Tue, 12 Jul 2011 09:52:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
Message-ID: <20110712135241.GD1293@redhat.com>
References: <20110704170922.976299676@linux.vnet.ibm.com>
 <20110705202615.GJ24348@redhat.com>
 <1309944287.3937.39.camel@br98xy6r>
 <20110707193321.GE28850@redhat.com>
 <49979.1310234299@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49979.1310234299@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 09, 2011 at 01:58:19PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 07 Jul 2011 15:33:21 EDT, Vivek Goyal said:
> > On Wed, Jul 06, 2011 at 11:24:47AM +0200, Michael Holzheu wrote:
> 
> > > S390 stand-alone dump tools are independent mini operating systems that
> > > are installed on disks or tapes. When a dump should be created, these
> > > stand-alone dump tools are booted. All that they do is to write the dump
> > > (current memory plus the CPU registers) to the disk/tape device.
> > > 
> > > The advantage compared to kdump is that since they are freshly loaded
> > > into memory they can't be overwritten in memory.
> > 
> > > Another advantage is
> > > that since it is different code, it is much less likely that the dump
> > > tool will run into the same problem than the previously crashed kernel.
> > 
> > I think in practice this is not really a problem. If your kernel
> > is not stable enough to even boot and copy a file, then most likely
> > it has not even been deployed. The very fact that a kernel has been
> > up and running verifies that it is a stable kernel for that machine
> > and is capable of capturing the dump.
> 
> Vivek: I used to do VM/XA on S/390 boxes for a living, and that's *not* where
> Michael is coming from.
> 
> What the standalone dump code does is take a system that may have the moral
> equivalent of 256 separate PCI buses, several hundred disks all visible in
> multipath configurations, dozens of other devices, and as long as you can find
> *one* console and *one* tape/disk drive that works, you can capture a dump.

IIUC, capturing dump in virtualized environment is much more easy as
software is not completely dead and hypervisor is still running. For
example, qemu can easily capture the memory snapshot of the VM once it
is hung reliably in all situations. Issue becomes mageability with filtering
with various kernel versions and across operating systems inside VM. Hence
kdump for linux is being deployed even in virtualized environment.

I guess using stand alone dump tools is very similar to qemu dump in terms
of reliability but lacks filtering capabilities and is limited to specific
devices. That way qemu is much more powerful.

> 
> More than once in my career, I got into a situation where the production system
> would hang - and booting off another disk that contained an older copy with
> maybe a few less patches would *also* hang.  VM/XA would simply *not run*.
> Booting the standalone dump utility (which shared zero code with VM/XA, and did
> *much* less initialization of I/O devices not needed for the actual dump) would
> work just fine.  This would get me a dump that would show that we had a
> (usually) hardware issue - either we were tripping over an errata that *no*
> released version of VM/XA had a workaround for, or outright defective hardware.

Can we not achieve almost equivalent of it by only loading very selective
modules in second kernel?

If not, one can always use qemu-kvm dump capability with kvm hypervisor if
kdump does not work. It will be a manual operation though like s390 stand
alone dump utility.

So the point is that I am fine with stand alone dump utitliy capturing
the dump. Just keep it as backup plan if kdump does not work. Also for
early crashes kdump will not work and stand alone dump utility will be
the primary plan to capture the dump.

In above example, are you saying that your production kernel does not even
boot now which used to boot in the past on same system (because of some
bad hardware state?).

> 
> For the same efficiency reasons that Linux doesn't do a lot of checking for
> "can never happen" cases, VM/XA doesn't check some things. So when busted
> hardware would present logically impossible combinations of status bits (for
> instance, "device still connected" but "I/O bus disconnected"), Bad Things
> would happen.  Booting a tiny dump program that never even *tried* to look at
> the bad bits posted by the miscreant hardware would allow you to get the info
> you needed to debug it.

Ok, may be. I am not saying that don't use stand alone dump utility for
severe hardware issues. I am just saying that a closer integration with
kexec infrastructure like other architecture will be better. We probably
do not require any common code changes except a custom purgatory for
s390 to IPL stand alone utilities.

Thanks
Vivek
