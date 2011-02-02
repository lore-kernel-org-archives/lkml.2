Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab1BBQAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 11:00:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:62983 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab1BBQAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 11:00:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Subject: ARM unaligned MMIO access with attribute((packed))
Date: Wed, 2 Feb 2011 17:00:20 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gcc@gcc.gnu.org,
        Peter Maydell <peter.maydell@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102021700.20683.arnd@arndb.de>
X-Provags-ID: V02:K0:bKVViHgY27j6rTwOqaRG/nFiNe8qE7VFVXyJgrn1XTg
 a8Gh0b639AlZsqbltCGERsi2T8b6zJAOl9s5yU/QM0QkDqhiuE
 gUMHklOQT/blucxvLi7hEECu/o+jphOeYYmfZn1bNoetzO0Pl2
 /7+qYk6BXf+Fk/T1LzjNZuSiR7uQRR969tPTWmf8j4JMX+EaWj
 ScU+3umXWHzowut6uAzXw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As noticed by Peter Maydell, the EHCI device driver in Linux gets
miscompiled by some versions of arm-gcc (still need to find out which)
due to a combination of problems:

1. In include/linux/usb/ehci_def.h, struct ehci_caps is defined
with __attribute__((packed)), for no good reason. This is clearly
a bug and needs to get fixed, but other drivers have the same bug
and it used to work. The attribute forces byte access on all members
accessed through pointer dereference, which is not allowed on
MMIO accesses in general. The specific code triggering the problem
in Peter's case is in ehci-omap.c:
        omap->ehci->regs = hcd->regs
                + HC_LENGTH(readl(&omap->ehci->caps->hc_capbase));


2. The ARM version of the readl() function is implemented as a macro
doing a direct pointer dereference with a typecast:

#define __raw_readl(a)          (__chk_io_ptr(a), *(volatile unsigned int __force   *)(a))
#define readl_relaxed(c) ({ u32 __v = le32_to_cpu((__force __le32) \
                                        __raw_readl(__mem_pci(c))); __v; })
#define readl(c)                ({ u32 __v = readl_relaxed(c); __iormb(); __v; })

On other architectures, readl() is implemented using an inline assembly
specifically to prevent gcc from issuing anything but a single 32-bit
load instruction. readl() only makes sense on aligned memory, so in case
of a misaligned pointer argument, it should cause a trap anyway.

3. gcc does not seem to clearly define what happens during a cast between
aligned an packed pointers. In this case, the original pointer is packed
(byte aligned), while the access is done through a 32-bit aligned
volatile unsigned int pointer. In gcc-4.4, casting from "unsigned int
__attribute__((packed))" to "volatile unsigned int" resulted in a 32-bit
aligned access, while casting to "unsigned int" (without volatile) resulted
in four byte accesses. gcc-4.5 seems to have changed this to always do
a byte access in both cases, but still does not document the behavior.
(need to confirm this).

I would suggest fixing this by:

1. auditing all uses of __attribute__((packed)) in the Linux USB code
and other drivers, removing the ones that are potentially harmful.

2. Changing the ARM MMIO functions to use inline assembly instead of
direct pointer dereference.

3. Documenting the gcc behavior as undefined.

Other suggestions?

	Arnd
