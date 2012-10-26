Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab2JZAjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:39:55 -0400
Received: from mail.kernel.org ([198.145.19.201]:52896 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537Ab2JZAGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:06:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [ 21/42] Revert "cgroup: Remove task_lock() from cgroup_post_fork()"
Date: Thu, 25 Oct 2012 17:05:29 -0700
Message-Id: <20121026000126.914584418@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000124.790781113@linuxfoundation.org>
References: <20121026000124.790781113@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit d87838321124061f6c935069d97f37010fa417e6 upstream.

This reverts commit 7e3aa30ac8c904a706518b725c451bb486daaae9.

The commit incorrectly assumed that fork path always performed
threadgroup_change_begin/end() and depended on that for
synchronization against task exit and cgroup migration paths instead
of explicitly grabbing task_lock().

threadgroup_change is not locked when forking a new process (as
opposed to a new thread in the same process) and even if it were it
wouldn't be effective as different processes use different threadgroup
locks.

Revert the incorrect optimization.

Signed-off-by: Tejun Heo <tj@kernel.org>
LKML-Reference: <20121008020000.GB2575@localhost>
Acked-by: Li Zefan <lizefan@huawei.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4539,19 +4539,10 @@ void cgroup_post_fork(struct task_struct
 	 */
 	if (use_task_css_set_links) {
 		write_lock(&css_set_lock);
-		if (list_empty(&child->cg_list)) {
-			/*
-			 * It's safe to use child->cgroups without task_lock()
-			 * here because we are protected through
-			 * threadgroup_change_begin() against concurrent
-			 * css_set change in cgroup_task_migrate(). Also
-			 * the task can't exit at that point until
-			 * wake_up_new_task() is called, so we are protected
-			 * against cgroup_exit() setting child->cgroup to
-			 * init_css_set.
-			 */
+		task_lock(child);
+		if (list_empty(&child->cg_list))
 			list_add(&child->cg_list, &child->cgroups->tasks);
-		}
+		task_unlock(child);
 		write_unlock(&css_set_lock);
 	}
 }


