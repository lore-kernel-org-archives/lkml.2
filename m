Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab1I3SR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:17:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38908 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757272Ab1I3SR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:17:56 -0400
Date: Fri, 30 Sep 2011 20:16:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq fixes
Message-ID: <20110930181622.GA19077@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-urgent-for-linus

 Thanks,

	Ingo

------------------>
Rob Herring (2):
      irq: Add declaration of irq_domain_simple_ops to irqdomain.h
      irq: Fix check for already initialized irq_domain in irq_domain_add


 include/linux/irqdomain.h |    1 +
 kernel/irq/irqdomain.c    |    6 +++++-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index e807ad6..3ad553e 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -80,6 +80,7 @@ extern void irq_domain_del(struct irq_domain *domain);
 #endif /* CONFIG_IRQ_DOMAIN */
 
 #if defined(CONFIG_IRQ_DOMAIN) && defined(CONFIG_OF_IRQ)
+extern struct irq_domain_ops irq_domain_simple_ops;
 extern void irq_domain_add_simple(struct device_node *controller, int irq_base);
 extern void irq_domain_generate_simple(const struct of_device_id *match,
 					u64 phys_base, unsigned int irq_start);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index d5828da..b57a377 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -29,7 +29,11 @@ void irq_domain_add(struct irq_domain *domain)
 	 */
 	for (hwirq = 0; hwirq < domain->nr_irq; hwirq++) {
 		d = irq_get_irq_data(irq_domain_to_irq(domain, hwirq));
-		if (d || d->domain) {
+		if (!d) {
+			WARN(1, "error: assigning domain to non existant irq_desc");
+			return;
+		}
+		if (d->domain) {
 			/* things are broken; just report, don't clean up */
 			WARN(1, "error: irq_desc already assigned to a domain");
 			return;
