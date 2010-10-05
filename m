Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab0JEDUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 23:20:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33690 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588Ab0JEDUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 23:20:19 -0400
Date: Tue, 5 Oct 2010 14:20:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the lost-spurious-irq tree with the
 tip tree
Message-Id: <20101005142017.661c6ff9.sfr@canb.auug.org.au>
In-Reply-To: <20101005141334.6a0f15fd.sfr@canb.auug.org.au>
References: <20101005141334.6a0f15fd.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Tue, 5 Oct 2010 14:13:34 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Today's linux-next merge of the lost-spurious-irq tree got a conflict in
> kernel/irq/spurious.c between commits
> 6b8ff3120c758340505dddf08ad685ebb841d5d5 ("genirq: Convert core code to
> irq_data") and bd151412263a67b5321e9dd1d5b4bf6d96fdebf3 ("genirq: Provide
> config option to disable deprecated code") from the tip tree and commits
> 32b5d378f49485f3ae172eb0ac2bfc4ebbbdb060 ("irq: cleanup irqfixup") and
> 80f97e2b33c3e66c11b10abd2890506a3abeb320 ("irq: make spurious poll timer
> per desc") from the lost-spurious-irq tree.
> 
> I think I fixed it all up (see below).  I can carry this fix (or a better
> one) as necessary.

I then had to apply the following merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 5 Oct 2010 14:14:11 +1100
Subject: [PATCH] irq: fix for bus_lock API change

Due to commit 3876ec9ef3775d062345b3760d3271ecb8cd3fea ("genirq: Provide
compat handling for bus_lock/bus_sync_unlock") from the tip tree.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 kernel/irq/spurious.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index cfcd2e9..1f17127 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -878,7 +878,7 @@ void poll_irq(unsigned long arg)
 		return;
 
 	/* need to do locking dance for chip_bus_lock() to reenable IRQ */
-	chip_bus_lock(desc->irq_data.irq, desc);
+	chip_bus_lock(desc);
 	raw_spin_lock_irq(&desc->lock);
 
 	/* make sure we haven't raced with anyone inbetween */
@@ -890,7 +890,7 @@ void poll_irq(unsigned long arg)
 	}
 
 	raw_spin_unlock_irq(&desc->lock);
-	chip_bus_sync_unlock(desc->irq_data.irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 
 void irq_poll_action_added(struct irq_desc *desc, struct irqaction *action)
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
