Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab2JZH47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 03:56:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:52418 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757059Ab2JZH4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 03:56:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,653,1344236400"; 
   d="scan'208";a="238676433"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Stefani Seibold <stefani@seibold.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] kfifo: handle the case that alloc size is equal to 0
Date: Fri, 26 Oct 2012 15:56:58 +0800
Message-Id: <1351238218-22648-2-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1351238218-22648-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1351238218-22648-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

is_power_of_2(size) will be failed if size is 0, and then it calls
roundup_pow_of_two(0), then will return a quite *huge* value(well, the
comments at roundup_pow_of_two macro says: the result is undefined when
n == 0).

Moving the size check before power of 2 testing and rounding will fix
this "not really happened yet" issue.

Cc: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 kernel/kfifo.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/kernel/kfifo.c b/kernel/kfifo.c
index 0f78378..e3a63c6 100644
--- a/kernel/kfifo.c
+++ b/kernel/kfifo.c
@@ -38,13 +38,6 @@ static inline unsigned int kfifo_unused(struct __kfifo *fifo)
 int __kfifo_alloc(struct __kfifo *fifo, unsigned int size,
 		size_t esize, gfp_t gfp_mask)
 {
-	/*
-	 * round up to the next power of 2, since our 'let the indices
-	 * wrap' technique works only in this case.
-	 */
-	if (!is_power_of_2(size))
-		size = roundup_pow_of_two(size);
-
 	fifo->in = 0;
 	fifo->out = 0;
 	fifo->esize = esize;
@@ -54,6 +47,12 @@ int __kfifo_alloc(struct __kfifo *fifo, unsigned int size,
 		fifo->mask = 0;
 		return -EINVAL;
 	}
+	/*
+	 * round up to the next power of 2, since our 'let the indices
+	 * wrap' technique works only in this case.
+	 */
+	if (!is_power_of_2(size))
+		size = roundup_pow_of_two(size);
 
 	fifo->data = kmalloc(size * esize, gfp_mask);
 
@@ -81,20 +80,19 @@ EXPORT_SYMBOL(__kfifo_free);
 int __kfifo_init(struct __kfifo *fifo, void *buffer,
 		unsigned int size, size_t esize)
 {
-	size /= esize;
-
-	if (!is_power_of_2(size))
-		size = roundup_pow_of_two(size);
-
 	fifo->in = 0;
 	fifo->out = 0;
 	fifo->esize = esize;
 	fifo->data = buffer;
 
+	size /= esize;
 	if (size < 2) {
 		fifo->mask = 0;
 		return -EINVAL;
 	}
+	if (!is_power_of_2(size))
+		size = roundup_pow_of_two(size);
+
 	fifo->mask = size - 1;
 
 	return 0;
-- 
1.7.7.6

