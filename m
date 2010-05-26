Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab0EZPzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:55:05 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:45720 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439Ab0EZPzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:55:00 -0400
Date: Wed, 26 May 2010 17:54:55 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/17] arch/mips/kernel: Add missing read_unlock
Message-ID: <Pine.LNX.4.64.1005261754390.23743@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add a read_unlock missing on the error path.  Other ways of reaching
out_unlock have tasklist_lock unlocked.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1;
@@

* read_lock(E1,...);
  <+... when != E1
  if (...) {
    ... when != E1
*   return ...;
  }
  ...+>
* read_unlock(E1,...);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
I wasn't able to find what security_task_setscheduler actually does.  
If it releases tasklist_lock in an error case, then ignire this patch.

 arch/mips/kernel/mips-mt-fpaff.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kernel/mips-mt-fpaff.c b/arch/mips/kernel/mips-mt-fpaff.c
index f5981c4..73581bf 100644
--- a/arch/mips/kernel/mips-mt-fpaff.c
+++ b/arch/mips/kernel/mips-mt-fpaff.c
@@ -86,8 +86,10 @@ asmlinkage long mipsmt_sys_sched_setaffinity(pid_t pid, unsigned int len,
 	}
 
 	retval = security_task_setscheduler(p, 0, NULL);
-	if (retval)
+	if (retval) {
+		read_unlock(&tasklist_lock);
 		goto out_unlock;
+	}
 
 	/* Record new user-specified CPU set for future reference */
 	p->thread.user_cpus_allowed = new_mask;
