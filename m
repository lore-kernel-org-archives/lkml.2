Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359Ab2CDFR1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 00:17:27 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36356 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2CDFR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 00:17:26 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dhillf@gmail.com designates 10.52.23.199 as permitted sender) smtp.mail=dhillf@gmail.com; dkim=pass header.i=dhillf@gmail.com
MIME-Version: 1.0
Date: Sun, 4 Mar 2012 13:17:25 +0800
Message-ID: <CAJd=RBBYdY1rgoW+0bgKh6Cn8n=guB2_zq2nzaMr8-arqNkr_A@mail.gmail.com>
Subject: [PATCH] mm: shmem: unlock valid page
From: Hillf Danton <dhillf@gmail.com>
To: Linux-MM <linux-mm@kvack.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In shmem_read_mapping_page_gfp() page is unlocked if no error returned,
so the unlocked page has to valid.

To guarantee that validity, when getting page, success result is feed
back to caller only when page is valid.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/shmem.c	Sun Mar  4 12:17:42 2012
+++ b/mm/shmem.c	Sun Mar  4 12:26:56 2012
@@ -889,13 +889,13 @@ repeat:
 		goto failed;
 	}

-	if (page || (sgp == SGP_READ && !swap.val)) {
+	if (page) {
 		/*
 		 * Once we can get the page lock, it must be uptodate:
 		 * if there were an error in reading back from swap,
 		 * the page would not be inserted into the filecache.
 		 */
-		BUG_ON(page && !PageUptodate(page));
+		BUG_ON(!PageUptodate(page));
 		*pagep = page;
 		return 0;
 	}
--
