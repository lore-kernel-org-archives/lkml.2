Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab1I0Ua0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:30:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab1I0UaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:30:20 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Mark Salter <msalter@redhat.com>
Subject: [PATCH v3 01/24] fix default __strnlen_user macro
Date: Tue, 27 Sep 2011 16:29:42 -0400
Message-Id: <1317155405-26235-2-git-send-email-msalter@redhat.com>
In-Reply-To: <1317155405-26235-1-git-send-email-msalter@redhat.com>
References: <1317155405-26235-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing __strnlen_user macro simply resolved to strnlen. However, the
count returned by strnlen_user should include the NULL byte. This patch
fixes the __strnlen_user macro to include the NULL byte in the count.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 include/asm-generic/uaccess.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
index ac68c99..9788568 100644
--- a/include/asm-generic/uaccess.h
+++ b/include/asm-generic/uaccess.h
@@ -289,9 +289,14 @@ strncpy_from_user(char *dst, const char __user *src, long count)
  * Return 0 on exception, a value greater than N if too long
  */
 #ifndef __strnlen_user
-#define __strnlen_user strnlen
+#define __strnlen_user(s, n) (strnlen((s), (n)) + 1)
 #endif
 
+/*
+ * Unlike strnlen, strnlen_user includes the nul terminator in
+ * its returned count. Callers should check for a returned value
+ * greater than N as an indication the string is too long.
+ */
 static inline long strnlen_user(const char __user *src, long n)
 {
 	if (!access_ok(VERIFY_READ, src, 1))
-- 
1.7.6.2

