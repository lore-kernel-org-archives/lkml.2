Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964789Ab2I1S4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:56:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33712 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab2I1Szz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:55:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Nicolas Pitre <nico@linaro.org>, Matthew Leach <matthew.leach@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 045/262] ARM: 7501/1: decompressor: reset ttbcr for VMSA ARMv7 cores
Date: Fri, 28 Sep 2012 11:49:34 -0700
Message-Id: <20120928183003.275952918@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit dbece45894d3ab1baac15a96dc4e1e8e23f64a93 upstream.

When enabling the MMU for ARMv7 CPUs, the decompressor does not touch
the ttbcr register, assuming that it will be zeroed (N == 0, EAE == 0).
Given that only EAE is defined as 0 for non-secure copies of the
register (and a bootloader such as kexec may leave it set to 1 anyway),
we should ensure that we reset the register ourselves before turning on
the MMU.

This patch zeroes TTBCR.EAE and TTBCR.N prior to enabling the MMU for
ARMv7 cores in the decompressor, configuring us exclusively for 32-bit
translation tables via TTBR0.

Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Matthew Leach <matthew.leach@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/compressed/head.S |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -659,10 +659,14 @@ __armv7_mmu_cache_on:
 #ifdef CONFIG_CPU_ENDIAN_BE8
 		orr	r0, r0, #1 << 25	@ big-endian page tables
 #endif
+		mrcne   p15, 0, r6, c2, c0, 2   @ read ttb control reg
 		orrne	r0, r0, #1		@ MMU enabled
 		movne	r1, #0xfffffffd		@ domain 0 = client
+		bic     r6, r6, #1 << 31        @ 32-bit translation system
+		bic     r6, r6, #3 << 0         @ use only ttbr0
 		mcrne	p15, 0, r3, c2, c0, 0	@ load page table pointer
 		mcrne	p15, 0, r1, c3, c0, 0	@ load domain access control
+		mcrne   p15, 0, r6, c2, c0, 2   @ load ttb control
 #endif
 		mcr	p15, 0, r0, c7, c5, 4	@ ISB
 		mcr	p15, 0, r0, c1, c0, 0	@ load control register


