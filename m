Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab2CCBQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 20:16:09 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57819 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab2CCBQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 20:16:07 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linkinjeon@gmail.com designates 10.68.134.102 as permitted sender) smtp.mail=linkinjeon@gmail.com; dkim=pass header.i=linkinjeon@gmail.com
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Ravishankar N <cyberax82@gmail.com>
Subject: [PATCH 1/2] fat: Clean up xlate_to_uni.
Date: Fri,  2 Mar 2012 20:15:56 -0500
Message-Id: <1330737356-7092-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The xlate_to_uni is called by vfat_build_slots with sbi->nls_io as the final
 argument. nls_io can never be null at this point because the check is already being done in fat_fill_super wherein the mount fails if it is null.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Ravishankar N <cyberax82@gmail.com>
---
 fs/fat/namei_vfat.c |   83 ++++++++++++++++++++++-----------------------------
 1 files changed, 36 insertions(+), 47 deletions(-)

diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index a81eb23..aae3b4e 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -521,57 +521,46 @@ xlate_to_uni(const unsigned char *name, int len, unsigned char *outname,
 
 		op = &outname[*outlen * sizeof(wchar_t)];
 	} else {
-		if (nls) {
-			for (i = 0, ip = name, op = outname, *outlen = 0;
-			     i < len && *outlen <= FAT_LFN_LEN;
-			     *outlen += 1)
-			{
-				if (escape && (*ip == ':')) {
-					if (i > len - 5)
-						return -EINVAL;
-					ec = 0;
-					for (k = 1; k < 5; k++) {
-						nc = ip[k];
-						ec <<= 4;
-						if (nc >= '0' && nc <= '9') {
-							ec |= nc - '0';
-							continue;
-						}
-						if (nc >= 'a' && nc <= 'f') {
-							ec |= nc - ('a' - 10);
-							continue;
-						}
-						if (nc >= 'A' && nc <= 'F') {
-							ec |= nc - ('A' - 10);
-							continue;
-						}
-						return -EINVAL;
+		for (i = 0, ip = name, op = outname, *outlen = 0;
+			 i < len && *outlen <= FAT_LFN_LEN;
+			 *outlen += 1) {
+			if (escape && (*ip == ':')) {
+				if (i > len - 5)
+					return -EINVAL;
+				ec = 0;
+				for (k = 1; k < 5; k++) {
+					nc = ip[k];
+					ec <<= 4;
+					if (nc >= '0' && nc <= '9') {
+						ec |= nc - '0';
+						continue;
 					}
-					*op++ = ec & 0xFF;
-					*op++ = ec >> 8;
-					ip += 5;
-					i += 5;
-				} else {
-					if ((charlen = nls->char2uni(ip, len - i, (wchar_t *)op)) < 0)
-						return -EINVAL;
-					ip += charlen;
-					i += charlen;
-					op += 2;
+					if (nc >= 'a' && nc <= 'f') {
+						ec |= nc - ('a' - 10);
+						continue;
+					}
+					if (nc >= 'A' && nc <= 'F') {
+						ec |= nc - ('A' - 10);
+						continue;
+					}
+					return -EINVAL;
 				}
+				*op++ = ec & 0xFF;
+				*op++ = ec >> 8;
+				ip += 5;
+				i += 5;
+			} else {
+				charlen = nls->char2uni(ip, len - i,
+									(wchar_t *)op);
+				if (charlen < 0)
+					return -EINVAL;
+				ip += charlen;
+				i += charlen;
+				op += 2;
 			}
-			if (i < len)
-				return -ENAMETOOLONG;
-		} else {
-			for (i = 0, ip = name, op = outname, *outlen = 0;
-			     i < len && *outlen <= FAT_LFN_LEN;
-			     i++, *outlen += 1)
-			{
-				*op++ = *ip++;
-				*op++ = 0;
-			}
-			if (i < len)
-				return -ENAMETOOLONG;
 		}
+		if (i < len)
+			return -ENAMETOOLONG;
 	}
 
 	*longlen = *outlen;
-- 
1.7.5.4

