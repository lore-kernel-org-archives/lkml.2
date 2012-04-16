Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab2DPQWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:22:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40918 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab2DPQOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:14:22 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dchinner@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 08/27] mm: Make default vm_ops provide ->page_mkwrite handler
Date: Mon, 16 Apr 2012 18:13:46 +0200
Message-Id: <1334592845-22862-9-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1334592845-22862-1-git-send-email-jack@suse.cz>
References: <1334592845-22862-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make default vm_ops provide ->page_mkwrite handler. Currently it only updates
file's modification times and gets locked page but later it will also handle
filesystem freezing.

BugLink: https://bugs.launchpad.net/bugs/897421
Tested-by: Kamal Mostafa <kamal@canonical.com>
Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
Tested-by: Dann Frazier <dann.frazier@canonical.com>
Tested-by: Massimo Morana <massimo.morana@canonical.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/mm.h |    1 +
 mm/filemap.c       |   19 +++++++++++++++++++
 mm/filemap_xip.c   |    1 +
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d8738a4..9bec077 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1424,6 +1424,7 @@ extern void truncate_inode_pages_range(struct address_space *,
 
 /* generic vm_area_ops exported for stackable file systems */
 extern int filemap_fault(struct vm_area_struct *, struct vm_fault *);
+extern int filemap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 
 /* mm/page-writeback.c */
 int write_one_page(struct page *page, int wait);
diff --git a/mm/filemap.c b/mm/filemap.c
index 79c4b2b..aec7356 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1751,8 +1751,27 @@ page_not_uptodate:
 }
 EXPORT_SYMBOL(filemap_fault);
 
+int filemap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct page *page = vmf->page;
+	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
+	int ret = VM_FAULT_LOCKED;
+
+	file_update_time(vma->vm_file);
+	lock_page(page);
+	if (page->mapping != inode->i_mapping) {
+		unlock_page(page);
+		ret = VM_FAULT_NOPAGE;
+		goto out;
+	}
+out:
+	return ret;
+}
+EXPORT_SYMBOL(filemap_page_mkwrite);
+
 const struct vm_operations_struct generic_file_vm_ops = {
 	.fault		= filemap_fault,
+	.page_mkwrite	= filemap_page_mkwrite,
 };
 
 /* This is used for a general mmap of a disk file */
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index a4eb311..591dba6 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -304,6 +304,7 @@ out:
 
 static const struct vm_operations_struct xip_file_vm_ops = {
 	.fault	= xip_file_fault,
+	.page_mkwrite	= filemap_page_mkwrite,
 };
 
 int xip_file_mmap(struct file * file, struct vm_area_struct * vma)
-- 
1.7.1

