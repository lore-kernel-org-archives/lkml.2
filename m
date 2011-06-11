Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab1FKHba (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 03:31:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57262 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab1FKHb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 03:31:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=QhU8YiWAlpZBB1xFATk9dmkr6/CtP0oa/aFld0ssu0QQQgyr993T+j7rfcMNomdak/
         DOBTDbjljcZh+ncDmZ4s5bLmdnmo44B0XAjxOUJVM3MMr1rmwMAmHHR3Sds4HLKCjn4b
         BzSiMX7KUaT43SceGfs57KEmaB984z03+x66w=
Subject: [PATCH] x86, vsyscall: Fix build warning in vsyscall_64.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: mingo@elte.hu
Cc: hpa@zytor.com, tglx@linutronix.de, luto@mit.edu, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Jun 2011 13:31:04 +0600
Message-ID: <1307777464.25182.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to commit 5cec93c216db77 (x86-64: Emulate legacy vsyscalls), we get the following warning:

   arch/x86/kernel/vsyscall_64.c: In function ‘do_emulate_vsyscall’:
   arch/x86/kernel/vsyscall_64.c:111:7: warning: ‘ret’ may be used uninitialized in this function

The uninitialized value of 'ret' maybe gets assigned to regs->ax. So, initialize it with -EINVAL.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 10cd8ac..180c56d 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -108,7 +108,7 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 	struct task_struct *tsk;
 	unsigned long caller;
 	int vsyscall_nr;
-	long ret;
+	long ret = -EINVAL;
 
 	/* Kernel code must never get here. */
 	BUG_ON(!user_mode(regs));
@@ -163,7 +163,7 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 		BUG();
 	}
 
-	if (ret == -EFAULT) {
+	if (ret == -EFAULT || ret == -EINVAL) {
 		/*
 		 * Bad news -- userspace fed a bad pointer to a vsyscall.
 		 *


