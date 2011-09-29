Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab1I2NQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 09:16:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:65198 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408Ab1I2NQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 09:16:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,461,1312182000"; 
   d="scan'208";a="21788949"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [PATCHv3] fat: don't use custom hex_to_bin()
Date: Thu, 29 Sep 2011 16:15:40 +0300
Message-Id: <2c8e77b881028c0a11f3cfef4ebb231c3236d60c.1317302092.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <87bou5inkk.fsf@devron.myhome.or.jp>
References: <87bou5inkk.fsf@devron.myhome.or.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---
 fs/fat/namei_vfat.c |   37 +++++++++++++++----------------------
 1 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index bb3f29c..7deb604 100644
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
+	int i, rc, fill;
 	int charlen;
 
 	if (utf8) {
@@ -528,26 +528,19 @@ xlate_to_uni(const unsigned char *name, int len, unsigned char *outname,
 				if (escape && (*ip == ':')) {
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
+					/* The ip contains 2 bytes in little
+					 * endian format. We need to get them
+					 * in native endian. */
+
+					rc = hex2bin(op++, ip + 3, 1);
+					if (rc < 0)
+						return -EINVAL;
+
+					rc = hex2bin(op++, ip + 1, 1);
+					if (rc < 0)
 						return -EINVAL;
-					}
-					*op++ = ec & 0xFF;
-					*op++ = ec >> 8;
+
 					ip += 5;
 					i += 5;
 				} else {
-- 
1.7.6.3

