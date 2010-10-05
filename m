Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab0JEDNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 23:13:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43132 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423Ab0JEDNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 23:13:09 -0400
Date: Tue, 5 Oct 2010 14:12:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the lost-spurious-irq tree with the tip
 tree
Message-Id: <20101005141258.af27dee9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Today's linux-next merge of the lost-spurious-irq tree got a conflict in
kernel/irq/internals.h between commits
a77c4635915021c646cc017f22239e66d1aab4d5 ("genirq: Add new functions to
dummy chips") and bd151412263a67b5321e9dd1d5b4bf6d96fdebf3 ("genirq:
Provide config option to disable deprecated code") from the tip tree and
commits 32b5d378f49485f3ae172eb0ac2bfc4ebbbdb060 ("irq: cleanup
irqfixup") and 80f97e2b33c3e66c11b10abd2890506a3abeb320 ("irq: make
spurious poll timer per desc") from the lost-spurious-irq tree.

Just context changes.  I fixed it up (see below) and can carry the fixes
as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/irq/internals.h
index b905f0a,1b24309..0000000
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@@ -2,10 -2,6 +2,8 @@@
   * IRQ subsystem internal functions and variables:
   */
  
- extern int noirqdebug;
- 
 +#define irq_data_to_desc(data)	container_of(data, struct irq_desc, irq_data)
 +
  /* Set default functions for irq_chip structures: */
  extern void irq_chip_set_defaults(struct irq_chip *chip);
  
@@@ -42,27 -38,23 +40,33 @@@ extern int irq_select_affinity_usr(unsi
  
  extern void irq_set_thread_affinity(struct irq_desc *desc);
  
 +#ifndef CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED
 +static inline void irq_end(unsigned int irq, struct irq_desc *desc)
 +{
 +	if (desc->irq_data.chip && desc->irq_data.chip->end)
 +		desc->irq_data.chip->end(irq);
 +}
 +#else
 +static inline void irq_end(unsigned int irq, struct irq_desc *desc) { }
 +#endif
 +
+ extern void poll_irq(unsigned long arg);
+ extern void irq_poll_action_added(struct irq_desc *desc,
+ 				  struct irqaction *action);
+ extern void irq_poll_action_removed(struct irq_desc *desc,
+ 				    struct irqaction *action);
+ 
  /* Inline functions for support of irq chips on slow busses */
 -static inline void chip_bus_lock(unsigned int irq, struct irq_desc *desc)
 +static inline void chip_bus_lock(struct irq_desc *desc)
  {
 -	if (unlikely(desc->chip->bus_lock))
 -		desc->chip->bus_lock(irq);
 +	if (unlikely(desc->irq_data.chip->irq_bus_lock))
 +		desc->irq_data.chip->irq_bus_lock(&desc->irq_data);
  }
  
 -static inline void chip_bus_sync_unlock(unsigned int irq, struct irq_desc *desc)
 +static inline void chip_bus_sync_unlock(struct irq_desc *desc)
  {
 -	if (unlikely(desc->chip->bus_sync_unlock))
 -		desc->chip->bus_sync_unlock(irq);
 +	if (unlikely(desc->irq_data.chip->irq_bus_sync_unlock))
 +		desc->irq_data.chip->irq_bus_sync_unlock(&desc->irq_data);
  }
  
  /*
@@@ -76,11 -68,11 +80,11 @@@
  static inline void print_irq_desc(unsigned int irq, struct irq_desc *desc)
  {
  	printk("irq %d, desc: %p, depth: %d, count: %d, unhandled: %d\n",
- 		irq, desc, desc->depth, desc->irq_count, desc->irqs_unhandled);
+ 		irq, desc, desc->depth, desc->spr.nr_samples, desc->spr.nr_bad);
  	printk("->handle_irq():  %p, ", desc->handle_irq);
  	print_symbol("%s\n", (unsigned long)desc->handle_irq);
 -	printk("->chip(): %p, ", desc->chip);
 -	print_symbol("%s\n", (unsigned long)desc->chip);
 +	printk("->irq_data.chip(): %p, ", desc->irq_data.chip);
 +	print_symbol("%s\n", (unsigned long)desc->irq_data.chip);
  	printk("->action(): %p\n", desc->action);
  	if (desc->action) {
  		printk("->action->handler(): %p, ", desc->action->handler);
