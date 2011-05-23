Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab1EWBTX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 21:19:23 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64304 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab1EWBTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 21:19:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=d/tQx1n+mIuhlvPG/82SXDpengv9D47276kMecLjpdu/+ruaghIX70v5YUP/sba04A
         arof5Nehom0fssacr+AfJml5YVVFUFeryoyQhtmVTNSZl4Wj60QWtF61Kf2QF4MFeJyc
         LIfmj0yjZOgplNPthpog1rDtDcOKiV6Eim2Oc=
Subject: [PATCH] kernel: Fix ftrace.c compiler warning when calling
 ftrace_nop_replace()
From: Eduardo Silva <edsiper@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 May 2011 21:19:08 -0400
Message-ID: <1306113548.29789.2.camel@monotop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the function ftrace_nop_replace() returns a 'static const unsigned char *'
value, so when the caller perform a direct assignment to a
'static unsigned char *', the compiler raise the following warning message:

 ftrace.c:308:6: warning: assignment discards qualifiers from pointer target type
 ftrace.c:318:6: warning: assignment discards qualifiers from pointer target type

Adding the proper casts the message goes away.

Signed-off-by: Eduardo Silva <edsiper@gmail.com>
---
 arch/x86/kernel/ftrace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 0ba15a6..b44c3c9 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -305,7 +305,7 @@ int ftrace_make_nop(struct module *mod,
 	unsigned long ip = rec->ip;
 
 	old = ftrace_call_replace(ip, addr);
-	new = ftrace_nop_replace();
+	new = (unsigned char *) ftrace_nop_replace();
 
 	return ftrace_modify_code(rec->ip, old, new);
 }
@@ -315,7 +315,7 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	unsigned char *new, *old;
 	unsigned long ip = rec->ip;
 
-	old = ftrace_nop_replace();
+	old = (unsigned char *) ftrace_nop_replace();
 	new = ftrace_call_replace(ip, addr);
 
 	return ftrace_modify_code(rec->ip, old, new);
-- 
1.7.4.1



