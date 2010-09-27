Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457Ab0I0Fok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 01:44:40 -0400
Received: from crca.org.au ([74.207.252.120]:34142 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758088Ab0I0Foh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 01:44:37 -0400
X-Bogosity: Ham, spamicity=0.000001
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 20/23] Hibernation: Prepare for handle.cur removal
Date: Mon, 27 Sep 2010 15:43:55 +1000
Message-Id: <1285566238-10966-21-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for the removal of handle.cur by stopping using
it in get_swap_reader.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/block_io.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
index c154a92..4f46878 100644
--- a/kernel/power/block_io.c
+++ b/kernel/power/block_io.c
@@ -276,29 +276,29 @@ int get_swap_reader(unsigned int *flags_p, sector_t first_page)
 	if (!handle.cur)
 		return -ENOMEM;
 
-	error = hib_bio_read_page(first_page, handle.cur, 1);
+	error = hib_prepare_buffer();
 	if (error) {
 		release_swap_reader();
 		return error;
 	}
 
-	error = hib_prepare_buffer();
+	/* Bootstrap reading the extents */
+	error = hib_bio_read_page(first_page, hib_ppio_buffer, 1);
 	if (error) {
 		release_swap_reader();
+		hib_free_buffer();
 		return error;
 	}
 
 	handle.k = 0;
 
-	/* Bootstrap reading the extents */
-	memcpy(hib_ppio_buffer, handle.cur, PAGE_SIZE);
 	error = hib_extents_load(&sector_extents, 1);
 
 	if (error) {
 		release_swap_reader();
-		return error;
 	}
 
+	hib_free_buffer();
 	return error;
 }
 
-- 
1.7.0.4

