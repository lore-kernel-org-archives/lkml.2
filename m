Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab0I0Fo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 01:44:58 -0400
Received: from crca.org.au ([74.207.252.120]:50863 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758479Ab0I0Fol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 01:44:41 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 22/23] Hibernation: Remove now-empty routines.
Date: Mon, 27 Sep 2010 15:43:57 +1000
Message-Id: <1285566238-10966-23-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

release_swap_writer and release_swap_reader are now empty functions.
Remove them and clean up callers (including swap_reader_finish, which
just called release_swap_reader).

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/block_io.c |   36 ++++--------------------------------
 kernel/power/block_io.h |    2 --
 kernel/power/swap.c     |    9 ---------
 3 files changed, 4 insertions(+), 43 deletions(-)

diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
index f452650..fc2e05d 100644
--- a/kernel/power/block_io.c
+++ b/kernel/power/block_io.c
@@ -172,28 +172,19 @@ static int write_page(void *buf, sector_t offset, int sync)
 	return hib_bio_write_page(offset, src, sync);
 }
 
-void release_swap_writer(void)
-{
-}
-
 int hib_bio_prepare_write(void)
 {
 	int result, result2;
 
 	result = hib_prepare_buffer();
-	if (result) {
-		release_swap_writer();
+	if (result)
 		return result;
-	}
 
 	first_sector = hib_extent_current(&sector_extents);
 
 	result = hib_extents_store(&sector_extents);
 	result2 = hib_flush_write_buffer();
 
-	if (result || result2)
-		release_swap_writer();
-
 	return result ? result : result2;
 }
 
@@ -211,38 +202,19 @@ int flush_swap_writer(void)
 	return 0;
 }
 
-/**
- *	The following functions allow us to read data using a swap map
- *	in a file-alike way
- */
-
-void release_swap_reader(void)
-{
-}
-
 int get_swap_reader(unsigned int *flags_p, sector_t first_page)
 {
 	int error;
 
 	error = hib_prepare_buffer();
-	if (error) {
-		release_swap_reader();
+	if (error)
 		return error;
-	}
 
 	/* Bootstrap reading the extents */
 	error = hib_bio_read_page(first_page, hib_ppio_buffer, 1);
-	if (error) {
-		release_swap_reader();
-		hib_free_buffer();
-		return error;
-	}
 
-	error = hib_extents_load(&sector_extents, 1);
-
-	if (error) {
-		release_swap_reader();
-	}
+	if (!error)
+		error = hib_extents_load(&sector_extents, 1);
 
 	hib_free_buffer();
 	return error;
diff --git a/kernel/power/block_io.h b/kernel/power/block_io.h
index 1482060..228fe58 100644
--- a/kernel/power/block_io.h
+++ b/kernel/power/block_io.h
@@ -14,12 +14,10 @@ void hib_wait_on_bio_chain(void);
 unsigned int hib_bio_overhead(unsigned int nr_pages);
 sector_t hib_get_first_sector(void);
 extern struct hib_extent_state sector_extents;
-void release_swap_writer(void);
 int hib_bio_prepare_write(void);
 int flush_swap_writer(void);
 int swap_write_page(void *buf, int sync);
 int get_swap_reader(unsigned int *flags_p, sector_t first_page);
-void release_swap_reader(void);
 int swap_read_page(void *buf, int sync);
 int hib_flush_write_buffer(void);
 
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 0a9715b..0e94484 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -216,7 +216,6 @@ static int swap_writer_finish(unsigned int flags, int error)
 
 	if (error)
 		free_all_swap_pages(root_swap);
-	release_swap_writer();
 	swsusp_close(FMODE_WRITE);
 
 	return error;
@@ -315,13 +314,6 @@ out_finish:
 	return error;
 }
 
-static int swap_reader_finish(void)
-{
-	release_swap_reader();
-
-	return 0;
-}
-
 /**
  *	load_image - load the image using the swap map handle
  *	@handle and the snapshot handle @snapshot
@@ -408,7 +400,6 @@ int swsusp_read(unsigned int *flags_p)
 		error = swap_read_page(header, 1);
 	if (!error)
 		error = load_image(&snapshot, header->pages - 1, *flags_p);
-	swap_reader_finish();
 end:
 	compress_image_cleanup();
 	if (!error)
-- 
1.7.0.4

