Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab2LKV4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 16:56:52 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42294 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044Ab2LKV4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 16:56:41 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: =?UTF-8?q?=5BPATCH=208/8=5D=20zswap=3A=20add=20documentation?=
Date: Tue, 11 Dec 2012 15:56:06 -0600
Message-Id: <1355262966-15281-9-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355262966-15281-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1355262966-15281-1-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121121-7182-0000-0000-000003B6C691
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the documentation file for the zswap functionality

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 Documentation/vm/zswap.txt |   74 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)
 create mode 100644 Documentation/vm/zswap.txt

diff --git a/Documentation/vm/zswap.txt b/Documentation/vm/zswap.txt
new file mode 100644
index 0000000..f12d690
--- /dev/null
+++ b/Documentation/vm/zswap.txt
@@ -0,0 +1,74 @@
+Overview:
+
+Zswap is a lightweight compressed cache for swap pages. It takes
+pages that are in the process of being swapped out and attempts to
+compress them into a dynamically allocated RAM-based memory pool.
+If this process is successful, the writeback to the swap device is
+deferred and, in many cases, avoided completely.  This results in
+a significant I/O reduction and performance gains for systems that
+are swapping.
+
+Zswap provides compressed swap caching that basically trades CPU cycles
+for reduced swap I/O.  This trade-off can result in a significant
+performance improvement as reads to/writes from to the compressed
+cache almost always faster that reading from a swap device
+which incurs the latency of an asynchronous block I/O read.
+
+Some potential benefits:
+* Desktop/laptop users with limited RAM capacities can mitigate the
+    performance impact of swapping.
+* Overcommitted guests that share a common I/O resource can
+    dramatically reduce their swap I/O pressure, avoiding heavy
+    handed I/O throttling by the hypervisor.  This allows more work
+    to get done with less impact to the guest workload and guests
+    sharing the I/O subsystem
+* Users with SSDs as swap devices can extend the life of the device by
+    drastically reducing life-shortening writes.
+
+Zswap evicts pages from compressed cache on an LRU basis to the backing
+swap device when the compress pool reaches it size limit or the pool is
+unable to obtain additional pages from the buddy allocator.  This
+requirement had been identified in prior community discussions.
+
+To enabled zswap, the "enabled" attribute must be set to 1 at boot time.
+e.g. zswap.enabled=1
+
+Design:
+
+Zswap receives pages for compression through the Frontswap API and
+is able to evict pages from its own compressed pool on an LRU basis
+and write them back to the backing swap device in the case that the
+compressed pool is full or unable to secure additional pages from
+the buddy allocator.
+
+Zswap makes use of zsmalloc for the managing the compressed memory
+pool.  This is because zsmalloc is specifically designed to minimize
+fragmentation on large (> PAGE_SIZE/2) allocation sizes.  Each
+allocation in zsmalloc is not directly accessible by address.
+Rather, a handle is return by the allocation routine and that handle
+must be mapped before being accessed.  The compressed memory pool grows
+on demand and shrinks as compressed pages are freed.  The pool is
+not preallocated.
+
+When a swap page is passed from frontswap to zswap, zswap maintains
+a mapping of the swap entry, a combination of the swap type and swap
+offset, to the zsmalloc handle that references that compressed swap
+page.  This mapping is achieved with a red-black tree per swap type.
+The swap offset is the search key for the tree nodes.
+
+Zswap seeks to be simple in its policies.  Sysfs attributes allow for
+two user controlled policies:
+* max_compression_ratio - Maximum compression ratio, as as percentage,
+    for an acceptable compressed page. Any page that does not compress
+    by at least this ratio will be rejected.
+* max_pool_percent - The maximum percentage of memory that the compressed
+    pool can occupy.
+
+Zswap allows the compressor to be selected at kernel boot time by
+setting the “compressor” attribute.  The default compressor is lzo.
+e.g. zswap.compressor=deflate
+
+A debugfs interface is provided for various statistic about pool size,
+number of pages stored, and various counters for the reasons pages
+are rejected.
+
-- 
1.7.9.5

