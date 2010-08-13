Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab0HMT7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 15:59:21 -0400
Received: from trinity.develer.com ([83.149.158.210]:60563 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab0HMT7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 15:59:14 -0400
From: Andrea Righi <arighi@develer.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] kfifo: add explicit error checking in all the examples
Date: Fri, 13 Aug 2010 21:59:05 +0200
Message-Id: <1281729545-1663-3-git-send-email-arighi@develer.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281729545-1663-1-git-send-email-arighi@develer.com>
References: <1281729545-1663-1-git-send-email-arighi@develer.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a check in all the kfifo examples to validate the correct
execution of each testcase.

 [ Andrew: this depends on kfifo-add-explicit-error-checking-in-byte-stream-example.patch ]

Signed-off-by: Andrea Righi <arighi@develer.com>
---
 samples/kfifo/bytestream-example.c |    7 ++-
 samples/kfifo/dma-example.c        |  106 +++++++++++++++++++++++-------------
 samples/kfifo/inttype-example.c    |   43 ++++++++++++---
 samples/kfifo/record-example.c     |   39 ++++++++++++-
 4 files changed, 144 insertions(+), 51 deletions(-)

diff --git a/samples/kfifo/bytestream-example.c b/samples/kfifo/bytestream-example.c
index a94e694..178061e 100644
--- a/samples/kfifo/bytestream-example.c
+++ b/samples/kfifo/bytestream-example.c
@@ -44,7 +44,7 @@ static struct kfifo test;
 static DECLARE_KFIFO(test, unsigned char, FIFO_SIZE);
 #endif
 
-static unsigned char expected_result[FIFO_SIZE] = {
+static const unsigned char expected_result[FIFO_SIZE] = {
 	 3,  4,  5,  6,  7,  8,  9,  0,
 	 1, 20, 21, 22, 23, 24, 25, 26,
 	27, 28, 29, 30, 31, 32, 33, 34,
@@ -90,9 +90,14 @@ static int __init testfunc(void)
 
 	printk(KERN_INFO "queue len: %u\n", kfifo_len(&test));
 
+	/* show the first value without removing from the fifo */
+	if (kfifo_peek(&test, &i))
+		printk(KERN_INFO "%d\n", i);
+
 	/* check the correctness of all values in the fifo */
 	j = 0;
 	while (kfifo_get(&test, &i)) {
+		printk(KERN_INFO "item = %d\n", i);
 		if (i != expected_result[j++]) {
 			printk(KERN_WARNING "value mismatch: test failed\n");
 			return -EIO;
diff --git a/samples/kfifo/dma-example.c b/samples/kfifo/dma-example.c
index 3682278..ee03a4f 100644
--- a/samples/kfifo/dma-example.c
+++ b/samples/kfifo/dma-example.c
@@ -29,8 +29,8 @@ static int __init example_init(void)
 	printk(KERN_INFO "DMA fifo test start\n");
 
 	if (kfifo_alloc(&fifo, FIFO_SIZE, GFP_KERNEL)) {
-		printk(KERN_ERR "error kfifo_alloc\n");
-		return 1;
+		printk(KERN_WARNING "error kfifo_alloc\n");
+		return -ENOMEM;
 	}
 
 	printk(KERN_INFO "queue size: %u\n", kfifo_size(&fifo));
@@ -41,65 +41,93 @@ static int __init example_init(void)
 		kfifo_put(&fifo, &i);
 
 	/* kick away first byte */
-	ret = kfifo_get(&fifo, &i);
+	kfifo_skip(&fifo);
 
 	printk(KERN_INFO "queue len: %u\n", kfifo_len(&fifo));
 
+	/*
+	 * Configure the kfifo buffer to receive data from DMA input.
+	 *
+	 *  .--------------------------------------.
+	 *  | 0 | 1 | 2 | ... | 12 | 13 | ... | 31 |
+	 *  |---|------------------|---------------|
+	 *   \_/ \________________/ \_____________/
+	 *    \          \                  \
+	 *     \          \_allocated data   \
+	 *      \_*free space*                \_*free space*
+	 *
+	 * We need two different SG entries: one for the free space area at the
+	 * end of the kfifo buffer (19 bytes) and another for the first free
+	 * byte at the beginning, after the kfifo_skip().
+	 */
 	sg_init_table(sg, ARRAY_SIZE(sg));
 	ret = kfifo_dma_in_prepare(&fifo, sg, ARRAY_SIZE(sg), FIFO_SIZE);
 	printk(KERN_INFO "DMA sgl entries: %d\n", ret);
+	if (!ret) {
+		/* fifo is full and no sgl was created */
+		printk(KERN_WARNING "error kfifo_dma_in_prepare\n");
+		return -EIO;
+	}
 
-	/* if 0 was returned, fifo is full and no sgl was created */
-	if (ret) {
-		printk(KERN_INFO "scatterlist for receive:\n");
-		for (i = 0; i < ARRAY_SIZE(sg); i++) {
-			printk(KERN_INFO
-			"sg[%d] -> "
-			"page_link 0x%.8lx offset 0x%.8x length 0x%.8x\n",
-				i, sg[i].page_link, sg[i].offset, sg[i].length);
+	/* receive data */
+	printk(KERN_INFO "scatterlist for receive:\n");
+	for (i = 0; i < ARRAY_SIZE(sg); i++) {
+		printk(KERN_INFO
+		"sg[%d] -> "
+		"page_link 0x%.8lx offset 0x%.8x length 0x%.8x\n",
+			i, sg[i].page_link, sg[i].offset, sg[i].length);
 
-			if (sg_is_last(&sg[i]))
-				break;
-		}
+		if (sg_is_last(&sg[i]))
+			break;
+	}
 
-		/* but here your code to setup and exectute the dma operation */
-		/* ... */
+	/* put here your code to setup and exectute the dma operation */
+	/* ... */
 
-		/* example: zero bytes received */
-		ret = 0;
+	/* example: zero bytes received */
+	ret = 0;
 
-		/* finish the dma operation and update the received data */
-		kfifo_dma_in_finish(&fifo, ret);
-	}
+	/* finish the dma operation and update the received data */
+	kfifo_dma_in_finish(&fifo, ret);
 
+	/* Prepare to transmit data, example: 8 bytes */
 	ret = kfifo_dma_out_prepare(&fifo, sg, ARRAY_SIZE(sg), 8);
 	printk(KERN_INFO "DMA sgl entries: %d\n", ret);
+	if (!ret) {
+		/* no data was available and no sgl was created */
+		printk(KERN_WARNING "error kfifo_dma_out_prepare\n");
+		return -EIO;
+	}
 
-	/* if 0 was returned, no data was available and no sgl was created */
-	if (ret) {
-		printk(KERN_INFO "scatterlist for transmit:\n");
-		for (i = 0; i < ARRAY_SIZE(sg); i++) {
-			printk(KERN_INFO
-			"sg[%d] -> "
-			"page_link 0x%.8lx offset 0x%.8x length 0x%.8x\n",
-				i, sg[i].page_link, sg[i].offset, sg[i].length);
+	printk(KERN_INFO "scatterlist for transmit:\n");
+	for (i = 0; i < ARRAY_SIZE(sg); i++) {
+		printk(KERN_INFO
+		"sg[%d] -> "
+		"page_link 0x%.8lx offset 0x%.8x length 0x%.8x\n",
+			i, sg[i].page_link, sg[i].offset, sg[i].length);
 
-			if (sg_is_last(&sg[i]))
-				break;
-		}
+		if (sg_is_last(&sg[i]))
+			break;
+	}
 
-		/* but here your code to setup and exectute the dma operation */
-		/* ... */
+	/* put here your code to setup and exectute the dma operation */
+	/* ... */
 
-		/* example: 5 bytes transmitted */
-		ret = 5;
+	/* example: 5 bytes transmitted */
+	ret = 5;
 
-		/* finish the dma operation and update the transmitted data */
-		kfifo_dma_out_finish(&fifo, ret);
-	}
+	/* finish the dma operation and update the transmitted data */
+	kfifo_dma_out_finish(&fifo, ret);
 
+	ret = kfifo_len(&fifo);
 	printk(KERN_INFO "queue len: %u\n", kfifo_len(&fifo));
 
+	if (ret != 7) {
+		printk(KERN_WARNING "size mismatch: test failed");
+		return -EIO;
+	}
+	printk(KERN_INFO "test passed\n");
+
 	return 0;
 }
 
diff --git a/samples/kfifo/inttype-example.c b/samples/kfifo/inttype-example.c
index d6c5b7d..71b2aab 100644
--- a/samples/kfifo/inttype-example.c
+++ b/samples/kfifo/inttype-example.c
@@ -44,10 +44,17 @@ static DECLARE_KFIFO_PTR(test, int);
 static DEFINE_KFIFO(test, int, FIFO_SIZE);
 #endif
 
+static const int expected_result[FIFO_SIZE] = {
+	 3,  4,  5,  6,  7,  8,  9,  0,
+	 1, 20, 21, 22, 23, 24, 25, 26,
+	27, 28, 29, 30, 31, 32, 33, 34,
+	35, 36, 37, 38, 39, 40, 41, 42,
+};
+
 static int __init testfunc(void)
 {
 	int		buf[6];
-	int		i;
+	int		i, j;
 	unsigned int	ret;
 
 	printk(KERN_INFO "int fifo test start\n");
@@ -66,8 +73,13 @@ static int __init testfunc(void)
 	ret = kfifo_in(&test, buf, ret);
 	printk(KERN_INFO "ret: %d\n", ret);
 
-	for (i = 20; i != 30; i++)
-		kfifo_put(&test, &i);
+	/* skip first element of the fifo */
+	printk(KERN_INFO "skip 1st element\n");
+	kfifo_skip(&test);
+
+	/* put values into the fifo until is full */
+	for (i = 20; kfifo_put(&test, &i); i++)
+		;
 
 	printk(KERN_INFO "queue len: %u\n", kfifo_len(&test));
 
@@ -75,10 +87,20 @@ static int __init testfunc(void)
 	if (kfifo_peek(&test, &i))
 		printk(KERN_INFO "%d\n", i);
 
-	/* print out all values in the fifo */
-	while (kfifo_get(&test, &i))
-		printk("%d ", i);
-	printk("\n");
+	/* check the correctness of all values in the fifo */
+	j = 0;
+	while (kfifo_get(&test, &i)) {
+		printk(KERN_INFO "item = %d\n", i);
+		if (i != expected_result[j++]) {
+			printk(KERN_WARNING "value mismatch: test failed\n");
+			return -EIO;
+		}
+	}
+	if (j != ARRAY_SIZE(expected_result)) {
+		printk(KERN_WARNING "size mismatch: test failed\n");
+		return -EIO;
+	}
+	printk(KERN_INFO "test passed\n");
 
 	return 0;
 }
@@ -132,7 +154,12 @@ static int __init example_init(void)
 		return ret;
 	}
 #endif
-	testfunc();
+	if (testfunc() < 0) {
+#ifdef DYNAMIC
+		kfifo_free(&test);
+#endif
+		return -EIO;
+	}
 
 	if (proc_create(PROC_FIFO, 0, NULL, &fifo_fops) == NULL) {
 #ifdef DYNAMIC
diff --git a/samples/kfifo/record-example.c b/samples/kfifo/record-example.c
index 32c6e0b..e68bd16 100644
--- a/samples/kfifo/record-example.c
+++ b/samples/kfifo/record-example.c
@@ -55,6 +55,19 @@ typedef STRUCT_KFIFO_REC_1(FIFO_SIZE) mytest;
 static mytest test;
 #endif
 
+static const char *expected_result[] = {
+	"a",
+	"bb",
+	"ccc",
+	"dddd",
+	"eeeee",
+	"ffffff",
+	"ggggggg",
+	"hhhhhhhh",
+	"iiiiiiiii",
+	"jjjjjjjjjj",
+};
+
 static int __init testfunc(void)
 {
 	char		buf[100];
@@ -75,6 +88,10 @@ static int __init testfunc(void)
 		kfifo_in(&test, buf, i + 1);
 	}
 
+	/* skip first element of the fifo */
+	printk(KERN_INFO "skip 1st element\n");
+	kfifo_skip(&test);
+
 	printk(KERN_INFO "fifo len: %u\n", kfifo_len(&test));
 
 	/* show the first record without removing from the fifo */
@@ -82,11 +99,22 @@ static int __init testfunc(void)
 	if (ret)
 		printk(KERN_INFO "%.*s\n", ret, buf);
 
-	/* print out all records in the fifo */
+	/* check the correctness of all values in the fifo */
+	i = 0;
 	while (!kfifo_is_empty(&test)) {
 		ret = kfifo_out(&test, buf, sizeof(buf));
-		printk(KERN_INFO "%.*s\n", ret, buf);
+		buf[ret] = '\0';
+		printk(KERN_INFO "item = %.*s\n", ret, buf);
+		if (strcmp(buf, expected_result[i++])) {
+			printk(KERN_WARNING "value mismatch: test failed\n");
+			return -EIO;
+		}
+	}
+	if (i != ARRAY_SIZE(expected_result)) {
+		printk(KERN_WARNING "size mismatch: test failed\n");
+		return -EIO;
 	}
+	printk(KERN_INFO "test passed\n");
 
 	return 0;
 }
@@ -142,7 +170,12 @@ static int __init example_init(void)
 #else
 	INIT_KFIFO(test);
 #endif
-	testfunc();
+	if (testfunc() < 0) {
+#ifdef DYNAMIC
+		kfifo_free(&test);
+#endif
+		return -EIO;
+	}
 
 	if (proc_create(PROC_FIFO, 0, NULL, &fifo_fops) == NULL) {
 #ifdef DYNAMIC
-- 
1.7.0.4

