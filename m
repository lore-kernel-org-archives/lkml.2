Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab1ELRdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:33:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50228 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758132Ab1ELRdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:33:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Kb8cc78RaEWtqdAf/xylDdLYLT9VGtN3Ej9Oea/6fZSn7+rnlC5YJDNWJUp9rLaMv/
         wxijz8po+ktH6MasWvhjO2SRRvkqPmjNHSl6A9PIJmxamtiouXmX1EywSFc8PGT5WOxR
         iRvUJsSCDruiVNk3Jf6duYuQw89NYhYGoIogo=
Subject: [PATCH] x86, ftrace: Fix compiler warning in ftrace.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo@vger.kernel.org, Molnar@vger.kernel.org
Cc: hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 23:33:40 +0600
Message-ID: <1305221620.7986.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Due to commit dc326fca2b64 (x86, cpu: Clean up and unify the NOP selection infrastructure), we get the following warning:

arch/x86/kernel/ftrace.c: In function ‘ftrace_make_nop’:
arch/x86/kernel/ftrace.c:308:6: warning: assignment discards qualifiers from pointer target type
arch/x86/kernel/ftrace.c: In function ‘ftrace_make_call’:
arch/x86/kernel/ftrace.c:318:6: warning: assignment discards qualifiers from pointer target type
 
ftrace_nop_replace() now returns const unsigned char *, so change its associated function/variable to its compatible type to keep compiler clam.


Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 0ba15a6..d2d82cf 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -266,8 +266,8 @@ static const unsigned char *ftrace_nop_replace(void)
 }
 
 static int
-ftrace_modify_code(unsigned long ip, unsigned char *old_code,
-		   unsigned char *new_code)
+ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
+		   unsigned const char *new_code)
 {
 	unsigned char replaced[MCOUNT_INSN_SIZE];
 
@@ -290,7 +290,7 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 		return -EINVAL;
 
 	/* replace the text with the new text */
-	if (do_ftrace_mod_code(ip, new_code))
+	if (do_ftrace_mod_code(ip, (void *)new_code))
 		return -EPERM;
 
 	sync_core();
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


