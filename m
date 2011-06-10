Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab1FJHu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 03:50:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:57983 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab1FJHuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 03:50:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,345,1304319600"; 
   d="scan'208";a="10655858"
Subject: [PATCH]rcu: avoid unnecessary thread wakeup
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jun 2011 15:50:51 +0800
Message-ID: <1307692251.15392.91.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

invoke_rcu_cpu_kthread could be called in the thread itself. In this case,
we don't need call wakeup, which is just wasting CPU.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 89419ff..f9bd051 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1475,7 +1475,8 @@ static void invoke_rcu_cpu_kthread(void)
 		local_irq_restore(flags);
 		return;
 	}
-	wake_up_process(__this_cpu_read(rcu_cpu_kthread_task));
+	if (current != __this_cpu_read(rcu_cpu_kthread_task))
+		wake_up_process(__this_cpu_read(rcu_cpu_kthread_task));
 	local_irq_restore(flags);
 }
 


