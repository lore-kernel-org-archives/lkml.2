Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab0LMOFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 09:05:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757556Ab0LMOFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 09:05:35 -0500
From: Anton Arapov <aarapov@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "Changli Gao <xiaosuo@gmail.com>; Andrew Morton
	<akpm@linux-foundation.org>; Linus Torvalds" 
	<torvalds@linux-foundation.org>,
        Anton Arapov <aarapov@redhat.com>
Subject: [PATCH] lib: fix vscnprintf() if @size is == 0
Date: Mon, 13 Dec 2010 15:05:19 +0100
Message-Id: <1292249119-21600-1-git-send-email-aarapov@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vscnprintf() should return 0 if @size is == 0. Update the comment for it,
as @size is unsigned.

This change based on the code of commit b903c0b8899b46829a9b80ba55b61079b35940ec
moves the real fix into vscnprinf() from scnprintf() and makes scnprintf() call
vscnprintf(), thus avoid code duplication.

Signed-off-by: Anton Arapov <aarapov@redhat.com>
---
 lib/vsprintf.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index c150d3d..85e6b27 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1451,7 +1451,7 @@ EXPORT_SYMBOL(vsnprintf);
  * @args: Arguments for the format string
  *
  * The return value is the number of characters which have been written into
- * the @buf not including the trailing '\0'. If @size is <= 0 the function
+ * the @buf not including the trailing '\0'. If @size is == 0 the function
  * returns 0.
  *
  * Call this function if you are already dealing with a va_list.
@@ -1465,7 +1465,11 @@ int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
 
 	i = vsnprintf(buf, size, fmt, args);
 
-	return (i >= size) ? (size - 1) : i;
+	if (likely(i < size))
+		return i;
+	if (size != 0)
+		return size - 1;
+	return 0;
 }
 EXPORT_SYMBOL(vscnprintf);
 
@@ -1513,14 +1517,10 @@ int scnprintf(char *buf, size_t size, const char *fmt, ...)
 	int i;
 
 	va_start(args, fmt);
-	i = vsnprintf(buf, size, fmt, args);
+	i = vscnprintf(buf, size, fmt, args);
 	va_end(args);
 
-	if (likely(i < size))
-		return i;
-	if (size != 0)
-		return size - 1;
-	return 0;
+	return i;
 }
 EXPORT_SYMBOL(scnprintf);
 
-- 
1.7.1

