Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab2DYPWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:22:39 -0400
Received: from fieldses.org ([174.143.236.118]:51425 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086Ab2DYPWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:22:14 -0400
From: bfields@fieldses.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3/5] vfs: don't use PARENT/CHILD lock classes for non-directories
Date: Wed, 25 Apr 2012 11:22:07 -0400
Message-Id: <1335367329-929-3-git-send-email-bfields@fieldses.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20120418215238.GA11959@fieldses.org>
References: <20120418215238.GA11959@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

Reserve I_MUTEX_PARENT and I_MUTEX_CHILD for locking of actual
directories.

(Since I_MUTEX_QUOTA is now used just any time we need to lock a second
non-directory object, not necessarily a quota file, perhaps it should
get some more generic name, like I_MUTEX_NONDIR2.)

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/inode.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 9718f1c..487c924 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -971,12 +971,12 @@ void lock_two_nondirectories(struct inode *inode1, struct inode *inode2)
 	if (inode1 == inode2 || inode2 == NULL)
 		mutex_lock(&inode1->i_mutex);
 	else if (inode1 < inode2) {
-		mutex_lock_nested(&inode1->i_mutex, I_MUTEX_PARENT);
-		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_CHILD);
+		mutex_lock(&inode1->i_mutex);
+		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_QUOTA);
 
 	} else {
-		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_PARENT);
-		mutex_lock_nested(&inode1->i_mutex, I_MUTEX_CHILD);
+		mutex_lock(&inode2->i_mutex);
+		mutex_lock_nested(&inode1->i_mutex, I_MUTEX_QUOTA);
 	}
 }
 EXPORT_SYMBOL(lock_two_nondirectories);
-- 
1.7.5.4

