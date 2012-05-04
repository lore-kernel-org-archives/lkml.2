Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab2EDVIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:08:48 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:45099 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507Ab2EDUqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:46:46 -0400
Message-Id: <20120504204229.068408039@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Bojan Smojver <bojan@rexursive.com>,
        "Rafael J. Wysocki" <rjw@suse.de>
Subject: [ 55/75] PM / Hibernate: fix the number of pages used for hibernate/thaw buffering
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bojan Smojver <bojan@rexursive.com>

commit f8262d476823a7ea1eb497ff9676d1eab2393c75 upstream.

Hibernation regression fix, since 3.2.

Calculate the number of required free pages based on non-high memory
pages only, because that is where the buffers will come from.

Commit 081a9d043c983f161b78fdc4671324d1342b86bc introduced a new buffer
page allocation logic during hibernation, in order to improve the
performance. The amount of pages allocated was calculated based on total
amount of pages available, although only non-high memory pages are
usable for this purpose. This caused hibernation code to attempt to over
allocate pages on platforms that have high memory, which led to hangs.

Signed-off-by: Bojan Smojver <bojan@rexursive.com>
Signed-off-by: Rafael J. Wysocki <rjw@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/power/swap.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -51,6 +51,23 @@
 
 #define MAP_PAGE_ENTRIES	(PAGE_SIZE / sizeof(sector_t) - 1)
 
+/*
+ * Number of free pages that are not high.
+ */
+static inline unsigned long low_free_pages(void)
+{
+	return nr_free_pages() - nr_free_highpages();
+}
+
+/*
+ * Number of pages required to be kept free while writing the image. Always
+ * half of all available low pages before the writing starts.
+ */
+static inline unsigned long reqd_free_pages(void)
+{
+	return low_free_pages() / 2;
+}
+
 struct swap_map_page {
 	sector_t entries[MAP_PAGE_ENTRIES];
 	sector_t next_swap;
@@ -72,7 +89,7 @@ struct swap_map_handle {
 	sector_t cur_swap;
 	sector_t first_sector;
 	unsigned int k;
-	unsigned long nr_free_pages, written;
+	unsigned long reqd_free_pages;
 	u32 crc32;
 };
 
@@ -316,8 +333,7 @@ static int get_swap_writer(struct swap_m
 		goto err_rel;
 	}
 	handle->k = 0;
-	handle->nr_free_pages = nr_free_pages() >> 1;
-	handle->written = 0;
+	handle->reqd_free_pages = reqd_free_pages();
 	handle->first_sector = handle->cur_swap;
 	return 0;
 err_rel:
@@ -352,11 +368,11 @@ static int swap_write_page(struct swap_m
 		handle->cur_swap = offset;
 		handle->k = 0;
 	}
-	if (bio_chain && ++handle->written > handle->nr_free_pages) {
+	if (bio_chain && low_free_pages() <= handle->reqd_free_pages) {
 		error = hib_wait_on_bio_chain(bio_chain);
 		if (error)
 			goto out;
-		handle->written = 0;
+		handle->reqd_free_pages = reqd_free_pages();
 	}
  out:
 	return error;
@@ -618,7 +634,7 @@ static int save_image_lzo(struct swap_ma
 	 * Adjust number of free pages after all allocations have been done.
 	 * We don't want to run out of pages when writing.
 	 */
-	handle->nr_free_pages = nr_free_pages() >> 1;
+	handle->reqd_free_pages = reqd_free_pages();
 
 	/*
 	 * Start the CRC32 thread.


