Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab2LZKor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 05:44:47 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:60122 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab2LZKoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 05:44:46 -0500
Date: Wed, 26 Dec 2012 02:44:43 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Woodhouse <dwmw2@infradead.org>
cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/build] x86: Default to ARCH= x86 to avoid overriding
 CONFIG_64BIT
In-Reply-To: <1356511396.7010.13.camel@shinybook.infradead.org>
Message-ID: <alpine.DEB.2.00.1212260228200.10166@chino.kir.corp.google.com>
References: <1356040315.3198.51.camel@shinybook.infradead.org> <tip-ffee0de411fd4f74f3b788892eeb075abbf26c52@git.kernel.org> <alpine.DEB.2.00.1212252222450.24528@chino.kir.corp.google.com> <1356511396.7010.13.camel@shinybook.infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Dec 2012, David Woodhouse wrote:

> > arch/x86/built-in.o: In function `hpet_setup_msi_irq':
> > hpet.c:(.text+0x34638): undefined reference to `arch_setup_hpet_msi'
> > hpet.c:(.text+0x34651): undefined reference to `destroy_irq'
> > arch/x86/built-in.o: In function `hpet_msi_capability_lookup':
> > hpet.c:(.text+0x347ff): undefined reference to `create_irq_nr'
> > arch/x86/built-in.o:(.data+0xd1c): undefined reference to `native_setup_msi_irqs'
> > arch/x86/built-in.o:(.data+0xd20): undefined reference to `native_teardown_msi_irq'
> > drivers/built-in.o: In function `dmar_set_interrupt':
> > (.text+0x89eec0): undefined reference to `create_irq'
> > drivers/built-in.o: In function `dmar_set_interrupt':
> > (.text+0x89ef0b): undefined reference to `arch_setup_dmar_msi'
> > drivers/built-in.o: In function `dmar_set_interrupt':
> > (.text+0x89ef44): undefined reference to `destroy_irq'
> > drivers/built-in.o: In function `free_dmar_iommu':
> > (.text+0x8a6ae8): undefined reference to `destroy_irq'
> > 
> > These functions require CONFIG_X86_IO_APIC, which is only possible with 
> > X86_64 or X86_32_NON_STANDARD.  CONFIG_HPET_TIMER, however, can be enabled 
> > with X86_32, and CONFIG_DMAR_TABLE can be enabled with any X86 via 
> > CONFIG_INTEL_IOMMU.
> 
> I don't think it can have created them, surely? They must have existed
> already when building with ARCH=x86. And probably with ARCH=i386 too?

I'm sure it's a 32-bit issue, nothing has changed recently in auto-latest 
related to these subsystems and I'm sure it's just because my randconfig 
builds were exposed to this combination solely because of this patch.

> I'll take a further look in more detail, but at first glance it doesn't
> seem correct to describe them as bugs caused by this patch; merely bugs
> that this patch helped us to *find*.
> 
> Please could you provide the .config file?
> 

Attached.

> >  When I do "make randconfig" and uname -m is x86_64, I expect 
> > CONFIG_64BIT to always be set.  This commit makes this random for all x86 
> > so that "make randconfig" may result in a 32-bit build.  That should be 
> > the behavior for "make ARCH=i386 randconfig" but not "make randconfig" on 
> > a 64-bit machine.
> 
> We've had this bizarre "I don't really want randconfig to be random"
> conversation before. If don't want randconfig to be random, you can use
> $KCONFIG_ALLCONFIG to override anything you like. Or, for the specific
> case of CONFIG_64BIT on x86, you can use ARCH=i386 or ARCH=x86_64 to
> override just that one option.
> 

If it were truly random then it would be generating sparc configs, hppa 
configs, etc.  Randconfig has always generated random configurations for 
the underlying architecture (just like you respect the architecture with 
defconfig with your patch), the fact that it's been unified into a single 
x86 architecture changes the behavior of plain old "make randconfig".  I 
certainly understand how to override that with ARCH=x86_64.  However, the 
reverse can also be said: make the same adjustment for randconfig that you 
made for defconfig so the old behavior is maintained and allow users on 
x86_64 to do "make ARCH=i386 randconfig" for 32-bit builds.
