Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813Ab2CTUzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 16:55:05 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60463 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065Ab2CTUzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 16:55:01 -0400
Subject: [PATCH linux-next] mm: fix rcu-lock/unlock balance in vm_is_stack()
To: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 21 Mar 2012 00:54:55 +0400
Message-ID: <20120320205455.31285.23096.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix bug introduced in "procfs: mark thread stack correctly in proc/<pid>/maps"
(patch in mm/linux-next)

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/memory.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ee85fc4..cc08b86 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3932,13 +3932,12 @@ pid_t vm_is_stack(struct task_struct *task,
 		while_each_thread(task, t) {
 			if (vm_is_stack_for_task(t, vma)) {
 				ret = t->pid;
-				goto done;
+				break;
 			}
 		}
+		rcu_read_unlock();
 	}
 
-done:
-	rcu_read_unlock();
 	return ret;
 }
 

