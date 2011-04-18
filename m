Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab1DRDeK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 23:34:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45952 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab1DRDeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 23:34:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: mm: convert vma->vm_flags to 64bit
Cc: kosaki.motohiro@jp.fujitsu.com, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>
In-Reply-To: <1303091139.28876.152.camel@pasglop>
References: <alpine.LSU.2.00.1104171649350.21405@sister.anvils> <1303091139.28876.152.camel@pasglop>
Message-Id: <20110418123422.9341.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon, 18 Apr 2011 12:34:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> On Sun, 2011-04-17 at 17:26 -0700, Hugh Dickins wrote:
> > I am surprised that
> > #define VM_EXEC         0x00000004ULL
> > does not cause trouble for arch/arm/kernel/asm-offsets.c,
> > but you tried cross-building it which I never did.
> 
> It would probably cause trouble for a big endian ARM no ? In that case
> it should offset the load by 4.

I think you are talking two thing, VM_EXEC and offsetof(vm_flags).
Therefore I'd explain my code reading result of two.

1) VM_EXEC

arch/arm/kernel/asm-offsets.c
----------------------------------------------------------------
  DEFINE(VM_EXEC,               VM_EXEC);

kbuild.h
----------------------------------------------------------------
#define DEFINE(sym, val) \
        asm volatile("\n->" #sym " %0 " #val : : "i" (val))

In this case, gcc asm() statement recognize C suffix and then
we don't see compile and/or link-time error.

2) vm_flags

arch/arm/kernel/asm-offsets.c
----------------------------------------------------------------
  DEFINE(VMA_VM_FLAGS,          offsetof(struct vm_area_struct, vm_flags));

OK, this is risky. we have to see all of users of this.


arch/arm/mm/proc-macros.S
----------------------------------------------------------------
/*
 * vma_vm_flags - get vma->vm_flags
 */
        .macro  vma_vm_flags, rd, rn
        ldr     \rd, [\rn, #VMA_VM_FLAGS]
        .endm


VMA_VM_FLAGS is only used this macro. then, we only need to see
vma_vm_flags assembler macro.

Next, 

% grep ENDIAN arch/arm/configs/*
arch/arm/configs/ixp2000_defconfig:CONFIG_CPU_BIG_ENDIAN=y
arch/arm/configs/ixp23xx_defconfig:CONFIG_CPU_BIG_ENDIAN=y
arch/arm/configs/ixp4xx_defconfig:CONFIG_CPU_BIG_ENDIAN=y

We only need to care the three subarch.

-----------------------------------------------------------
config ARCH_IXP23XX
        bool "IXP23XX-based"
        depends on MMU
        select CPU_XSC3
        select PCI
        select ARCH_USES_GETTIMEOFFSET
        help
          Support for Intel's IXP23xx (XScale) family of processors.

config ARCH_IXP2000
        bool "IXP2400/2800-based"
        depends on MMU
        select CPU_XSCALE
        select PCI
        select ARCH_USES_GETTIMEOFFSET
        help
          Support for Intel's IXP2400/2800 (XScale) family of processors.

config ARCH_IXP4XX
        bool "IXP4xx-based"
        depends on MMU
        select CPU_XSCALE
        select GENERIC_GPIO
        select GENERIC_CLOCKEVENTS
        select HAVE_SCHED_CLOCK
        select MIGHT_HAVE_PCI
        select DMABOUNCE if PCI
        help
          Support for Intel's IXP4XX (XScale) family of processors.
-----------------------------------------------------------

and they are CONFIG_CPU_XSCALE or CONFIG_CPU_XSC3.

arch/arm/mm/Makefile
-----------------------------------------------------------
obj-$(CONFIG_CPU_XSCALE)        += proc-xscale.o
obj-$(CONFIG_CPU_XSC3)          += proc-xsc3.o

grep -c  vma_vm_flags arch/arm/mm/proc-{xscale,xsc3}.S
arch/arm/mm/proc-xscale.S:0
arch/arm/mm/proc-xsc3.S:0


Then, current big endian user aren't harm from this change.

Of course, I might take mistake. I'm not arm expert. please correct
me if I'm misunderstand.



