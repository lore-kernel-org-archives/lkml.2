Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab1G0Vyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:54:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:16735 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755718Ab1G0VtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32826547"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: jaxboe@fusionio.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [77/99] cfq-iosched: fix locking around ioc->ioc_data assignment
Message-Id: <20110727214916.ABDDE2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jens Axboe <jaxboe@fusionio.com>

commit ab4bd22d3cce6977dc039664cc2d052e3147d662 upstream.

Since we are modifying this RCU pointer, we need to hold
the lock protecting it around it.

This fixes a potential reuse and double free of a cfq
io_context structure. The bug has been in CFQ for a long
time, it hit very few people but those it did hit seemed
to see it a lot.

Tracked in RH bugzilla here:

https://bugzilla.redhat.com/show_bug.cgi?id=577968

Credit goes to Paul Bolle for figuring out that the issue
was around the one-hit ioc->ioc_data cache. Thanks to his
hard work the issue is now fixed.

Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 block/cfq-iosched.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/block/cfq-iosched.c
===================================================================
--- linux-2.6.35.y.orig/block/cfq-iosched.c
+++ linux-2.6.35.y/block/cfq-iosched.c
@@ -2615,8 +2615,11 @@ static void __cfq_exit_single_io_context
 	smp_wmb();
 	cic->key = cfqd_dead_key(cfqd);
 
-	if (ioc->ioc_data == cic)
+	if (rcu_dereference(ioc->ioc_data) == cic) {
+		spin_lock(&ioc->lock);
 		rcu_assign_pointer(ioc->ioc_data, NULL);
+		spin_unlock(&ioc->lock);
+	}
 
 	if (cic->cfqq[BLK_RW_ASYNC]) {
 		cfq_exit_cfqq(cfqd, cic->cfqq[BLK_RW_ASYNC]);
