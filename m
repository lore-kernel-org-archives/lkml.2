Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847Ab1GUO6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 10:58:40 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:41060 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab1GUO6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 10:58:36 -0400
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: oomichi@mxs.nes.nec.co.jp, linux-s390@vger.kernel.org,
        mahesh@linux.vnet.ibm.com, heiko.carstens@de.ibm.com,
        linux-kernel@vger.kernel.org, hbabu@us.ibm.com, horms@verge.net.au,
        ebiederm@xmission.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        kexec@lists.infradead.org
In-Reply-To: <20110720192509.GD10079@redhat.com>
References: <20110714180528.GF6672@redhat.com>
	 <1310739717.10789.31.camel@br98xy6r>	<20110715143820.GG3428@redhat.com>
	 <1310744603.10789.79.camel@br98xy6r>	<20110718123140.GB31986@redhat.com>
	 <1310997641.4427.10.camel@br98xy6r>	<20110718141943.GE31986@redhat.com>
	 <1311000253.4427.23.camel@br98xy6r>	<20110718152532.GF31986@redhat.com>
	 <1311012188.4427.58.camel@br98xy6r>  <20110720192509.GD10079@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Thu, 21 Jul 2011 16:58:18 +0200
Message-ID: <1311260298.6160.43.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

On Wed, 2011-07-20 at 15:25 -0400, Vivek Goyal wrote:
> On Mon, Jul 18, 2011 at 08:03:08PM +0200, Michael Holzheu wrote:

[snip]

> > What you as kdump framework maintainer would have to accept with this
> > solution is that it is allowed now to start kdump directly via purgatory
> > without using code from the old kernel (e.g. crash_kexec). This has as
> > implication that all things that the old kernel has to initialize for
> > kdump has to be done before the system crashes. Currently this is only
> > the initialization of vmcoreinfo.
> 
> Hi Michael,
> 
> Instead of introdcuing a new entry point for second kernel, why not
> jump to crash_kexec() from stand alone tools? That should be functionally
> equivalent to what you described above without any need to pass the 
> purgatory details to stand alone tools.

That has the drawback that we still execute unchecked code from the
crashed kernel. But ...

... I discussed that with Martin and we had an idea how to deal with
this problem. On s390 when an invalid opcode is executed or invalid
parameters are used, we get a program check interrupt. When the
crash_kexec() code path or data is corrupted, it is almost sure that we
get a program check. The stand-alone dump tools could establish a
program check interrupt handler that jumps back to the dump tools code
and then create full-blown dump.

So I think with this mechanism we could use an entry point (name it
s390_kdump_entry) in the old kernel that calls crash_kexec().

We would change the purgatory code that for s390 it returns to the
caller, if the checksum test fails. This *requires* that
s390_kdump_entry()->crash_kexec()->machine_kexec() is allowed to return.
Currently this is the case.

> Only thing which needs to be figured out is how to pass the address of
> crash_kexec() to stand alone tools and set registers/parameters 
> appropriately.

We could do this s390 specific (e.g. using meminfo). In this case this
would only be used for kernel/dump tools communication and not for
kernel/kernel communication. So I hope this should not be a problem for
you.

Then the design would look like the following:
* Define s390_kdump_entry in old kernel that calls crash_kexec()
* Use preallocated ELF core header
* s390_kdump_entry code path stores registers to ELF notes,  ...
* ... and finally jumps to purgatory code
* For s390 the purgatory code returns to caller in case of
  checksum failure
* dump tools call s390_kdump_entry with program check handler
  for error handling

I think, if we do it that way, we do not affect the current kdump
framework at all.

Is that acceptable for you? If yes, I would rework my patches
accordingly.

Michael

