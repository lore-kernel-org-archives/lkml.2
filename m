Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965706Ab2CAVw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:52:26 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35253 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965663Ab2CAVvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:51:00 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.132.198 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213923.395633823@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:29 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Joe Perches <joe@perches.com>, Sven-Haegar Koch <haegar@sdinet.de>
Subject: [ 07/34] printk_ratelimited(): fix uninitialized spinlock
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

commit d8521fcc5e0ad3e79bbc4231bb20a6cdc2b50164 upstream.

ratelimit_state initialization of printk_ratelimited() seems broken.  This
fixes it by using DEFINE_RATELIMIT_STATE() to initialize spinlock
properly.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sven-Haegar Koch <haegar@sdinet.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/kernel.h |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -411,14 +411,13 @@ static inline char *pack_hex_byte(char *
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


