Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966791Ab2JZW3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 18:29:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3024 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966765Ab2JZW3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 18:29:35 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=qCXup1kX4aAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=15xylSUfAn4A:10 a=VwQbUJbxAAAA:8 a=5fEQ8duNsXe7oITYnbYA:9 a=Zh68SRI7RUMA:10 a=2AUcKhdyPHMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121026222932.512114600@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 26 Oct 2012 18:28:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Kristian Lehmann <krleit00@hs-esslingen.de>
Subject: [PATCH RT 1/2] rcu: rcutiny: Prevent RCU stall
References: <20121026222835.523598217@goodmis.org>
Content-Disposition: inline; filename=0001-rcu-rcutiny-Prevent-RCU-stall.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

rcu_read_unlock_special() checks in_serving_softirq() and leaves early
when true. On RT this is obviously wrong as softirq processing context
can be preempted and therefor such a task can be on the gp_tasks
list. Leaving early here will leave the task on the list and therefor
block RCU processing forever.

This cannot happen on mainline because softirq processing context
cannot be preempted and therefor this can never happen at all.

In fact this check looks quite questionable in general. Neither irq
context nor softirq processing context in mainline can ever be
preempted in mainline so the special unlock case should not ever be
invoked in such context. Now the only explanation might be a
rcu_read_unlock() being interrupted and therefor leave the rcu nest
count at 0 before the special unlock bit has been cleared. That looks
fragile. At least it's missing a big fat comment. Paul ????

See mainline commits: ec433f0c5 and 8762705a for further enlightment.

Reported-by: Kristian Lehmann <krleit00@hs-esslingen.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rcutiny_plugin.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 22ecea0..97e359b 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -572,7 +572,7 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 		rcu_preempt_cpu_qs();
 
 	/* Hardware IRQ handlers cannot block. */
-	if (in_irq() || in_serving_softirq()) {
+	if (preempt_count() & (HARDIRQ_MASK | SOFTIRQ_OFFSET)) {
 		local_irq_restore(flags);
 		return;
 	}
-- 
1.7.10.4


