Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033Ab2JaAdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 20:33:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15455 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab2JaAdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 20:33:16 -0400
X-Authority-Analysis: v=2.0 cv=KcBQQHkD c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=xeYwfR7OzYsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=xevd-OzywMUA:10 a=BbwCCoxnAAAA:8 a=VwQbUJbxAAAA:8 a=0kNQ-MfBMuU_7YX1S3UA:9 a=oviIBxwnDvQA:10 a=Zh68SRI7RUMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121031003314.510366648@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 30 Oct 2012 20:32:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 1/4] hrtimer: Raise softirq if hrtimer irq stalled
References: <20121031003258.811955127@goodmis.org>
Content-Disposition: inline; filename=0001-hrtimer-Raise-softirq-if-hrtimer-irq-stalled.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Watanabe <shunsuke.watanabe@tel.com>

When the hrtimer stall detection hits the softirq is not raised.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
---
 kernel/hrtimer.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 7327846..87b4917 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1527,11 +1527,7 @@ retry:
 	if (expires_next.tv64 == KTIME_MAX ||
 	    !tick_program_event(expires_next, 0)) {
 		cpu_base->hang_detected = 0;
-
-		if (raise)
-			raise_softirq_irqoff(HRTIMER_SOFTIRQ);
-
-		return;
+		goto out;
 	}
 
 	/*
@@ -1575,6 +1571,9 @@ retry:
 	tick_program_event(expires_next, 1);
 	printk_once(KERN_WARNING "hrtimer: interrupt took %llu ns\n",
 		    ktime_to_ns(delta));
+out:
+	if (raise)
+		raise_softirq_irqoff(HRTIMER_SOFTIRQ);
 }
 
 /*
-- 
1.7.10.4


