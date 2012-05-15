Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965810Ab2EOCvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:51:31 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53393 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964872Ab2EOCRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 098/179] PM / Hibernate: Fix free_unnecessary_pages()
Date: Mon, 14 May 2012 22:13:14 -0400
Message-ID: <1337048075-6132-99-git-send-email-paul.gortmaker@windriver.com>
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

commit 4d4cf23cdde2f8f9324f5684a7f349e182039529 upstream.

There is a bug in free_unnecessary_pages() that causes it to
attempt to free too many pages in some cases, which triggers the
BUG_ON() in memory_bm_clear_bit() for copy_bm.  Namely, if
count_data_pages() is initially greater than alloc_normal, we get
to_free_normal equal to 0 and "save" greater from 0.  In that case,
if the sum of "save" and count_highmem_pages() is greater than
alloc_highmem, we subtract a positive number from to_free_normal.
Hence, since to_free_normal was 0 before the subtraction and is
an unsigned int, the result is converted to a huge positive number
that is used as the number of pages to free.

Fix this bug by checking if to_free_normal is actually greater
than or equal to the number we're going to subtract from it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-and-tested-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/power/snapshot.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index a204467..5e16efe 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1194,7 +1194,11 @@ static void free_unnecessary_pages(void)
 		to_free_highmem = alloc_highmem - save;
 	} else {
 		to_free_highmem = 0;
-		to_free_normal -= save - alloc_highmem;
+		save -= alloc_highmem;
+		if (to_free_normal > save)
+			to_free_normal -= save;
+		else
+			to_free_normal = 0;
 	}
 
 	memory_bm_position_reset(&copy_bm);
-- 
1.7.9.6

