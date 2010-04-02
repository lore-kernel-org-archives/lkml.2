Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab0DBSat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 14:30:49 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:51263 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab0DBSam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:30:42 -0400
X-Spam-Processed: digidescorp.com, Fri, 02 Apr 2010 13:30:40 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=17085dc9e4=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: microblaze-uclinux@itee.uq.edu.au
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org,
       "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH] microblaze: Fix ftrace_update_ftrace_func panic
Date: Fri,  2 Apr 2010 13:29:39 -0500
Message-Id: <1270232979-12113-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Microblaze dynamic ftrace code assumes a call ordering that is not met
in all scenarios. Specifically, executing a command similar to:

  echo 105 > /sys/kernel/debug/tracing/set_ftrace_pid

before any other tracing-related commands results in a kernel panic:

  BUG: failure at arch/microblaze/kernel/ftrace.c:198/ftrace_update_ftrace_func()!

Recoding ftrace_update_ftrace_func() to use &ftrace_caller directly eliminates 
the need to capture its address elsewhere (and thus rely on a particular call 
sequence).

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/arch/microblaze/kernel/ftrace.c b/arch/microblaze/kernel/ftrace.c
--- a/arch/microblaze/kernel/ftrace.c	2010-04-02 13:10:54.000000000 -0500
+++ b/arch/microblaze/kernel/ftrace.c	2010-04-02 13:13:29.000000000 -0500
@@ -151,13 +151,10 @@ int ftrace_make_nop(struct module *mod,
 	return ret;
 }
 
-static int ret_addr; /* initialized as 0 by default */
-
 /* I believe that first is called ftrace_make_nop before this function */
 int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 {
 	int ret;
-	ret_addr = addr; /* saving where the barrier jump is */
 	pr_debug("%s: addr:0x%x, rec->ip: 0x%x, imm:0x%x\n",
 		__func__, (unsigned int)addr, (unsigned int)rec->ip, imm);
 	ret = ftrace_modify_code(rec->ip, imm);
@@ -194,12 +191,9 @@ int ftrace_update_ftrace_func(ftrace_fun
 	ret = ftrace_modify_code(ip, upper);
 	ret += ftrace_modify_code(ip + 4, lower);
 
-	/* We just need to remove the rtsd r15, 8 by NOP */
-	BUG_ON(!ret_addr);
-	if (ret_addr)
-		ret += ftrace_modify_code(ret_addr, MICROBLAZE_NOP);
-	else
-		ret = 1; /* fault */
+	/* We just need to replace the rtsd r15, 8 with NOP */
+	ret += ftrace_modify_code((unsigned long)&ftrace_caller,
+				  MICROBLAZE_NOP);
 
 	/* All changes are done - lets do caches consistent */
 	flush_icache();

