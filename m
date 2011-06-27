Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab1F0Gxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 02:53:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:14701 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756292Ab1F0Gwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 02:52:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,431,1304319600"; 
   d="scan'208";a="20933163"
Subject: [patch 1/2]cfq-iosched: fix a rcu warning
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 14:52:37 +0800
Message-ID: <1309157557.15392.176.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got a rcu warnning at boot. the ioc->ioc_data is rcu_deferenced, but
doesn't hold rcu_read_lock.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index f379943..fd566c1 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2773,11 +2773,14 @@ static void __cfq_exit_single_io_context(struct cfq_data *cfqd,
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


