Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab0GHAJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 20:09:25 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45518 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656Ab0GHAJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 20:09:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=W0kisTVq/Ac8jrArQZ4bhrUJxh4UhPXE/5+GtbPVu7ooZ7FXcX4M5anvqJkixkgzDQ
         ARctBZXnoXHrPKip+cJhykLP+tf8y6zNDyo8Xb8W0baJB+hbEdGF6DhMivfLochQupH0
         QI50G0ypIs29GhhpdDaVVoP2fwQSdEOTBLuJI=
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Fix warning: 'calltime.tv64' may be used uninitialized in this function in init/main.c
Date: Wed,  7 Jul 2010 21:09:10 -0300
Message-Id: <1278547751-2237-1-git-send-email-kjwinchester@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100707152640.586442f3.akpm@linux-foundation.org>
References: <20100707152640.586442f3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: Ingo Molnar <mingo@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using:

	gcc (GCC) 4.5.0 20100610 (prerelease)

The following warning appears:

	init/main.c: In function ‘do_one_initcall’:
	init/main.c:730:10: warning: ‘calltime.tv64’ may be used uninitialized in this function

This warning is actually correct, as the global initcall_debug
could arguably be changed by the initcall.

Correct this warning by extracting a new function,
do_one_initcall_debug, that performs the initcall for the debug
case.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
---
 init/main.c |   34 ++++++++++++++++++++--------------
 1 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/init/main.c b/init/main.c
index 3e0f4b5..828ffac 100644
--- a/init/main.c
+++ b/init/main.c
@@ -724,27 +724,33 @@ core_param(initcall_debug, initcall_debug, bool, 0644);
 
 static char msgbuf[64];
 
-int do_one_initcall(initcall_t fn)
+static int do_one_initcall_debug(initcall_t fn)
 {
-	int count = preempt_count();
 	ktime_t calltime, delta, rettime;
 	unsigned long long duration;
 	int ret;
 
-	if (initcall_debug) {
-		printk("calling  %pF @ %i\n", fn, task_pid_nr(current));
-		calltime = ktime_get();
-	}
-
+	printk(KERN_DEBUG "calling  %pF @ %i\n", fn, task_pid_nr(current));
+	calltime = ktime_get();
 	ret = fn();
+	rettime = ktime_get();
+	delta = ktime_sub(rettime, calltime);
+	duration = (unsigned long long) ktime_to_ns(delta) >> 10;
+	printk(KERN_DEBUG "initcall %pF returned %d after %lld usecs\n", fn,
+		ret, duration);
 
-	if (initcall_debug) {
-		rettime = ktime_get();
-		delta = ktime_sub(rettime, calltime);
-		duration = (unsigned long long) ktime_to_ns(delta) >> 10;
-		printk("initcall %pF returned %d after %lld usecs\n", fn,
-			ret, duration);
-	}
+	return ret;
+}
+
+int do_one_initcall(initcall_t fn)
+{
+	int count = preempt_count();
+	int ret;
+
+	if (initcall_debug)
+		ret = do_one_initcall_debug(fn);
+	else
+		ret = fn();
 
 	msgbuf[0] = 0;
 
-- 
1.7.1

