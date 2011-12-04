Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab1LDLQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 06:16:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38880 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab1LDLQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 06:16:18 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: akpm@linux-foundation.org
Cc: stern@rowland.harvard.edu, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: [PATCH] nls: add surroagate pair support in nls utf8.
Date: Sun,  4 Dec 2011 06:15:45 -0500
Message-Id: <1322997345-22899-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It allows surrogate pair in nls utf8.

Signed-off-by: Ashish Sangwan <ashishsangwan2@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
CC: Alan Stern <stern@rowland.harvard.edu>
---
 fs/nls/nls_base.c   |    8 --------
 fs/nls/nls_utf8.c   |   15 +++++++++++++--
 include/linux/nls.h |    8 ++++++++
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/fs/nls/nls_base.c b/fs/nls/nls_base.c
index 44a88a9..07a12cc 100644
--- a/fs/nls/nls_base.c
+++ b/fs/nls/nls_base.c
@@ -44,14 +44,6 @@ static const struct utf8_table utf8_table[] =
     {0,						       /* end of table    */}
 };
 
-#define UNICODE_MAX	0x0010ffff
-#define PLANE_SIZE	0x00010000
-
-#define SURROGATE_MASK	0xfffff800
-#define SURROGATE_PAIR	0x0000d800
-#define SURROGATE_LOW	0x00000400
-#define SURROGATE_BITS	0x000003ff
-
 int utf8_to_utf32(const u8 *s, int len, unicode_t *pu)
 {
 	unsigned long l;
diff --git a/fs/nls/nls_utf8.c b/fs/nls/nls_utf8.c
index 0d60a44..be7685a 100644
--- a/fs/nls/nls_utf8.c
+++ b/fs/nls/nls_utf8.c
@@ -30,13 +30,24 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 {
 	int n;
 	unicode_t u;
+	u16 *op;
 
+	op = uni;
 	n = utf8_to_utf32(rawstring, boundlen, &u);
-	if (n < 0 || u > MAX_WCHAR_T) {
+	if (n < 0 || u > UNICODE_MAX) {
 		*uni = 0x003f;	/* ? */
 		return -EINVAL;
 	}
-	*uni = (wchar_t) u;
+
+	if (u >= PLANE_SIZE) {
+		u -= PLANE_SIZE;
+		*op++ = (wchar_t) (SURROGATE_PAIR |
+		((u >> 10) & SURROGATE_BITS));
+		*op++ = (wchar_t) (SURROGATE_PAIR |
+		SURROGATE_LOW | (u & SURROGATE_BITS));
+		} else
+			*op++ = (wchar_t) u;
+
 	return n;
 }
 
diff --git a/include/linux/nls.h b/include/linux/nls.h
index d47beef..253cbd2 100644
--- a/include/linux/nls.h
+++ b/include/linux/nls.h
@@ -18,6 +18,14 @@
 typedef u16 wchar_t;
 #define MAX_WCHAR_T	0xffff
 
+/* Plane-1 Unicode surrogate pair characters */
+#define UNICODE_MAX	0x0010ffff
+#define PLANE_SIZE	0x00010000
+#define SURROGATE_MASK	0xfffff800
+#define SURROGATE_PAIR	0x0000d800
+#define SURROGATE_LOW	0x00000400
+#define SURROGATE_BITS	0x000003ff
+
 /* Arbitrary Unicode character */
 typedef u32 unicode_t;
 
-- 
1.7.5.4

