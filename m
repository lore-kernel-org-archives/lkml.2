Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab2BTAO7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:14:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57234 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab2BTAO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:14:56 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com, Alexander Viro <viro@zeniv.linux.org.uk>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 13/30] elf: Allow core dump-related fields to be overridden
Date: Sun, 19 Feb 2012 16:07:51 -0800
Message-Id: <1329696488-16970-14-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:14:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. J. Lu" <hjl.tools@gmail.com>

Allow some core dump-related fields to be overridden.  This allows
core dumps to work correctly for x32.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 fs/binfmt_elf.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index bcb884e..43ba478 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1390,6 +1390,22 @@ static void do_thread_regset_writeback(struct task_struct *task,
 		regset->writeback(task, regset, 1);
 }
 
+#ifndef PR_REG_SIZE
+#define PR_REG_SIZE(S) sizeof(S)
+#endif
+
+#ifndef PRSTATUS_SIZE
+#define PRSTATUS_SIZE(S) sizeof(S)
+#endif
+
+#ifndef PR_REG_PTR
+#define PR_REG_PTR(S) (&((S)->pr_reg))
+#endif
+
+#ifndef SET_PR_FPVALID
+#define SET_PR_FPVALID(S, V) ((S)->pr_fpvalid = (V))
+#endif
+
 static int fill_thread_core_info(struct elf_thread_core_info *t,
 				 const struct user_regset_view *view,
 				 long signr, size_t *total)
@@ -1404,11 +1420,11 @@ static int fill_thread_core_info(struct elf_thread_core_info *t,
 	 */
 	fill_prstatus(&t->prstatus, t->task, signr);
 	(void) view->regsets[0].get(t->task, &view->regsets[0],
-				    0, sizeof(t->prstatus.pr_reg),
-				    &t->prstatus.pr_reg, NULL);
+				    0, PR_REG_SIZE(t->prstatus.pr_reg),
+				    PR_REG_PTR(&t->prstatus), NULL);
 
 	fill_note(&t->notes[0], "CORE", NT_PRSTATUS,
-		  sizeof(t->prstatus), &t->prstatus);
+		  PRSTATUS_SIZE(t->prstatus), &t->prstatus);
 	*total += notesize(&t->notes[0]);
 
 	do_thread_regset_writeback(t->task, &view->regsets[0]);
@@ -1438,7 +1454,7 @@ static int fill_thread_core_info(struct elf_thread_core_info *t,
 						  regset->core_note_type,
 						  size, data);
 				else {
-					t->prstatus.pr_fpvalid = 1;
+					SET_PR_FPVALID(&t->prstatus, 1);
 					fill_note(&t->notes[i], "CORE",
 						  NT_PRFPREG, size, data);
 				}
-- 
1.7.6.5

