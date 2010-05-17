Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695Ab0EQAiZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 20:38:25 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:42362 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab0EQAiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 20:38:23 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Adds ratelimit_state_init()
Date: Mon, 17 May 2010 09:38:20 +0900
Message-ID: <87k4r3cqgz.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please review.

Andrew, this is the part of fatfs error ratelimit. I.e. fatfs change is
depending to this patch.

I guess this area usually is sent to you. But, if this patch
wasn't applied before fatfs change, fatfs will break.

Well, so, can I pass fatfs patch to you? Or, I should apply this to
fatfs-tree too?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


For now, all users of ratelimit_state allocates it statically, so
DEFINE_RATELIMIT_STATE() is enough. But, I want to use ratelimit_state
for fs, i.e. per super_block to suppress too many error reports.

So, this adds ratelimit_state_init() to initialize ratelimite_state
which is dynamically allocated, instead of opencoding.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 include/linux/ratelimit.h |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN include/linux/ratelimit.h~ratelimit-enhance include/linux/ratelimit.h
--- linux-2.6/include/linux/ratelimit.h~ratelimit-enhance	2010-05-17 03:44:27.000000000 +0900
+++ linux-2.6-hirofumi/include/linux/ratelimit.h	2010-05-17 03:44:27.000000000 +0900
@@ -2,7 +2,7 @@
 #define _LINUX_RATELIMIT_H
 
 #include <linux/param.h>
-#include <linux/spinlock_types.h>
+#include <linux/spinlock.h>
 
 #define DEFAULT_RATELIMIT_INTERVAL	(5 * HZ)
 #define DEFAULT_RATELIMIT_BURST		10
@@ -25,6 +25,17 @@ struct ratelimit_state {
 		.burst		= burst_init,				\
 	}
 
+static inline void ratelimit_state_init(struct ratelimit_state *rs,
+					int interval, int burst)
+{
+	spin_lock_init(&rs->lock);
+	rs->interval = interval;
+	rs->burst = burst;
+	rs->printed = 0;
+	rs->missed = 0;
+	rs->begin = 0;
+}
+
 extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
 #define __ratelimit(state) ___ratelimit(state, __func__)
 
_
