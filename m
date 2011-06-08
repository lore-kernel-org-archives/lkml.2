Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab1FHTax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:30:53 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48401 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444Ab1FHTao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:30:44 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jes Sorensen <jes@sgi.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH tip/core/rcu 17/28] ia64,rcu: Convert call_rcu(sn_irq_info_free) to kfree_rcu()
Date: Wed,  8 Jun 2011 12:29:56 -0700
Message-Id: <1307561407-13809-17-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110608192943.GA13211@linux.vnet.ibm.com>
References: <20110608192943.GA13211@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback sn_irq_info_free() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(sn_irq_info_free).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Jes Sorensen <jes@sgi.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/ia64/sn/kernel/irq.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/ia64/sn/kernel/irq.c b/arch/ia64/sn/kernel/irq.c
index 81a1f4e..485c42d 100644
--- a/arch/ia64/sn/kernel/irq.c
+++ b/arch/ia64/sn/kernel/irq.c
@@ -112,8 +112,6 @@ static void sn_ack_irq(struct irq_data *data)
 	irq_move_irq(data);
 }
 
-static void sn_irq_info_free(struct rcu_head *head);
-
 struct sn_irq_info *sn_retarget_vector(struct sn_irq_info *sn_irq_info,
 				       nasid_t nasid, int slice)
 {
@@ -177,7 +175,7 @@ struct sn_irq_info *sn_retarget_vector(struct sn_irq_info *sn_irq_info,
 	spin_lock(&sn_irq_info_lock);
 	list_replace_rcu(&sn_irq_info->list, &new_irq_info->list);
 	spin_unlock(&sn_irq_info_lock);
-	call_rcu(&sn_irq_info->rcu, sn_irq_info_free);
+	kfree_rcu(sn_irq_info, rcu);
 
 
 finish_up:
@@ -338,14 +336,6 @@ static void unregister_intr_pda(struct sn_irq_info *sn_irq_info)
 	rcu_read_unlock();
 }
 
-static void sn_irq_info_free(struct rcu_head *head)
-{
-	struct sn_irq_info *sn_irq_info;
-
-	sn_irq_info = container_of(head, struct sn_irq_info, rcu);
-	kfree(sn_irq_info);
-}
-
 void sn_irq_fixup(struct pci_dev *pci_dev, struct sn_irq_info *sn_irq_info)
 {
 	nasid_t nasid = sn_irq_info->irq_nasid;
@@ -399,7 +389,7 @@ void sn_irq_unfixup(struct pci_dev *pci_dev)
 	spin_unlock(&sn_irq_info_lock);
 	if (list_empty(sn_irq_lh[sn_irq_info->irq_irq]))
 		free_irq_vector(sn_irq_info->irq_irq);
-	call_rcu(&sn_irq_info->rcu, sn_irq_info_free);
+	kfree_rcu(sn_irq_info, rcu);
 	pci_dev_put(pci_dev);
 
 }
-- 
1.7.3.2

