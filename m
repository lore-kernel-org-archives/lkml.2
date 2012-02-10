Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab2BJTm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:42:28 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61948 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab2BJTmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:42:25 -0500
Subject: [PATCH 1/4] shmem: simlify shmem_unlock_mapping
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 10 Feb 2012 23:42:22 +0400
Message-ID: <20120210194222.6492.97744.stgit@zurg>
In-Reply-To: <20120210193249.6492.18768.stgit@zurg>
References: <20120210193249.6492.18768.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_get_pages() now can skip unlimited count of exeptional entries,
so shmem_find_get_pages_and_swap() does not required there any more.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/shmem.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 269d049..4af8e85 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -397,7 +397,6 @@ static void shmem_deswap_pagevec(struct pagevec *pvec)
 void shmem_unlock_mapping(struct address_space *mapping)
 {
 	struct pagevec pvec;
-	pgoff_t indices[PAGEVEC_SIZE];
 	pgoff_t index = 0;
 
 	pagevec_init(&pvec, 0);
@@ -405,16 +404,9 @@ void shmem_unlock_mapping(struct address_space *mapping)
 	 * Minor point, but we might as well stop if someone else SHM_LOCKs it.
 	 */
 	while (!mapping_unevictable(mapping)) {
-		/*
-		 * Avoid pagevec_lookup(): find_get_pages() returns 0 as if it
-		 * has finished, if it hits a row of PAGEVEC_SIZE swap entries.
-		 */
-		pvec.nr = shmem_find_get_pages_and_swap(mapping, index,
-					PAGEVEC_SIZE, pvec.pages, indices);
-		if (!pvec.nr)
+		if (!pagevec_lookup(&pvec, mapping, index, PAGEVEC_SIZE))
 			break;
-		index = indices[pvec.nr - 1] + 1;
-		shmem_deswap_pagevec(&pvec);
+		index = pvec.pages[pvec.nr - 1]->index + 1;
 		check_move_unevictable_pages(pvec.pages, pvec.nr);
 		pagevec_release(&pvec);
 		cond_resched();

