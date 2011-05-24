Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab1EXSRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:17:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38088 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab1EXSRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:17:21 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=vhdKIqpQuCYA:10 a=yG7VgigxZREA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=VVezscezS1KcZcbIXk0A:9 a=V2S8qur0rY0apTtiNKgA:7 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110524181719.603843681@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 24 May 2011 14:10:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rakib Mullick <rakib.mullick@gmail.com>
Subject: [PATCH 02/12] x86/ftrace: Fix compiler warning in ftrace.c
References: <20110524181032.382259739@goodmis.org>
Content-Disposition: inline; filename=0002-x86-ftrace-Fix-compiler-warning-in-ftrace.c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rakib Mullick <rakib.mullick@gmail.com>

 Due to commit dc326fca2b64 (x86, cpu: Clean up and unify the NOP selection infrastructure), we get the following warning:

arch/x86/kernel/ftrace.c: In function ‘ftrace_make_nop’:
arch/x86/kernel/ftrace.c:308:6: warning: assignment discards qualifiers from pointer target type
arch/x86/kernel/ftrace.c: In function ‘ftrace_make_call’:
arch/x86/kernel/ftrace.c:318:6: warning: assignment discards qualifiers from pointer target type

ftrace_nop_replace() now returns const unsigned char *, so change its associated function/variable to its compatible type to keep compiler clam.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Link: http://lkml.kernel.org/r/1305221620.7986.4.camel@localhost.localdomain

[ updated for change of const void *src in probe_kernel_write() ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 0ba15a6..c9a281f 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -123,7 +123,7 @@ static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 static atomic_t nmi_running = ATOMIC_INIT(0);
 static int mod_code_status;		/* holds return value of text write */
 static void *mod_code_ip;		/* holds the IP to write to */
-static void *mod_code_newcode;		/* holds the text to write to the IP */
+static const void *mod_code_newcode;	/* holds the text to write to the IP */
 
 static unsigned nmi_wait_count;
 static atomic_t nmi_update_count = ATOMIC_INIT(0);
@@ -225,7 +225,7 @@ within(unsigned long addr, unsigned long start, unsigned long end)
 }
 
 static int
-do_ftrace_mod_code(unsigned long ip, void *new_code)
+do_ftrace_mod_code(unsigned long ip, const void *new_code)
 {
 	/*
 	 * On x86_64, kernel text mappings are mapped read-only with
@@ -266,8 +266,8 @@ static const unsigned char *ftrace_nop_replace(void)
 }
 
 static int
-ftrace_modify_code(unsigned long ip, unsigned char *old_code,
-		   unsigned char *new_code)
+ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
+		   unsigned const char *new_code)
 {
 	unsigned char replaced[MCOUNT_INSN_SIZE];
 
@@ -301,7 +301,7 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 int ftrace_make_nop(struct module *mod,
 		    struct dyn_ftrace *rec, unsigned long addr)
 {
-	unsigned char *new, *old;
+	unsigned const char *new, *old;
 	unsigned long ip = rec->ip;
 
 	old = ftrace_call_replace(ip, addr);
@@ -312,7 +312,7 @@ int ftrace_make_nop(struct module *mod,
 
 int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 {
-	unsigned char *new, *old;
+	unsigned const char *new, *old;
 	unsigned long ip = rec->ip;
 
 	old = ftrace_nop_replace();
-- 
1.7.4.4


