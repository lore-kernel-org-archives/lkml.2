Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab0IYQKI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 12:10:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40297 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682Ab0IYQKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 12:10:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WzACYhz9OQ795GjmcpVaypBTjzcRsOWMBA780B04g/GX5gZH6Ygk6Yaa0a6hUDIkZK
         gzrWQNflkYzZUp5U+lMLotgvJQr2xlYvvJC81+5AyK5n/Ukcp85a7+YmUeT6pXZrfgy6
         aURvmCKfs6NXlRVhfJ3zsTYzwzTtrHbCsnSEQ=
From: Namhyung Kim <namhyung@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] posix-timers: annotate lock_timer()
Date: Sun, 26 Sep 2010 01:09:55 +0900
Message-Id: <1285430995-13619-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lock_timer() conditionally grabs it_lock in case of returning non-NULL
but unlock_timer() releases it unconditionally. This leads sparse to
complain about the lock context imbalance. Rename and wrap lock_timer
using __cond_lock() macro to make sparse happy.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/posix-timers.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 9ca4973..93bd2eb 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -145,7 +145,13 @@ static int common_timer_del(struct k_itimer *timer);
 
 static enum hrtimer_restart posix_timer_fn(struct hrtimer *data);
 
-static struct k_itimer *lock_timer(timer_t timer_id, unsigned long *flags);
+static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags);
+
+#define lock_timer(tid, flags)						   \
+({	struct k_itimer *__timr;					   \
+	__cond_lock(&__timr->it_lock, __timr = __lock_timer(tid, flags));  \
+	__timr;								   \
+})
 
 static inline void unlock_timer(struct k_itimer *timr, unsigned long flags)
 {
@@ -619,7 +625,7 @@ out:
  * the find to the timer lock.  To avoid a dead lock, the timer id MUST
  * be release with out holding the timer lock.
  */
-static struct k_itimer *lock_timer(timer_t timer_id, unsigned long *flags)
+static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags)
 {
 	struct k_itimer *timr;
 	/*
-- 
1.7.2.2

