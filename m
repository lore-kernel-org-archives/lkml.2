Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab2ABQdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 11:33:31 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:24139
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752743Ab2ABQd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 11:33:29 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh8275dhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LX6JBN-02-WEA-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Russell King <linux@arm.linux.org.uk>
CC: Joerg Roedel <joerg.roedel@amd.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Herring <rob.herring@calxeda.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] arm: Fix linux-next compile error in arch/arm/common/gic.c
Date: Mon, 2 Jan 2012 17:33:10 +0100
Message-ID: <1325521990-4445-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_SMP=n the following compile error occurs:

  CC      arch/arm/common/gic.o
arch/arm/common/gic.c: In function 'gic_init_bases':
arch/arm/common/gic.c:679:4: error: implicit declaration of function 'cpu_logical_map' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

This patch fixes the problem.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/arm/common/gic.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index b2dc2dd..b33f6b0 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -676,7 +676,10 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 		}
 
 		for_each_possible_cpu(cpu) {
-			unsigned long offset = percpu_offset * cpu_logical_map(cpu);
+			unsigned long offset = percpu_offset;
+#ifdef CONFIG_SMP
+			offset *= cpu_logical_map(cpu);
+#endif
 			*per_cpu_ptr(gic->dist_base.percpu_base, cpu) = dist_base + offset;
 			*per_cpu_ptr(gic->cpu_base.percpu_base, cpu) = cpu_base + offset;
 		}
-- 
1.7.5.4


