Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab1GYQDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 12:03:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab1GYQDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 12:03:03 -0400
Date: Mon, 25 Jul 2011 12:02:44 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: oomichi@mxs.nes.nec.co.jp, linux-s390@vger.kernel.org,
        mahesh@linux.vnet.ibm.com, heiko.carstens@de.ibm.com,
        linux-kernel@vger.kernel.org, hbabu@us.ibm.com, horms@verge.net.au,
        ebiederm@xmission.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        kexec@lists.infradead.org
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
Message-ID: <20110725160244.GB11009@redhat.com>
References: <20110718123140.GB31986@redhat.com>
 <1310997641.4427.10.camel@br98xy6r>
 <20110718141943.GE31986@redhat.com>
 <1311000253.4427.23.camel@br98xy6r>
 <20110718152532.GF31986@redhat.com>
 <1311012188.4427.58.camel@br98xy6r>
 <20110720192509.GD10079@redhat.com>
 <1311260298.6160.43.camel@br98xy6r>
 <20110721212257.GI12373@redhat.com>
 <1311327191.5772.51.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311327191.5772.51.camel@br98xy6r>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 11:33:11AM +0200, Michael Holzheu wrote:

[..]
> > > 
> > > Then the design would look like the following:
> > > * Define s390_kdump_entry in old kernel that calls crash_kexec()
> > > * Use preallocated ELF core header
> > > * s390_kdump_entry code path stores registers to ELF notes,  ...
> > 
> > crash_kexec() -> crash_setup_regs() already does that. We just need to
> > define an s390 specific crash_setup_regs().
> 
> I looked at the code. x86 seems to store only registers for current CPU.
> Where are all other CPUs stored? ia64 has an empty implementation. Where
> are registers stored there?

native_machine_crash_shutdown()
	kdump_nmi_shootdown_cpus()
		kdump_nmi_callback()
			crash_save_cpu()

Basically crashing cpu sends NMI to other cpus to stop them and with-in
NMI handler it also saves per cpu state.

> 
> > 
> > > * ... and finally jumps to purgatory code
> > > * For s390 the purgatory code returns to caller in case of
> > >   checksum failure
> > > * dump tools call s390_kdump_entry with program check handler
> > >   for error handling
> > 
> > I thought that program check handler will call something else and not
> > s390_kdump_entry()? Because program check handler is supposed to hit
> > when any of the code we are executing is corrupted and we can not
> > jump to kdump tool any more. Otherwise we will be nesting.
> 
> Looks like the sentence was misleading. What I wanted to say is:
> * First dump tools setup program check handler that jumps back to
>   dump tool in case kdump fails
> * Then dump tools call s390_dump_entry
> 
> > > 
> > > I think, if we do it that way, we do not affect the current kdump
> > > framework at all.
> > 
> > Can you give some more details about various code flows and entry points.
> > Like panic() path, hard hang path. From your mail it sounds that even
> > with program check handler, after panic() you would like to jump to
> > stand alone tools first and then call s390_kdump_entry(). I think that
> > should not be required any more as you are not doing any checksumming
> > in dump tools anymore?
> 
> Ok some code flows:
> 
> Generally we have the flow:
> * crash_kexec -> machine_kexec -> purgatory -> kdump
> 
> crash_kexec can be entered by e.g.:
> * panic -> kdump shutdown action -> crash_kexec
> * panic -> s390 dump shutdown action -> auto IPL dump tool -> s390_kdump_entry -> crash_kexec

So after panic() You will still jump to dump tools? The only thing you
need to do there is installing program check handler and could have been
easily done in kernel too.

> * hard hang -> manual IPL dump tool -> s390_kdump_entry -> crash_kexec

This one makes sense as kernel is hard hung and dump tools need to
force crash_kexec() now. It is more like x86 NMI handler.

> 
> Handling for corrupted kdump:
> 
> New idea for returning to dump tools in case of program check:
> We could force a program check for s390, if purgatory checksum
> fails. Then we would automatically return to stand-alone dump
> tools.
> 
> The flow would look like the following in this case:
> 
> IPL dump tool -> s390_kdump_entry -> crash_kexec +--> purgatory -+->[checksum ok]---> kdump
>       ^                                          |               |
>       |                                          |        [checksum fail]
>       |                                          |               |
>       |                                          |     [forced program check]
>       +------[program check]---------------------+               |
>       |                                                          |
>       +----------------------------------------------------------+
> 
> Then of course also the kernel code would have to install a special
> program check handler before calling purgatory.

If kernel code is going to install the program check handler before
calling purgatory, then we don't need to jump to dump tools at all
after panic()?

Thanks
Vivek
