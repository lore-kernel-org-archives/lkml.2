Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab2DPQXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:23:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40905 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab2DPQOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:14:21 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dchinner@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 07/27] mm: Update file times from fault path only if .page_mkwrite is not set
Date: Mon, 16 Apr 2012 18:13:45 +0200
Message-Id: <1334592845-22862-8-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1334592845-22862-1-git-send-email-jack@suse.cz>
References: <1334592845-22862-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Filesystems wanting to properly support freezing need to have control
when file_update_time() is called. After pushing file_update_time()
to all relevant .page_mkwrite implementations we can just stop calling
file_update_time() when filesystem implements .page_mkwrite.

Tested-by: Kamal Mostafa <kamal@canonical.com>
Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
Tested-by: Dann Frazier <dann.frazier@canonical.com>
Tested-by: Massimo Morana <massimo.morana@canonical.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/memory.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 6105f47..4803e47 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2633,6 +2633,9 @@ reuse:
 		if (!page_mkwrite) {
 			wait_on_page_locked(dirty_page);
 			set_page_dirty_balance(dirty_page, page_mkwrite);
+			/* file_update_time outside page_lock */
+			if (vma->vm_file)
+				file_update_time(vma->vm_file);
 		}
 		put_page(dirty_page);
 		if (page_mkwrite) {
@@ -2650,10 +2653,6 @@ reuse:
 			}
 		}
 
-		/* file_update_time outside page_lock */
-		if (vma->vm_file)
-			file_update_time(vma->vm_file);
-
 		return ret;
 	}
 
@@ -3322,12 +3321,13 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	if (dirty_page) {
 		struct address_space *mapping = page->mapping;
+		int dirtied = 0;
 
 		if (set_page_dirty(dirty_page))
-			page_mkwrite = 1;
+			dirtied = 1;
 		unlock_page(dirty_page);
 		put_page(dirty_page);
-		if (page_mkwrite && mapping) {
+		if ((dirtied || page_mkwrite) && mapping) {
 			/*
 			 * Some device drivers do not set page.mapping but still
 			 * dirty their pages
@@ -3336,7 +3336,7 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		}
 
 		/* file_update_time outside page_lock */
-		if (vma->vm_file)
+		if (vma->vm_file && !page_mkwrite)
 			file_update_time(vma->vm_file);
 	} else {
 		unlock_page(vmf.page);
-- 
1.7.1

