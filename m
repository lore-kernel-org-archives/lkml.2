Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab1GVJdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 05:33:38 -0400
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:35128 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab1GVJdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 05:33:36 -0400
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: oomichi@mxs.nes.nec.co.jp, linux-s390@vger.kernel.org,
        mahesh@linux.vnet.ibm.com, heiko.carstens@de.ibm.com,
        linux-kernel@vger.kernel.org, hbabu@us.ibm.com, horms@verge.net.au,
        ebiederm@xmission.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        kexec@lists.infradead.org
In-Reply-To: <20110721212257.GI12373@redhat.com>
References: <20110715143820.GG3428@redhat.com>
	 <1310744603.10789.79.camel@br98xy6r> <20110718123140.GB31986@redhat.com>
	 <1310997641.4427.10.camel@br98xy6r> <20110718141943.GE31986@redhat.com>
	 <1311000253.4427.23.camel@br98xy6r> <20110718152532.GF31986@redhat.com>
	 <1311012188.4427.58.camel@br98xy6r> <20110720192509.GD10079@redhat.com>
	 <1311260298.6160.43.camel@br98xy6r>  <20110721212257.GI12373@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Fri, 22 Jul 2011 11:33:11 +0200
Message-ID: <1311327191.5772.51.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

On Thu, 2011-07-21 at 17:22 -0400, Vivek Goyal wrote:
> On Thu, Jul 21, 2011 at 04:58:18PM +0200, Michael Holzheu wrote:
> > We would change the purgatory code that for s390 it returns to the
> > caller, if the checksum test fails. This *requires* that
> > s390_kdump_entry()->crash_kexec()->machine_kexec() is allowed to return.
> > Currently this is the case.
> 
> Can we directly jump to entry point of stand alone dump tools from purgaotry
> if checksum fails? We should be able to set this entry point in user space
> while loading kdump kernel.

I described a new idea with forced program check below.

> > > Only thing which needs to be figured out is how to pass the address of
> > > crash_kexec() to stand alone tools and set registers/parameters 
> > > appropriately.
> > 
> > We could do this s390 specific (e.g. using meminfo). In this case this
> > would only be used for kernel/dump tools communication and not for
> > kernel/kernel communication. So I hope this should not be a problem for
> > you.
> 
> So you will be preparing a block/segment of data (called meminfo, though
> this name does not make much sense anymore), and pass it to second kernel?
> All done in user space and no first kernel involvement?
>
> I am trying to remember the details that how do you tell second kernel
> where this this data block is. I recall that last time you said something
> about setting this in kernel in kexec-tools but I did not understand it.

Better you forget everything :-)

We will establish a s390 specific mechanism that allows dump tools to
find s390_kdump_entry and does not affect the kdump framework. Hopefully
nothing you have to worry about.

> > 
> > Then the design would look like the following:
> > * Define s390_kdump_entry in old kernel that calls crash_kexec()
> > * Use preallocated ELF core header
> > * s390_kdump_entry code path stores registers to ELF notes,  ...
> 
> crash_kexec() -> crash_setup_regs() already does that. We just need to
> define an s390 specific crash_setup_regs().

I looked at the code. x86 seems to store only registers for current CPU.
Where are all other CPUs stored? ia64 has an empty implementation. Where
are registers stored there?

> 
> > * ... and finally jumps to purgatory code
> > * For s390 the purgatory code returns to caller in case of
> >   checksum failure
> > * dump tools call s390_kdump_entry with program check handler
> >   for error handling
> 
> I thought that program check handler will call something else and not
> s390_kdump_entry()? Because program check handler is supposed to hit
> when any of the code we are executing is corrupted and we can not
> jump to kdump tool any more. Otherwise we will be nesting.

Looks like the sentence was misleading. What I wanted to say is:
* First dump tools setup program check handler that jumps back to
  dump tool in case kdump fails
* Then dump tools call s390_dump_entry

> > 
> > I think, if we do it that way, we do not affect the current kdump
> > framework at all.
> 
> Can you give some more details about various code flows and entry points.
> Like panic() path, hard hang path. From your mail it sounds that even
> with program check handler, after panic() you would like to jump to
> stand alone tools first and then call s390_kdump_entry(). I think that
> should not be required any more as you are not doing any checksumming
> in dump tools anymore?

Ok some code flows:

Generally we have the flow:
* crash_kexec -> machine_kexec -> purgatory -> kdump

crash_kexec can be entered by e.g.:
* panic -> kdump shutdown action -> crash_kexec
* panic -> s390 dump shutdown action -> auto IPL dump tool -> s390_kdump_entry -> crash_kexec
* hard hang -> manual IPL dump tool -> s390_kdump_entry -> crash_kexec

Handling for corrupted kdump:

New idea for returning to dump tools in case of program check:
We could force a program check for s390, if purgatory checksum
fails. Then we would automatically return to stand-alone dump
tools.

The flow would look like the following in this case:

IPL dump tool -> s390_kdump_entry -> crash_kexec +--> purgatory -+->[checksum ok]---> kdump
      ^                                          |               |
      |                                          |        [checksum fail]
      |                                          |               |
      |                                          |     [forced program check]
      +------[program check]---------------------+               |
      |                                                          |
      +----------------------------------------------------------+

Then of course also the kernel code would have to install a special
program check handler before calling purgatory.
                         
Michael

