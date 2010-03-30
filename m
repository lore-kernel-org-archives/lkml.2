Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab0C3XXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:23:11 -0400
Received: from kroah.org ([198.145.64.141]:46852 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932702Ab0C3XWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:22:14 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:57 2010
Message-Id: <20100330224856.473187255@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:43:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Kara <jack@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [148/156] quota: Fix warning when a delayed write happens before quota is enabled
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kara <jack@suse.cz>

commit 0a5a9c725512461d19397490f3adf29931dca1f2 upstream.

If a delayed-allocation write happens before quota is enabled, the
kernel spits out a warning:
WARNING: at fs/quota/dquot.c:988 dquot_claim_space+0x77/0x112()

because the fact that user has some delayed allocation is not recorded
in quota structure.

Make dquot_initialize() update amount of reserved space for user if it sees
inode has some space reserved. Also make sure that reserved quota space does
not go negative and we warn about the filesystem bug just once.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/quota/dquot.c |   35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -225,6 +225,8 @@ static struct hlist_head *dquot_hash;
 struct dqstats dqstats;
 EXPORT_SYMBOL(dqstats);
 
+static qsize_t inode_get_rsv_space(struct inode *inode);
+
 static inline unsigned int
 hashfn(const struct super_block *sb, unsigned int id, int type)
 {
@@ -840,11 +842,14 @@ static int dqinit_needed(struct inode *i
 static void add_dquot_ref(struct super_block *sb, int type)
 {
 	struct inode *inode, *old_inode = NULL;
+	int reserved = 0;
 
 	spin_lock(&inode_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
 			continue;
+		if (unlikely(inode_get_rsv_space(inode) > 0))
+			reserved = 1;
 		if (!atomic_read(&inode->i_writecount))
 			continue;
 		if (!dqinit_needed(inode, type))
@@ -865,6 +870,12 @@ static void add_dquot_ref(struct super_b
 	}
 	spin_unlock(&inode_lock);
 	iput(old_inode);
+
+	if (reserved) {
+		printk(KERN_WARNING "VFS (%s): Writes happened before quota"
+			" was turned on thus quota information is probably "
+			"inconsistent. Please run quotacheck(8).\n", sb->s_id);
+	}
 }
 
 /*
@@ -978,10 +989,12 @@ static inline void dquot_resv_space(stru
 /*
  * Claim reserved quota space
  */
-static void dquot_claim_reserved_space(struct dquot *dquot,
-						qsize_t number)
+static void dquot_claim_reserved_space(struct dquot *dquot, qsize_t number)
 {
-	WARN_ON(dquot->dq_dqb.dqb_rsvspace < number);
+	if (dquot->dq_dqb.dqb_rsvspace < number) {
+		WARN_ON_ONCE(1);
+		number = dquot->dq_dqb.dqb_rsvspace;
+	}
 	dquot->dq_dqb.dqb_curspace += number;
 	dquot->dq_dqb.dqb_rsvspace -= number;
 }
@@ -989,7 +1002,12 @@ static void dquot_claim_reserved_space(s
 static inline
 void dquot_free_reserved_space(struct dquot *dquot, qsize_t number)
 {
-	dquot->dq_dqb.dqb_rsvspace -= number;
+	if (dquot->dq_dqb.dqb_rsvspace >= number)
+		dquot->dq_dqb.dqb_rsvspace -= number;
+	else {
+		WARN_ON_ONCE(1);
+		dquot->dq_dqb.dqb_rsvspace = 0;
+	}
 }
 
 static void dquot_decr_inodes(struct dquot *dquot, qsize_t number)
@@ -1242,6 +1260,7 @@ static int info_bdq_free(struct dquot *d
 		return QUOTA_NL_BHARDBELOW;
 	return QUOTA_NL_NOWARN;
 }
+
 /*
  *	Initialize quota pointers in inode
  *	We do things in a bit complicated way but by that we avoid calling
@@ -1253,6 +1272,7 @@ int dquot_initialize(struct inode *inode
 	int cnt, ret = 0;
 	struct dquot *got[MAXQUOTAS] = { NULL, NULL };
 	struct super_block *sb = inode->i_sb;
+	qsize_t rsv;
 
 	/* First test before acquiring mutex - solves deadlocks when we
          * re-enter the quota code and are already holding the mutex */
@@ -1287,6 +1307,13 @@ int dquot_initialize(struct inode *inode
 		if (!inode->i_dquot[cnt]) {
 			inode->i_dquot[cnt] = got[cnt];
 			got[cnt] = NULL;
+			/*
+			 * Make quota reservation system happy if someone
+			 * did a write before quota was turned on
+			 */
+			rsv = inode_get_rsv_space(inode);
+			if (unlikely(rsv))
+				dquot_resv_space(inode->i_dquot[cnt], rsv);
 		}
 	}
 out_err:


