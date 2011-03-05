Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab1CEQuu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 11:50:50 -0500
Received: from smtp-03.mandic.com.br ([200.225.81.143]:37423 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab1CEQtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 11:49:21 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCHv2 19/24] sys_swapon: separate parsing of bad blocks and extents
Date: Sat,  5 Mar 2011 13:42:20 -0300
Message-Id: <1299343345-3984-20-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the code which parses the bad block list and the extents to a
separate function. Only code movement, no functional changes.

This change uses the fact that, after the success path, nr_good_pages ==
p->pages.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
---
 mm/swapfile.c |   83 +++++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 54 insertions(+), 29 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 7ac81fe..26eb84a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1991,6 +1991,54 @@ static unsigned long read_swap_header(struct swap_info_struct *p,
 	return maxpages;
 }
 
+static int setup_swap_map_and_extents(struct swap_info_struct *p,
+					union swap_header *swap_header,
+					unsigned char *swap_map,
+					unsigned long maxpages,
+					sector_t *span)
+{
+	int i;
+	int error;
+	unsigned int nr_good_pages;
+	int nr_extents;
+
+	nr_good_pages = maxpages - 1;	/* omit header page */
+
+	for (i = 0; i < swap_header->info.nr_badpages; i++) {
+		unsigned int page_nr = swap_header->info.badpages[i];
+		if (page_nr == 0 || page_nr > swap_header->info.last_page) {
+			error = -EINVAL;
+			goto bad_swap;
+		}
+		if (page_nr < maxpages) {
+			swap_map[page_nr] = SWAP_MAP_BAD;
+			nr_good_pages--;
+		}
+	}
+
+	if (nr_good_pages) {
+		swap_map[0] = SWAP_MAP_BAD;
+		p->max = maxpages;
+		p->pages = nr_good_pages;
+		nr_extents = setup_swap_extents(p, span);
+		if (nr_extents < 0) {
+			error = nr_extents;
+			goto bad_swap;
+		}
+		nr_good_pages = p->pages;
+	}
+	if (!nr_good_pages) {
+		printk(KERN_WARNING "Empty swap-file\n");
+		error = -EINVAL;
+		goto bad_swap;
+	}
+
+	return nr_extents;
+
+bad_swap:
+	return error;
+}
+
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 {
 	struct swap_info_struct *p;
@@ -2001,7 +2049,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	int error;
 	union swap_header *swap_header;
 	unsigned int nr_good_pages;
-	int nr_extents = 0;
+	int nr_extents;
 	sector_t span;
 	unsigned long maxpages;
 	unsigned char *swap_map = NULL;
@@ -2078,36 +2126,13 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (error)
 		goto bad_swap;
 
-	nr_good_pages = maxpages - 1;	/* omit header page */
-
-	for (i = 0; i < swap_header->info.nr_badpages; i++) {
-		unsigned int page_nr = swap_header->info.badpages[i];
-		if (page_nr == 0 || page_nr > swap_header->info.last_page) {
-			error = -EINVAL;
-			goto bad_swap;
-		}
-		if (page_nr < maxpages) {
-			swap_map[page_nr] = SWAP_MAP_BAD;
-			nr_good_pages--;
-		}
-	}
-
-	if (nr_good_pages) {
-		swap_map[0] = SWAP_MAP_BAD;
-		p->max = maxpages;
-		p->pages = nr_good_pages;
-		nr_extents = setup_swap_extents(p, &span);
-		if (nr_extents < 0) {
-			error = nr_extents;
-			goto bad_swap;
-		}
-		nr_good_pages = p->pages;
-	}
-	if (!nr_good_pages) {
-		printk(KERN_WARNING "Empty swap-file\n");
-		error = -EINVAL;
+	nr_extents = setup_swap_map_and_extents(p, swap_header, swap_map,
+		maxpages, &span);
+	if (unlikely(nr_extents < 0)) {
+		error = nr_extents;
 		goto bad_swap;
 	}
+	nr_good_pages = p->pages;
 
 	if (p->bdev) {
 		if (blk_queue_nonrot(bdev_get_queue(p->bdev))) {
-- 
1.7.4

