Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab1B1Xst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 18:48:49 -0500
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:55281 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab1B1XsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 18:48:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:in-reply-to:references; q=dns; s=sasl; b=
	KN+pYQM6WVIGQ0fAlxJqqLJ0rfVBJgeEiAQKWoVtvI4A9T+RSTS8H5fKnIJnBvQi
	c+/wAgAbFwV8Nn85b+9nXsDmxT9pHlWj+jzAdhQJFX5Ni4EeZKrpFpOs/L5EpHeE
	uI/oWtDsuFgwqXEgzV1bQEvCzm2x2TnhWybcR/U6Ndg=
From: ntl@pobox.com
To: linux-kernel@vger.kernel.org
Cc: containers@lists.linux-foundation.org, Oren Laadan <orenl@cs.columbia.edu>,
        Nathan Lynch <ntl@pobox.com>
Subject: [PATCH 03/10] Introduce has_locks_with_owner() helper
Date: Mon, 28 Feb 2011 17:40:25 -0600
Message-Id: <1298936432-29607-4-git-send-email-ntl@pobox.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298936432-29607-1-git-send-email-ntl@pobox.com>
References: <1298936432-29607-1-git-send-email-ntl@pobox.com>
X-Pobox-Relay-ID: 5D6C8B1E-4394-11E0-838D-AF401E47CF6F-04752483!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Lynch <ntl@pobox.com>

Support for file locks is in the works, but until that is done
checkpoint needs to fail when an open file has locks.

Based on original "find_locks_with_owner" patch by Dave Hansen.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
[ntl: changed name and return type to clearly express semantics]
Signed-off-by: Nathan Lynch <ntl@pobox.com>
---
 fs/locks.c         |   35 +++++++++++++++++++++++++++++++++++
 include/linux/fs.h |    6 ++++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 8729347..961e17f 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2037,6 +2037,41 @@ void locks_remove_posix(struct file *filp, fl_owner_t owner)
 
 EXPORT_SYMBOL(locks_remove_posix);
 
+bool has_locks_with_owner(struct file *filp, fl_owner_t owner)
+{
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct file_lock **inode_fl;
+	bool ret = false;
+
+	lock_flocks();
+	for_each_lock(inode, inode_fl) {
+		struct file_lock *fl = *inode_fl;
+		/*
+		 * We could use posix_same_owner() along with a 'fake'
+		 * file_lock.  But, the fake file will never have the
+		 * same fl_lmops as the fl that we are looking for and
+		 * posix_same_owner() would just fall back to this
+		 * check anyway.
+		 */
+		if (IS_POSIX(fl)) {
+			if (fl->fl_owner == owner) {
+				ret = true;
+				break;
+			}
+		} else if (IS_FLOCK(fl) || IS_LEASE(fl)) {
+			if (fl->fl_file == filp) {
+				ret = true;
+				break;
+			}
+		} else {
+			WARN(1, "unknown file lock type, fl_flags: %x",
+				fl->fl_flags);
+		}
+	}
+	unlock_flocks();
+	return ret;
+}
+
 /*
  * This function is called on the last close of an open file.
  */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 090f0ea..315ded4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1138,6 +1138,7 @@ extern void locks_remove_posix(struct file *, fl_owner_t);
 extern void locks_remove_flock(struct file *);
 extern void locks_release_private(struct file_lock *);
 extern void posix_test_lock(struct file *, struct file_lock *);
+extern bool has_locks_with_owner(struct file *filp, fl_owner_t owner);
 extern int posix_lock_file(struct file *, struct file_lock *, struct file_lock *);
 extern int posix_lock_file_wait(struct file *, struct file_lock *);
 extern int posix_unblock_lock(struct file *, struct file_lock *);
@@ -1208,6 +1209,11 @@ static inline void locks_remove_posix(struct file *filp, fl_owner_t owner)
 	return;
 }
 
+static inline bool has_locks_with_owner(struct file *filp, fl_owner_t owner)
+{
+	return false;
+}
+
 static inline void locks_remove_flock(struct file *filp)
 {
 	return;
-- 
1.7.4

