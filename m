Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965840Ab2EOCvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:51:32 -0400
Received: from mail.windriver.com ([147.11.1.11]:49649 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965109Ab2EOCRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:19 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 097/179] PM / Hibernate: Avoid hitting OOM during preallocation of memory
Date: Mon, 14 May 2012 22:13:13 -0400
Message-ID: <1337048075-6132-98-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6715045ddc7472a22be5e49d4047d2d89b391f45 upstream.

There is a problem in hibernate_preallocate_memory() that it calls
preallocate_image_memory() with an argument that may be greater than
the total number of available non-highmem memory pages.  If that's
the case, the OOM condition is guaranteed to trigger, which in turn
can cause significant slowdown to occur during hibernation.

To avoid that, make preallocate_image_memory() adjust its argument
before calling preallocate_image_pages(), so that the total number of
saveable non-highem pages left is not less than the minimum size of
a hibernation image.  Change hibernate_preallocate_memory() to try to
allocate from highmem if the number of pages allocated by
preallocate_image_memory() is too low.

Modify free_unnecessary_pages() to take all possible memory
allocation patterns into account.

Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Tested-by: M. Vefa Bicakci <bicave@superonline.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/power/snapshot.c |   85 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 65 insertions(+), 20 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 0652dcc..a204467 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1121,9 +1121,19 @@ static unsigned long preallocate_image_pages(unsigned long nr_pages, gfp_t mask)
 	return nr_alloc;
 }
 
-static unsigned long preallocate_image_memory(unsigned long nr_pages)
+static unsigned long preallocate_image_memory(unsigned long nr_pages,
+					      unsigned long avail_normal)
 {
-	return preallocate_image_pages(nr_pages, GFP_IMAGE);
+	unsigned long alloc;
+
+	if (avail_normal <= alloc_normal)
+		return 0;
+
+	alloc = avail_normal - alloc_normal;
+	if (nr_pages < alloc)
+		alloc = nr_pages;
+
+	return preallocate_image_pages(alloc, GFP_IMAGE);
 }
 
 #ifdef CONFIG_HIGHMEM
@@ -1169,15 +1179,22 @@ static inline unsigned long preallocate_highmem_fraction(unsigned long nr_pages,
  */
 static void free_unnecessary_pages(void)
 {
-	unsigned long save_highmem, to_free_normal, to_free_highmem;
+	unsigned long save, to_free_normal, to_free_highmem;
 
-	to_free_normal = alloc_normal - count_data_pages();
-	save_highmem = count_highmem_pages();
-	if (alloc_highmem > save_highmem) {
-		to_free_highmem = alloc_highmem - save_highmem;
+	save = count_data_pages();
+	if (alloc_normal >= save) {
+		to_free_normal = alloc_normal - save;
+		save = 0;
+	} else {
+		to_free_normal = 0;
+		save -= alloc_normal;
+	}
+	save += count_highmem_pages();
+	if (alloc_highmem >= save) {
+		to_free_highmem = alloc_highmem - save;
 	} else {
 		to_free_highmem = 0;
-		to_free_normal -= save_highmem - alloc_highmem;
+		to_free_normal -= save - alloc_highmem;
 	}
 
 	memory_bm_position_reset(&copy_bm);
@@ -1258,7 +1275,7 @@ int hibernate_preallocate_memory(void)
 {
 	struct zone *zone;
 	unsigned long saveable, size, max_size, count, highmem, pages = 0;
-	unsigned long alloc, save_highmem, pages_highmem;
+	unsigned long alloc, save_highmem, pages_highmem, avail_normal;
 	struct timeval start, stop;
 	int error;
 
@@ -1295,6 +1312,7 @@ int hibernate_preallocate_memory(void)
 		else
 			count += zone_page_state(zone, NR_FREE_PAGES);
 	}
+	avail_normal = count;
 	count += highmem;
 	count -= totalreserve_pages;
 
@@ -1309,12 +1327,21 @@ int hibernate_preallocate_memory(void)
 	 */
 	if (size >= saveable) {
 		pages = preallocate_image_highmem(save_highmem);
-		pages += preallocate_image_memory(saveable - pages);
+		pages += preallocate_image_memory(saveable - pages, avail_normal);
 		goto out;
 	}
 
 	/* Estimate the minimum size of the image. */
 	pages = minimum_image_size(saveable);
+	/*
+	 * To avoid excessive pressure on the normal zone, leave room in it to
+	 * accommodate an image of the minimum size (unless it's already too
+	 * small, in which case don't preallocate pages from it at all).
+	 */
+	if (avail_normal > pages)
+		avail_normal -= pages;
+	else
+		avail_normal = 0;
 	if (size < pages)
 		size = min_t(unsigned long, pages, max_size);
 
@@ -1335,16 +1362,34 @@ int hibernate_preallocate_memory(void)
 	 */
 	pages_highmem = preallocate_image_highmem(highmem / 2);
 	alloc = (count - max_size) - pages_highmem;
-	pages = preallocate_image_memory(alloc);
-	if (pages < alloc)
-		goto err_out;
-	size = max_size - size;
-	alloc = size;
-	size = preallocate_highmem_fraction(size, highmem, count);
-	pages_highmem += size;
-	alloc -= size;
-	pages += preallocate_image_memory(alloc);
-	pages += pages_highmem;
+	pages = preallocate_image_memory(alloc, avail_normal);
+	if (pages < alloc) {
+		/* We have exhausted non-highmem pages, try highmem. */
+		alloc -= pages;
+		pages += pages_highmem;
+		pages_highmem = preallocate_image_highmem(alloc);
+		if (pages_highmem < alloc)
+			goto err_out;
+		pages += pages_highmem;
+		/*
+		 * size is the desired number of saveable pages to leave in
+		 * memory, so try to preallocate (all memory - size) pages.
+		 */
+		alloc = (count - pages) - size;
+		pages += preallocate_image_highmem(alloc);
+	} else {
+		/*
+		 * There are approximately max_size saveable pages at this point
+		 * and we want to reduce this number down to size.
+		 */
+		alloc = max_size - size;
+		size = preallocate_highmem_fraction(alloc, highmem, count);
+		pages_highmem += size;
+		alloc -= size;
+		size = preallocate_image_memory(alloc, avail_normal);
+		pages_highmem += preallocate_image_highmem(alloc - size);
+		pages += pages_highmem + size;
+	}
 
 	/*
 	 * We only need as many page frames for the image as there are saveable
-- 
1.7.9.6

