Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828Ab0I0Foe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 01:44:34 -0400
Received: from crca.org.au ([74.207.252.120]:42757 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756668Ab0I0Fo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 01:44:29 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 15/23] Hibernation: Use block extents for reading image
Date: Mon, 27 Sep 2010 15:43:50 +1000
Message-Id: <1285566238-10966-16-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
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
index 89601d3..f2bc044 100644
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

