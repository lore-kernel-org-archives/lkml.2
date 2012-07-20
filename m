Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab2GTStf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 14:49:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:17115 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab2GTSst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 14:48:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="169050355"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] futex: Test for pi_mutex on fault in futex_wait_requeue_pi
Date: Fri, 20 Jul 2012 11:46:29 -0700
Message-Id: <dc59890338fc413606f04e5c5b131530734dae3d.1342809673.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1342809673.git.dvhart@linux.intel.com>
References: <cover.1342809673.git.dvhart@linux.intel.com>
In-Reply-To: <cover.1342809673.git.dvhart@linux.intel.com>
References: <cover.1342809673.git.dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If fixup_pi_state_owner() faults, pi_mutex may be NULL. Test
for pi_mutex != NULL before testing the owner against current
and possibly unlocking it.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
CC: Dave Jones <davej@redhat.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index e2b0fb9..05018bf 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2370,7 +2370,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 	 * fault, unlock the rt_mutex and return the fault to userspace.
 	 */
 	if (ret == -EFAULT) {
-		if (rt_mutex_owner(pi_mutex) == current)
+		if (pi_mutex && rt_mutex_owner(pi_mutex) == current)
 			rt_mutex_unlock(pi_mutex);
 	} else if (ret == -EINTR) {
 		/*
-- 
1.7.10.4

