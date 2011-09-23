Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1IWLc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 07:32:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:40254 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab1IWLcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 07:32:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,429,1312182000"; 
   d="scan'208";a="69029591"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [PATCH] fat: don't use custom hex_to_bin()
Date: Fri, 23 Sep 2011 14:32:12 +0300
Message-Id: <e1a466eb82a79c91f3ec103b8308f2f81bfcbd69.1316777398.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <e23268a9c837d75a24c2d209f1623c505371eb1d.1316777507.git.andriy.shevchenko@linux.intel.com>
References: <e23268a9c837d75a24c2d209f1623c505371eb1d.1316777507.git.andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---
 fs/fat/namei_vfat.c |   22 ++++++----------------
 1 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index bb3f29c..09cec4c 100644
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
@@ -505,7 +507,6 @@ xlate_to_uni(const unsigned char *name, int len, unsigned char *outname,
 	     struct nls_table *nls)
 {
 	const unsigned char *ip;
-	unsigned char nc;
 	unsigned char *op;
 	unsigned int ec;
 	int i, k, fill;
@@ -530,21 +531,10 @@ xlate_to_uni(const unsigned char *name, int len, unsigned char *outname,
 						return -EINVAL;
 					ec = 0;
 					for (k = 1; k < 5; k++) {
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
+						int val = hex_to_bin(ip[k]);
+						if (val < 0)
+							return -EINVAL;
+						ec = (ec << 4) | val;
 					}
 					*op++ = ec & 0xFF;
 					*op++ = ec >> 8;
-- 
1.7.6.3

