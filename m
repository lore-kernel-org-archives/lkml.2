Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab0C3X0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:26:36 -0400
Received: from kroah.org ([198.145.64.141]:46801 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932699Ab0C3XWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:22:13 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:56 2010
Message-Id: <20100330224855.888120778@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:43:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dmitry Monakhov <dmonakhov@openvz.org>, Jan Kara <jack@suse.cz>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [147/156] quota: manage reserved space when quota is not active [v2]
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit c469070aea5a0ada45a836937c776fd3083dae2b upstream.

Since we implemented generic reserved space management interface,
then it is possible to account reserved space even when quota
is not active (similar to i_blocks/i_bytes).

Without this patch following testcase result in massive comlain from
WARN_ON in dquot_claim_space()

TEST_CASE:
mount /dev/sdb /mnt -oquota
dd if=/dev/zero of=/mnt/test bs=1M count=1
quotaon /mnt
# fs_reserved_spave == 1Mb
# quota_reserved_space == 0, because quota was disabled
dd if=/dev/zero of=/mnt/test seek=1 bs=1M count=1
# fs_reserved_spave == 2Mb
# quota_reserved_space == 1Mb
sync  # ->dquot_claim_space() -> WARN_ON

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/quota/dquot.c         |   10 ++++++----
 include/linux/quotaops.h |   11 +++++++++--
 2 files changed, 15 insertions(+), 6 deletions(-)

--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1351,28 +1351,30 @@ static qsize_t *inode_reserved_space(str
 	return inode->i_sb->dq_op->get_reserved_space(inode);
 }
 
-static void inode_add_rsv_space(struct inode *inode, qsize_t number)
+void inode_add_rsv_space(struct inode *inode, qsize_t number)
 {
 	spin_lock(&inode->i_lock);
 	*inode_reserved_space(inode) += number;
 	spin_unlock(&inode->i_lock);
 }
+EXPORT_SYMBOL(inode_add_rsv_space);
 
-
-static void inode_claim_rsv_space(struct inode *inode, qsize_t number)
+void inode_claim_rsv_space(struct inode *inode, qsize_t number)
 {
 	spin_lock(&inode->i_lock);
 	*inode_reserved_space(inode) -= number;
 	__inode_add_bytes(inode, number);
 	spin_unlock(&inode->i_lock);
 }
+EXPORT_SYMBOL(inode_claim_rsv_space);
 
-static void inode_sub_rsv_space(struct inode *inode, qsize_t number)
+void inode_sub_rsv_space(struct inode *inode, qsize_t number)
 {
 	spin_lock(&inode->i_lock);
 	*inode_reserved_space(inode) -= number;
 	spin_unlock(&inode->i_lock);
 }
+EXPORT_SYMBOL(inode_sub_rsv_space);
 
 static qsize_t inode_get_rsv_space(struct inode *inode)
 {
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -26,6 +26,10 @@ static inline void writeout_quota_sb(str
 		sb->s_qcop->quota_sync(sb, type);
 }
 
+void inode_add_rsv_space(struct inode *inode, qsize_t number);
+void inode_claim_rsv_space(struct inode *inode, qsize_t number);
+void inode_sub_rsv_space(struct inode *inode, qsize_t number);
+
 int dquot_initialize(struct inode *inode, int type);
 int dquot_drop(struct inode *inode);
 struct dquot *dqget(struct super_block *sb, unsigned int id, int type);
@@ -42,7 +46,6 @@ int dquot_alloc_inode(const struct inode
 int dquot_reserve_space(struct inode *inode, qsize_t number, int prealloc);
 int dquot_claim_space(struct inode *inode, qsize_t number);
 void dquot_release_reserved_space(struct inode *inode, qsize_t number);
-qsize_t dquot_get_reserved_space(struct inode *inode);
 
 int dquot_free_space(struct inode *inode, qsize_t number);
 int dquot_free_inode(const struct inode *inode, qsize_t number);
@@ -199,6 +202,8 @@ static inline int vfs_dq_reserve_space(s
 		if (inode->i_sb->dq_op->reserve_space(inode, nr, 0) == NO_QUOTA)
 			return 1;
 	}
+	else
+		inode_add_rsv_space(inode, nr);
 	return 0;
 }
 
@@ -221,7 +226,7 @@ static inline int vfs_dq_claim_space(str
 		if (inode->i_sb->dq_op->claim_space(inode, nr) == NO_QUOTA)
 			return 1;
 	} else
-		inode_add_bytes(inode, nr);
+		inode_claim_rsv_space(inode, nr);
 
 	mark_inode_dirty(inode);
 	return 0;
@@ -235,6 +240,8 @@ void vfs_dq_release_reservation_space(st
 {
 	if (sb_any_quota_active(inode->i_sb))
 		inode->i_sb->dq_op->release_rsv(inode, nr);
+	else
+		inode_sub_rsv_space(inode, nr);
 }
 
 static inline void vfs_dq_free_space_nodirty(struct inode *inode, qsize_t nr)


