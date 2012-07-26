Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab2GZVcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:32:18 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:52843 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab2GZVcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:32:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Rientjes <rientjes@google.com>, Miao Xie <miaox@cn.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Nick Piggin <npiggin@kernel.dk>, Paul Menage <paul@paulmenage.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [ 37/40] cpusets: avoid looping when storing to mems_allowed if one node remains set
Date: Thu, 26 Jul 2012 14:29:55 -0700
Message-Id: <20120726211414.550266170@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120726211411.164006056@linuxfoundation.org>
References: <20120726211424.GA7709@kroah.com>
 <20120726211411.164006056@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rientjes <rientjes@google.com>

commit 89e8a244b97e48f1f30e898b6f32acca477f2a13 upstream.

Stable note: Not tracked in Bugzilla. [get|put]_mems_allowed() is
	extremely expensive and severely impacted page allocator performance.
	This is part of a series of patches that reduce page allocator
	overhead.

{get,put}_mems_allowed() exist so that general kernel code may locklessly
access a task's set of allowable nodes without having the chance that a
concurrent write will cause the nodemask to be empty on configurations
where MAX_NUMNODES > BITS_PER_LONG.

This could incur a significant delay, however, especially in low memory
conditions because the page allocator is blocking and reclaim requires
get_mems_allowed() itself.  It is not atypical to see writes to
cpuset.mems take over 2 seconds to complete, for example.  In low memory
conditions, this is problematic because it's one of the most imporant
times to change cpuset.mems in the first place!

The only way a task's set of allowable nodes may change is through cpusets
by writing to cpuset.mems and when attaching a task to a generic code is
not reading the nodemask with get_mems_allowed() at the same time, and
then clearing all the old nodes.  This prevents the possibility that a
reader will see an empty nodemask at the same time the writer is storing a
new nodemask.

If at least one node remains unchanged, though, it's possible to simply
set all new nodes and then clear all the old nodes.  Changing a task's
nodemask is protected by cgroup_mutex so it's guaranteed that two threads
are not changing the same task's nodemask at the same time, so the
nodemask is guaranteed to be stored before another thread changes it and
determines whether a node remains set or not.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Paul Menage <paul@paulmenage.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cpuset.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -949,6 +949,8 @@ static void cpuset_migrate_mm(struct mm_
 static void cpuset_change_task_nodemask(struct task_struct *tsk,
 					nodemask_t *newmems)
 {
+	bool masks_disjoint = !nodes_intersects(*newmems, tsk->mems_allowed);
+
 repeat:
 	/*
 	 * Allow tasks that have access to memory reserves because they have
@@ -963,7 +965,6 @@ repeat:
 	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
 	mpol_rebind_task(tsk, newmems, MPOL_REBIND_STEP1);
 
-
 	/*
 	 * ensure checking ->mems_allowed_change_disable after setting all new
 	 * allowed nodes.
@@ -980,9 +981,11 @@ repeat:
 
 	/*
 	 * Allocation of memory is very fast, we needn't sleep when waiting
-	 * for the read-side.
+	 * for the read-side.  No wait is necessary, however, if at least one
+	 * node remains unchanged.
 	 */
-	while (ACCESS_ONCE(tsk->mems_allowed_change_disable)) {
+	while (masks_disjoint &&
+			ACCESS_ONCE(tsk->mems_allowed_change_disable)) {
 		task_unlock(tsk);
 		if (!task_curr(tsk))
 			yield();


