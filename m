Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab0LHHCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 02:02:30 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34558 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab0LHHC2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 02:02:28 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: akpm@linux-foundation.org
Subject: Re: [merged] mm-mempolicyc-add-rcu-read-lock-to-protect-pid-structure.patch removed from -mm tree
Cc: kosaki.motohiro@jp.fujitsu.com, zengzm.kernel@gmail.com,
        cl@linux-foundation.org, paulmck@us.ibm.com,
        mm-commits@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <201012071948.oB7Jm78B004585@imap1.linux-foundation.org>
References: <201012071948.oB7Jm78B004585@imap1.linux-foundation.org>
Message-Id: <20101208160009.173F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  8 Dec 2010 16:02:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The patch titled
>      mm/mempolicy.c: add rcu read lock to protect pid structure
> has been removed from the -mm tree.  Its filename was
>      mm-mempolicyc-add-rcu-read-lock-to-protect-pid-structure.patch
> 
> This patch was dropped because it was merged into mainline or a subsystem tree
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: mm/mempolicy.c: add rcu read lock to protect pid structure
> From: Zeng Zhaoming <zengzm.kernel@gmail.com>
> 
> find_task_by_vpid() should be protected by rcu_read_lock(), to prevent
> free_pid() reclaiming pid.
> 
> Signed-off-by: Zeng Zhaoming <zengzm.kernel@gmail.com>
> Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>


Andrew, please consider pick following patch too.



===========================================================================
>From 9de9f70f74e55d92b5e9057e22fc629405f63295 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 16 Dec 2010 17:49:23 +0900
Subject: [PATCH] mempolicy: remove tasklist_lock from migrate_pages

Today, tasklist_lock in migrate_pages doesn't protect anything. 
rcu_read_lock() provide enough protection from pid hash walk.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/mempolicy.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 11ff260..9064945 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1308,16 +1308,13 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
 
 	/* Find the mm_struct */
 	rcu_read_lock();
-	read_lock(&tasklist_lock);
 	task = pid ? find_task_by_vpid(pid) : current;
 	if (!task) {
-		read_unlock(&tasklist_lock);
 		rcu_read_unlock();
 		err = -ESRCH;
 		goto out;
 	}
 	mm = get_task_mm(task);
-	read_unlock(&tasklist_lock);
 	rcu_read_unlock();
 
 	err = -EINVAL;
-- 
1.6.5.2



