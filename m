Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab0FBMWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:22:20 -0400
Received: from crca.org.au ([74.207.252.120]:36991 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757969Ab0FBMU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:20:29 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 14/21] Hibernation: Use block extents for reading image
Date: Wed,  2 Jun 2010 22:19:13 +1000
Message-Id: <1275481160-31150-15-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275481160-31150-1-git-send-email-nigel@tuxonice.net>
References: <1275481160-31150-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch from using swap map pages to using block extents for
knowing where the next page needs to be read from.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/block_io.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
index 7fabb0c..6745e77 100644
--- a/kernel/power/block_io.c
+++ b/kernel/power/block_io.c
@@ -332,7 +332,7 @@ int swap_read_page(void *buf, int sync)
 
 	if (!handle.cur)
 		return -EINVAL;
-	offset = handle.cur->entries[handle.k];
+	offset = hib_extent_next(&sector_extents);
 	if (!offset)
 		return -EFAULT;
 	error = hib_bio_read_page(offset, buf, sync);
@@ -341,7 +341,7 @@ int swap_read_page(void *buf, int sync)
 	if (++handle.k >= MAP_PAGE_ENTRIES) {
 		error = hib_wait_on_bio_chain();
 		handle.k = 0;
-		offset = handle.cur->next_swap;
+		offset = hib_extent_next(&sector_extents);
 		if (!offset)
 			release_swap_reader();
 		else if (!error)
-- 
1.7.0.4

