Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab1FNJAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 05:00:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51681 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755390Ab1FNJAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 05:00:04 -0400
Message-ID: <4DF7231B.1080708@cn.fujitsu.com>
Date: Tue, 14 Jun 2011 17:00:11 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        josh@joshtriplett.org, Manfred Spraul <manfred@colorfullife.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] rcu,doc: lock-free update site
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-14 16:59:42,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-14 16:59:44,
	Serialize complete at 2011-06-14 16:59:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a document which describes a pattern of using RCU to implement lock-free(lockless)
update site.

Singed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 Documentation/RCU/00-INDEX                  |    2 +
 Documentation/RCU/lock-free-update-site.txt |  143 +++++++++++++++++++++++++++
 2 files changed, 145 insertions(+), 0 deletions(-)

diff --git a/Documentation/RCU/00-INDEX b/Documentation/RCU/00-INDEX
index 1d7a885..7178dd5 100644
--- a/Documentation/RCU/00-INDEX
+++ b/Documentation/RCU/00-INDEX
@@ -8,6 +8,8 @@ listRCU.txt
 	- Using RCU to Protect Read-Mostly Linked Lists
 lockdep.txt
 	- RCU and lockdep checking
+lock-free-update-site.txt
+	- RCU pattern of lock-free update site
 NMI-RCU.txt
 	- Using RCU to Protect Dynamic NMI Handlers
 rcubarrier.txt
diff --git a/Documentation/RCU/lock-free-update-site.txt b/Documentation/RCU/lock-free-update-site.txt
new file mode 100644
index 0000000..9b6984a
--- /dev/null
+++ b/Documentation/RCU/lock-free-update-site.txt
@@ -0,0 +1,143 @@
+Lock-free(lockless) update site
+
+This article describes a pattern of using RCU to implement lock-free(lockless)
+update site. RCU update site is considered call-rare and it is protected
+by a update-site lock generally. But blocking algorithms are undesirable
+in some cases for some reasons, thus, this pattern may help.
+
+This pattern can only protect a single pointer which is the only reference
+of the object.
+
+object pointer:
+
+struct my_struct *gptr;
+
+wait-free read site:
+{
+	rcu_read_lock();
+	ptr = rcu_dereference(gptr);
+	my_struct_read(ptr);
+	rcu_read_unlock();
+}
+
+lock-free update site(update as new):
+{
+	new_ptr = my_struct_alloc();
+	for (;;) {
+		rcu_read_lock();
+
+		old_ptr = rcu_dereference(gptr);
+
+		/* copy data from old_ptr to new_ptr and update it */
+		my_struct_update(new_ptr, old_ptr);
+
+		/* atomically publish the new_ptr and de-publish the old_ptr */
+		if (cmpxchg(&gptr, old_ptr, new_ptr) == old_ptr) {
+			rcu_read_unlock();
+
+			/*
+			 * free it after a grace-period, read sites and other
+			 * update sites may be reading it in parallel.
+			 */
+			kfree_rcu(old_ptr);
+
+			/* success, exit the loop */
+			break;
+		} else {
+			rcu_read_unlock();
+
+			/*
+			 * Other update site successfully update it, we need
+			 * to read the latest data and try the update again.
+			 *
+			 * If the other update site did the same thing we need,
+			 * we can free the new_ptr and exit this loop too,
+			 * and it may becomes a wait-free algorithm.
+			 */
+		}
+	}
+}
+
+1) In update site, rcu_read_lock() is needed for my_struct_update().
+
+   In this kind of lock-free update site, many update sides
+   may run parallel, other update side may had successfully
+   de-published old_ptr and tried to free it. rcu_read_lock()
+   prevents old_ptr from freeing and ensures it valid for
+   my_struct_update().
+
+2) In update site, rcu_read_lock() is needed until cmpxchg() finished.
+
+   Although the content of old_ptr is not accessed when cmpxchg(),
+   but old_ptr should not be freed until cmpxchg() finished.
+   Otherwise we may miss other successful update and publish a
+   new_ptr without information from the latest object.
+
+   Example:(wrong update site code, rcu_read_unlock() is moved up before cmpxchg())
+   (cause ABA-problem: http://en.wikipedia.org/wiki/ABA_problem)
+
+   CPU0						CPU1
+   rcu_read_lock()
+   old_ptr = rcu_dereference(gptr);
+   my_struct_update(new_ptr, old_ptr);
+   rcu_read_unlock();
+   .						successfully update, now gptr=other_ptr
+   .						old_ptr is freed
+   .
+   .						other update, my_struct_alloc() returns old_ptr
+   .						successfully publish and de-publish
+   .						now gptr=old_ptr again
+   .
+   cmpxchg(&gptr, old_ptr, new_ptr)
+     cmpxchg() success, but the 2 updates
+     of CPU1 are completely missed.
+
+   This exmaple shows rcu_read_lock() is needed to prevent old_ptr from reusing
+   before cmpxchg() finished and to prevent ABA-problem.
+
+3) Beware NULL pointer.
+
+   Some use cases may set gptr to NULL when needed. (the previous gptr != NULL)
+
+lock-free update site(dispose, wait-free):
+{
+	old_ptr = xchg(&gptr, NULL);
+	if (old_ptr != NULL)
+		kfree_rcu(old_ptr);
+}
+
+   This code cause NULL reusing and may cause ABA-problem like above example:
+
+   CPU0						CPU1
+   rcu_read_lock()
+   old_ptr = rcu_dereference(gptr);
+   /* old_ptr = NULL */
+   my_struct_update(new_ptr, NULL);
+   .						successfully update, now gptr=other_ptr
+   .
+   .						successfully dispose
+   .						now gptr=NULL again
+   .
+   cmpxchg(&gptr, NULL, new_ptr)
+     cmpxchg() success, but the update
+     and the dispose of CPU1 are missed
+     consideration by CPU0.
+   rcu_read_unlock();
+
+   In many use cases, these behaviors are OK. In these use cases,
+   my_struct_update(new_ptr, NULL) give us the same result even we retry.
+
+   But in some raw use cases(I can't find any use-case now, I believe it exist),
+   the missed considerations of the updates are not acceptable, in this case,
+   we should use different null-value for NULL pointer for every disposing.
+
+lock-free update site(dispose, wait-free, paranoid version):
+{
+	null_ptr = alloc_null_ptr();
+	old_ptr = xchg(&gptr, null_ptr);
+	if (is_null_ptr(old_ptr))
+		free_null_ptr_by_rcu_for_preventing_it_from_reusing(old_ptr);
+	else
+		kfree_rcu(old_ptr);
+}
+
