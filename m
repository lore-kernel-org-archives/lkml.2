Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab1G0Vtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:49:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:57385 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755754Ab1G0Vt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32274854"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: shaohua.li@intel.com, jaxboe@fusionio.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [78/99] cfq-iosched: fix a rcu warning
Message-Id: <20110727214917.B1EDB2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Shaohua Li <shaohua.li@intel.com>

commit 3181faa85bda3dc3f5e630a1846526c9caaa38e3 upstream.

I got a rcu warnning at boot. the ioc->ioc_data is rcu_deferenced, but
doesn't hold rcu_read_lock.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
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
@@ -2615,11 +2615,14 @@ static void __cfq_exit_single_io_context
 	smp_wmb();
 	cic->key = cfqd_dead_key(cfqd);
 
+	rcu_read_lock();
 	if (rcu_dereference(ioc->ioc_data) == cic) {
+		rcu_read_unlock();
 		spin_lock(&ioc->lock);
 		rcu_assign_pointer(ioc->ioc_data, NULL);
 		spin_unlock(&ioc->lock);
-	}
+	} else
+		rcu_read_unlock();
 
 	if (cic->cfqq[BLK_RW_ASYNC]) {
 		cfq_exit_cfqq(cfqd, cic->cfqq[BLK_RW_ASYNC]);
