Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab1BCPnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:43:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199Ab1BCPnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:43:08 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com
Subject: [PATCH 2/4] tracing - adding size parameter to do_ftrace_mod_code
Date: Thu,  3 Feb 2011 16:42:39 +0100
Message-Id: <1296747761-9082-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1296747761-9082-1-git-send-email-jolsa@redhat.com>
References: <1296747761-9082-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adding size parameter to be able to restore the saved
instructions, which could be longer than relative call

wbr,
jirka
---
 arch/x86/kernel/ftrace.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 382eb29..979ec14 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -124,6 +124,7 @@ static atomic_t nmi_running = ATOMIC_INIT(0);
 static int mod_code_status;		/* holds return value of text write */
 static void *mod_code_ip;		/* holds the IP to write to */
 static void *mod_code_newcode;		/* holds the text to write to the IP */
+static int mod_code_size;		/* holds the size of the new code */
 
 static unsigned nmi_wait_count;
 static atomic_t nmi_update_count = ATOMIC_INIT(0);
@@ -161,7 +162,7 @@ static void ftrace_mod_code(void)
 	 * to succeed, then they all should.
 	 */
 	mod_code_status = probe_kernel_write(mod_code_ip, mod_code_newcode,
-					     MCOUNT_INSN_SIZE);
+					     mod_code_size);
 
 	/* if we fail, then kill any new writers */
 	if (mod_code_status)
@@ -225,7 +226,7 @@ within(unsigned long addr, unsigned long start, unsigned long end)
 }
 
 static int
-do_ftrace_mod_code(unsigned long ip, void *new_code)
+do_ftrace_mod_code(unsigned long ip, void *new_code, int size)
 {
 	/*
 	 * On x86_64, kernel text mappings are mapped read-only with
@@ -240,6 +241,7 @@ do_ftrace_mod_code(unsigned long ip, void *new_code)
 
 	mod_code_ip = (void *)ip;
 	mod_code_newcode = new_code;
+	mod_code_size = size;
 
 	/* The buffers need to be visible before we let NMIs write them */
 	smp_mb();
@@ -290,7 +292,7 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 		return -EINVAL;
 
 	/* replace the text with the new text */
-	if (do_ftrace_mod_code(ip, new_code))
+	if (do_ftrace_mod_code(ip, new_code, MCOUNT_INSN_SIZE))
 		return -EPERM;
 
 	sync_core();
@@ -361,7 +363,7 @@ static int ftrace_mod_jmp(unsigned long ip,
 
 	*(int *)(&code[1]) = new_offset;
 
-	if (do_ftrace_mod_code(ip, &code))
+	if (do_ftrace_mod_code(ip, &code, MCOUNT_INSN_SIZE))
 		return -EPERM;
 
 	return 0;
-- 
1.7.1

