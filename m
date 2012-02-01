Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab2BATnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:43:08 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:40482 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774Ab2BATnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:43:02 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH RFC tip/core/rcu 07/41] s390: Convert call_rcu() to kfree_rcu()
Date: Wed,  1 Feb 2012 11:41:25 -0800
Message-Id: <1328125319-5205-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-7282-0000-0000-0000061F2587
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The call_rcu() in unregister_external_interrupt() invokes
ext_int_hash_update(), which just does a kfree().  Convert the
call_rcu() to kfree_rcu(), allowing ext_int_hash_update() to
be eliminated.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/kernel/irq.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index b9a7fdd..e30b2df 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -165,13 +165,6 @@ static inline int ext_hash(u16 code)
 	return (code + (code >> 9)) & 0xff;
 }
 
-static void ext_int_hash_update(struct rcu_head *head)
-{
-	struct ext_int_info *p = container_of(head, struct ext_int_info, rcu);
-
-	kfree(p);
-}
-
 int register_external_interrupt(u16 code, ext_int_handler_t handler)
 {
 	struct ext_int_info *p;
@@ -202,7 +195,7 @@ int unregister_external_interrupt(u16 code, ext_int_handler_t handler)
 	list_for_each_entry_rcu(p, &ext_int_hash[index], entry)
 		if (p->code == code && p->handler == handler) {
 			list_del_rcu(&p->entry);
-			call_rcu(&p->rcu, ext_int_hash_update);
+			kfree_rcu(p, rcu);
 		}
 	spin_unlock_irqrestore(&ext_int_hash_lock, flags);
 	return 0;
-- 
1.7.8

