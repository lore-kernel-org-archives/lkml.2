Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab2BZEZn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 23:25:43 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48833 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab2BZEZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 23:25:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bobbypowers@gmail.com designates 10.224.117.146 as permitted sender) smtp.mail=bobbypowers@gmail.com; dkim=pass header.i=bobbypowers@gmail.com
From: Bobby Powers <bobbypowers@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        hjl.tools@gmail.com, Bobby Powers <bobbypowers@gmail.com>
Subject: [PATCH] x32: make sure TS_COMPAT is cleared for x32 tasks
Date: Sat, 25 Feb 2012 23:25:38 -0500
Message-Id: <1330230338-25077-1-git-send-email-bobbypowers@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a process has a non-x32 ia32 personality and changes to x32, the
process would keep its TS_COMPAT flag. x32 uses the presence of the
x32 flag on a syscall to determine compat status, so make sure
TS_COMPAT is cleared.

Signed-off-by: Bobby Powers <bobbypowers@gmail.com>
---
 arch/x86/kernel/process_64.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index e9ec8f1..a465973 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -539,6 +539,9 @@ void set_personality_ia32(bool x32)
 		clear_thread_flag(TIF_IA32);
 		set_thread_flag(TIF_X32);
 		current->personality &= ~READ_IMPLIES_EXEC;
+		/* is_compat_task() uses the presence of the x32
+		   syscall bit flag to determine compat status */
+		current_thread_info()->status &= ~TS_COMPAT;
 	} else {
 		set_thread_flag(TIF_IA32);
 		clear_thread_flag(TIF_X32);
-- 
1.7.7.6

