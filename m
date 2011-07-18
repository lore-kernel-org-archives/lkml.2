Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab1GRSDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 14:03:36 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:34092 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab1GRSDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 14:03:34 -0400
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
In-Reply-To: <20110718152532.GF31986@redhat.com>
References: <20110714091800.720da848@mschwide>
	 <20110714175532.GE6672@redhat.com> <20110714180528.GF6672@redhat.com>
	 <1310739717.10789.31.camel@br98xy6r> <20110715143820.GG3428@redhat.com>
	 <1310744603.10789.79.camel@br98xy6r> <20110718123140.GB31986@redhat.com>
	 <1310997641.4427.10.camel@br98xy6r> <20110718141943.GE31986@redhat.com>
	 <1311000253.4427.23.camel@br98xy6r>  <20110718152532.GF31986@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Mon, 18 Jul 2011 20:03:08 +0200
Message-ID: <1311012188.4427.58.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

On Mon, 2011-07-18 at 11:25 -0400, Vivek Goyal wrote:
> On Mon, Jul 18, 2011 at 04:44:13PM +0200, Michael Holzheu wrote:
> > On Mon, 2011-07-18 at 10:19 -0400, Vivek Goyal wrote:
> > > - Make sure these headers are not overwritten by newly booted kernel.
> > 
> > And that was my question: What is the best way to do that. E.g. we could
> > pass a 2nd kernel parameter "elfcorehdr_size", implement s390 boot
> > parameter or implement the memmap kernel parameter.
> 
> You could do that but I think a more generic parameter will make more
> sense.
> 
> - Either something along the lines of memmap=
> - Or excludemem=x@y
> - Or modify memory map in s390 specific bootloading protocol block etc.

Ok, understood. Thanks for the information.

We still have discussions here, if we could somehow implement our
original idea of triggering kdump by the stand-alone dump tools. Sorry
for being so stubborn :-(

So here comes the modified suggestion:

As requested by you we can pre-allocate the ELF header and use purgatory
as done on other architectures.

To allow the stand-alone dump tools as kdump triggers, we then only
would have to provide an s390 specific way to tell the stand-alone dump
tools:
1. Entry point address into purgatory
2. Address, size and checksum for purgatory

We could store address, size and checksum of the purgatory to a fixed
offset in the kdump kernel image. This can be done in the kexec tools
code. Then the dump tools only would need the crashkernel memory offset
to find all information. Then dump tools will verify purgatory and
afterwards jump to the purgatory code. Then purgatory verifies all kexec
segments. For s390, if this check fails, we return to caller
(stand-alone tools). If the check is ok, then purgatory code on s390
saves all registers to the preallocated ELF notes and starts kdump.

I think, this is all s390 specific and IMHO will not affect other
architectures at all.

What you as kdump framework maintainer would have to accept with this
solution is that it is allowed now to start kdump directly via purgatory
without using code from the old kernel (e.g. crash_kexec). This has as
implication that all things that the old kernel has to initialize for
kdump has to be done before the system crashes. Currently this is only
the initialization of vmcoreinfo.

Would such a solution be acceptable for you?

Michael

