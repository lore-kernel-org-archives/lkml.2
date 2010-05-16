Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab0EPX5o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 19:57:44 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:60886 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab0EPX5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 19:57:43 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix uninitialized spinlock of printk_ratelimited()
Date: Mon, 17 May 2010 08:57:38 +0900
Message-ID: <87hbm7e6x9.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ratelimit_state initialization of printk_ratelimited() seems
broken. This fixes it by using DEFINE_RATELIMIT_STATE() to initialize
spinlock properly.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 include/linux/kernel.h |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN include/linux/kernel.h~printk_ratelimited-fix include/linux/kernel.h
--- linux-2.6/include/linux/kernel.h~printk_ratelimited-fix	2010-05-17 03:37:33.000000000 +0900
+++ linux-2.6-hirofumi/include/linux/kernel.h	2010-05-17 03:37:33.000000000 +0900
@@ -420,14 +420,13 @@ static inline char *pack_hex_byte(char *
  * no local ratelimit_state used in the !PRINTK case
  */
 #ifdef CONFIG_PRINTK
-#define printk_ratelimited(fmt, ...)  ({		\
-	static struct ratelimit_state _rs = {		\
-		.interval = DEFAULT_RATELIMIT_INTERVAL, \
-		.burst = DEFAULT_RATELIMIT_BURST,       \
-	};                                              \
-							\
-	if (__ratelimit(&_rs))                          \
-		printk(fmt, ##__VA_ARGS__);		\
+#define printk_ratelimited(fmt, ...)  ({				\
+	static DEFINE_RATELIMIT_STATE(_rs,				\
+				      DEFAULT_RATELIMIT_INTERVAL,	\
+				      DEFAULT_RATELIMIT_BURST);		\
+									\
+	if (__ratelimit(&_rs))						\
+		printk(fmt, ##__VA_ARGS__);				\
 })
 #else
 /* No effect, but we still get type checking even in the !PRINTK case: */
_
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
