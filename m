Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab2GTMlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 08:41:24 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:41129 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753442Ab2GTMlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 08:41:18 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah)
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <scottwood@freescale.com>,
        <galak@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: [PATCH v8 2/7] powerpc/smp: add generic_set_cpu_up() to set cpu_state as CPU_UP_PREPARE
Date: Fri, 20 Jul 2012 20:42:34 +0800
Message-ID: <1342788159-27529-3-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.6.4.1
In-Reply-To: <1342788159-27529-1-git-send-email-chenhui.zhao@freescale.com>
References: <1342788159-27529-1-git-send-email-chenhui.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of cpu hotplug, the cpu_state should be set to CPU_UP_PREPARE when kicking cpu.
Otherwise, the cpu_state is always CPU_DEAD after calling generic_set_cpu_dead(), which
makes the delay in generic_cpu_die() not happen.

Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
---
 arch/powerpc/include/asm/smp.h |    1 +
 arch/powerpc/kernel/smp.c      |   12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/smp.h b/arch/powerpc/include/asm/smp.h
index ebc24dc..ce8e2bd 100644
--- a/arch/powerpc/include/asm/smp.h
+++ b/arch/powerpc/include/asm/smp.h
@@ -65,6 +65,7 @@ int generic_cpu_disable(void);
 void generic_cpu_die(unsigned int cpu);
 void generic_mach_cpu_die(void);
 void generic_set_cpu_dead(unsigned int cpu);
+void generic_set_cpu_up(unsigned int cpu);
 int generic_check_cpu_restart(unsigned int cpu);
 #endif
 
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 0321007..fecb038 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -102,7 +102,7 @@ int __devinit smp_generic_kick_cpu(int nr)
 	 * Ok it's not there, so it might be soft-unplugged, let's
 	 * try to bring it back
 	 */
-	per_cpu(cpu_state, nr) = CPU_UP_PREPARE;
+	generic_set_cpu_up(nr);
 	smp_wmb();
 	smp_send_reschedule(nr);
 #endif /* CONFIG_HOTPLUG_CPU */
@@ -406,6 +406,16 @@ void generic_set_cpu_dead(unsigned int cpu)
 	per_cpu(cpu_state, cpu) = CPU_DEAD;
 }
 
+/*
+ * The cpu_state should be set to CPU_UP_PREPARE in kick_cpu(), otherwise
+ * the cpu_state is always CPU_DEAD after calling generic_set_cpu_dead(),
+ * which makes the delay in generic_cpu_die() not happen.
+ */
+void generic_set_cpu_up(unsigned int cpu)
+{
+	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
+}
+
 int generic_check_cpu_restart(unsigned int cpu)
 {
 	return per_cpu(cpu_state, cpu) == CPU_UP_PREPARE;
-- 
1.6.4.1


