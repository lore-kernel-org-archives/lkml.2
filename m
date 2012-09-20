Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab2ITCNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 22:13:25 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51750 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab2ITCLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 22:11:32 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Date: Wed, 19 Sep 2012 18:52:25 -0700
Message-Id: <1348105949-25454-23-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
References: <871uhx1n71.fsf@xmission.com>
 <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+1Q/XQMk6prxsPzz2wYzdyMe0rx2gdXt0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4081]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 23/27] userns: Modify dqget to take struct kqid
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Modify dqget to take struct kqid instead of a type and an identifier
pair.

Modify the callers of dqget in ocfs2 and dquot to take generate
a struct kqid so they can continue to call dqget.  The conversion
to create struct kqid should all be the final conversions that
are needed in those code paths.

Cc: Jan Kara <jack@suse.cz>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/ocfs2/file.c          |    6 ++----
 fs/ocfs2/quota_local.c   |    4 +++-
 fs/quota/dquot.c         |   20 +++++++++++---------
 include/linux/quotaops.h |    2 +-
 4 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 46a1f6d..5a4ee77 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1184,8 +1184,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 		if (attr->ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid
 		    && OCFS2_HAS_RO_COMPAT_FEATURE(sb,
 		    OCFS2_FEATURE_RO_COMPAT_USRQUOTA)) {
-			transfer_to[USRQUOTA] = dqget(sb, attr->ia_uid,
-						      USRQUOTA);
+			transfer_to[USRQUOTA] = dqget(sb, make_kqid_uid(attr->ia_uid));
 			if (!transfer_to[USRQUOTA]) {
 				status = -ESRCH;
 				goto bail_unlock;
@@ -1194,8 +1193,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 		if (attr->ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid
 		    && OCFS2_HAS_RO_COMPAT_FEATURE(sb,
 		    OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)) {
-			transfer_to[GRPQUOTA] = dqget(sb, attr->ia_gid,
-						      GRPQUOTA);
+			transfer_to[GRPQUOTA] = dqget(sb, make_kqid_gid(attr->ia_gid));
 			if (!transfer_to[GRPQUOTA]) {
 				status = -ESRCH;
 				goto bail_unlock;
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index f100bf7..020f0ba 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -501,7 +501,9 @@ static int ocfs2_recover_local_quota_file(struct inode *lqinode,
 			}
 			dqblk = (struct ocfs2_local_disk_dqblk *)(qbh->b_data +
 				ol_dqblk_block_off(sb, chunk, bit));
-			dquot = dqget(sb, le64_to_cpu(dqblk->dqb_id), type);
+			dquot = dqget(sb,
+				      make_kqid(&init_user_ns, type,
+						le64_to_cpu(dqblk->dqb_id)));
 			if (!dquot) {
 				status = -EIO;
 				mlog(ML_ERROR, "Failed to get quota structure "
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 80d3378..53e377a 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -829,8 +829,10 @@ static struct dquot *get_empty_dquot(struct super_block *sb, int type)
  *   a) checking for quota flags under dq_list_lock and
  *   b) getting a reference to dquot before we release dq_list_lock
  */
-struct dquot *dqget(struct super_block *sb, unsigned int id, int type)
+struct dquot *dqget(struct super_block *sb, struct kqid qid)
 {
+	unsigned int type = qid.type;
+	unsigned int id = from_kqid(&init_user_ns, qid);
 	unsigned int hashent = hashfn(sb, id, type);
 	struct dquot *dquot = NULL, *empty = NULL;
 
@@ -1390,7 +1392,6 @@ static int dquot_active(const struct inode *inode)
  */
 static void __dquot_initialize(struct inode *inode, int type)
 {
-	unsigned int id = 0;
 	int cnt;
 	struct dquot *got[MAXQUOTAS];
 	struct super_block *sb = inode->i_sb;
@@ -1403,18 +1404,19 @@ static void __dquot_initialize(struct inode *inode, int type)
 
 	/* First get references to structures we might need. */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
+		struct kqid qid;
 		got[cnt] = NULL;
 		if (type != -1 && cnt != type)
 			continue;
 		switch (cnt) {
 		case USRQUOTA:
-			id = inode->i_uid;
+			qid = make_kqid_uid(inode->i_uid);
 			break;
 		case GRPQUOTA:
-			id = inode->i_gid;
+			qid = make_kqid_gid(inode->i_gid);
 			break;
 		}
-		got[cnt] = dqget(sb, id, cnt);
+		got[cnt] = dqget(sb, qid);
 	}
 
 	down_write(&sb_dqopt(sb)->dqptr_sem);
@@ -1898,9 +1900,9 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
 		return 0;
 
 	if (iattr->ia_valid & ATTR_UID && iattr->ia_uid != inode->i_uid)
-		transfer_to[USRQUOTA] = dqget(sb, iattr->ia_uid, USRQUOTA);
+		transfer_to[USRQUOTA] = dqget(sb, make_kqid_uid(iattr->ia_uid));
 	if (iattr->ia_valid & ATTR_GID && iattr->ia_gid != inode->i_gid)
-		transfer_to[GRPQUOTA] = dqget(sb, iattr->ia_gid, GRPQUOTA);
+		transfer_to[GRPQUOTA] = dqget(sb, make_kqid_gid(iattr->ia_gid));
 
 	ret = __dquot_transfer(inode, transfer_to);
 	dqput_all(transfer_to);
@@ -2381,7 +2383,7 @@ int dquot_get_dqblk(struct super_block *sb, struct kqid qid,
 {
 	struct dquot *dquot;
 
-	dquot = dqget(sb, qid.type, from_kqid(&init_user_ns, qid));
+	dquot = dqget(sb, qid);
 	if (!dquot)
 		return -ESRCH;
 	do_get_dqblk(dquot, di);
@@ -2494,7 +2496,7 @@ int dquot_set_dqblk(struct super_block *sb, struct kqid qid,
 	struct dquot *dquot;
 	int rc;
 
-	dquot = dqget(sb, qid.type, from_kqid(&init_user_ns, qid));
+	dquot = dqget(sb, qid);
 	if (!dquot) {
 		rc = -ESRCH;
 		goto out;
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index bd3730d..1c50093 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -44,7 +44,7 @@ void inode_sub_rsv_space(struct inode *inode, qsize_t number);
 
 void dquot_initialize(struct inode *inode);
 void dquot_drop(struct inode *inode);
-struct dquot *dqget(struct super_block *sb, unsigned int id, int type);
+struct dquot *dqget(struct super_block *sb, struct kqid qid);
 void dqput(struct dquot *dquot);
 int dquot_scan_active(struct super_block *sb,
 		      int (*fn)(struct dquot *dquot, unsigned long priv),
-- 
1.7.5.4

