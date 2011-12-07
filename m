Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab1LGQsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:48:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33737 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932916Ab1LGQVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:21:04 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:16 2011
Message-Id: <20111207161216.482507846@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:23 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [021/104] ARM: 7161/1: errata: no automatic store buffer drain
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 11ed0ba1754841316d4095478944300acf19acc3 upstream.

This patch implements a workaround for PL310 erratum 769419. On
revisions of the PL310 prior to r3p2, the Store Buffer does not
automatically drain. This can cause normal, non-cacheable writes to be
retained when the memory system is idle, leading to suboptimal I/O
performance for drivers using coherent DMA.

This patch adds an optional wmb() call to the cpu_idle loop. On systems
with an outer cache, this causes an explicit flush of the store buffer.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/Kconfig          |   12 ++++++++++++
 arch/arm/kernel/process.c |    3 +++
 2 files changed, 15 insertions(+)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1297,6 +1297,18 @@ config ARM_ERRATA_764369
 	  relevant cache maintenance functions and sets a specific bit
 	  in the diagnostic control register of the SCU.
 
+config PL310_ERRATA_769419
+	bool "PL310 errata: no automatic Store Buffer drain"
+	depends on CACHE_L2X0
+	help
+	  On revisions of the PL310 prior to r3p2, the Store Buffer does
+	  not automatically drain. This can cause normal, non-cacheable
+	  writes to be retained when the memory system is idle, leading
+	  to suboptimal I/O performance for drivers using coherent DMA.
+	  This option adds a write barrier to the cpu_idle loop so that,
+	  on systems with an outer cache, the store buffer is drained
+	  explicitly.
+
 endmenu
 
 source "arch/arm/common/Kconfig"
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -192,6 +192,9 @@ void cpu_idle(void)
 #endif
 
 			local_irq_disable();
+#ifdef CONFIG_PL310_ERRATA_769419
+			wmb();
+#endif
 			if (hlt_counter) {
 				local_irq_enable();
 				cpu_relax();


