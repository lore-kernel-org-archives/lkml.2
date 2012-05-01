Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab2EAN1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 09:27:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45872 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab2EAN1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 09:27:42 -0400
Date: Tue, 1 May 2012 06:26:21 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 3/3] vmevent: Implement special low-memory attribute
Message-ID: <20120501132620.GC24226@lizard>
References: <20120501132409.GA22894@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120501132409.GA22894@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is specially "blended" attribute, the event triggers when kernel
decides that we're close to the low memory threshold. Userspace should
not expect very precise meaning of low memory situation, mostly, it's
just a guess on the kernel's side.

Well, this is the same as userland should not know or care how exactly
kernel manages the memory, or assume that memory management behaviour
is a part of the "ABI". So, all the 'low memory' is just guessing, but
we're trying to do our best. It might be that we will end up with two
or three variations of 'low memory' thresholds, and all of them would
be useful for different use cases.

For this implementation, we assume that there's a low memory situation
for the N pages threshold when we have neither N pages of completely
free pages, nor we have N reclaimable pages in the cache. This
effectively means, that if userland expects to allocate N pages, it
would consume all the free pages, and any further allocations (above
N) would start draining caches.

In the worst case, prior to hitting the threshold, we might have only
N pages in cache, and nearly no memory as free pages.

The same 'low memory' meaning is used in the current Android Low
Memory Killer driver.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 include/linux/vmevent.h              |    7 ++++++
 mm/vmevent.c                         |   40 ++++++++++++++++++++++++++++++++++
 tools/testing/vmevent/vmevent-test.c |   12 +++++++++-
 3 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/include/linux/vmevent.h b/include/linux/vmevent.h
index aae0d24..9bfa244 100644
--- a/include/linux/vmevent.h
+++ b/include/linux/vmevent.h
@@ -10,6 +10,13 @@ enum {
 	VMEVENT_ATTR_NR_AVAIL_PAGES	= 1UL,
 	VMEVENT_ATTR_NR_FREE_PAGES	= 2UL,
 	VMEVENT_ATTR_NR_SWAP_PAGES	= 3UL,
+	/*
+	 * This is specially blended attribute, the event triggers
+	 * when kernel decides that we're close to the low memory threshold.
+	 * Don't expect very precise meaning of low memory situation, mostly,
+	 * it's just a guess on the kernel's side.
+	 */
+	VMEVENT_ATTR_LOWMEM_PAGES	= 4UL,
 
 	VMEVENT_ATTR_MAX		/* non-ABI */
 };
diff --git a/mm/vmevent.c b/mm/vmevent.c
index b312236..d278a25 100644
--- a/mm/vmevent.c
+++ b/mm/vmevent.c
@@ -68,10 +68,50 @@ static u64 vmevent_attr_avail_pages(struct vmevent_watch *watch,
 	return totalram_pages;
 }
 
+/*
+ * Here's some implementation details for the "low memory" meaning.
+ *
+ * (The explanation is not in the header file as userland should not
+ * know these details, nor it should assume that the meaning will
+ * always be the same. As well as it should not know how exactly kernel
+ * manages the memory, or assume that memory management behaviour is a
+ * part of the "ABI". So, all the 'low memory' is just guessing, but
+ * we're trying to do our best.)
+ *
+ * For this implementation, we assume that there's a low memory situation
+ * for the N pages threshold when we have neither N pages of completely
+ * free pages, nor we have N reclaimable pages in the cache. This
+ * effectively means, that if userland expects to allocate N pages, it
+ * would consume all the free pages, and any further allocations (above
+ * N) would start draining caches.
+ *
+ * In the worst case, prior hitting the threshold, we might have only
+ * N pages in cache, and nearly no memory as free pages.
+ */
+static u64 vmevent_attr_lowmem_pages(struct vmevent_watch *watch,
+				     struct vmevent_attr *attr)
+{
+	int free = global_page_state(NR_FREE_PAGES);
+	int file = global_page_state(NR_FILE_PAGES) -
+		   global_page_state(NR_SHMEM); /* TODO: account locked pages */
+	int val = attr->value;
+
+	/*
+	 * For convenience we return 0 or attr value (instead of 0/1), it
+	 * makes it easier for vmevent_match() to cope with blended
+	 * attributes, plus userland might use the value to find out which
+	 * threshold triggered.
+	 */
+	if (free < val && file < val)
+		return val;
+	return 0;
+}
+
 static vmevent_attr_sample_fn attr_samplers[] = {
 	[VMEVENT_ATTR_NR_AVAIL_PAGES]   = vmevent_attr_avail_pages,
 	[VMEVENT_ATTR_NR_FREE_PAGES]    = vmevent_attr_free_pages,
 	[VMEVENT_ATTR_NR_SWAP_PAGES]    = vmevent_attr_swap_pages,
+	[VMEVENT_ATTR_LOWMEM_PAGES]     = vmevent_attr_lowmem_pages,
 };
 
 static u64 vmevent_sample_attr(struct vmevent_watch *watch, struct vmevent_attr *attr)
diff --git a/tools/testing/vmevent/vmevent-test.c b/tools/testing/vmevent/vmevent-test.c
index fd9a174..c61aed7 100644
--- a/tools/testing/vmevent/vmevent-test.c
+++ b/tools/testing/vmevent/vmevent-test.c
@@ -33,7 +33,7 @@ int main(int argc, char *argv[])
 
 	config = (struct vmevent_config) {
 		.sample_period_ns	= 1000000000L,
-		.counter		= 6,
+		.counter		= 7,
 		.attrs			= {
 			{
 				.type	= VMEVENT_ATTR_NR_FREE_PAGES,
@@ -59,6 +59,13 @@ int main(int argc, char *argv[])
 				.type	= VMEVENT_ATTR_NR_SWAP_PAGES,
 			},
 			{
+				.type	= VMEVENT_ATTR_LOWMEM_PAGES,
+				.state	= VMEVENT_ATTR_STATE_VALUE_LT |
+					  VMEVENT_ATTR_STATE_VALUE_EQ |
+					  VMEVENT_ATTR_STATE_ONE_SHOT,
+				.value	= phys_pages / 2,
+			},
+			{
 				.type	= 0xffff, /* invalid */
 			},
 		},
@@ -108,6 +115,9 @@ int main(int argc, char *argv[])
 			case VMEVENT_ATTR_NR_SWAP_PAGES:
 				printf("  VMEVENT_ATTR_NR_SWAP_PAGES: %Lu\n", attr->value);
 				break;
+			case VMEVENT_ATTR_LOWMEM_PAGES:
+				printf("  VMEVENT_ATTR_LOWMEM_PAGES: %Lu\n", attr->value);
+				break;
 			default:
 				printf("  Unknown attribute: %Lu\n", attr->value);
 			}
-- 
1.7.9.2
