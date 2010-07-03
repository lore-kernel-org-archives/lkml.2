Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab0GCX0g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 19:26:36 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60711 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab0GCX0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 19:26:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QQY2uF/8VGrerESWuENbss0q70g+WhXOHbhlsmn72O+7xePC/gCYugnEwStSFDvygT
         bXx0BPYkg+XYczKvOVG3zN393nS9Lqcrp5rd8u9+CVXtx9WFdzEXsjuZy4s7VNUCebJF
         wnXKazrdUw7OF1JZugAlUXRMSxMV44mMYGjNk=
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix uninitialized variable warning in do_one_initcall
Date: Sat,  3 Jul 2010 20:26:28 -0300
Message-Id: <1278199588-3273-1-git-send-email-kjwinchester@gmail.com>
X-Mailer: git-send-email 1.7.1
To: Ingo Molnar <mingo@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The warning is corrected by extracting the debug path out into
its own function.  This does en up duplicating one line of code
between the debug and regular code paths (i.e. the actual call
of the initcall function), but it seems worthwhile for the
cleaner build.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
---
 init/main.c |   49 ++++++++++++++++++++++++++++---------------------
 1 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/init/main.c b/init/main.c
index a42fdf4..21def42 100644
--- a/init/main.c
+++ b/init/main.c
@@ -728,30 +728,38 @@ static char msgbuf[64];
 static struct boot_trace_call call;
 static struct boot_trace_ret ret;
 
+static inline int do_one_initcall_debug(initcall_t fn)
+{
+	ktime_t calltime, rettime, delta;
+	int result;
+
+	call.caller = task_pid_nr(current);
+	printk(KERN_DEBUG "calling  %pF @ %i\n", fn, call.caller);
+	calltime = ktime_get();
+	trace_boot_call(&call, fn);
+	enable_boot_trace();
+
+	result = fn();
+
+	disable_boot_trace();
+	rettime = ktime_get();
+	delta = ktime_sub(rettime, calltime);
+	ret.duration = (unsigned long long) ktime_to_ns(delta) >> 10;
+	trace_boot_ret(&ret, fn);
+	printk(KERN_DEBUG "initcall %pF returned %d after %lld usecs\n", fn,
+		ret.result, ret.duration);
+
+	return result;
+}
+
 int do_one_initcall(initcall_t fn)
 {
 	int count = preempt_count();
-	ktime_t calltime, delta, rettime;
-
-	if (initcall_debug) {
-		call.caller = task_pid_nr(current);
-		printk("calling  %pF @ %i\n", fn, call.caller);
-		calltime = ktime_get();
-		trace_boot_call(&call, fn);
-		enable_boot_trace();
-	}
 
-	ret.result = fn();
-
-	if (initcall_debug) {
-		disable_boot_trace();
-		rettime = ktime_get();
-		delta = ktime_sub(rettime, calltime);
-		ret.duration = (unsigned long long) ktime_to_ns(delta) >> 10;
-		trace_boot_ret(&ret, fn);
-		printk("initcall %pF returned %d after %Ld usecs\n", fn,
-			ret.result, ret.duration);
-	}
+	if (initcall_debug)
+		ret.result = do_one_initcall_debug(fn);
+	else
+		ret.result = fn();
 
 	msgbuf[0] = 0;
 
@@ -773,7 +781,6 @@ int do_one_initcall(initcall_t fn)
 	return ret.result;
 }
 
-
 extern initcall_t __initcall_start[], __initcall_end[], __early_initcall_end[];
 
 static void __init do_initcalls(void)
-- 
1.7.1

