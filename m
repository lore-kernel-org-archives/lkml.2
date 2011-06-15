Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab1FPHAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:00:43 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:47977 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755435Ab1FPHAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:37 -0400
X-Sasl-enc: GFi9cw/xUbjCR20tTVdt07F1aVGvpcgogDK36p4nRNBS 1308207636
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:31 2011
Message-Id: <20110616000231.433209528@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [25/89] mm: fix ENOSPC returned by handle_mm_fault()
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hughd@google.com>

commit e0dcd8a05be438b3d2e49ef61441ea3a463663f8 upstream.

Al Viro observes that in the hugetlb case, handle_mm_fault() may return
a value of the kind ENOSPC when its caller is expecting a value of the
kind VM_FAULT_SIGBUS: fix alloc_huge_page()'s failure returns.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1033,10 +1033,10 @@ static struct page *alloc_huge_page(stru
 	 */
 	chg = vma_needs_reservation(h, vma, addr);
 	if (chg < 0)
-		return ERR_PTR(chg);
+		return ERR_PTR(-VM_FAULT_OOM);
 	if (chg)
 		if (hugetlb_get_quota(inode->i_mapping, chg))
-			return ERR_PTR(-ENOSPC);
+			return ERR_PTR(-VM_FAULT_SIGBUS);
 
 	spin_lock(&hugetlb_lock);
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);


