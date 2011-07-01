Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab1GANnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 09:43:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859Ab1GANnr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 09:43:47 -0400
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of arbitrary physical addresses
Date: Fri, 1 Jul 2011 15:43:42 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.5-default; KDE/4.6.0; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <201106171038.25988.ptesarik@suse.cz> <201106291106.00070.ptesarik@suse.cz> <20110701125802.GE12605@elte.hu>
In-Reply-To: <20110701125802.GE12605@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107011543.43000.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Pá 1. července 2011 14:58:02 Ingo Molnar napsal(a):
> * Petr Tesarik <ptesarik@suse.cz> wrote:
> > Dne Pá 17. června 2011 11:30:32 Ingo Molnar napsal(a):
> > > * Petr Tesarik <ptesarik@suse.cz> wrote:
> > > > This patch series enhances /dev/mem, so that read and write is
> > > > possible at any address. The patchset includes actual
> > > > implementation for x86.
> > > 
> > > This series lacks a description of why this is desired.
> > >
> > >[...]
> > >
> > > Are you aware of any legitimate usecases?
> > 
> > Looking back at the mail tread, I'd say there are people who have
> > legitimate usecases. However, this may not be the most important
> > question. At the moment, the /dev/mem interface is broken (it
> > doesn't implement the specification correctly), and my patchset
> > fixes it.
> > 
> > If there are no technical objections, [...]
> 
> Well, my objections were entirely technical:
> 
>  - the device never implemented above-4G support upstream
> 
>  - there's colorful variants of abuse (drivers with binary-only
>    userspace) even if we ignore the obvious fact that the
>    main use of /dev/mem today is /dev/rootkit ...
> 
> Now my objections might be outweighed by the advantages of improving
> this driver, but you misrepresenting my position really does not help
> that process.
> 
> So what was not mentioned in your series, what is *your* motivation
> and your usecase? Enabling closed-source userspace drivers? Enabling
> the crash utility?

I think I made it clear that my use-case is enabling the crash utility. But I 
can re-state it now, no problem. ;)

> If the former then shame on you, if the latter then how do you
> explain that distros appear to disable the RAM aspect of /dev/mem:
> 
>  $ grep DEVMEM $(rpm -ql kernel-2.6.38-0.rc7.git2.3.fc16.x86_64 | grep
> config-2.6 ) CONFIG_STRICT_DEVMEM=y

I've already addressed this point as well. Fedora and RHEL ship with 
CONFIG_STRICT_DEVMEM=y. openSUSE and SLES ship with CONFIG_STRICT_DEVMEM=n.

> So the crash utility use-case does not work on unpatched, default
> kernels, right?

Right. And even told you how RedHat "solved" that issue. They re-implemented 
the /dev/mem driver and called it /dev/crash. RHEL4 and RHEL5 included this as 
a separate module (called crash.ko), so you can at least blacklist it. With 
RHEL6, the driver is built into the kernel, so it's probably always there.

In short, if you're breaking into a system, remember to symlink /dev/rootkit 
to /dev/crash instead of /dev/mem, and your rootkit will continue to work. 
Anyway, I fail to see how this can be a problem. To acces /dev/mem you must 
have root privileges already, so what else does it protect?

> As i said i have no problem with extending this, as long as it
> couples to a non-default flag (for example !STRICT_DEVMEM or a boot
> flag) and thus does not extend by default and does not extend the
> abuse.

I'm not sure what you mean. If you have a kernel compiled with 
CONFIG_STRICT_DEVMEM, then my patchset doesn't change anything in practice 
(unless you have an MMIO device mapped above 4G, in which case it will allow 
you to program it by writing to /dev/mem, instead of wrapping around to a 
random area in the first 4G and corrupting innocent data).

Hope that helps,
Petr Tesarik

> > @Ingo: you can also send a patchset that rips off the /dev/mem
> > driver completely if you believe that would get through. [...]
> 
> Why would we want to do that? Existing users can become more and more
> obsolete just fine.
> 
> What i'm asking for is to not enable new abuse by default ...
> 
> Thanks,
> 
> 	Ingo
