Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab0EJRs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 13:48:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab0EJRsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 13:48:50 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 2/5] kprobes: Limit maximum number of optimization at once
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>,
       Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Mon, 10 May 2010 13:53:27 -0400
Message-ID: <20100510175327.27396.72255.stgit@localhost6.localdomain6>
In-Reply-To: <20100510175313.27396.34605.stgit@localhost6.localdomain6>
References: <20100510175313.27396.34605.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since text_poke_smp() uses stop_machine(), the machine almost
stop a while if we optimize a lot of probes at once. This patch
limits the maximum number of probes to optimize (means calling
text_poke_smp()) at once, and try it again after a while if
there are more probes waiting for optimization than the
limitation.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---

 kernel/kprobes.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 1d34eef..aae368a 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -424,11 +424,13 @@ static LIST_HEAD(optimizing_list);
 static void kprobe_optimizer(struct work_struct *work);
 static DECLARE_DELAYED_WORK(optimizing_work, kprobe_optimizer);
 #define OPTIMIZE_DELAY 5
+#define MAX_OPTIMIZE_PROBES 64
 
 /* Kprobe jump optimizer */
 static __kprobes void kprobe_optimizer(struct work_struct *work)
 {
 	struct optimized_kprobe *op, *tmp;
+	int c = 0;
 
 	/* Lock modules while optimizing kprobes */
 	mutex_lock(&module_mutex);
@@ -462,9 +464,13 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
 		if (arch_optimize_kprobe(op) < 0)
 			op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
 		list_del_init(&op->list);
+		if (++c >= MAX_OPTIMIZE_PROBES)
+			break;
 	}
 	mutex_unlock(&text_mutex);
 	put_online_cpus();
+	if (!list_empty(&optimizing_list))
+		schedule_delayed_work(&optimizing_work, OPTIMIZE_DELAY);
 end:
 	mutex_unlock(&kprobe_mutex);
 	mutex_unlock(&module_mutex);


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
