Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab1A1O5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:57:31 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:53309 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab1A1O53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:57:29 -0500
Date: Fri, 28 Jan 2011 08:57:27 -0600
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] [v2] zram/vmalloc: Correct tunings to enable use with
 64K pages
Message-ID: <20110128145726.GB2062@linux.vnet.ibm.com>
Mail-Followup-To: Nitin Gupta <ngupta@vflare.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <20110128145602.GA2062@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110128145602.GA2062@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xvmalloc will not currently function with 64K pages.  Newly allocated
pages will be inserted at an offset beyond the end of the first-level
index.  This tuning is needed to properly size the allocator for 64K
pages.

The default 3 byte shift results in a second level list size which can not
be indexed using the 64 bits of the flbitmap in the xv_pool structure.
The shift must increase to 4 bytes between second level list entries to
fit the size of the first level bitmap.

Here are a few statistics for structure sizes on 32- and 64-bit CPUs
with 4KB and 64KB page sizes.

bits_per_long              32        64        64
page_size               4,096     4,096    65,535
xv_align                    4         8         8
fl_delta                    3         3         4
num_free_lists            508       508     4,094
xv_pool size            4,144b    8,216b   66,040b
per object overhead        32        64        64
zram struct 0.5GB disk    512KB    1024KB      64KB

This patch maintains the current tunings for 4K pages, adds an optimal
sizing for 64K pages and adds a safe tuning for any other page sizes.

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
---
 drivers/staging/zram/xvmalloc_int.h |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zram/xvmalloc_int.h b/drivers/staging/zram/xvmalloc_int.h
index e23ed5c..82a31fb 100644
--- a/drivers/staging/zram/xvmalloc_int.h
+++ b/drivers/staging/zram/xvmalloc_int.h
@@ -19,7 +19,11 @@
 /* User configurable params */
 
 /* Must be power of two */
+#ifdef CONFIG_64BIT
+#define XV_ALIGN_SHIFT 3
+#else
 #define XV_ALIGN_SHIFT	2
+#endif
 #define XV_ALIGN	(1 << XV_ALIGN_SHIFT)
 #define XV_ALIGN_MASK	(XV_ALIGN - 1)
 
@@ -27,8 +31,16 @@
 #define XV_MIN_ALLOC_SIZE	32
 #define XV_MAX_ALLOC_SIZE	(PAGE_SIZE - XV_ALIGN)
 
-/* Free lists are separated by FL_DELTA bytes */
-#define FL_DELTA_SHIFT	3
+/*
+ * Free lists are separated by FL_DELTA bytes
+ * This value is 3 for 4k pages and 4 for 64k pages, for any
+ * other page size, a conservative (PAGE_SHIFT - 9) is used.
+ */
+#if PAGE_SHIFT == 16
+#define FL_DELTA_SHIFT 4
+#else
+#define FL_DELTA_SHIFT (PAGE_SHIFT - 9)
+#endif
 #define FL_DELTA	(1 << FL_DELTA_SHIFT)
 #define FL_DELTA_MASK	(FL_DELTA - 1)
 #define NUM_FREE_LISTS	((XV_MAX_ALLOC_SIZE - XV_MIN_ALLOC_SIZE) \
-- 
1.7.0.4

