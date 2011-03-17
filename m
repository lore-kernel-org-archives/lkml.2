Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab1CQTWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 15:22:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46195 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab1CQTWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 15:22:10 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=vhdKIqpQuCYA:10 a=jKzRtJ-AOHIA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=pQ84p8bZnIrrL--BOikA:9 a=obxiIoaAM047skQAbLthRqzUJHMA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110317192208.682654502@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 17 Mar 2011 15:21:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/2] futex: Fix WARN_ON() test for UP
References: <20110317192105.308382309@goodmis.org>
Content-Disposition: inline; filename=0002-futex-Fix-WARN_ON-test-for-UP.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

An update of the futex code had a

	WARN_ON(!spin_is_locked(q->lock_ptr))

But on UP, spin_is_locked() is always false, and will
trigger this warning, and even worse, it will exit the function
without doing the necessary work.

Converting this to a WARN_ON_SMP() fixes the problem.

Reported-by: Richard Weinberger <richard@nod.at>
Tested-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/futex.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 9fe9131..850d00b 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -785,8 +785,8 @@ static void __unqueue_futex(struct futex_q *q)
 {
 	struct futex_hash_bucket *hb;
 
-	if (WARN_ON(!q->lock_ptr || !spin_is_locked(q->lock_ptr)
-			|| plist_node_empty(&q->list)))
+	if (WARN_ON_SMP(!q->lock_ptr || !spin_is_locked(q->lock_ptr))
+	    || WARN_ON(plist_node_empty(&q->list)))
 		return;
 
 	hb = container_of(q->lock_ptr, struct futex_hash_bucket, lock);
-- 
1.7.2.3


