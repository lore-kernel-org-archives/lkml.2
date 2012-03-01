Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab2CAF05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 00:26:57 -0500
Received: from mail-pz0-f51.google.com ([209.85.210.51]:60475 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab2CAF04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 00:26:56 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Mar 2012 00:26:56 EST
Authentication-Results: mr.google.com; spf=pass (google.com: domain of siddhesh.poyarekar@gmail.com designates 10.68.201.1 as permitted sender) smtp.mail=siddhesh.poyarekar@gmail.com; dkim=pass header.i=siddhesh.poyarekar@gmail.com
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jamie Lokier <jamie@shareable.org>, Mike Frysinger <vapier@gentoo.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Subject: [PATCH 1/2] Take rcu read lock when iterating through thread group
Date: Thu,  1 Mar 2012 10:50:58 +0530
Message-Id: <1330579259-3456-1-git-send-email-siddhesh.poyarekar@gmail.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <20120228174049.GA11136@redhat.com> <201202241112.46337.vapier@gentoo.org>
References: <20120228174049.GA11136@redhat.com> <201202241112.46337.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect the iteration through thread group with rcu_read_lock when
looking for tasks in the group that use the current vma as
stack. Thanks KOSAKI Motohiro (kosaki.motohiro@gmail.com) for pointing
it out.

Signed-off-by: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
---
 mm/memory.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 601a920..a88b764 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3915,20 +3915,27 @@ void print_vma_addr(char *prefix, unsigned long ip)
  * just check in the current task.
  */
 int vm_is_stack(struct task_struct *task,
-			      struct vm_area_struct *vma, int in_group)
+		struct vm_area_struct *vma, int in_group)
 {
+	int ret = 0;
+
 	if (vm_is_stack_for_task(task, vma))
 		return 1;
 
 	if (in_group) {
 		struct task_struct *t = task;
+		rcu_read_lock();
 		while_each_thread(task, t) {
-			if (vm_is_stack_for_task(t, vma))
-				return 1;
+			if (vm_is_stack_for_task(t, vma)) {
+				ret = 1;
+				goto done;
+			}
 		}
 	}
 
-	return 0;
+done:
+	rcu_read_unlock();
+	return ret;
 }
 
 #ifdef CONFIG_PROVE_LOCKING
-- 
1.7.7.4

