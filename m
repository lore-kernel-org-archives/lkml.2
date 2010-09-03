Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab0ICAwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 20:52:14 -0400
Received: from sh.osrg.net ([192.16.179.4]:59040 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705Ab0ICAvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 20:51:41 -0400
Date: Fri, 3 Sep 2010 09:51:31 +0900
To: akpm@linux-foundation.org
Subject: [PATCH -mm 0/8] unify dma_addr_t typedef
 (CONFIG_ARCH_DMA_ADDR_T_64BIT)
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100903094753S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 03 Sep 2010 09:51:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are about twenty architectures have the own dma_addr_t typedef
because include/asm-generic/types.h can't be perfect (some of them can
use it though):

#ifndef dma_addr_t
#ifdef CONFIG_PHYS_ADDR_T_64BIT
typedef u64 dma_addr_t;
#else
typedef u32 dma_addr_t;
#endif /* CONFIG_PHYS_ADDR_T_64BIT */
#endif /* dma_addr_t */

Another problem is that there is a way to determine if dma_addr_t is
64-bit. We see hopeless tricks like the following:

#if (defined(__i386__) && defined(CONFIG_HIGHMEM64G)) || defined(__x86_64__) || defined (__ia64__) || defined(__alpha__) || defined(__mips64__) || (defined(__mips__) && defined(CONFIG_HIGHMEM) && defined(CONFIG_64BIT_PHYS_ADDR))

This clean up the mess with introducing CONFIG_ARCH_DMA_ADDR_T_64BIT
define (like CONFIG_ARCH_PHYS_ADDR_T_64BIT).

If architecture needs 64bit dma_addr_t, it must enable
CONFIG_ARCH_DMA_ADDR_T_64BIT.

The summary are:

- always 64bit
-- alpha
-- ia64
-- tile

- conditionally 64bit
-- x86
-- mips
-- powerpc
-- s390

- always 32bit
-- arm
-- avr32
-- cris
-- frv
-- h8300
-- m32r
-- m68k
-- mn10300
-- parisc
-- xtensa
-- sparc
-- blackfin
-- microblaze
-- score
-- sh

=
 arch/alpha/Kconfig               |    3 +++
 arch/alpha/include/asm/types.h   |    1 -
 arch/arm/include/asm/types.h     |    3 ---
 arch/avr32/include/asm/types.h   |    8 --------
 arch/cris/include/asm/types.h    |    3 ---
 arch/frv/include/asm/types.h     |    8 --------
 arch/h8300/include/asm/types.h   |    4 ----
 arch/ia64/Kconfig                |    3 +++
 arch/ia64/include/asm/types.h    |    3 ---
 arch/m32r/include/asm/types.h    |    3 ---
 arch/m68k/include/asm/types.h    |    3 ---
 arch/mips/Kconfig                |    3 +++
 arch/mips/include/asm/types.h    |    6 ------
 arch/mn10300/include/asm/types.h |    7 -------
 arch/parisc/include/asm/types.h  |    3 ---
 arch/powerpc/Kconfig             |    3 +++
 arch/powerpc/include/asm/types.h |    5 -----
 arch/s390/Kconfig                |    3 +++
 arch/s390/include/asm/types.h    |    6 ------
 arch/sparc/include/asm/types.h   |    4 ----
 arch/tile/Kconfig                |    3 +++
 arch/x86/Kconfig                 |    3 +++
 arch/x86/include/asm/types.h     |    8 --------
 arch/xtensa/include/asm/types.h  |    4 ----
 include/asm-generic/types.h      |   27 ---------------------------
 include/linux/types.h            |    6 ++++++
 26 files changed, 27 insertions(+), 106 deletions(-)
