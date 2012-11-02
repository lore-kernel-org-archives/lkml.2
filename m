Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287Ab2KBQdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:33:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760176Ab2KBQdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:33:43 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Tony Luck <tony.luck@intel.com>, Andi Kleen <andi.kleen@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2 v2] mm: print out information of file affected by memory error
Date: Fri,  2 Nov 2012 12:33:13 -0400
Message-Id: <1351873993-9373-3-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1351873993-9373-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1351873993-9373-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Printing out the information about which file can be affected by a
memory error in generic_error_remove_page() is helpful for user to
estimate the impact of the error.

Changelog v2:
  - dereference mapping->host after if (!mapping) check for robustness

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Jan Kara <jack@suse.cz>
---
 mm/truncate.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git v3.7-rc3.orig/mm/truncate.c v3.7-rc3/mm/truncate.c
index d51ce92..db1b216 100644
--- v3.7-rc3.orig/mm/truncate.c
+++ v3.7-rc3/mm/truncate.c
@@ -151,14 +151,20 @@ int truncate_inode_page(struct address_space *mapping, struct page *page)
  */
 int generic_error_remove_page(struct address_space *mapping, struct page *page)
 {
+	struct inode *inode;
+
 	if (!mapping)
 		return -EINVAL;
+	inode = mapping->host;
 	/*
 	 * Only punch for normal data pages for now.
 	 * Handling other types like directories would need more auditing.
 	 */
-	if (!S_ISREG(mapping->host->i_mode))
+	if (!S_ISREG(inode->i_mode))
 		return -EIO;
+	pr_info("MCE %#lx: file info pgoff:%lu, inode:%lu, dev:%s\n",
+		page_to_pfn(page), page_index(page),
+		inode->i_ino, inode->i_sb->s_id);
 	return truncate_inode_page(mapping, page);
 }
 EXPORT_SYMBOL(generic_error_remove_page);
-- 
1.7.11.7

