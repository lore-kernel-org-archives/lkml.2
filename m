Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab2GILgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 07:36:21 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42272 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752991Ab2GILgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 07:36:19 -0400
Date: Mon, 9 Jul 2012 12:35:59 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120709113558.GE8052@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <20120706235804.1bd26a1a@pyramind.ukuu.org.uk>
 <20120707231456.GA21201@arm.com>
 <20120708002920.4f55c737@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120708002920.4f55c737@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Sun, Jul 08, 2012 at 12:29:20AM +0100, Alan Cox wrote:
> > 1. The AArch64 architecture is significantly different from AArch32 (the
> > official name of the 32-bit ARM architecture), it is not an extension.
> > It has a new exception model, new instruction set (even the register
> > names are different), new C ABI, PCS. It has a hardware compat mode but
> > that's about it, there is no interworking between the two (not allowed
> > by hardware, nor that the ABIs would make this possible). 
> > 
> > 2. Easier code maintenance. While I started the kernel port from the
> > arch/arm/ code base (it was at a time when Linux didn't even have
> > generic unistd.h and the AArch64 specs kept changing) the code diverged
> > significantly both because of architecture differences and software
> > requirements like new ABI, generic headers (unistd.h, stat.h etc). The
> > port undergone significant rewrite following the rules for new
> > architecture ports and some of the few similarities will be moved to a
> > more generic place (like the mmu_gather patches from peterz). AArch64
> > SoCs are going into a more standardised direction and the SoC code will
> > be kept to a minimum and moved under drivers/. So merging AArch32 and
> > AArch64 together would be rather detrimental to code maintenance for
> > both architectures (#ifdef's or duplicate 32/64 files).
> > 
> > 3. Flexibility. It's early days for AArch64, we don't have a hardware
> > platform supported yet and there are ongoing debates around ACPI,
> > firmware standardisation for CPU booting, hotplug, power management. We
> > need the flexibility to improve the code base without worrying about
> > backwards compatibility (apart from the compat layer which isn't at all
> > affected by the hardware developments).
> 
> These are the same reasons the x86_64 people gave and regretted later.

I would not compare the x86_64 extension to the AArch64 architecture.
Unfortunately not all the specs are public yet and I can't point people
to the exception model which gives the full description of the AArch64
architecture.

Comparing with IA-64 is not entirely correct either but I would say the
AArch32/AArch64 diff is much closer to the x86/IA-64 diff than to the
x86_32/x86_64 one.

Just to give some highlights:

AArch32 (classic ARM) has r0-r14 32-bit general purpose registers (x14
is the stack pointer) and pc as the program counter. AArch64 has x0-x30
64-bit general purpose registers with the stack pointer (sp) as a
special one, similar to pc. To access the lower 32-bit part of general
registers on AArch64 we use w0-w30.

Following the register structure, the procedure calling standard (that's
a public document I mentioned in the cover) is also different. AArch32
uses r0-r3 as arguments with r4-r11 as the callee-saved registers. On
AArch64 we have x0-x7 as arguments, x8-x15 caller saved (a new addition
to AArch64), x19-x28 callee-saved. The rest are temporary or return
address (lr) registers.

The instruction set (called A64), while some mnemonics have been reused,
is a lot different. There are new instructions, there is no conditional
execution apart from the branch instruction (unlike A32 where pretty
much every instruction has a condition field encoded in the opcode).
Even the A64 instruction encodings are different from A32/T32. The best
thing about this is that they have been in a way that is optimal for
real apps without worrying about backwards compatibility.

The FPU (FP/SIMD) support is also re-designed with simplified exception
handling, new ISA.

In terms of exception model, AArch32 has USR mode for user apps and a
multitude of modes - SVC, IRQ, FIQ, ABT - for the kernel,  each with
their own banked lr (link register), sp and spsr (saved processor
state). AArch64 simplified this drastically with EL0 for user and just
EL1 for kernel with separate sp registers for each. All exceptions
handled by the kernel are taken in a single EL1 mode, no need to juggle
with switching between IRQ etc. and SVC like on AArch32. In addition,
there is a dedicated AArch64 ELR register for automatic saving of the
exception return address, unlike AArch32 where we had to temporarily
free r0 (by saving on the stack) just to be able to preserve the
information when switching between IRQ etc. and SVC.

As for the Linux implementation, the AArch32 and AArch64 ABIs are
entirely different - AArch64 uses generic syscalls (unistd.h), lots of
generic user structures, different ELF relocations (loadable modules).
The MMU is completely different from the classic ARM MMU (closer to
LPAE) and we have the advantage of not having to implement the MMU
support in a backwards compatible way, simplifying code like mm/mmu.c
greatly (and not only).

In conclusion, AArch64 hardware features together with the ongoing
effort on SoC and firmware standardisation allow for a much cleaner OS
implementation. I'm now looking forward to maintaining the AArch64
kernel port for the many years to come in the same clean way and driving
it into new directions (server space).

-- 
Catalin
