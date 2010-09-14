Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab0INMoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 08:44:14 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:48642 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab0INMoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 08:44:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HUP2stZu0KHNV7egxsMJSHltqov+Kw4uD9yqWZhbLgFQz1hYIdkyhh3ZeQyS+u5Pzp
         MDYyf6MVZL6zjGekP9AjWJ2PMMKgNQ/1vXPAvAQeOOJkdol6pN19o09Qd1CPH5od4/I5
         lsplF+8weWdUGu4tAreyI+hE2dZ9Pe3UdMB0Q=
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Darren Hart <dvhltc@us.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] futex: mark restart_block.futex.uaddr as a __user pointer
Date: Tue, 14 Sep 2010 21:43:47 +0900
Message-Id: <1284468228-8723-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1284468228-8723-1-git-send-email-namhyung@gmail.com>
References: <1284468228-8723-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@uaddr field in restart_block.futex is a user pointer but was
missing __user markup. Add it and remove unnecessary castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 include/linux/thread_info.h |    4 ++--
 kernel/futex.c              |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index a8cc4e1..c906965 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -23,12 +23,12 @@ struct restart_block {
 		};
 		/* For futex_wait and futex_wait_requeue_pi */
 		struct {
-			u32 *uaddr;
+			u32 __user *uaddr;
 			u32 val;
 			u32 flags;
 			u32 bitset;
 			u64 time;
-			u32 *uaddr2;
+			u32 __user *uaddr2;
 		} futex;
 		/* For nanosleep */
 		struct {
diff --git a/kernel/futex.c b/kernel/futex.c
index 464de27..45e448a 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1843,7 +1843,7 @@ retry:
 
 	restart = &current_thread_info()->restart_block;
 	restart->fn = futex_wait_restart;
-	restart->futex.uaddr = (u32 *)uaddr;
+	restart->futex.uaddr = uaddr;
 	restart->futex.val = val;
 	restart->futex.time = abs_time->tv64;
 	restart->futex.bitset = bitset;
@@ -1869,7 +1869,7 @@ out:
 
 static long futex_wait_restart(struct restart_block *restart)
 {
-	u32 __user *uaddr = (u32 __user *)restart->futex.uaddr;
+	u32 __user *uaddr = restart->futex.uaddr;
 	int fshared = 0;
 	ktime_t t, *tp = NULL;
 
-- 
1.7.2.2

