Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0LQRN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 12:13:59 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:57880 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746Ab0LQRN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 12:13:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qrf1ffPafI5ytsRzS8MNhoTn4pB5oN1YJ5WcPNrgD/6HmAV+44TR65IkJTiZVnFz48
         0qRse8LglVlc1M+S5wmV801DhFbVOY9GdA97EjLIFjN5cyU4GOapXqbzNCygHDkk8nEC
         XQn3fgLNUrEsEtCujeK3XfPdx2hojzCvL+fIw=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>
Subject: [RFC 1/5] drop page reference on remove_from_page_cache
Date: Sat, 18 Dec 2010 02:13:36 +0900
Message-Id: <4bd059fc4f45fba7ed29a9f4325deb4f437d39f3.1292604745.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1292604745.git.minchan.kim@gmail.com>
References: <cover.1292604745.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1292604745.git.minchan.kim@gmail.com>
References: <cover.1292604745.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we add page reference on add_to_page_cache but doesn't drop it
in remove_from_page_cache. Such asymmetric makes confusing about
page reference so that caller should notice it and comment why they
release page reference. It's not good API.

Long time ago, Hugh tried it[1] but gave up of reason which
reiser4's drop_page had to unlock the page between removing it from
page cache and doing the page_cache_release. But now the situation is
changed. I think at least things in current mainline doesn't have any
obstacles. The problem is fs or somethings out of mainline.
If it has done such thing like reiser4, this patch could be a problem.

Do anyone know the such things? Do we care about things out of mainline?

Note :
The comment of remove_from_page_cache make by copy & paste & s/swap/page/
from delete_from_swap_cache.

[1] http://lkml.org/lkml/2004/10/24/140

Cc: Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/filemap.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 095c393..fb9db36 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -148,6 +148,16 @@ void __remove_from_page_cache(struct page *page)
 	}
 }
 
+/**
+ * remove_from_page_cache - remove page from page cache
+ *
+ * @page: the page which the kernel is trying to remove from page cache
+ *
+ * This must be called only on pages that have
+ * been verified to be in the page cache and locked.
+ * It will never put the page into the free list,
+ * the caller has a reference on the page.
+ */
 void remove_from_page_cache(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
@@ -163,6 +173,8 @@ void remove_from_page_cache(struct page *page)
 
 	if (freepage)
 		freepage(page);
+
+	page_cache_release(page);
 }
 EXPORT_SYMBOL(remove_from_page_cache);
 
-- 
1.7.0.4

