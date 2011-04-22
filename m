Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab1DVNdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 09:33:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49006 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078Ab1DVNdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 09:33:44 -0400
Date: Fri, 22 Apr 2011 15:33:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq fix
Message-ID: <20110422133333.GA22154@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

 Thanks,

	Ingo

------------------>
Thomas Gleixner (1):
      xtensa: Fixup irq conversion fallout and nmi_count


 arch/xtensa/kernel/irq.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/xtensa/kernel/irq.c b/arch/xtensa/kernel/irq.c
index d77089d..4340ee0 100644
--- a/arch/xtensa/kernel/irq.c
+++ b/arch/xtensa/kernel/irq.c
@@ -64,47 +64,41 @@ asmlinkage void do_IRQ(int irq, struct pt_regs *regs)
 
 int arch_show_interrupts(struct seq_file *p, int prec)
 {
-	int j;
-
-	seq_printf(p, "%*s: ", prec, "NMI");
-	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", nmi_count(j));
-	seq_putc(p, '\n');
 	seq_printf(p, "%*s: ", prec, "ERR");
 	seq_printf(p, "%10u\n", atomic_read(&irq_err_count));
 	return 0;
 }
 
-static void xtensa_irq_mask(struct irq_chip *d)
+static void xtensa_irq_mask(struct irq_data *d)
 {
 	cached_irq_mask &= ~(1 << d->irq);
 	set_sr (cached_irq_mask, INTENABLE);
 }
 
-static void xtensa_irq_unmask(struct irq_chip *d)
+static void xtensa_irq_unmask(struct irq_data *d)
 {
 	cached_irq_mask |= 1 << d->irq;
 	set_sr (cached_irq_mask, INTENABLE);
 }
 
-static void xtensa_irq_enable(struct irq_chip *d)
+static void xtensa_irq_enable(struct irq_data *d)
 {
 	variant_irq_enable(d->irq);
 	xtensa_irq_unmask(d->irq);
 }
 
-static void xtensa_irq_disable(struct irq_chip *d)
+static void xtensa_irq_disable(struct irq_data *d)
 {
 	xtensa_irq_mask(d->irq);
 	variant_irq_disable(d->irq);
 }
 
-static void xtensa_irq_ack(struct irq_chip *d)
+static void xtensa_irq_ack(struct irq_data *d)
 {
 	set_sr(1 << d->irq, INTCLEAR);
 }
 
-static int xtensa_irq_retrigger(struct irq_chip *d)
+static int xtensa_irq_retrigger(struct irq_data *d)
 {
 	set_sr (1 << d->irq, INTSET);
 	return 1;
