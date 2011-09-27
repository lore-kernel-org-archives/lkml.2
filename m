Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab1I0LtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 07:49:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:61586 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab1I0LtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 07:49:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,449,1312182000"; 
   d="scan'208";a="71148274"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [PATCHv2] fat: don't use custom hex_to_bin()
Date: Tue, 27 Sep 2011 14:48:46 +0300
Message-Id: <542eeafb16d173360eb79f8188f967cc3dcc9252.1317124046.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <CAK1hOcNus4RKQOF=eivuCXFEM5Lqb+jBdOD4YrMA_5bL2EB6yA@mail.gmail.com>
References: <CAK1hOcNus4RKQOF=eivuCXFEM5Lqb+jBdOD4YrMA_5bL2EB6yA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---
 fs/fat/namei_vfat.c |   30 ++++++++----------------------
 1 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index bb3f29c..cf0fd96 100644
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
@@ -528,26 +528,12 @@ xlate_to_uni(const unsigned char *name, int len, unsigned char *outname,
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
+					rc = hex2bin(op, ip + 1, 2);
+					if (rc < 0)
 						return -EINVAL;
-					}
-					*op++ = ec & 0xFF;
-					*op++ = ec >> 8;
+
+					op += 2;
 					ip += 5;
 					i += 5;
 				} else {
-- 
1.7.6.3

