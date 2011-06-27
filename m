Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab1F0Gye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 02:54:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:22264 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756795Ab1F0Gwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 02:52:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,431,1304319600"; 
   d="scan'208";a="18962120"
Subject: [patch 2/2]cfq-iosched: make code consistent
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 14:52:40 +0800
Message-ID: <1309157560.15392.177.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioc->ioc_data is rcu protectd, so uses correct API to access it.
This doesn't change any behavior, but just make code consistent.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index f379943..ae21919 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3084,7 +3087,8 @@ cfq_drop_dead_cic(struct cfq_data *cfqd, struct io_context *ioc,
 
 	spin_lock_irqsave(&ioc->lock, flags);
 
-	BUG_ON(ioc->ioc_data == cic);
+	BUG_ON(rcu_dereference_check(ioc->ioc_data,
+		lockdep_is_held(&ioc->lock)) == cic);
 
 	radix_tree_delete(&ioc->radix_root, cfqd->cic_index);
 	hlist_del_rcu(&cic->cic_list);


