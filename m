Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab3AHXhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:37:10 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53582 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab3AHXhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:05 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 23/77] ARM: 7161/1: errata: no automatic store buffer drain
Date: Tue, 8 Jan 2013 18:35:02 -0500
Message-ID: <1357688156-25387-24-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/arm/Kconfig          | 12 ++++++++++++
 arch/arm/kernel/process.c |  3 +++
 2 files changed, 15 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 811dedc..3ee6a06 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1380,6 +1380,18 @@ config UACCESS_WITH_MEMCPY
 	  However, if the CPU data cache is using a write-allocate mode,
 	  this option is unlikely to provide any performance gain.
 
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
 
 menu "Boot options"
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index acf5e6f..7f170f4 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -155,6 +155,9 @@ void cpu_idle(void)
 #endif
 
 			local_irq_disable();
+#ifdef CONFIG_PL310_ERRATA_769419
+			wmb();
+#endif
 			if (hlt_counter) {
 				local_irq_enable();
 				cpu_relax();
-- 
1.7.12.1

