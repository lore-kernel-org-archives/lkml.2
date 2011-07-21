Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab1GUVXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 17:23:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab1GUVXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 17:23:30 -0400
Date: Thu, 21 Jul 2011 17:22:57 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: oomichi@mxs.nes.nec.co.jp, linux-s390@vger.kernel.org,
        mahesh@linux.vnet.ibm.com, heiko.carstens@de.ibm.com,
        linux-kernel@vger.kernel.org, hbabu@us.ibm.com, horms@verge.net.au,
        ebiederm@xmission.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        kexec@lists.infradead.org
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
Message-ID: <20110721212257.GI12373@redhat.com>
References: <20110715143820.GG3428@redhat.com>
 <1310744603.10789.79.camel@br98xy6r>
 <20110718123140.GB31986@redhat.com>
 <1310997641.4427.10.camel@br98xy6r>
 <20110718141943.GE31986@redhat.com>
 <1311000253.4427.23.camel@br98xy6r>
 <20110718152532.GF31986@redhat.com>
 <1311012188.4427.58.camel@br98xy6r>
 <20110720192509.GD10079@redhat.com>
 <1311260298.6160.43.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311260298.6160.43.camel@br98xy6r>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 04:58:18PM +0200, Michael Holzheu wrote:
> Hello Vivek,
> 
> On Wed, 2011-07-20 at 15:25 -0400, Vivek Goyal wrote:
> > On Mon, Jul 18, 2011 at 08:03:08PM +0200, Michael Holzheu wrote:
> 
> [snip]
> 
> > > What you as kdump framework maintainer would have to accept with this
> > > solution is that it is allowed now to start kdump directly via purgatory
> > > without using code from the old kernel (e.g. crash_kexec). This has as
> > > implication that all things that the old kernel has to initialize for
> > > kdump has to be done before the system crashes. Currently this is only
> > > the initialization of vmcoreinfo.
> > 
> > Hi Michael,
> > 
> > Instead of introdcuing a new entry point for second kernel, why not
> > jump to crash_kexec() from stand alone tools? That should be functionally
> > equivalent to what you described above without any need to pass the 
> > purgatory details to stand alone tools.
> 
> That has the drawback that we still execute unchecked code from the
> crashed kernel. But ...
> 
> ... I discussed that with Martin and we had an idea how to deal with
> this problem. On s390 when an invalid opcode is executed or invalid
> parameters are used, we get a program check interrupt. When the
> crash_kexec() code path or data is corrupted, it is almost sure that we
> get a program check. The stand-alone dump tools could establish a
> program check interrupt handler that jumps back to the dump tools code
> and then create full-blown dump.

Ok, that sounds good. So now you don't have to worry about checksumming
purgatory code.

> 
> So I think with this mechanism we could use an entry point (name it
> s390_kdump_entry) in the old kernel that calls crash_kexec().
> 
> We would change the purgatory code that for s390 it returns to the
> caller, if the checksum test fails. This *requires* that
> s390_kdump_entry()->crash_kexec()->machine_kexec() is allowed to return.
> Currently this is the case.

Can we directly jump to entry point of stand alone dump tools from purgaotry
if checksum fails? We should be able to set this entry point in user space
while loading kdump kernel.

> 
> > Only thing which needs to be figured out is how to pass the address of
> > crash_kexec() to stand alone tools and set registers/parameters 
> > appropriately.
> 
> We could do this s390 specific (e.g. using meminfo). In this case this
> would only be used for kernel/dump tools communication and not for
> kernel/kernel communication. So I hope this should not be a problem for
> you.

So you will be preparing a block/segment of data (called meminfo, though
this name does not make much sense anymore), and pass it to second kernel?
All done in user space and no first kernel involvement?

I am trying to remember the details that how do you tell second kernel
where this this data block is. I recall that last time you said something
about setting this in kernel in kexec-tools but I did not understand it.

> 
> Then the design would look like the following:
> * Define s390_kdump_entry in old kernel that calls crash_kexec()
> * Use preallocated ELF core header
> * s390_kdump_entry code path stores registers to ELF notes,  ...

crash_kexec() -> crash_setup_regs() already does that. We just need to
define an s390 specific crash_setup_regs().

> * ... and finally jumps to purgatory code
> * For s390 the purgatory code returns to caller in case of
>   checksum failure
> * dump tools call s390_kdump_entry with program check handler
>   for error handling

I thought that program check handler will call something else and not
s390_kdump_entry()? Because program check handler is supposed to hit
when any of the code we are executing is corrupted and we can not
jump to kdump tool any more. Otherwise we will be nesting.

In fact how do we differentiate between kdump code being corrupted
vs some normal kernel code being corrupted. In first case we would like
to jump to dump tools and take full dump and in second case it would
be desirable to jump to kdump kernel.

> 
> I think, if we do it that way, we do not affect the current kdump
> framework at all.

Can you give some more details about various code flows and entry points.
Like panic() path, hard hang path. From your mail it sounds that even
with program check handler, after panic() you would like to jump to
stand alone tools first and then call s390_kdump_entry(). I think that
should not be required any more as you are not doing any checksumming
in dump tools anymore?

Thanks
Vivek
