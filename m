Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab1E3DOb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 23:14:31 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:46739 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389Ab1E3DOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 23:14:30 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-arch@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH/RFC] asm-generic/mutex-dec.h: add SMP support
Date: Sun, 29 May 2011 23:19:28 -0400
Message-Id: <1306725568-10922-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make these guys work on SMP systems, we just need to sprinkle a few
barriers around.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
note: this is what the Blackfin SMP port is using, but it doesn't seem
like other SMP ports are ... so I wonder if we're just trying too hard
and these barriers aren't actually necessary ?

 include/asm-generic/mutex-dec.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/mutex-dec.h b/include/asm-generic/mutex-dec.h
index f104af7..e746c3c 100644
--- a/include/asm-generic/mutex-dec.h
+++ b/include/asm-generic/mutex-dec.h
@@ -22,6 +22,8 @@ __mutex_fastpath_lock(atomic_t *count, void (*fail_fn)(atomic_t *))
 {
 	if (unlikely(atomic_dec_return(count) < 0))
 		fail_fn(count);
+	else
+		smp_mb();
 }
 
 /**
@@ -39,6 +41,7 @@ __mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
 {
 	if (unlikely(atomic_dec_return(count) < 0))
 		return fail_fn(count);
+	smp_mb();
 	return 0;
 }
 
@@ -58,6 +61,7 @@ __mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
 static inline void
 __mutex_fastpath_unlock(atomic_t *count, void (*fail_fn)(atomic_t *))
 {
+	smp_mb();
 	if (unlikely(atomic_inc_return(count) <= 0))
 		fail_fn(count);
 }
@@ -82,8 +86,10 @@ __mutex_fastpath_unlock(atomic_t *count, void (*fail_fn)(atomic_t *))
 static inline int
 __mutex_fastpath_trylock(atomic_t *count, int (*fail_fn)(atomic_t *))
 {
-	if (likely(atomic_cmpxchg(count, 1, 0) == 1))
+	if (likely(atomic_cmpxchg(count, 1, 0) == 1)) {
+		smp_mb();
 		return 1;
+	}
 	return 0;
 }
 
-- 
1.7.5.rc3

