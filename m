Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965880Ab2EOC5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:57:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:49539 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964866Ab2EOCRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:03 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 077/179] migrate: don't account swapcache as shmem
Date: Mon, 14 May 2012 22:12:53 -0400
Message-ID: <1337048075-6132-78-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 99a15e21d96f6857dafab1e5167e5e8183215c9c upstream.

swapcache will reach the below code path in migrate_page_move_mapping,
and swapcache is accounted as NR_FILE_PAGES but it's not accounted as
NR_SHMEM.

Hugh pointed out we must use PageSwapCache instead of comparing
mapping to &swapper_space, to avoid build failure with CONFIG_SWAP=n.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index d3f3f7f..c8e7195 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -262,7 +262,7 @@ static int migrate_page_move_mapping(struct address_space *mapping,
 	 */
 	__dec_zone_page_state(page, NR_FILE_PAGES);
 	__inc_zone_page_state(newpage, NR_FILE_PAGES);
-	if (PageSwapBacked(page)) {
+	if (!PageSwapCache(page) && PageSwapBacked(page)) {
 		__dec_zone_page_state(page, NR_SHMEM);
 		__inc_zone_page_state(newpage, NR_SHMEM);
 	}
-- 
1.7.9.6

