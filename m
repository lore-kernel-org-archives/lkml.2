Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab2K2InF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 03:43:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:24868 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab2K2InC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 03:43:02 -0500
X-IronPort-AV: E=Sophos;i="4.83,339,1352044800"; 
   d="scan'208";a="6299570"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/8] srcu: simplify __srcu_read_unlock() via this_cpu_dec()
Date: Thu, 29 Nov 2012 16:46:02 +0800
Message-Id: <1354178770-6028-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1354178770-6028-1-git-send-email-laijs@cn.fujitsu.com>
References: <1354178770-6028-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/29 16:42:31,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/29 16:42:32,
	Serialize complete at 2012/11/29 16:42:32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this_cpu_dec() can do the same thing and sometimes it is better.
(avoid preempt_disable() and use more tiny instructions)

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/srcu.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/srcu.c b/kernel/srcu.c
index b363b09..b2e4f36 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -317,10 +317,8 @@ EXPORT_SYMBOL_GPL(__srcu_read_lock);
  */
 void __srcu_read_unlock(struct srcu_struct *sp, int idx)
 {
-	preempt_disable();
 	smp_mb(); /* C */  /* Avoid leaking the critical section. */
-	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) -= 1;
-	preempt_enable();
+	this_cpu_dec(sp->per_cpu_ref->c[idx]);
 }
 EXPORT_SYMBOL_GPL(__srcu_read_unlock);
 
-- 
1.7.4.4

