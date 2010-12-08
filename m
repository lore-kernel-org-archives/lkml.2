Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab0LHBjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:39:11 -0500
Received: from kroah.org ([198.145.64.141]:48900 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756854Ab0LHBA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:57 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:32 2010
Message-Id: <20101208005732.780722495@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dean Nelson <dnelson@redhat.com>, Mel Gorman <mel@csn.ul.ie>
Subject: [114/289] mm/hugetlb.c: add missing spin_lock() to hugetlb_cow()
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dean Nelson <dnelson@redhat.com>

commit 44e2aa937e698ea95dd86b2a4fabd734ef2c76db upstream.

Add missing spin_lock() of the page_table_lock before an error return in
hugetlb_cow(). Callers of hugtelb_cow() expect it to be held upon return.

Signed-off-by: Dean Nelson <dnelson@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/hugetlb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2380,8 +2380,11 @@ retry_avoidcopy:
 	 * When the original hugepage is shared one, it does not have
 	 * anon_vma prepared.
 	 */
-	if (unlikely(anon_vma_prepare(vma)))
+	if (unlikely(anon_vma_prepare(vma))) {
+		/* Caller expects lock to be held */
+		spin_lock(&mm->page_table_lock);
 		return VM_FAULT_OOM;
+	}
 
 	copy_huge_page(new_page, old_page, address, vma);
 	__SetPageUptodate(new_page);


