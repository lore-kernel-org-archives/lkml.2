Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934483Ab0HMOzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 10:55:40 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:49493 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934288Ab0HMOzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 10:55:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KhOGwT+yvHmnIIm1HMKnzQEaf7++YlXsacYK/yoC+Pv0lcqDZ0XWvJijnSURG9HjD7
         pnDkR2RUZWjUdzUTNKOMJXR4ijVoI+p0ZlT2MIlnOK7f9T12twn8HfjBPAYX88ozeKsq
         eAhot1Ho0p/cHdn5py/deN3dufwb5gOV1LNY0=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] bitmap: fix address_space conversion on __bitmap_parse
Date: Fri, 13 Aug 2010 23:55:34 +0900
Message-Id: <1281711334-28428-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

buf can be a user-space pointer in case of is_user, 3rd arg, is 1.
But casting to ubuf lacks required address_space notations. Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 lib/bitmap.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index ffb78c9..42205d8 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -422,7 +422,7 @@ int __bitmap_parse(const char *buf, unsigned int buflen,
 {
 	int c, old_c, totaldigits, ndigits, nchunks, nbits;
 	u32 chunk;
-	const char __user *ubuf = buf;
+	const char __user *ubuf = (const char __user __force *) buf;
 
 	bitmap_zero(maskp, nmaskbits);
 
@@ -507,7 +507,8 @@ int bitmap_parse_user(const char __user *ubuf,
 {
 	if (!access_ok(VERIFY_READ, ubuf, ulen))
 		return -EFAULT;
-	return __bitmap_parse((const char *)ubuf, ulen, 1, maskp, nmaskbits);
+	return __bitmap_parse((const char __force *)ubuf, ulen, 1,
+			      maskp, nmaskbits);
 }
 EXPORT_SYMBOL(bitmap_parse_user);
 
-- 
1.7.0.4

