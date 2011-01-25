Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab1AYPhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 10:37:00 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42982 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1AYPg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 10:36:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j0tJ+NvdiuPdiVQcWGuhKMqBhAV1QbwTmgyccb/bufMThHH9uNC1hmlzcxEm29OHvU
         JIvyg633yaGytq3S7KNQ+nABn/o3v28RwfqXZN8NR4aOv7tHTgLLilp4DC8v08FnqUBT
         rsDbc0vQjK2mooueKRXY+GvYxSktObh/oT+mI=
Date: Tue, 25 Jan 2011 17:36:49 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86-ML <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Willy Tarreau <wtarreau@hera.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Dirk Hohndel <hohndel@infradead.org>, Dirk.Hohndel@intel.com,
        IDE-ML <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk
	upon panic
Message-ID: <20110125153649.GA11386@laptop>
References: <20110125134748.GA10051@laptop> <20110125140948.GA26762@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110125140948.GA26762@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 03:09:48PM +0100, Ingo Molnar wrote:
> 
> * Ahmed S. Darwish <darwish.07@gmail.com> wrote:
> 
> > Hi,
> > 
> > I've faced some very early panics in latest kernel. Being a run of the mill
> > x86 laptop, the machine is void of debugging aids like serial ports or
> > network boot.
> > 
> > As a possible solution, below patches prototypes the idea of persistently
> > storing the kernel log ring to a hard disk partition using the enhanced BIOS
> > 0x13 services.

[...]

> > 
> > Diffstat:
> > 
> >  arch/x86/kernel/saveoops-rmode.S |  483 ++++++++++++++++++++++++++++++++++++++
> >  arch/x86/include/asm/saveoops.h  |   15 ++
> >  arch/x86/kernel/saveoops.c       |  219 +++++++++++++++++
> >  arch/x86/kernel/setup.c          |    9 +
> >  arch/x86/kernel/Makefile         |    3 +
> >  lib/Kconfig.debug                |   15 ++
> >  6 files changed, 744 insertions(+), 0 deletions(-)
> 
> Ok, i have to admit that while i'm a rabid BIOS-hater i find this debug feature very 
> very interesting, for the plain reason that if it's implemented in a robust and 
> clever way then this has a chance to improve debuggability of pretty much any Linux 
> laptop quite enormously!
> 
> While we generally thoroughly hate BIOSes from beginning to end, one thing can be 
> said, a BIOS bootstraps very early during bootup, and it's relatively simple to 
> trigger as well.
> 

Yes, the BIOS subset used is the same one used by SYSLINUX, grub, etc to load
the kernel. If the kernel is on, these functions are hopefully quite stable.

The complete __roadblock__ I'm currently facing though is restoring the disk
controllers to the state originally setup by the BIOS Power-on self-test (POST).
I hope such re-initialization is even technically feasible.

Without such re-initialization, we'll just be risking the BIOS code exploding.
That was the case in the 5-minute hang described in the cover sheet (PATCH #0).

> Also, since latest kernels do not stomp on BIOS data structures anymore (low RAM), 
> there's some good chance it's still functional at the point of crash - be that an 
> early crash or a later crash.
> 

Yes, I've noticed that thankfully the kernel reserves the BIOS EBDA area. I'm
not sure though if it reserves the real-mode vector table area 0x0 -> 0x400?

> I think the biggest areas of practical concern would be:
> 
>  - Can this mechanism ever, under any circumstance corrupt any real data, destroy 
>    the MBR or do other nasties. Can you think of any additional fail-safe measures 
>    where you could _further robustify the BIOS calls_ to make sure it can never go 
>    to the wrong sector(s)? I really do not want to think of trusting a BIOS to 
>    _write to my disk_.
> 

Admittedly, I was quite worried while testing this on disk. As a possible
safety trigger, I'm thinking of coding a small script under "tools/" that will
write a cookie in the desired area. If the real-mode code did not find such
cookie in the expected place, it abandons the write operation.

>  - Is there some hidden disk area somewhere on PCs, or somewhere on a real partition
>    on typical Linux distributions, which we could use without having to reinstall
>    the box? This would increase utility and availability enormously. I'm thinking of 
>    partition _ends_ which sometimes get rounded in an awkward way and which are 
>    potentially skipped by most Linux filesystems. Even a very small, 512 bytes of 
>    area would be extremely useful for debugging weird suspend hangs ...
> 

I did not have to re-partition the box here. A kindof a hacky solution was
disabling the swap partition and using it for storing the log. That would make
the feature available without re-installing the box, at the cost of temporarily
disabling swap.

Another testing method was booting the kernel from a USB stick and writing the
log there. If there are other free places in the boot disk, it can be used. But
I'm afraid it will make saveoops much more dangerous than what it already is
(by virtue of being much closer to file-system structures and such).

>  - Could we automate the recovery of the dump, and just put it into the regular 
>    kernel log on the next (successful) bootup (on a feature-enabled kernel)? That 
>    would make the log of the 'previous crash' very conveniently available in dmesg 
>    and the syslog. Tools like kerneloops could make use of it immediately.
> 

If I can make the code reliably work, it can be very very useful in a huge
number of situations such as these and more. The catch is the "If" part :)

> All in one, a very intriguing idea IMO, and the hardest bits (lowlevel x86 
> transition) is all implemented already.
> 

There is a place under arch/x86 that already does the lmode->rmode transition?

That was (so far) the hardest part; I quite searched the tree but did not find
any, so I rolled my own lmode->rmode switch code in the file "saveoops-rmode.S"

> 
> 	Ingo

Thanks,

-- 
Darwish
http://darwish.07.googlepages.com
