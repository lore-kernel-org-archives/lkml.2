Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab2DVW34 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 18:29:56 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:51398 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab2DVW3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 18:29:55 -0400
Message-ID: <1335133792.2187.8.camel@shrek.rexursive.com>
Subject: Re: [PATCH v11]: Hibernation: fix the number of pages used for
 hibernate/thaw buffering
From: Bojan Smojver <bojan@rexursive.com>
To: Per Olofsson <pelle@debian.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Date: Mon, 23 Apr 2012 08:29:52 +1000
In-Reply-To: <4F946B86.4000509@debian.org>
References: <1334267969.2573.14.camel@shrek.rexursive.com>
	 <201204221347.52883.rjw@sisk.pl>
	 <22aaaccf-5898-460c-b1e4-a87c153d9e0c@email.android.com>
	 <201204222229.47160.rjw@sisk.pl> <4F946B86.4000509@debian.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-22 at 22:35 +0200, Per Olofsson wrote:
> It is also possible to create a much smaller patch which only
> subtracts the high pages and nothing else.

For instance:
---------------------------------------
Hibernation regression fix, since 3.2:

Calculate the number of required free pages based on non-high memory
pages only, because that is where the buffers will come from.

Signed-off-by: Bojan Smojver <bojan@rexursive.com>
---
 kernel/power/swap.c |   33 +++++++++++++++++++++++++--------
 1 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 8742fd0..fdf834f 100644
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
 
@@ -316,8 +333,7 @@ static int get_swap_writer(struct swap_map_handle *handle)
 		goto err_rel;
 	}
 	handle->k = 0;
-	handle->nr_free_pages = nr_free_pages() >> 1;
-	handle->written = 0;
+	handle->reqd_free_pages = reqd_free_pages();
 	handle->first_sector = handle->cur_swap;
 	return 0;
 err_rel:
@@ -352,11 +368,11 @@ static int swap_write_page(struct swap_map_handle *handle, void *buf,
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
@@ -618,7 +634,7 @@ static int save_image_lzo(struct swap_map_handle *handle,
 	 * Adjust number of free pages after all allocations have been done.
 	 * We don't want to run out of pages when writing.
 	 */
-	handle->nr_free_pages = nr_free_pages() >> 1;
+	handle->reqd_free_pages = reqd_free_pages();
 
 	/*
 	 * Start the CRC32 thread.
---------------------------------------

-- 
Bojan

