Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab2JRNkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:40:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3274 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab2JRNkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:40:05 -0400
X-Authority-Analysis: v=2.0 cv=IZ4FqBWa c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ulyn_FWc_fwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=Wu5ZJh4uJkYA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=mX60Ua4OHw6a_isyzEYA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Subject: [PATCH RT] slab: Fix up stable merge of slab init_lock_keys()
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Oct 2012 09:40:01 -0400
Message-ID: <1350567601.19292.69.camel@pippen.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

There was a little conflict with my merge of 3.4.14 due to the backport
of this patch:

commit 947ca1856a7e60aa6d20536785e6a42dff25aa6e
Author: Michael Wang <wangyun@linux.vnet.ibm.com>
Date:   Wed Sep 5 10:33:18 2012 +0800

    slab: fix the DEADLOCK issue on l3 alien lock

Could you just confirm that my fix is correct.

Thanks,

-- Steve


>From 741c5d3c42ad58b577d0ee602dd1f0bb52b7b92b Mon Sep 17 00:00:00 2001
From: Steven Rostedt <srostedt@redhat.com>
Date: Tue, 16 Oct 2012 17:00:19 -0400
Subject: [PATCH] slab: Fix up stable merge of slab init_lock_keys()

There was a stable fix that moved the init_lock_keys() to after
the enable_cpucache(). But -rt changed this function to
init_cachep_lock_keys(). This moves the init afterwards to
match the stable fix.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 mm/slab.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 119969a..27a194c 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1763,15 +1763,12 @@ void __init kmem_cache_init_late(void)
 	/* 6) resize the head arrays to their final sizes */
 	mutex_lock(&cache_chain_mutex);
 	list_for_each_entry(cachep, &cache_chain, next) {
-		init_cachep_lock_keys(cachep);
 		if (enable_cpucache(cachep, GFP_NOWAIT))
 			BUG();
+		init_cachep_lock_keys(cachep);
 	}
 	mutex_unlock(&cache_chain_mutex);
 
-	/* Annotate slab for lockdep -- annotate the malloc caches */
-	init_lock_keys();
-
 	/* Done! */
 	g_cpucache_up = FULL;
 
-- 
1.7.10.4



