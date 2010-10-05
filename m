Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab0JENjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 09:39:55 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:55163 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab0JENjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 09:39:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: mingo@elte.hu
Cc: akpm@linux-foundation.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/1] softirq: cleanup preempt check
Date: Tue,  5 Oct 2010 15:35:46 +0200
Message-Id: <1286285746-3917-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <20101005074554.GB23608@elte.hu>
References: <20101005074554.GB23608@elte.hu>
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 05 Oct 2010 15:35:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The preempt debugging check in the softirq code is ugly. The print is
lenghty and spread over several lines which makes the code difficult
to read. This was also the reason for the wrong spacing in the message.

So move the check into a separate inlined function and make the print
text a one-liner for easier grepping.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/softirq.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 2bf4cd5..4366370 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -177,6 +177,17 @@ void local_bh_enable_ip(unsigned long ip)
 }
 EXPORT_SYMBOL(local_bh_enable_ip);
 
+static inline void softirq_preempt_check(struct softirq_action *h,
+		int prev_count)
+{
+	if (unlikely(prev_count != preempt_count())) {
+		printk(KERN_ERR "huh, entered softirq %td %s %pf with preempt_count %08x, exited with %08x?\n",
+			h - softirq_vec, softirq_to_name[h - softirq_vec],
+			h->action, prev_count, preempt_count());
+		preempt_count() = prev_count;
+	}
+}
+
 /*
  * We restart softirq processing MAX_SOFTIRQ_RESTART times,
  * and we fall back to softirqd after that.
@@ -218,14 +229,8 @@ restart:
 			trace_softirq_entry(h, softirq_vec);
 			h->action(h);
 			trace_softirq_exit(h, softirq_vec);
-			if (unlikely(prev_count != preempt_count())) {
-				printk(KERN_ERR "huh, entered softirq %td %s "
-				       "%pf with preempt_count %08x,"
-				       " exited with %08x?\n", h - softirq_vec,
-				       softirq_to_name[h - softirq_vec],
-				       h->action, prev_count, preempt_count());
-				preempt_count() = prev_count;
-			}
+
+			softirq_preempt_check(h, prev_count);
 
 			rcu_bh_qs(cpu);
 		}
-- 
1.7.3.1

