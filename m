Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614Ab2JJXDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:03:17 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57955 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757656Ab2JJXDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:03:09 -0400
X-Sasl-enc: tHdauEQLBEkHzkPnOwwxc+cXIO5kOImjdnRU4v3cxrtv 1349910188
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Michal Hocko <mhocko@suse.cz>, Hillf Danton <dhillf@gmail.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 060/122] hugetlb: do not use vma_hugecache_offset() for vma_prio_tree_foreach
Date: Thu, 11 Oct 2012 07:53:46 +0900
Message-Id: <20121010225348.888774594@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Hocko <mhocko@suse.cz>

commit 36e4f20af833d1ce196e6a4ade05dc26c44652d1 upstream.

Commit 0c176d52b0b2 ("mm: hugetlb: fix pgoff computation when unmapping
page from vma") fixed pgoff calculation but it has replaced it by
vma_hugecache_offset() which is not approapriate for offsets used for
vma_prio_tree_foreach() because that one expects index in page units
rather than in huge_page_shift.

Johannes said:

: The resulting index may not be too big, but it can be too small: assume
: hpage size of 2M and the address to unmap to be 0x200000.  This is regular
: page index 512 and hpage index 1.  If you have a VMA that maps the file
: only starting at the second huge page, that VMAs vm_pgoff will be 512 but
: you ask for offset 1 and miss it even though it does map the page of
: interest.  hugetlb_cow() will try to unmap, miss the vma, and retry the
: cow until the allocation succeeds or the skipped vma(s) go away.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Hillf Danton <dhillf@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/hugetlb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2481,7 +2481,8 @@ static int unmap_ref_private(struct mm_s
 	 * from page cache lookup which is in HPAGE_SIZE units.
 	 */
 	address = address & huge_page_mask(h);
-	pgoff = vma_hugecache_offset(h, vma, address);
+	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) +
+			vma->vm_pgoff;
 	mapping = vma->vm_file->f_dentry->d_inode->i_mapping;
 
 	/*


