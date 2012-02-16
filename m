Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab2BPNqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:46:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34557 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab2BPNqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:46:51 -0500
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Jan Kara <jack@suse.cz>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org
Subject: [PATCH 05/11] cifs: Push file_update_time() into cifs_page_mkwrite()
Date: Thu, 16 Feb 2012 14:46:13 +0100
Message-Id: <1329399979-3647-6-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1329399979-3647-1-git-send-email-jack@suse.cz>
References: <1329399979-3647-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Steve French <sfrench@samba.org>
CC: linux-cifs@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/cifs/file.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

  BTW: How does cifs_page_mkwrite() protect against races with truncate?
See e.g. checks in __block_page_mkwrite()...

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 4dd9283..8e3b23b 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2425,6 +2425,9 @@ cifs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct page *page = vmf->page;
 
+	/* Update file times before taking page lock */
+	file_update_time(vma->vm_file);
+
 	lock_page(page);
 	return VM_FAULT_LOCKED;
 }
-- 
1.7.1

