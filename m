Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab0IBT45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 15:56:57 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:38601 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab0IBT44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 15:56:56 -0400
Date: Thu, 2 Sep 2010 12:56:55 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: Stefani Seibold <stefani@seibold.net>
Subject: [PATCH] kfifo: fix scatterlist usage
Message-ID: <20100902195655.GB24861@ovro.caltech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Thu, 02 Sep 2010 12:56:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kfifo_dma family of functions use sg_mark_end() on the last element
in their scatterlist. This forces use of a fresh scatterlist for each
DMA operation, which makes recycling a single scatterlist impossible.

Change the behavior of the kfifo_dma functions to match the usage of the
dma_map_sg function. This means that users must respect the returned
nents value. The sample code is updated to reflect the change.

This bug is trivial to cause: call kfifo_dma_in_prepare() such that it
prepares a scatterlist with a single entry comprising the whole fifo.
This is the case when you map the entirety of a newly created empty
fifo. This causes the setup_sgl() function to mark the first scatterlist
entry as the end of the chain, no matter what comes after it.

Afterwards, add and remove some data from the fifo such that another
call to kfifo_dma_in_prepare() will create two scatterlist entries. It
returns nents=2. However, due to the previous sg_mark_end() call,
sg_is_last() will now return true for the first scatterlist element.
This causes the sample code to print a single scatterlist element when
it should print two.

By removing the call to sg_mark_end(), we make the API as similar as
possible to the DMA mapping API. All users are required to respect
the returned nents.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---

Hello Stefani,

I found this bug while porting one of my drivers to the new kfifo API.
It caused a hard to find crash in dma_map_sg(), where I passed the nents
value returned from kfifo_dma_in_prepare().

Unfortunately, I won't be able to use the new kfifo for this driver: I
used vmalloc to allocate memory, however vmalloc'd memory cannot be used
for DMA. If I were willing to do 64 * 128kB kmalloc allocations, kfifo
would have worked fine. Oh well. I'm sure other users will come along.

 kernel/kfifo.c              |    2 --
 samples/kfifo/dma-example.c |   17 +++++++++--------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/kernel/kfifo.c b/kernel/kfifo.c
index 6b5580c..01a0700 100644
--- a/kernel/kfifo.c
+++ b/kernel/kfifo.c
@@ -365,8 +365,6 @@ static unsigned int setup_sgl(struct __kfifo *fifo, struct scatterlist *sgl,
 	n = setup_sgl_buf(sgl, fifo->data + off, nents, l);
 	n += setup_sgl_buf(sgl + n, fifo->data, nents - n, len - l);
 
-	if (n)
-		sg_mark_end(sgl + n - 1);
 	return n;
 }
 
diff --git a/samples/kfifo/dma-example.c b/samples/kfifo/dma-example.c
index ee03a4f..0647379 100644
--- a/samples/kfifo/dma-example.c
+++ b/samples/kfifo/dma-example.c
@@ -24,6 +24,7 @@ static int __init example_init(void)
 {
 	int			i;
 	unsigned int		ret;
+	unsigned int		nents;
 	struct scatterlist	sg[10];
 
 	printk(KERN_INFO "DMA fifo test start\n");
@@ -61,9 +62,9 @@ static int __init example_init(void)
 	 * byte at the beginning, after the kfifo_skip().
 	 */
 	sg_init_table(sg, ARRAY_SIZE(sg));
-	ret = kfifo_dma_in_prepare(&fifo, sg, ARRAY_SIZE(sg), FIFO_SIZE);
-	printk(KERN_INFO "DMA sgl entries: %d\n", ret);
-	if (!ret) {
+	nents = kfifo_dma_in_prepare(&fifo, sg, ARRAY_SIZE(sg), FIFO_SIZE);
+	printk(KERN_INFO "DMA sgl entries: %d\n", nents);
+	if (!nents) {
 		/* fifo is full and no sgl was created */
 		printk(KERN_WARNING "error kfifo_dma_in_prepare\n");
 		return -EIO;
@@ -71,7 +72,7 @@ static int __init example_init(void)
 
 	/* receive data */
 	printk(KERN_INFO "scatterlist for receive:\n");
-	for (i = 0; i < ARRAY_SIZE(sg); i++) {
+	for (i = 0; i < nents; i++) {
 		printk(KERN_INFO
 		"sg[%d] -> "
 		"page_link 0x%.8lx offset 0x%.8x length 0x%.8x\n",
@@ -91,16 +92,16 @@ static int __init example_init(void)
 	kfifo_dma_in_finish(&fifo, ret);
 
 	/* Prepare to transmit data, example: 8 bytes */
-	ret = kfifo_dma_out_prepare(&fifo, sg, ARRAY_SIZE(sg), 8);
-	printk(KERN_INFO "DMA sgl entries: %d\n", ret);
-	if (!ret) {
+	nents = kfifo_dma_out_prepare(&fifo, sg, ARRAY_SIZE(sg), 8);
+	printk(KERN_INFO "DMA sgl entries: %d\n", nents);
+	if (!nents) {
 		/* no data was available and no sgl was created */
 		printk(KERN_WARNING "error kfifo_dma_out_prepare\n");
 		return -EIO;
 	}
 
 	printk(KERN_INFO "scatterlist for transmit:\n");
-	for (i = 0; i < ARRAY_SIZE(sg); i++) {
+	for (i = 0; i < nents; i++) {
 		printk(KERN_INFO
 		"sg[%d] -> "
 		"page_link 0x%.8lx offset 0x%.8x length 0x%.8x\n",
-- 
1.7.1

