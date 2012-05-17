Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab2EQFQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 01:16:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47411 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab2EQFQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 01:16:35 -0400
Date: Wed, 16 May 2012 22:16:36 -0700
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] ARM: SoC fixes for 3.4
Message-ID: <20120517051636.GA25029@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 36be50515fe2aef61533b516fa2576a2c7fe7664:

  Linux 3.4-rc7 (2012-05-12 18:37:47 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to ad3b8a83933e83e5a2a08956211343bda269e778:

  ARM: PRIMA2: fix irq domain size and IRQ mask of internal interrupt controller (2012-05-16 21:52:13 -0700)

----------------------------------------------------------------
ARM: SoC fixes for 3.4

I will stop trying to predict when we're done with fixes for a release.

Here's another small batch of three patches for arm-soc:

- A fix for a boot time WARN_ON() due to irq domain conversion on PRIMA2
- Fix for a regression in Tegra SMP spinup code due to swapped register offsets
- Fixed config dependency for mv_cesa crypto driver to avoid build breakage

----------------------------------------------------------------
Alexander Clouter (1):
      crypto: mv_cesa requires on CRYPTO_HASH to build

Arnd Bergmann (2):
      Merge branch 'marvell_fixes_for_v3.4' of git://git.infradead.org/users/jcooper/linux into fixes
      Merge branch 'for-3.4/fixes-for-final' of git://git.kernel.org/.../swarren/linux-tegra into fixes

Barry Song (1):
      ARM: PRIMA2: fix irq domain size and IRQ mask of internal interrupt controller

Peter De Schrijver (1):
      ARM: tegra: Fix flow controller accesses

 arch/arm/mach-prima2/irq.c     | 6 ++++--
 arch/arm/mach-tegra/flowctrl.c | 4 ++--
 drivers/crypto/Kconfig         | 1 +
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-prima2/irq.c b/arch/arm/mach-prima2/irq.c
index 37c2de9..a7b9415 100644
--- a/arch/arm/mach-prima2/irq.c
+++ b/arch/arm/mach-prima2/irq.c
@@ -42,7 +42,8 @@ sirfsoc_alloc_gc(void __iomem *base, unsigned int irq_start, unsigned int num)
 static __init void sirfsoc_irq_init(void)
 {
 	sirfsoc_alloc_gc(sirfsoc_intc_base, 0, 32);
-	sirfsoc_alloc_gc(sirfsoc_intc_base + 4, 32, SIRFSOC_INTENAL_IRQ_END - 32);
+	sirfsoc_alloc_gc(sirfsoc_intc_base + 4, 32,
+			SIRFSOC_INTENAL_IRQ_END + 1 - 32);
 
 	writel_relaxed(0, sirfsoc_intc_base + SIRFSOC_INT_RISC_LEVEL0);
 	writel_relaxed(0, sirfsoc_intc_base + SIRFSOC_INT_RISC_LEVEL1);
@@ -68,7 +69,8 @@ void __init sirfsoc_of_irq_init(void)
 	if (!sirfsoc_intc_base)
 		panic("unable to map intc cpu registers\n");
 
-	irq_domain_add_legacy(np, 32, 0, 0, &irq_domain_simple_ops, NULL);
+	irq_domain_add_legacy(np, SIRFSOC_INTENAL_IRQ_END + 1, 0, 0,
+		&irq_domain_simple_ops, NULL);
 
 	of_node_put(np);
 
diff --git a/arch/arm/mach-tegra/flowctrl.c b/arch/arm/mach-tegra/flowctrl.c
index fef66a7..f07488e 100644
--- a/arch/arm/mach-tegra/flowctrl.c
+++ b/arch/arm/mach-tegra/flowctrl.c
@@ -53,10 +53,10 @@ static void flowctrl_update(u8 offset, u32 value)
 
 void flowctrl_write_cpu_csr(unsigned int cpuid, u32 value)
 {
-	return flowctrl_update(flowctrl_offset_halt_cpu[cpuid], value);
+	return flowctrl_update(flowctrl_offset_cpu_csr[cpuid], value);
 }
 
 void flowctrl_write_cpu_halt(unsigned int cpuid, u32 value)
 {
-	return flowctrl_update(flowctrl_offset_cpu_csr[cpuid], value);
+	return flowctrl_update(flowctrl_offset_halt_cpu[cpuid], value);
 }
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index ab9abb4..dd414d9 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -164,6 +164,7 @@ config CRYPTO_DEV_MV_CESA
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES
 	select CRYPTO_BLKCIPHER2
+	select CRYPTO_HASH
 	help
 	  This driver allows you to utilize the Cryptographic Engines and
 	  Security Accelerator (CESA) which can be found on the Marvell Orion
