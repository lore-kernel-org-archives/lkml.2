Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286Ab2BNMte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 07:49:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32935 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756506Ab2BNMta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 07:49:30 -0500
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Markus <M4rkusXXL@web.de>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH] quota: Make quota code not call tty layer with dqptr_sem held
Date: Tue, 14 Feb 2012 13:49:20 +0100
Message-Id: <1329223760-13817-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dqptr_sem can be called from slab reclaim. tty layer uses GFP_KERNEL mask for
allocation so it can end up calling slab reclaim. Given quota code can call
into tty layer to print warning this creates possibility for lock inversion
between tty->atomic_write_lock and dqptr_sem.

Using direct printing of warnings from quota layer is obsolete but since it's
easy enough to change quota code to not hold any locks when printing warnings,
let's just do it. It seems like a good thing to do even when we use netlink
layer to transmit warnings to userspace.

Reported-by: Markus <M4rkusXXL@web.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c |  189 ++++++++++++++++++++++++++++++++----------------------
 1 files changed, 113 insertions(+), 76 deletions(-)

 I plan to put this fix into my tree if noone objects.

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 4674197..439ab11 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1109,6 +1109,13 @@ static void dquot_decr_space(struct dquot *dquot, qsize_t number)
 	clear_bit(DQ_BLKS_B, &dquot->dq_flags);
 }
 
+struct dquot_warn {
+	struct super_block *w_sb;
+	qid_t w_dq_id;
+	short w_dq_type;
+	short w_type;
+};
+
 static int warning_issued(struct dquot *dquot, const int warntype)
 {
 	int flag = (warntype == QUOTA_NL_BHARDWARN ||
@@ -1124,41 +1131,42 @@ static int warning_issued(struct dquot *dquot, const int warntype)
 #ifdef CONFIG_PRINT_QUOTA_WARNING
 static int flag_print_warnings = 1;
 
-static int need_print_warning(struct dquot *dquot)
+static int need_print_warning(struct dquot_warn *warn)
 {
 	if (!flag_print_warnings)
 		return 0;
 
-	switch (dquot->dq_type) {
+	switch (warn->w_dq_type) {
 		case USRQUOTA:
-			return current_fsuid() == dquot->dq_id;
+			return current_fsuid() == warn->w_dq_id;
 		case GRPQUOTA:
-			return in_group_p(dquot->dq_id);
+			return in_group_p(warn->w_dq_id);
 	}
 	return 0;
 }
 
 /* Print warning to user which exceeded quota */
-static void print_warning(struct dquot *dquot, const int warntype)
+static void print_warning(struct dquot_warn *warn)
 {
 	char *msg = NULL;
 	struct tty_struct *tty;
+	int warntype = warn->w_type;
 
 	if (warntype == QUOTA_NL_IHARDBELOW ||
 	    warntype == QUOTA_NL_ISOFTBELOW ||
 	    warntype == QUOTA_NL_BHARDBELOW ||
-	    warntype == QUOTA_NL_BSOFTBELOW || !need_print_warning(dquot))
+	    warntype == QUOTA_NL_BSOFTBELOW || !need_print_warning(warn))
 		return;
 
 	tty = get_current_tty();
 	if (!tty)
 		return;
-	tty_write_message(tty, dquot->dq_sb->s_id);
+	tty_write_message(tty, warn->w_sb->s_id);
 	if (warntype == QUOTA_NL_ISOFTWARN || warntype == QUOTA_NL_BSOFTWARN)
 		tty_write_message(tty, ": warning, ");
 	else
 		tty_write_message(tty, ": write failed, ");
-	tty_write_message(tty, quotatypes[dquot->dq_type]);
+	tty_write_message(tty, quotatypes[warn->w_dq_type]);
 	switch (warntype) {
 		case QUOTA_NL_IHARDWARN:
 			msg = " file limit reached.\r\n";
@@ -1184,26 +1192,34 @@ static void print_warning(struct dquot *dquot, const int warntype)
 }
 #endif
 
+static void prepare_warning(struct dquot_warn *warn, struct dquot *dquot,
+			    int warntype)
+{
+	if (warning_issued(dquot, warntype))
+		return;
+	warn->w_type = warntype;
+	warn->w_sb = dquot->dq_sb;
+	warn->w_dq_id = dquot->dq_id;
+	warn->w_dq_type = dquot->dq_type;
+}
+
 /*
  * Write warnings to the console and send warning messages over netlink.
  *
- * Note that this function can sleep.
+ * Note that this function can call into tty and networking code.
  */
-static void flush_warnings(struct dquot *const *dquots, char *warntype)
+static void flush_warnings(struct dquot_warn *warn)
 {
-	struct dquot *dq;
 	int i;
 
 	for (i = 0; i < MAXQUOTAS; i++) {
-		dq = dquots[i];
-		if (dq && warntype[i] != QUOTA_NL_NOWARN &&
-		    !warning_issued(dq, warntype[i])) {
+		if (warn[i].w_type == QUOTA_NL_NOWARN)
+			continue;
 #ifdef CONFIG_PRINT_QUOTA_WARNING
-			print_warning(dq, warntype[i]);
+		print_warning(&warn[i]);
 #endif
-			quota_send_warning(dq->dq_type, dq->dq_id,
-					   dq->dq_sb->s_dev, warntype[i]);
-		}
+		quota_send_warning(warn[i].w_dq_type, warn[i].w_dq_id,
+				   warn[i].w_sb->s_dev, warn[i].w_type);
 	}
 }
 
@@ -1217,11 +1233,11 @@ static int ignore_hardlimit(struct dquot *dquot)
 }
 
 /* needs dq_data_lock */
-static int check_idq(struct dquot *dquot, qsize_t inodes, char *warntype)
+static int check_idq(struct dquot *dquot, qsize_t inodes,
+		     struct dquot_warn *warn)
 {
 	qsize_t newinodes = dquot->dq_dqb.dqb_curinodes + inodes;
 
-	*warntype = QUOTA_NL_NOWARN;
 	if (!sb_has_quota_limits_enabled(dquot->dq_sb, dquot->dq_type) ||
 	    test_bit(DQ_FAKE_B, &dquot->dq_flags))
 		return 0;
@@ -1229,7 +1245,7 @@ static int check_idq(struct dquot *dquot, qsize_t inodes, char *warntype)
 	if (dquot->dq_dqb.dqb_ihardlimit &&
 	    newinodes > dquot->dq_dqb.dqb_ihardlimit &&
             !ignore_hardlimit(dquot)) {
-		*warntype = QUOTA_NL_IHARDWARN;
+		prepare_warning(warn, dquot, QUOTA_NL_IHARDWARN);
 		return -EDQUOT;
 	}
 
@@ -1238,14 +1254,14 @@ static int check_idq(struct dquot *dquot, qsize_t inodes, char *warntype)
 	    dquot->dq_dqb.dqb_itime &&
 	    get_seconds() >= dquot->dq_dqb.dqb_itime &&
             !ignore_hardlimit(dquot)) {
-		*warntype = QUOTA_NL_ISOFTLONGWARN;
+		prepare_warning(warn, dquot, QUOTA_NL_ISOFTLONGWARN);
 		return -EDQUOT;
 	}
 
 	if (dquot->dq_dqb.dqb_isoftlimit &&
 	    newinodes > dquot->dq_dqb.dqb_isoftlimit &&
 	    dquot->dq_dqb.dqb_itime == 0) {
-		*warntype = QUOTA_NL_ISOFTWARN;
+		prepare_warning(warn, dquot, QUOTA_NL_ISOFTWARN);
 		dquot->dq_dqb.dqb_itime = get_seconds() +
 		    sb_dqopt(dquot->dq_sb)->info[dquot->dq_type].dqi_igrace;
 	}
@@ -1254,12 +1270,12 @@ static int check_idq(struct dquot *dquot, qsize_t inodes, char *warntype)
 }
 
 /* needs dq_data_lock */
-static int check_bdq(struct dquot *dquot, qsize_t space, int prealloc, char *warntype)
+static int check_bdq(struct dquot *dquot, qsize_t space, int prealloc,
+		     struct dquot_warn *warn)
 {
 	qsize_t tspace;
 	struct super_block *sb = dquot->dq_sb;
 
-	*warntype = QUOTA_NL_NOWARN;
 	if (!sb_has_quota_limits_enabled(sb, dquot->dq_type) ||
 	    test_bit(DQ_FAKE_B, &dquot->dq_flags))
 		return 0;
@@ -1271,7 +1287,7 @@ static int check_bdq(struct dquot *dquot, qsize_t space, int prealloc, char *war
 	    tspace > dquot->dq_dqb.dqb_bhardlimit &&
             !ignore_hardlimit(dquot)) {
 		if (!prealloc)
-			*warntype = QUOTA_NL_BHARDWARN;
+			prepare_warning(warn, dquot, QUOTA_NL_BHARDWARN);
 		return -EDQUOT;
 	}
 
@@ -1281,7 +1297,7 @@ static int check_bdq(struct dquot *dquot, qsize_t space, int prealloc, char *war
 	    get_seconds() >= dquot->dq_dqb.dqb_btime &&
             !ignore_hardlimit(dquot)) {
 		if (!prealloc)
-			*warntype = QUOTA_NL_BSOFTLONGWARN;
+			prepare_warning(warn, dquot, QUOTA_NL_BSOFTLONGWARN);
 		return -EDQUOT;
 	}
 
@@ -1289,7 +1305,7 @@ static int check_bdq(struct dquot *dquot, qsize_t space, int prealloc, char *war
 	    tspace > dquot->dq_dqb.dqb_bsoftlimit &&
 	    dquot->dq_dqb.dqb_btime == 0) {
 		if (!prealloc) {
-			*warntype = QUOTA_NL_BSOFTWARN;
+			prepare_warning(warn, dquot, QUOTA_NL_BSOFTWARN);
 			dquot->dq_dqb.dqb_btime = get_seconds() +
 			    sb_dqopt(sb)->info[dquot->dq_type].dqi_bgrace;
 		}
@@ -1542,10 +1558,9 @@ static void inode_decr_space(struct inode *inode, qsize_t number, int reserve)
 int __dquot_alloc_space(struct inode *inode, qsize_t number, int flags)
 {
 	int cnt, ret = 0;
-	char warntype[MAXQUOTAS];
-	int warn = flags & DQUOT_SPACE_WARN;
+	struct dquot_warn warn[MAXQUOTAS];
+	struct dquot **dquots = inode->i_dquot;
 	int reserve = flags & DQUOT_SPACE_RESERVE;
-	int nofail = flags & DQUOT_SPACE_NOFAIL;
 
 	/*
 	 * First test before acquiring mutex - solves deadlocks when we
@@ -1558,36 +1573,36 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number, int flags)
 
 	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-		warntype[cnt] = QUOTA_NL_NOWARN;
+		warn[cnt].w_type = QUOTA_NL_NOWARN;
 
 	spin_lock(&dq_data_lock);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (!inode->i_dquot[cnt])
+		if (!dquots[cnt])
 			continue;
-		ret = check_bdq(inode->i_dquot[cnt], number, !warn,
-				warntype+cnt);
-		if (ret && !nofail) {
+		ret = check_bdq(dquots[cnt], number,
+				!(flags & DQUOT_SPACE_WARN), &warn[cnt]);
+		if (ret && !(flags & DQUOT_SPACE_NOFAIL)) {
 			spin_unlock(&dq_data_lock);
 			goto out_flush_warn;
 		}
 	}
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (!inode->i_dquot[cnt])
+		if (!dquots[cnt])
 			continue;
 		if (reserve)
-			dquot_resv_space(inode->i_dquot[cnt], number);
+			dquot_resv_space(dquots[cnt], number);
 		else
-			dquot_incr_space(inode->i_dquot[cnt], number);
+			dquot_incr_space(dquots[cnt], number);
 	}
 	inode_incr_space(inode, number, reserve);
 	spin_unlock(&dq_data_lock);
 
 	if (reserve)
 		goto out_flush_warn;
-	mark_all_dquot_dirty(inode->i_dquot);
+	mark_all_dquot_dirty(dquots);
 out_flush_warn:
-	flush_warnings(inode->i_dquot, warntype);
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	flush_warnings(warn);
 out:
 	return ret;
 }
@@ -1599,36 +1614,37 @@ EXPORT_SYMBOL(__dquot_alloc_space);
 int dquot_alloc_inode(const struct inode *inode)
 {
 	int cnt, ret = 0;
-	char warntype[MAXQUOTAS];
+	struct dquot_warn warn[MAXQUOTAS];
+	struct dquot * const *dquots = inode->i_dquot;
 
 	/* First test before acquiring mutex - solves deadlocks when we
          * re-enter the quota code and are already holding the mutex */
 	if (!dquot_active(inode))
 		return 0;
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-		warntype[cnt] = QUOTA_NL_NOWARN;
+		warn[cnt].w_type = QUOTA_NL_NOWARN;
 	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	spin_lock(&dq_data_lock);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (!inode->i_dquot[cnt])
+		if (!dquots[cnt])
 			continue;
-		ret = check_idq(inode->i_dquot[cnt], 1, warntype + cnt);
+		ret = check_idq(dquots[cnt], 1, &warn[cnt]);
 		if (ret)
 			goto warn_put_all;
 	}
 
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (!inode->i_dquot[cnt])
+		if (!dquots[cnt])
 			continue;
-		dquot_incr_inodes(inode->i_dquot[cnt], 1);
+		dquot_incr_inodes(dquots[cnt], 1);
 	}
 
 warn_put_all:
 	spin_unlock(&dq_data_lock);
 	if (ret == 0)
-		mark_all_dquot_dirty(inode->i_dquot);
-	flush_warnings(inode->i_dquot, warntype);
+		mark_all_dquot_dirty(dquots);
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	flush_warnings(warn);
 	return ret;
 }
 EXPORT_SYMBOL(dquot_alloc_inode);
@@ -1668,7 +1684,8 @@ EXPORT_SYMBOL(dquot_claim_space_nodirty);
 void __dquot_free_space(struct inode *inode, qsize_t number, int flags)
 {
 	unsigned int cnt;
-	char warntype[MAXQUOTAS];
+	struct dquot_warn warn[MAXQUOTAS];
+	struct dquot **dquots = inode->i_dquot;
 	int reserve = flags & DQUOT_SPACE_RESERVE;
 
 	/* First test before acquiring mutex - solves deadlocks when we
@@ -1681,23 +1698,28 @@ void __dquot_free_space(struct inode *inode, qsize_t number, int flags)
 	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	spin_lock(&dq_data_lock);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (!inode->i_dquot[cnt])
+		int wtype;
+
+		warn[cnt].w_type = QUOTA_NL_NOWARN;
+		if (!dquots[cnt])
 			continue;
-		warntype[cnt] = info_bdq_free(inode->i_dquot[cnt], number);
+		wtype = info_bdq_free(dquots[cnt], number);
+		if (wtype != QUOTA_NL_NOWARN)
+			prepare_warning(&warn[cnt], dquots[cnt], wtype);
 		if (reserve)
-			dquot_free_reserved_space(inode->i_dquot[cnt], number);
+			dquot_free_reserved_space(dquots[cnt], number);
 		else
-			dquot_decr_space(inode->i_dquot[cnt], number);
+			dquot_decr_space(dquots[cnt], number);
 	}
 	inode_decr_space(inode, number, reserve);
 	spin_unlock(&dq_data_lock);
 
 	if (reserve)
 		goto out_unlock;
-	mark_all_dquot_dirty(inode->i_dquot);
+	mark_all_dquot_dirty(dquots);
 out_unlock:
-	flush_warnings(inode->i_dquot, warntype);
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	flush_warnings(warn);
 }
 EXPORT_SYMBOL(__dquot_free_space);
 
@@ -1707,7 +1729,8 @@ EXPORT_SYMBOL(__dquot_free_space);
 void dquot_free_inode(const struct inode *inode)
 {
 	unsigned int cnt;
-	char warntype[MAXQUOTAS];
+	struct dquot_warn warn[MAXQUOTAS];
+	struct dquot * const *dquots = inode->i_dquot;
 
 	/* First test before acquiring mutex - solves deadlocks when we
          * re-enter the quota code and are already holding the mutex */
@@ -1717,15 +1740,20 @@ void dquot_free_inode(const struct inode *inode)
 	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	spin_lock(&dq_data_lock);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (!inode->i_dquot[cnt])
+		int wtype;
+
+		warn[cnt].w_type = QUOTA_NL_NOWARN;
+		if (!dquots[cnt])
 			continue;
-		warntype[cnt] = info_idq_free(inode->i_dquot[cnt], 1);
-		dquot_decr_inodes(inode->i_dquot[cnt], 1);
+		wtype = info_idq_free(dquots[cnt], 1);
+		if (wtype != QUOTA_NL_NOWARN)
+			prepare_warning(&warn[cnt], dquots[cnt], wtype);
+		dquot_decr_inodes(dquots[cnt], 1);
 	}
 	spin_unlock(&dq_data_lock);
-	mark_all_dquot_dirty(inode->i_dquot);
-	flush_warnings(inode->i_dquot, warntype);
+	mark_all_dquot_dirty(dquots);
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	flush_warnings(warn);
 }
 EXPORT_SYMBOL(dquot_free_inode);
 
@@ -1746,16 +1774,20 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
 	struct dquot *transfer_from[MAXQUOTAS] = {};
 	int cnt, ret = 0;
 	char is_valid[MAXQUOTAS] = {};
-	char warntype_to[MAXQUOTAS];
-	char warntype_from_inodes[MAXQUOTAS], warntype_from_space[MAXQUOTAS];
+	struct dquot_warn warn_to[MAXQUOTAS];
+	struct dquot_warn warn_from_inodes[MAXQUOTAS];
+	struct dquot_warn warn_from_space[MAXQUOTAS];
 
 	/* First test before acquiring mutex - solves deadlocks when we
          * re-enter the quota code and are already holding the mutex */
 	if (IS_NOQUOTA(inode))
 		return 0;
 	/* Initialize the arrays */
-	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-		warntype_to[cnt] = QUOTA_NL_NOWARN;
+	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
+		warn_to[cnt].w_type = QUOTA_NL_NOWARN;
+		warn_from_inodes[cnt].w_type = QUOTA_NL_NOWARN;
+		warn_from_space[cnt].w_type = QUOTA_NL_NOWARN;
+	}
 	down_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	if (IS_NOQUOTA(inode)) {	/* File without quota accounting? */
 		up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
@@ -1777,10 +1809,10 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
 			continue;
 		is_valid[cnt] = 1;
 		transfer_from[cnt] = inode->i_dquot[cnt];
-		ret = check_idq(transfer_to[cnt], 1, warntype_to + cnt);
+		ret = check_idq(transfer_to[cnt], 1, &warn_to[cnt]);
 		if (ret)
 			goto over_quota;
-		ret = check_bdq(transfer_to[cnt], space, 0, warntype_to + cnt);
+		ret = check_bdq(transfer_to[cnt], space, 0, &warn_to[cnt]);
 		if (ret)
 			goto over_quota;
 	}
@@ -1793,10 +1825,15 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
 			continue;
 		/* Due to IO error we might not have transfer_from[] structure */
 		if (transfer_from[cnt]) {
-			warntype_from_inodes[cnt] =
-				info_idq_free(transfer_from[cnt], 1);
-			warntype_from_space[cnt] =
-				info_bdq_free(transfer_from[cnt], space);
+			int wtype;
+			wtype = info_idq_free(transfer_from[cnt], 1);
+			if (wtype != QUOTA_NL_NOWARN)
+				prepare_warning(&warn_from_inodes[cnt],
+						transfer_from[cnt], wtype);
+			wtype = info_bdq_free(transfer_from[cnt], space);
+			if (wtype != QUOTA_NL_NOWARN)
+				prepare_warning(&warn_from_space[cnt],
+						transfer_from[cnt], wtype);
 			dquot_decr_inodes(transfer_from[cnt], 1);
 			dquot_decr_space(transfer_from[cnt], cur_space);
 			dquot_free_reserved_space(transfer_from[cnt],
@@ -1814,9 +1851,9 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
 
 	mark_all_dquot_dirty(transfer_from);
 	mark_all_dquot_dirty(transfer_to);
-	flush_warnings(transfer_to, warntype_to);
-	flush_warnings(transfer_from, warntype_from_inodes);
-	flush_warnings(transfer_from, warntype_from_space);
+	flush_warnings(warn_to);
+	flush_warnings(warn_from_inodes);
+	flush_warnings(warn_from_space);
 	/* Pass back references to put */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
 		if (is_valid[cnt])
@@ -1825,7 +1862,7 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
 over_quota:
 	spin_unlock(&dq_data_lock);
 	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
-	flush_warnings(transfer_to, warntype_to);
+	flush_warnings(warn_to);
 	return ret;
 }
 EXPORT_SYMBOL(__dquot_transfer);
-- 
1.7.1

