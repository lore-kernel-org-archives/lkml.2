Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab1GSPEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 11:04:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab1GSPEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 11:04:49 -0400
Date: Tue, 19 Jul 2011 11:04:23 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
Message-ID: <20110719150423.GA7001@redhat.com>
References: <20110714180528.GF6672@redhat.com>
 <1310739717.10789.31.camel@br98xy6r>
 <20110715143820.GG3428@redhat.com>
 <1310744603.10789.79.camel@br98xy6r>
 <20110718123140.GB31986@redhat.com>
 <1310997641.4427.10.camel@br98xy6r>
 <20110718141943.GE31986@redhat.com>
 <1311000253.4427.23.camel@br98xy6r>
 <20110718152532.GF31986@redhat.com>
 <1311012188.4427.58.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311012188.4427.58.camel@br98xy6r>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 08:03:08PM +0200, Michael Holzheu wrote:
> Hello Vivek,
> 
> On Mon, 2011-07-18 at 11:25 -0400, Vivek Goyal wrote:
> > On Mon, Jul 18, 2011 at 04:44:13PM +0200, Michael Holzheu wrote:
> > > On Mon, 2011-07-18 at 10:19 -0400, Vivek Goyal wrote:
> > > > - Make sure these headers are not overwritten by newly booted kernel.
> > > 
> > > And that was my question: What is the best way to do that. E.g. we could
> > > pass a 2nd kernel parameter "elfcorehdr_size", implement s390 boot
> > > parameter or implement the memmap kernel parameter.
> > 
> > You could do that but I think a more generic parameter will make more
> > sense.
> > 
> > - Either something along the lines of memmap=
> > - Or excludemem=x@y
> > - Or modify memory map in s390 specific bootloading protocol block etc.
> 
> Ok, understood. Thanks for the information.
> 
> We still have discussions here, if we could somehow implement our
> original idea of triggering kdump by the stand-alone dump tools. Sorry
> for being so stubborn :-(

What's the advantage of that. Why are we so stuborn about first passing
the control to dump tools after panic()?

The case of purgatory corruption is no different then panic() code
and associated hook code corruption. 

It is a corner case and even if it gets corrupted you have other
mechanisms to IPL dump tools and capture dump.

Why do you want to mix two mechanisms. What's the advantage of making
even dump tools complicated and make it aware of a kernel binary
object purgatory?

To me the simple interface is that there is no coupling between dump
tools and kdump. If there is no coupling, then there is no need to
exchange any information and no need to make any assumption about
hard coded location where purgatory entry point, size and checksums
are stored.

> 
> So here comes the modified suggestion:
> 
> As requested by you we can pre-allocate the ELF header and use purgatory
> as done on other architectures.
> 
> To allow the stand-alone dump tools as kdump triggers, we then only
> would have to provide an s390 specific way to tell the stand-alone dump
> tools:
> 1. Entry point address into purgatory
> 2. Address, size and checksum for purgatory
> 
> We could store address, size and checksum of the purgatory to a fixed
> offset in the kdump kernel image. This can be done in the kexec tools
> code.

I think this will require kernel changes also? Otherwise how would you
store variables in kernel address space.

Secondly, if the goal is to just be able to checksum purgatory also, then
it probably should be done in a generic mannner so that kernel could
checksum purgatory before jumping to it.

> Then the dump tools only would need the crashkernel memory offset
> to find all information. Then dump tools will verify purgatory and
> afterwards jump to the purgatory code. Then purgatory verifies all kexec
> segments. For s390, if this check fails, we return to caller
> (stand-alone tools). If the check is ok, then purgatory code on s390
> saves all registers to the preallocated ELF notes and starts kdump.

So far I really don't think that there is any need of involving dump
tools here. By making it a requirement we are just making the design
complex with no gains.

> 
> I think, this is all s390 specific and IMHO will not affect other
> architectures at all.
> 
> What you as kdump framework maintainer would have to accept with this
> solution is that it is allowed now to start kdump directly via purgatory
> without using code from the old kernel (e.g. crash_kexec). This has as
> implication that all things that the old kernel has to initialize for
> kdump has to be done before the system crashes. Currently this is only
> the initialization of vmcoreinfo.

when would you save vmcoreinfo? I guess I shall have to look at the
patches.

Thanks
Vivek
