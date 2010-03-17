Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab0CQQeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 12:34:06 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:36924 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab0CQQMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 12:12:37 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, containers@lists.linux-foundation.org,
       Matt Helsley <matthltc@us.ibm.com>, Oren Laadan <orenl@cs.columbia.edu>,
       Cedric Le Goater <legoater@free.fr>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [C/R v20][PATCH 16/96] cgroup freezer: Update stale locking comments
Date: Wed, 17 Mar 2010 12:08:04 -0400
Message-Id: <1268842164-5590-17-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1268842164-5590-16-git-send-email-orenl@cs.columbia.edu>
References: <1268842164-5590-1-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-2-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-3-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-4-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-5-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-6-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-7-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-8-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-9-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-10-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-11-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-12-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-13-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-14-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-15-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-16-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Helsley <matthltc@us.ibm.com>

Update stale comments regarding locking order and add a little more detail
so it's easier to follow the locking between the cgroup freezer and the
power management freezer code.

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>
Cc: Cedric Le Goater <legoater@free.fr>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup_freezer.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index eb3f34d..2c44736 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -88,10 +88,10 @@ struct cgroup_subsys freezer_subsys;
 
 /* Locks taken and their ordering
  * ------------------------------
- * css_set_lock
  * cgroup_mutex (AKA cgroup_lock)
- * task->alloc_lock (AKA task_lock)
  * freezer->lock
+ * css_set_lock
+ * task->alloc_lock (AKA task_lock)
  * task->sighand->siglock
  *
  * cgroup code forces css_set_lock to be taken before task->alloc_lock
@@ -99,33 +99,38 @@ struct cgroup_subsys freezer_subsys;
  * freezer_create(), freezer_destroy():
  * cgroup_mutex [ by cgroup core ]
  *
- * can_attach():
- * cgroup_mutex
+ * freezer_can_attach():
+ * cgroup_mutex (held by caller of can_attach)
  *
- * cgroup_frozen():
+ * cgroup_freezing_or_frozen():
  * task->alloc_lock (to get task's cgroup)
  *
  * freezer_fork() (preserving fork() performance means can't take cgroup_mutex):
- * task->alloc_lock (to get task's cgroup)
  * freezer->lock
  *  sighand->siglock (if the cgroup is freezing)
  *
  * freezer_read():
  * cgroup_mutex
  *  freezer->lock
+ *   write_lock css_set_lock (cgroup iterator start)
+ *    task->alloc_lock
  *   read_lock css_set_lock (cgroup iterator start)
  *
  * freezer_write() (freeze):
  * cgroup_mutex
  *  freezer->lock
+ *   write_lock css_set_lock (cgroup iterator start)
+ *    task->alloc_lock
  *   read_lock css_set_lock (cgroup iterator start)
- *    sighand->siglock
+ *    sighand->siglock (fake signal delivery inside freeze_task())
  *
  * freezer_write() (unfreeze):
  * cgroup_mutex
  *  freezer->lock
+ *   write_lock css_set_lock (cgroup iterator start)
+ *    task->alloc_lock
  *   read_lock css_set_lock (cgroup iterator start)
- *    task->alloc_lock (to prevent races with freeze_task())
+ *    task->alloc_lock (inside thaw_process(), prevents race with refrigerator())
  *     sighand->siglock
  */
 static struct cgroup_subsys_state *freezer_create(struct cgroup_subsys *ss,
-- 
1.6.3.3

