Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab1CEQur (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 11:50:47 -0500
Received: from smtp-03.mandic.com.br ([200.225.81.143]:54430 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab1CEQtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 11:49:21 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCHv2 20/24] sys_swapon: simplify error flow in setup_swap_map_and_extents
Date: Sat,  5 Mar 2011 13:42:21 -0300
Message-Id: <1299343345-3984-21-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there is no cleanup to do, there is no reason to jump to a label.
Return directly instead.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
---
 mm/swapfile.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 26eb84a..5f6df81 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1998,7 +1998,6 @@ static int setup_swap_map_and_extents(struct swap_info_struct *p,
 					sector_t *span)
 {
 	int i;
-	int error;
 	unsigned int nr_good_pages;
 	int nr_extents;
 
@@ -2006,10 +2005,8 @@ static int setup_swap_map_and_extents(struct swap_info_struct *p,
 
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
 		unsigned int page_nr = swap_header->info.badpages[i];
-		if (page_nr == 0 || page_nr > swap_header->info.last_page) {
-			error = -EINVAL;
-			goto bad_swap;
-		}
+		if (page_nr == 0 || page_nr > swap_header->info.last_page)
+			return -EINVAL;
 		if (page_nr < maxpages) {
 			swap_map[page_nr] = SWAP_MAP_BAD;
 			nr_good_pages--;
@@ -2021,22 +2018,16 @@ static int setup_swap_map_and_extents(struct swap_info_struct *p,
 		p->max = maxpages;
 		p->pages = nr_good_pages;
 		nr_extents = setup_swap_extents(p, span);
-		if (nr_extents < 0) {
-			error = nr_extents;
-			goto bad_swap;
-		}
+		if (nr_extents < 0)
+			return nr_extents;
 		nr_good_pages = p->pages;
 	}
 	if (!nr_good_pages) {
 		printk(KERN_WARNING "Empty swap-file\n");
-		error = -EINVAL;
-		goto bad_swap;
+		return -EINVAL;
 	}
 
 	return nr_extents;
-
-bad_swap:
-	return error;
 }
 
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
-- 
1.7.4

