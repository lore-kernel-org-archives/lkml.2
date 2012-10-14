Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab2JNPy3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:54:29 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:21605 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab2JNPy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 11:54:28 -0400
Message-ID: <1350230064.4069.1.camel@lorien2>
Subject: [PATCH] Documentation DMA-API-HOWTO.txt Add dma mapping error check
 usage examples
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Andrew Morton <akpm@linux-foundation.org>, konrad.wilk@oracle.com,
        rob@landley.net, joerg.roedel@amd.com
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devel@linuxdriverproject.org, shuahkhan@gmail.com
Date: Sun, 14 Oct 2012 09:54:24 -0600
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance the document to discuss the importance of dma mapping error checks
after dma_map_single() and dma_map_page() calls. Also added usage examples
that include unmap examples in error paths when dma mapping error is returned.
Includes correct and incorrect usages to high light some common mistakes in
error paths especially when dma mapping fails when more than one dma mapping
call is made.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 Documentation/DMA-API-HOWTO.txt |  128 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 127 insertions(+), 1 deletion(-)

diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
index a0b6250..cf1adb4 100644
--- a/Documentation/DMA-API-HOWTO.txt
+++ b/Documentation/DMA-API-HOWTO.txt
@@ -468,11 +468,46 @@ To map a single region, you do:
 	size_t size = buffer->len;
 
 	dma_handle = dma_map_single(dev, addr, size, direction);
+	if (unlikely(dma_mapping_error(dma_handle))) {
+		/*
+		 * reduce current DMA mapping usage,
+		 * delay and try again later or
+		 * reset driver.
+		 */
+		goto map_error_handling;
+	}
 
 and to unmap it:
 
 	dma_unmap_single(dev, dma_handle, size, direction);
 
+You should call dma_mapping_error() as dma_map_single() could fail and return
+error. Not all dma implementations support dma_mapping_error() interface.
+However, it is a good practice to call dma_mapping_error() interface, which
+will invoke the generic mapping error check interface. Doing so will ensure
+that the mapping code will work correctly on all dma implementations without
+any dependency on the specifics of the underlying implementation. Using the
+returned address without checking for errors could result in failures ranging
+from panics to silent data corruption. Couple of example of incorrect ways to
+check for errors that make assumptions about the underlying dma implementation
+are as follows and these are applicable to dma_map_page() as well.
+
+Incorrect example 1:
+	dma_addr_t dma_handle;
+
+	dma_handle = dma_map_single(dev, addr, size, direction);
+	if ((dma_handle & 0xffff != 0) || (dma_handle >= 0x1000000)) {
+		goto map_error;
+	}
+
+Incorrect example 2:
+	dma_addr_t dma_handle;
+
+	dma_handle = dma_map_single(dev, addr, size, direction);
+	if (dma_handle == DMA_ERROR_CODE) {
+		goto map_error;
+	}
+
 You should call dma_unmap_single when the DMA activity is finished, e.g.
 from the interrupt which told you that the DMA transfer is done.
 
@@ -489,6 +524,14 @@ Specifically:
 	size_t size = buffer->len;
 
 	dma_handle = dma_map_page(dev, page, offset, size, direction);
+	if (unlikely(dma_mapping_error(dma_handle))) {
+		/*
+		 * reduce current DMA mapping usage,
+		 * delay and try again later or
+		 * reset driver.
+		 */
+		goto map_error_handling;
+	}
 
 	...
 
@@ -496,6 +539,12 @@ Specifically:
 
 Here, "offset" means byte offset within the given page.
 
+You should call dma_mapping_error() as dma_map_page() could fail and return
+error as outlined under the dma_map_single() discussion.
+
+You should call dma_unmap_page when the DMA activity is finished, e.g.
+from the interrupt which told you that the DMA transfer is done.
+
 With scatterlists, you map a region gathered from several regions by:
 
 	int i, count = dma_map_sg(dev, sglist, nents, direction);
@@ -578,6 +627,14 @@ to use the dma_sync_*() interfaces.
 		dma_addr_t mapping;
 
 		mapping = dma_map_single(cp->dev, buffer, len, DMA_FROM_DEVICE);
+		if (unlikely(dma_mapping_error(dma_handle))) {
+			/*
+			 * reduce current DMA mapping usage,
+			 * delay and try again later or
+			 * reset driver.
+			 */
+			goto map_error_handling;
+		}
 
 		cp->rx_buf = buffer;
 		cp->rx_len = len;
@@ -652,12 +709,81 @@ failure can be determined by:
 	dma_addr_t dma_handle;
 
 	dma_handle = dma_map_single(dev, addr, size, direction);
-	if (dma_mapping_error(dev, dma_handle)) {
+	if (unlikely(dma_mapping_error(dev, dma_handle))) {
+		/*
+		 * reduce current DMA mapping usage,
+		 * delay and try again later or
+		 * reset driver.
+		 */
+		goto map_error_handling;
+	}
+
+- unmap pages that are already mapped, when mapping error occurs in the middle
+  of a multiple page mapping attempt. These example are applicable to
+  dma_map_page() as well.
+
+Example 1:
+	dma_addr_t dma_handle1;
+	dma_addr_t dma_handle2;
+
+	dma_handle1 = dma_map_single(dev, addr, size, direction);
+	if (unlikely(dma_mapping_error(dev, dma_handle1))) {
+		/*
+		 * reduce current DMA mapping usage,
+		 * delay and try again later or
+		 * reset driver.
+		 */
+		goto map_error_handling1;
+	}
+	dma_handle2 = dma_map_single(dev, addr, size, direction);
+	if (dma_mapping_error(dev, dma_handle2)) {
 		/*
 		 * reduce current DMA mapping usage,
 		 * delay and try again later or
 		 * reset driver.
 		 */
+		goto map_error_handling2;
+	}
+
+	...
+
+	map_error_handling2:
+		dma_unmap_single(dma_handle1);
+	map_error_handling1:
+
+Example 2: (if buffers are allocated a loop, unmap all mapped buffers when
+	    mapping error is detected in the middle)
+
+	dma_addr_t dma_addr;
+	dma_addr_t array[DMA_BUFFERS];
+	int save_index = 0;
+
+	for (i = 0; i < DMA_BUFFERS; i++) {
+
+		...
+
+		dma_addr = dma_map_single(dev, addr, size, direction);
+		if (dma_mapping_error(dev, dma_addr)) {
+			/*
+			 * reduce current DMA mapping usage,
+			 * delay and try again later or
+			 * reset driver.
+			 */
+			goto map_error_handling;
+		}
+		array[i].dma_addr = dma_addr;
+		save_index++;
+	}
+
+	...
+
+	map_error_handling:
+
+	for (i = 0; i < save_index; i++) {
+
+		...
+
+		dma_unmap_single(array[i].dma_addr);
 	}
 
 Networking drivers must call dev_kfree_skb to free the socket buffer
-- 
1.7.9.5



