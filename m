Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339Ab2CMBI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:08:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:46635 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650Ab2CMARj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:17:39 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 014/196] eCryptfs: Unlock page in write_begin error path
Date: Mon, 12 Mar 2012 20:12:22 -0400
Message-Id: <1331597724-31358-15-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 50f198ae16ac66508d4b8d5a40967a8507ad19ee upstream.

Unlock the page in error path of ecryptfs_write_begin(). This may
happen, for example, if decryption fails while bring the page
up-to-date.

Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ecryptfs/mmap.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 2ee9a3a..eb1a0c9 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -377,6 +377,11 @@ static int ecryptfs_write_begin(struct file *file,
 	    && (pos != 0))
 		zero_user(page, 0, PAGE_CACHE_SIZE);
 out:
+	if (unlikely(rc)) {
+		unlock_page(page);
+		page_cache_release(page);
+		*pagep = NULL;
+	}
 	return rc;
 }
 
-- 
1.7.9.3

