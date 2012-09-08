Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab2IHUuQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 16:50:16 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:49904 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab2IHUuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 16:50:10 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 05/10] mm, util: Use dup_user to duplicate user memory
Date: Sat,  8 Sep 2012 17:47:54 -0300
Message-Id: <1347137279-17568-5-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1347137279-17568-1-git-send-email-elezegarcia@gmail.com>
References: <1347137279-17568-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously the strndup_user allocation was being done through memdup_user,
and the caller was wrongly traced as being strndup_user
(the correct trace must report the caller of strndup_user).

This is a common problem: in order to get accurate callsite tracing,
a utils function can't allocate through another utils function,
but instead do the allocation himself (or inlined).

Here we fix this by creating an always inlined dup_user() function to
performed the real allocation and to be used by memdup_user and strndup_user.

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 mm/util.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/util.c b/mm/util.c
index dc3036c..48d3ff8b 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -76,14 +76,14 @@ void *kmemdup(const void *src, size_t len, gfp_t gfp)
 EXPORT_SYMBOL(kmemdup);
 
 /**
- * memdup_user - duplicate memory region from user space
+ * dup_user - duplicate memory region from user space
  *
  * @src: source address in user space
  * @len: number of bytes to copy
  *
  * Returns an ERR_PTR() on failure.
  */
-void *memdup_user(const void __user *src, size_t len)
+static __always_inline void *dup_user(const void __user *src, size_t len)
 {
 	void *p;
 
@@ -103,6 +103,11 @@ void *memdup_user(const void __user *src, size_t len)
 
 	return p;
 }
+
+void *memdup_user(const void __user *src, size_t len)
+{
+	return dup_user(src, len);
+}
 EXPORT_SYMBOL(memdup_user);
 
 static __always_inline void *__do_krealloc(const void *p, size_t new_size,
@@ -214,7 +219,7 @@ char *strndup_user(const char __user *s, long n)
 	if (length > n)
 		return ERR_PTR(-EINVAL);
 
-	p = memdup_user(s, length);
+	p = dup_user(s, length);
 
 	if (IS_ERR(p))
 		return p;
-- 
1.7.8.6

