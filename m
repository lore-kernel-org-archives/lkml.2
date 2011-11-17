Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab1KQMgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 07:36:44 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45959 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301Ab1KQMgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 07:36:43 -0500
MIME-Version: 1.0
In-Reply-To: <4EC4F0FD0200007800061840@nat28.tlf.novell.com>
References: <4EC4F0FD0200007800061840@nat28.tlf.novell.com>
Date: Thu, 17 Nov 2011 13:36:41 +0100
Message-ID: <CA+rthh-1WxhWPeKE-Aqa5NCatxVoKu9=KHhLygkT1A6K35CBDA@mail.gmail.com>
Subject: Re: your patch "crypto: sha1 - SSSE3 based SHA1 implementation for
 x86-64" vs xsave
From: Mathias Krause <minipli@googlemail.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 11:33 AM, Jan Beulich <JBeulich@suse.com> wrote:
> Mathias,
>
> in avx_usable() you use cpu_has_osxsave to determine whether AVX can
> actually be used, but I can't see how that conditional would ever evaluate
> to true.

Well, it does, at least in my setup, a Core i7-2620M:

  [   44.902613] sha1_ssse3: Using AVX optimized SHA-1 implementation

> Checking CPUID.OSXSAVE is actually a user land requirement,
> whereas in the kernel you should really look at kernel internal variables
> to determine whether xsave was enabled

That's a valid point. I actually ported the check from the initial
assembler implementation which was written with userland code in mind.
Albeit this test can also be used in kernel code because the kernel
only sets this flag after xsave was enabled in
arch/x86/kernel/xsave.c:xstate_enable_boot_cpu/xstate_enable

> (or, if you really want to stay
> with using cpu_has_osxsave you'd have to force re-execution of
> get_cpu_cap() after xsave got enabled on individual CPUs), namely
> mmu_cr4_features having X86_CR4_OSXSAVE set.

I don't see where X86_CR4_OSXSAVE would get reset after xsave init.
Can you give me a pointer to that code?

> Additionally, under a hypervisor, CPUID.OSXSAVE may be set (due to
> the hypervisor having enabled xsave), while the kernel may be running
> with xsave disabled (e.g. due to a command line option saying so).

When noxsave is given on the kernel command line, X86_FEATURE_XSAVE
will be cleared and xsave_init() won't call xstate_enable(), so not
setting X86_CR4_OSXSAVE. All fine.


Thanks,
Mathias
