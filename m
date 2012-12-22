Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab2LVE0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 23:26:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28261 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab2LVEZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 23:25:55 -0500
X-Authority-Analysis: v=2.0 cv=QPnqt33L c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=V2H3lkE-9R8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=o7EQseuvQBcA:10 a=VwQbUJbxAAAA:8 a=2LSXkEi98N5-jCFdiEkA:9 a=Zh68SRI7RUMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121222042554.207940346@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 21 Dec 2012 23:25:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>
Subject: [PATCH RT 4/5] block: Use cpu_chill() for retry loops
References: <20121222042515.867823077@goodmis.org>
Content-Disposition: inline; filename=0004-block-Use-cpu_chill-for-retry-loops.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Retry loops on RT might loop forever when the modifying side was
preempted. Steven also observed a live lock when there was a
concurrent priority boosting going on.

Use cpu_chill() instead of cpu_relax() to let the system
make progress.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
---
 block/blk-ioc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index fb95dd2..6b54201 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -8,6 +8,7 @@
 #include <linux/blkdev.h>
 #include <linux/bootmem.h>	/* for max_pfn/max_low_pfn */
 #include <linux/slab.h>
+#include <linux/delay.h>
 
 #include "blk.h"
 
@@ -110,7 +111,7 @@ static void ioc_release_fn(struct work_struct *work)
 			spin_unlock(q->queue_lock);
 		} else {
 			spin_unlock_irqrestore(&ioc->lock, flags);
-			cpu_relax();
+			cpu_chill();
 			spin_lock_irqsave_nested(&ioc->lock, flags, 1);
 		}
 	}
@@ -188,7 +189,7 @@ retry:
 			spin_unlock(icq->q->queue_lock);
 		} else {
 			spin_unlock_irqrestore(&ioc->lock, flags);
-			cpu_relax();
+			cpu_chill();
 			goto retry;
 		}
 	}
-- 
1.7.10.4


