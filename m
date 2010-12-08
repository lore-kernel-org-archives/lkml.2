Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab0LHBRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:17:07 -0500
Received: from kroah.org ([198.145.64.141]:33681 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932687Ab0LHBDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:22 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:44 2010
Message-Id: <20101208005744.244436627@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dean Nelson <dnelson@redhat.com>
Subject: [228/289] mm/hugetlb.c: avoid double unlock_page() in hugetlb_fault()
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dean Nelson <dnelson@redhat.com>

commit 1f64d69c7ad2e48e697493e45590679f7a69b7b2 upstream.

Have hugetlb_fault() call unlock_page(page) only if it had previously
called lock_page(page).

Setting CONFIG_DEBUG_VM=y and then running the libhugetlbfs test suite,
resulted in the tripping of VM_BUG_ON(!PageLocked(page)) in
unlock_page() having been called by hugetlb_fault() when page ==
pagecache_page.  This patch remedied the problem.

Signed-off-by: Dean Nelson <dnelson@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/hugetlb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2668,7 +2668,8 @@ out_page_table_lock:
 		unlock_page(pagecache_page);
 		put_page(pagecache_page);
 	}
-	unlock_page(page);
+	if (page != pagecache_page)
+		unlock_page(page);
 
 out_mutex:
 	mutex_unlock(&hugetlb_instantiation_mutex);


