Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab2HWCSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 22:18:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:35291 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab2HWCRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 22:17:38 -0400
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>
CC: <jason.wessel@windriver.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [v2][PATCH 3/3] powerpc/kgdb: restore current_thread_info properly
Date: Thu, 23 Aug 2012 10:10:20 +0800
Message-ID: <1345687820-5248-3-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1345687820-5248-1-git-send-email-tiejun.chen@windriver.com>
References: <1345687820-5248-1-git-send-email-tiejun.chen@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For powerpc BooKE and e200, singlestep is handled on the critical/dbg
exception stack. This causes current_thread_info() to fail for kgdb
internal, so previously We work around this issue by copying
the thread_info from the kernel stack before calling kgdb_handle_exception,
and copying it back afterwards.

But actually we don't do this properly. We should backup current_thread_info
then restore that when exit.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
v2: fix a typo in patch head description.

 arch/powerpc/kernel/kgdb.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index 05adb69..c470a40 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -25,6 +25,7 @@
 #include <asm/processor.h>
 #include <asm/machdep.h>
 #include <asm/debug.h>
+#include <linux/slab.h>
 
 /*
  * This table contains the mapping between PowerPC hardware trap types, and
@@ -153,6 +154,8 @@ static int kgdb_handle_breakpoint(struct pt_regs *regs)
 static int kgdb_singlestep(struct pt_regs *regs)
 {
 	struct thread_info *thread_info, *exception_thread_info;
+	struct thread_info *backup_current_thread_info = \
+		(struct thread_info *)kmalloc(sizeof(struct thread_info), GFP_KERNEL);
 
 	if (user_mode(regs))
 		return 0;
@@ -170,13 +173,17 @@ static int kgdb_singlestep(struct pt_regs *regs)
 	thread_info = (struct thread_info *)(regs->gpr[1] & ~(THREAD_SIZE-1));
 	exception_thread_info = current_thread_info();
 
-	if (thread_info != exception_thread_info)
+	if (thread_info != exception_thread_info) {
+		/* Save the original current_thread_info. */
+		memcpy(backup_current_thread_info, exception_thread_info, sizeof *thread_info);
 		memcpy(exception_thread_info, thread_info, sizeof *thread_info);
+	}
 
 	kgdb_handle_exception(0, SIGTRAP, 0, regs);
 
 	if (thread_info != exception_thread_info)
-		memcpy(thread_info, exception_thread_info, sizeof *thread_info);
+		/* Restore current_thread_info lastly. */
+		memcpy(exception_thread_info, backup_current_thread_info, sizeof *thread_info);
 
 	return 1;
 }
-- 
1.5.6

