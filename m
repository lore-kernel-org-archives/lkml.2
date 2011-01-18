Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab1ARTFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 14:05:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45533 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021Ab1ARTFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 14:05:16 -0500
Date: Tue, 18 Jan 2011 20:05:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110118190504.GA11059@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Brian Gerst (1):
      x86: Clear irqstack thread_info

Shaohua Li (1):
      x86: Make relocatable kernel work with new binutils


 arch/x86/kernel/irq_32.c      |    7 ++-----
 arch/x86/kernel/vmlinux.lds.S |   11 +++++++++--
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 96656f2..5206bb9 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -129,8 +129,7 @@ void __cpuinit irq_ctx_init(int cpu)
 	irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
 					       THREAD_FLAGS,
 					       THREAD_ORDER));
-	irqctx->tinfo.task		= NULL;
-	irqctx->tinfo.exec_domain	= NULL;
+	memset(&irqctx->tinfo, 0, sizeof(struct thread_info));
 	irqctx->tinfo.cpu		= cpu;
 	irqctx->tinfo.preempt_count	= HARDIRQ_OFFSET;
 	irqctx->tinfo.addr_limit	= MAKE_MM_SEG(0);
@@ -140,10 +139,8 @@ void __cpuinit irq_ctx_init(int cpu)
 	irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
 					       THREAD_FLAGS,
 					       THREAD_ORDER));
-	irqctx->tinfo.task		= NULL;
-	irqctx->tinfo.exec_domain	= NULL;
+	memset(&irqctx->tinfo, 0, sizeof(struct thread_info));
 	irqctx->tinfo.cpu		= cpu;
-	irqctx->tinfo.preempt_count	= 0;
 	irqctx->tinfo.addr_limit	= MAKE_MM_SEG(0);
 
 	per_cpu(softirq_ctx, cpu) = irqctx;
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index bf47007..b34ab80 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -34,11 +34,9 @@ OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT)
 #ifdef CONFIG_X86_32
 OUTPUT_ARCH(i386)
 ENTRY(phys_startup_32)
-jiffies = jiffies_64;
 #else
 OUTPUT_ARCH(i386:x86-64)
 ENTRY(phys_startup_64)
-jiffies_64 = jiffies;
 #endif
 
 #if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
@@ -142,6 +140,15 @@ SECTIONS
 		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
 
 		DATA_DATA
+		/*
+		 * Workaround a binutils (2.20.51.0.12 to 2.21.51.0.3) bug.
+		 * This makes jiffies relocatable in such binutils
+		 */
+#ifdef CONFIG_X86_32
+		jiffies = jiffies_64;
+#else
+		jiffies_64 = jiffies;
+#endif
 		CONSTRUCTORS
 
 		/* rarely changed data like cpu maps */
