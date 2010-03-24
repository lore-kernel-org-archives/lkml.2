Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab0CXDWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 23:22:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56036 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710Ab0CXDWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 23:22:49 -0400
From: NeilBrown <neilb@suse.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Date: Wed, 24 Mar 2010 14:20:08 +1100
Subject: [PATCH 1/3] sysfs: simplify handling for s_active refcount
Cc: linux-kernel@vger.kernel.org
Message-ID: <20100324032008.2136.52640.stgit@notabene.brown>
In-Reply-To: <20100324031829.2136.66489.stgit@notabene.brown>
References: <20100324031829.2136.66489.stgit@notabene.brown>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s_active counts the number of active references to a 'sysfs_direct'.
When we wish to deactivate a sysfs_direct, we subtract a large
number for the refcount so it will always appear negative.  When
it is negative, new references will not be taken.
After that subtraction, we wait for all the active references to
drain away.

The subtraction of the large number contains exactly the same
information as the setting of the flag SYSFS_FLAG_REMOVED.
(We know this as we already assert that SYSFS_FLAG_REMOVED is set
before adding the large-negative-bias).
So doing both is pointless.

By starting s_active with a value of 1, not 0 (as is typical of
reference counts) and using atomic_inc_not_zero, we can significantly
simplify the code while keeping exactly the same functionality.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/sysfs/dir.c   |   60 ++++++++++++++----------------------------------------
 fs/sysfs/sysfs.h |    2 --
 2 files changed, 16 insertions(+), 46 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 5907178..76a2d10 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -95,26 +95,13 @@ static void sysfs_unlink_sibling(struct sysfs_dirent *sd)
  */
 struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd)
 {
-	if (unlikely(!sd))
+	if (likely(sd)
+	    && (sd->s_flags & SYSFS_FLAG_REMOVED) == 0
+	    && atomic_inc_not_zero(&sd->s_active)) {
+		rwsem_acquire_read(&sd->dep_map, 0, 1, _RET_IP_);
+		return sd;
+	} else
 		return NULL;
-
-	while (1) {
-		int v, t;
-
-		v = atomic_read(&sd->s_active);
-		if (unlikely(v < 0))
-			return NULL;
-
-		t = atomic_cmpxchg(&sd->s_active, v, v + 1);
-		if (likely(t == v)) {
-			rwsem_acquire_read(&sd->dep_map, 0, 1, _RET_IP_);
-			return sd;
-		}
-		if (t < 0)
-			return NULL;
-
-		cpu_relax();
-	}
 }
 
 /**
@@ -126,34 +113,26 @@ struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd)
  */
 void sysfs_put_active(struct sysfs_dirent *sd)
 {
-	struct completion *cmpl;
-	int v;
-
 	if (unlikely(!sd))
 		return;
 
 	rwsem_release(&sd->dep_map, 1, _RET_IP_);
-	v = atomic_dec_return(&sd->s_active);
-	if (likely(v != SD_DEACTIVATED_BIAS))
-		return;
-
-	/* atomic_dec_return() is a mb(), we'll always see the updated
-	 * sd->s_sibling.
-	 */
-	cmpl = (void *)sd->s_sibling;
-	complete(cmpl);
+	if (atomic_dec_and_test(&sd->s_active)) {
+		struct completion *cmpl = (void*)sd->s_sibling;
+		complete(cmpl);
+	}
 }
 
 /**
  *	sysfs_deactivate - deactivate sysfs_dirent
  *	@sd: sysfs_dirent to deactivate
  *
- *	Deny new active references and drain existing ones.
+ *	New active references are already denied.
+ *      Drop ours and drain other existing ones.
  */
 static void sysfs_deactivate(struct sysfs_dirent *sd)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
-	int v;
 
 	BUG_ON(sd->s_sibling || !(sd->s_flags & SYSFS_FLAG_REMOVED));
 
@@ -163,20 +142,13 @@ static void sysfs_deactivate(struct sysfs_dirent *sd)
 	sd->s_sibling = (void *)&wait;
 
 	rwsem_acquire(&sd->dep_map, 0, 0, _RET_IP_);
-	/* atomic_add_return() is a mb(), put_active() will always see
-	 * the updated sd->s_sibling.
-	 */
-	v = atomic_add_return(SD_DEACTIVATED_BIAS, &sd->s_active);
-
-	if (v != SD_DEACTIVATED_BIAS) {
-		lock_contended(&sd->dep_map, _RET_IP_);
-		wait_for_completion(&wait);
-	}
+	sysfs_put_active(sd);
+	lock_contended(&sd->dep_map, _RET_IP_);
+	wait_for_completion(&wait);
 
 	sd->s_sibling = NULL;
 
 	lock_acquired(&sd->dep_map, _RET_IP_);
-	rwsem_release(&sd->dep_map, 1, _RET_IP_);
 }
 
 static int sysfs_alloc_ino(ino_t *pino)
@@ -318,7 +290,7 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 		goto err_out2;
 
 	atomic_set(&sd->s_count, 1);
-	atomic_set(&sd->s_active, 0);
+	atomic_set(&sd->s_active, 1);
 
 	sd->s_name = name;
 	sd->s_mode = mode;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 30f5a44..6a2a60e 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -71,8 +71,6 @@ struct sysfs_dirent {
 	struct sysfs_inode_attrs *s_iattr;
 };
 
-#define SD_DEACTIVATED_BIAS		INT_MIN
-
 #define SYSFS_TYPE_MASK			0x00ff
 #define SYSFS_DIR			0x0001
 #define SYSFS_KOBJ_ATTR			0x0002


