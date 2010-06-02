Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab0FBMVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:21:49 -0400
Received: from crca.org.au ([74.207.252.120]:53615 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932355Ab0FBMUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:20:48 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 18/21] Hibernation: Remove wait_on_bio_chain result
Date: Wed,  2 Jun 2010 22:19:17 +1000
Message-Id: <1275481160-31150-19-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275481160-31150-1-git-send-email-nigel@tuxonice.net>
References: <1275481160-31150-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wait_on_bio_chain can't fail - make the result void instead
of int.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/block_io.c |    6 +++---
 kernel/power/block_io.h |    2 +-
 kernel/power/power.h    |    2 +-
 kernel/power/swap.c     |   14 +++-----------
 4 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
index 66cdc5a..c71c7c3 100644
--- a/kernel/power/block_io.c
+++ b/kernel/power/block_io.c
@@ -121,10 +121,9 @@ int hib_bio_write_page(pgoff_t page_off, void *addr, int sync)
 			virt_to_page(addr), sync);
 }
 
-int hib_wait_on_bio_chain(void)
+void hib_wait_on_bio_chain(void)
 {
 	wait_event(num_in_progress_wait, !atomic_read(&hib_io_in_progress));
-	return 0;
 }
 
 /*
@@ -253,7 +252,8 @@ int swap_write_page(void *buf, int sync)
 
 int flush_swap_writer(void)
 {
-	return hib_wait_on_bio_chain();
+	hib_wait_on_bio_chain();
+	return 0;
 }
 
 /**
diff --git a/kernel/power/block_io.h b/kernel/power/block_io.h
index ac378c5..1482060 100644
--- a/kernel/power/block_io.h
+++ b/kernel/power/block_io.h
@@ -9,7 +9,7 @@
 /* Low level routines */
 int hib_bio_read_page(pgoff_t page_off, void *addr, int sync);
 int hib_bio_write_page(pgoff_t page_off, void *addr, int sync);
-int hib_wait_on_bio_chain(void);
+void hib_wait_on_bio_chain(void);
 
 unsigned int hib_bio_overhead(unsigned int nr_pages);
 sector_t hib_get_first_sector(void);
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 9a046cd..4c21388 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -147,7 +147,7 @@ extern struct block_device *hib_resume_bdev;
 
 extern int hib_bio_read_page(pgoff_t page_off, void *addr, int sync);
 extern int hib_bio_write_page(pgoff_t page_off, void *addr, int sync);
-extern int hib_wait_on_bio_chain(void);
+extern void hib_wait_on_bio_chain(void);
 
 struct timeval;
 /* kernel/power/swsusp.c */
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index b4ab6a2..e477310 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -236,7 +236,6 @@ static int save_image(struct snapshot_handle *snapshot,
 	unsigned int m;
 	int ret;
 	int nr_pages;
-	int err2;
 	struct timeval start;
 	struct timeval stop;
 
@@ -258,11 +257,9 @@ static int save_image(struct snapshot_handle *snapshot,
 			printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
 		nr_pages++;
 	}
-	err2 = hib_wait_on_bio_chain();
+	hib_wait_on_bio_chain();
 	do_gettimeofday(&stop);
 	if (!ret)
-		ret = err2;
-	if (!ret)
 		printk(KERN_CONT "\b\b\b\bdone\n");
 	else
 		printk(KERN_CONT "\n");
@@ -329,7 +326,6 @@ static int load_image(struct snapshot_handle *snapshot, unsigned int nr_to_read)
 	int error = 0;
 	struct timeval start;
 	struct timeval stop;
-	int err2;
 	unsigned nr_pages;
 
 	printk(KERN_INFO "PM: Loading image data pages (%u pages) ...     ",
@@ -347,17 +343,13 @@ static int load_image(struct snapshot_handle *snapshot, unsigned int nr_to_read)
 		if (error)
 			break;
 		if (snapshot->sync_read)
-			error = hib_wait_on_bio_chain();
-		if (error)
-			break;
+			hib_wait_on_bio_chain();
 		if (!(nr_pages % m))
 			printk("\b\b\b\b%3d%%", nr_pages / m);
 		nr_pages++;
 	}
-	err2 = hib_wait_on_bio_chain();
+	hib_wait_on_bio_chain();
 	do_gettimeofday(&stop);
-	if (!error)
-		error = err2;
 	if (!error) {
 		printk("\b\b\b\bdone\n");
 		snapshot_write_finalize(snapshot);
-- 
1.7.0.4

