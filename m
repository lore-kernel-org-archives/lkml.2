Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab1E1Qgj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 12:36:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:32848 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab1E1Qgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 12:36:37 -0400
Date: Sat, 28 May 2011 16:36:23 GMT
From: tip-bot for Juri Lelli <juri.lelli@gmail.com>
Message-ID: <tip-f62508f68d04adefc4cf9b0177ba02c8818b3eec@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, yong.zhang0@gmail.com,
        juri.lelli@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, yong.zhang0@gmail.com,
        juri.lelli@gmail.com, mingo@elte.hu
In-Reply-To: <4DD4F6C1.5090701@gmail.com>
References: <4DD4F6C1.5090701@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] Documentation: Add statistics about nested locks
Git-Commit-ID: f62508f68d04adefc4cf9b0177ba02c8818b3eec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 28 May 2011 16:36:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f62508f68d04adefc4cf9b0177ba02c8818b3eec
Gitweb:     http://git.kernel.org/tip/f62508f68d04adefc4cf9b0177ba02c8818b3eec
Author:     Juri Lelli <juri.lelli@gmail.com>
AuthorDate: Thu, 19 May 2011 12:53:53 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 May 2011 17:03:29 +0200

Documentation: Add statistics about nested locks

Explain what the trailing "/1" on some lock class names of
lock_stat output means.

Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4DD4F6C1.5090701@gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/lockstat.txt |   36 ++++++++++++++++++++++++++++++++++--
 1 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/Documentation/lockstat.txt b/Documentation/lockstat.txt
index 9c0a80d..cef00d4 100644
--- a/Documentation/lockstat.txt
+++ b/Documentation/lockstat.txt
@@ -12,8 +12,9 @@ Because things like lock contention can severely impact performance.
 - HOW
 
 Lockdep already has hooks in the lock functions and maps lock instances to
-lock classes. We build on that. The graph below shows the relation between
-the lock functions and the various hooks therein.
+lock classes. We build on that (see Documentation/lockdep-design.txt).
+The graph below shows the relation between the lock functions and the various
+hooks therein.
 
         __acquire
             |
@@ -128,6 +129,37 @@ points are the points we're contending with.
 
 The integer part of the time values is in us.
 
+Dealing with nested locks, subclasses may appear:
+
+32...............................................................................................................................................................................................
+33
+34                               &rq->lock:         13128          13128           0.43         190.53      103881.26          97454        3453404           0.00         401.11    13224683.11
+35                               ---------
+36                               &rq->lock            645          [<ffffffff8103bfc4>] task_rq_lock+0x43/0x75
+37                               &rq->lock            297          [<ffffffff8104ba65>] try_to_wake_up+0x127/0x25a
+38                               &rq->lock            360          [<ffffffff8103c4c5>] select_task_rq_fair+0x1f0/0x74a
+39                               &rq->lock            428          [<ffffffff81045f98>] scheduler_tick+0x46/0x1fb
+40                               ---------
+41                               &rq->lock             77          [<ffffffff8103bfc4>] task_rq_lock+0x43/0x75
+42                               &rq->lock            174          [<ffffffff8104ba65>] try_to_wake_up+0x127/0x25a
+43                               &rq->lock           4715          [<ffffffff8103ed4b>] double_rq_lock+0x42/0x54
+44                               &rq->lock            893          [<ffffffff81340524>] schedule+0x157/0x7b8
+45
+46...............................................................................................................................................................................................
+47
+48                             &rq->lock/1:         11526          11488           0.33         388.73      136294.31          21461          38404           0.00          37.93      109388.53
+49                             -----------
+50                             &rq->lock/1          11526          [<ffffffff8103ed58>] double_rq_lock+0x4f/0x54
+51                             -----------
+52                             &rq->lock/1           5645          [<ffffffff8103ed4b>] double_rq_lock+0x42/0x54
+53                             &rq->lock/1           1224          [<ffffffff81340524>] schedule+0x157/0x7b8
+54                             &rq->lock/1           4336          [<ffffffff8103ed58>] double_rq_lock+0x4f/0x54
+55                             &rq->lock/1            181          [<ffffffff8104ba65>] try_to_wake_up+0x127/0x25a
+
+Line 48 shows statistics for the second subclass (/1) of &rq->lock class
+(subclass starts from 0), since in this case, as line 50 suggests,
+double_rq_lock actually acquires a nested lock of two spinlocks.
+
 View the top contending locks:
 
 # grep : /proc/lock_stat | head
