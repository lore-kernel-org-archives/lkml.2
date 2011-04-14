Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562Ab1DNNj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 09:39:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:44885 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab1DNNjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 09:39:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=bk+QC/sbBrRS63IwxG2iIK+zc7POVtrU8Rlp3vApyuXk287RpstROToe9ZGtAeEUZI
         OTucphyuh6FxafLl1KmA==
From: Michal Nazarewicz <mina86@mina86.com>
To: Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kstrtox: reuse functions from ctype.h
Date: Thu, 14 Apr 2011 15:34:05 +0200
Message-Id: <b266439c1f03640c677f911cb82f4d0e131d2e7d.1302785632.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kstrto*() family of functions uses open coded test
for a hexadecimal digit and own implementation of
tolower() function.  This commit changes the code
to use definitions from ctype.h.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 lib/kstrtox.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

Was there a reason not to use code from ctype.h?

I know that ctype.h's tolower() is kinda creepy but
IMO it's still better to reuse.

diff --git a/lib/kstrtox.c b/lib/kstrtox.c
index 05672e8..ba6c0d5 100644
--- a/lib/kstrtox.c
+++ b/lib/kstrtox.c
@@ -18,11 +18,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 
-static inline char _tolower(const char c)
-{
-	return c | 0x20;
-}
-
 static int _kstrtoull(const char *s, unsigned int base, unsigned long long *res)
 {
 	unsigned long long acc;
@@ -30,14 +25,14 @@ static int _kstrtoull(const char *s, unsigned int base, unsigned long long *res)
 
 	if (base == 0) {
 		if (s[0] == '0') {
-			if (_tolower(s[1]) == 'x' && isxdigit(s[2]))
+			if (tolower(s[1]) == 'x' && isxdigit(s[2]))
 				base = 16;
 			else
 				base = 8;
 		} else
 			base = 10;
 	}
-	if (base == 16 && s[0] == '0' && _tolower(s[1]) == 'x')
+	if (base == 16 && s[0] == '0' && tolower(s[1]) == 'x')
 		s += 2;
 
 	acc = 0;
@@ -47,8 +42,8 @@ static int _kstrtoull(const char *s, unsigned int base, unsigned long long *res)
 
 		if ('0' <= *s && *s <= '9')
 			val = *s - '0';
-		else if ('a' <= _tolower(*s) && _tolower(*s) <= 'f')
-			val = _tolower(*s) - 'a' + 10;
+		else if (isxdigit(*s))
+			val = tolower(*s) - 'a' + 10;
 		else if (*s == '\n') {
 			if (*(s + 1) == '\0')
 				break;
-- 
1.7.3.1

