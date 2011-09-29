Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab1I2PKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:10:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:59225 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756788Ab1I2PKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:10:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,461,1312182000"; 
   d="scan'208";a="56977393"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [PATCHv4] fat: don't use custom hex_to_bin()
Date: Thu, 29 Sep 2011 18:10:14 +0300
Message-Id: <f176b6be3c0de274839e813d6ac514d6f7736e77.1317308975.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <87ipob8l4l.fsf@devron.myhome.or.jp>
References: <87ipob8l4l.fsf@devron.myhome.or.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---
 fs/fat/namei_vfat.c |   32 ++++++++++----------------------
 1 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index bb3f29c..93f7009 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -21,6 +21,8 @@
 #include <linux/slab.h>
 #include <linux/buffer_head.h>
 #include <linux/namei.h>
+#include <linux/kernel.h>
+
 #include "fat.h"
 
 /*
@@ -505,10 +507,8 @@ xlate_to_uni(const unsigned char *name, int len, unsigned char *outname,
 	     struct nls_table *nls)
 {
 	const unsigned char *ip;
-	unsigned char nc;
 	unsigned char *op;
-	unsigned int ec;
-	int i, k, fill;
+	int i, fill;
 	int charlen;
 
 	if (utf8) {
@@ -526,28 +526,16 @@ xlate_to_uni(const unsigned char *name, int len, unsigned char *outname,
 			     *outlen += 1)
 			{
 				if (escape && (*ip == ':')) {
+					u8 uc[2];
+
 					if (i > len - 5)
 						return -EINVAL;
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
+
+					if (hex2bin(uc, ip + 1, 2) < 0)
 						return -EINVAL;
-					}
-					*op++ = ec & 0xFF;
-					*op++ = ec >> 8;
+
+					*(wchar_t *)op++ = uc[0] << 8 | uc[1];
+
 					ip += 5;
 					i += 5;
 				} else {
-- 
1.7.6.3

