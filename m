Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab2CEQiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:38:09 -0500
Received: from mail.windriver.com ([147.11.1.11]:45277 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab2CEQiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:38:07 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: siddhesh.poyarekar@gmail.com, akpm@linux-foundation.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] mm: fix task_nommu build regressions
Date: Mon,  5 Mar 2012 11:37:53 -0500
Message-Id: <1330965473-5401-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a69b756788619171e65c4d7081e9e3b8fbc4646a (linux-next)

  "procfs: mark thread stack correctly in proc/<pid>/maps"

introduced this failure on ARM's at91x40_defconfig:

In file included from fs/proc/task_nommu.c:3:
include/linux/mm.h: In function 'vm_is_stack_for_task':
include/linux/mm.h:1048: error: implicit declaration of function 'task_stack_page'
fs/proc/task_nommu.c: In function 'nommu_vma_show':
fs/proc/task_nommu.c:178: warning: no return statement in function returning non-void
fs/proc/task_nommu.c: At top level:
fs/proc/task_nommu.c:180: error: expected ')' before '\xa'
fs/proc/task_nommu.c:181: error: expected identifier or '(' before 'return'
fs/proc/task_nommu.c:182: error: expected identifier or '(' before '}' token

There are two reasons for the failure.  1) sched.h is needed for
task_stack_page, which is used by the newly added KSTK_ESP calls.
2) The above commit clearly left off an opening "{" in the line
"if (...) {" that it was altering.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index bdfff69..239fbd4 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -1,4 +1,5 @@
 
+#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/file.h>
 #include <linux/fdtable.h>
@@ -170,7 +171,7 @@ static int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma,
 		pad_len_spaces(m, len);
 		seq_path(m, &file->f_path, "");
 	} else if (mm) {
-		if (vm_is_stack(priv->task, vma, is_pid))
+		if (vm_is_stack(priv->task, vma, is_pid)) {
 			pad_len_spaces(m, len);
 			seq_puts(m, "[stack]");
 		}
-- 
1.7.9.1

