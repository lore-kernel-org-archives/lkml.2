Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab0LPC6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 21:58:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:52676 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755148Ab0LPC6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 21:58:16 -0500
Date: Thu, 16 Dec 2010 02:57:57 GMT
From: tip-bot for Andres Salomon <dilinger@queued.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dilinger@queued.net, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dilinger@queued.net, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20101111214526.5de7121b@queued.net>
References: <20101111214526.5de7121b@queued.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/olpc] x86, of: Define irq functions to allow drivers/of/* to build on x86
Message-ID: <tip-4722d194e648fb5755faecee895b96b26f9732f3@git.kernel.org>
Git-Commit-ID: 4722d194e648fb5755faecee895b96b26f9732f3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Dec 2010 02:57:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4722d194e648fb5755faecee895b96b26f9732f3
Gitweb:     http://git.kernel.org/tip/4722d194e648fb5755faecee895b96b26f9732f3
Author:     Andres Salomon <dilinger@queued.net>
AuthorDate: Fri, 12 Nov 2010 05:45:26 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 15 Dec 2010 17:11:16 -0800

x86, of: Define irq functions to allow drivers/of/* to build on x86

- Define a stub irq_create_of_mapping for x86 as a stop-gap solution until
   drivers/of/irq is further along.
 - Define irq_dispose_mapping for x86 to appease of_i2c.c

These are needed to allow stuff in drivers/of/ to build on x86.  This stuff
will eventually get replaced; quoting Grant,

"The long term plan is to have the drivers/of/ code handling the mapping
intelligently like powerpc currently does."  But for now, just provide
these functions.

Signed-off-by: Andres Salomon <dilinger@queued.net>
LKML-Reference: <20101111214526.5de7121b@queued.net>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/irq.h |    3 +++
 arch/x86/kernel/irq.c      |   10 ++++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 13b0eba..8d2c671 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -10,6 +10,9 @@
 #include <asm/apicdef.h>
 #include <asm/irq_vectors.h>
 
+/* Even though we don't support this, supply it to appease OF */
+static inline void irq_dispose_mapping(unsigned int virq) { }
+
 static inline int irq_canonicalize(int irq)
 {
 	return ((irq == 2) ? 9 : irq);
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 83ec017..d833d1b 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -4,6 +4,7 @@
 #include <linux/cpu.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
+#include <linux/of.h>
 #include <linux/seq_file.h>
 #include <linux/smp.h>
 #include <linux/ftrace.h>
@@ -275,6 +276,15 @@ void smp_x86_platform_ipi(struct pt_regs *regs)
 
 EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
 
+#ifdef CONFIG_OF
+unsigned int irq_create_of_mapping(struct device_node *controller,
+		const u32 *intspec, unsigned int intsize)
+{
+	return intspec[0];
+}
+EXPORT_SYMBOL_GPL(irq_create_of_mapping);
+#endif
+
 #ifdef CONFIG_HOTPLUG_CPU
 /* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
 void fixup_irqs(void)
