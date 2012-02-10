Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989Ab2BJOoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 09:44:13 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62508 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab2BJOoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 09:44:10 -0500
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, Pedro Alves <palves@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 5/5] ptrace: remove PTRACE_SEIZE_DEVEL bit
Date: Fri, 10 Feb 2012 15:43:11 +0100
Message-Id: <1328884991-23889-6-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1328884991-23889-5-git-send-email-vda.linux@googlemail.com>
References: <1328884991-23889-1-git-send-email-vda.linux@googlemail.com>
 <1328884991-23889-2-git-send-email-vda.linux@googlemail.com>
 <1328884991-23889-3-git-send-email-vda.linux@googlemail.com>
 <1328884991-23889-4-git-send-email-vda.linux@googlemail.com>
 <1328884991-23889-5-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PTRACE_SEIZE code is tested and ready for production use,
remove the code which requires special bit in data argument
to make PTRACE_SEIZE work.

Strace team prepares for a new release of strace, and we
would like to ship the code which uses PTRACE_SEIZE,
preferably after this change goes into released kernel.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 include/linux/ptrace.h |    5 +----
 kernel/ptrace.c        |   15 ---------------
 2 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index ec6571c..6dffe18 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -51,9 +51,6 @@
 #define PTRACE_INTERRUPT	0x4207
 #define PTRACE_LISTEN		0x4208
 
-/* flags in @data for PTRACE_SEIZE */
-#define PTRACE_SEIZE_DEVEL	0x80000000 /* temp flag for development */
-
 /* Wait extended result codes for the above trace options.  */
 #define PTRACE_EVENT_FORK	1
 #define PTRACE_EVENT_VFORK	2
@@ -64,7 +61,7 @@
 /* Extended result codes which enabled by means other than options.  */
 #define PTRACE_EVENT_STOP	128
 
-/* options set using PTRACE_SETOPTIONS */
+/* Options set using PTRACE_SETOPTIONS or using PTRACE_SEIZE @data param */
 #define PTRACE_O_TRACESYSGOOD	1
 #define PTRACE_O_TRACEFORK	(1 << PTRACE_EVENT_FORK)
 #define PTRACE_O_TRACEVFORK	(1 << PTRACE_EVENT_VFORK)
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 99a18a0..32846f7 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -237,25 +237,10 @@ static int ptrace_attach(struct task_struct *task, long request,
 	bool seize = (request == PTRACE_SEIZE);
 	int retval;
 
-	/*
-	 * SEIZE will enable new ptrace behaviors which will be implemented
-	 * gradually.  SEIZE_DEVEL bit is used to prevent applications
-	 * expecting full SEIZE behaviors trapping on kernel commits which
-	 * are still in the process of implementing them.
-	 *
-	 * Only test programs for new ptrace behaviors being implemented
-	 * should set SEIZE_DEVEL.  If unset, SEIZE will fail with -EIO.
-	 *
-	 * Once SEIZE behaviors are completely implemented, this flag
-	 * will be removed.
-	 */
 	retval = -EIO;
 	if (seize) {
 		if (addr != 0)
 			goto out;
-		if (!(flags & PTRACE_SEIZE_DEVEL))
-			goto out;
-		flags &= ~(unsigned long)PTRACE_SEIZE_DEVEL;
 		if (flags & ~(unsigned long)PTRACE_O_MASK)
 			goto out;
 		flags = PT_PTRACED | PT_SEIZED | (flags << PT_OPT_FLAG_SHIFT);
-- 
1.7.7.6

