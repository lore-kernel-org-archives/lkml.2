Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab1ESVDH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:03:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35213 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab1ESVDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:03:05 -0400
Date: Thu, 19 May 2011 23:02:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/irq changes for v2.6.40
Message-ID: <20110519210256.GA8830@elte.hu>
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

Please pull the latest x86-irq-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-irq-for-linus

 Thanks,

	Ingo

------------------>
Tian, Kevin (2):
      x86: Skip migrating IRQF_PER_CPU irqs in fixup_irqs()
      x86: Don't unmask disabled irqs when migrating them


 arch/x86/kernel/irq.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 1cb0b9f..6c0802e 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -249,7 +249,7 @@ void fixup_irqs(void)
 
 		data = irq_desc_get_irq_data(desc);
 		affinity = data->affinity;
-		if (!irq_has_action(irq) ||
+		if (!irq_has_action(irq) || irqd_is_per_cpu(data) ||
 		    cpumask_subset(affinity, cpu_online_mask)) {
 			raw_spin_unlock(&desc->lock);
 			continue;
@@ -276,7 +276,8 @@ void fixup_irqs(void)
 		else if (!(warned++))
 			set_affinity = 0;
 
-		if (!irqd_can_move_in_process_context(data) && chip->irq_unmask)
+		if (!irqd_can_move_in_process_context(data) &&
+		    !irqd_irq_disabled(data) && chip->irq_unmask)
 			chip->irq_unmask(data);
 
 		raw_spin_unlock(&desc->lock);
