Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab2ITCN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 22:13:27 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51740 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab2ITCLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 22:11:31 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 19 Sep 2012 18:52:29 -0700
Message-Id: <1348105949-25454-27-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
References: <871uhx1n71.fsf@xmission.com>
 <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18XqPtWlNFWQfWWect4GTwhXQJrFHPyKSI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2267]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 27/27] userns: Convert quota
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Now that the type changes are done, here is the final set of
changes to make the quota code work when user namespaces are enabled.

Small cleanups and fixes to make the code build when user namespaces
are enabled.

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/quota/dquot.c |   29 ++++++++++++++---------------
 init/Kconfig     |    1 -
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index f3db845..c4564d0 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -253,8 +253,10 @@ static qsize_t inode_get_rsv_space(struct inode *inode);
 static void __dquot_initialize(struct inode *inode, int type);
 
 static inline unsigned int
-hashfn(const struct super_block *sb, unsigned int id, int type)
+hashfn(const struct super_block *sb, struct kqid qid)
 {
+	unsigned int id = from_kqid(&init_user_ns, qid);
+	int type = qid.type;
 	unsigned long tmp;
 
 	tmp = (((unsigned long)sb>>L1_CACHE_SHIFT) ^ id) * (MAXQUOTAS - type);
@@ -267,7 +269,7 @@ hashfn(const struct super_block *sb, unsigned int id, int type)
 static inline void insert_dquot_hash(struct dquot *dquot)
 {
 	struct hlist_head *head;
-	head = dquot_hash + hashfn(dquot->dq_sb, from_kqid(&init_user_ns, dquot->dq_id), dquot->dq_id.type);
+	head = dquot_hash + hashfn(dquot->dq_sb, dquot->dq_id);
 	hlist_add_head(&dquot->dq_hash, head);
 }
 
@@ -277,9 +279,8 @@ static inline void remove_dquot_hash(struct dquot *dquot)
 }
 
 static struct dquot *find_dquot(unsigned int hashent, struct super_block *sb,
-				unsigned int id, int type)
+				struct kqid qid)
 {
-	struct kqid qid = make_kqid(&init_user_ns, type, id);
 	struct hlist_node *node;
 	struct dquot *dquot;
 
@@ -816,7 +817,7 @@ static struct dquot *get_empty_dquot(struct super_block *sb, int type)
 	INIT_LIST_HEAD(&dquot->dq_dirty);
 	init_waitqueue_head(&dquot->dq_wait_unused);
 	dquot->dq_sb = sb;
-	dquot->dq_id.type = type;
+	dquot->dq_id = make_kqid_invalid(type);
 	atomic_set(&dquot->dq_count, 1);
 
 	return dquot;
@@ -832,28 +833,26 @@ static struct dquot *get_empty_dquot(struct super_block *sb, int type)
  */
 struct dquot *dqget(struct super_block *sb, struct kqid qid)
 {
-	unsigned int type = qid.type;
-	unsigned int id = from_kqid(&init_user_ns, qid);
-	unsigned int hashent = hashfn(sb, id, type);
+	unsigned int hashent = hashfn(sb, qid);
 	struct dquot *dquot = NULL, *empty = NULL;
 
-        if (!sb_has_quota_active(sb, type))
+        if (!sb_has_quota_active(sb, qid.type))
 		return NULL;
 we_slept:
 	spin_lock(&dq_list_lock);
 	spin_lock(&dq_state_lock);
-	if (!sb_has_quota_active(sb, type)) {
+	if (!sb_has_quota_active(sb, qid.type)) {
 		spin_unlock(&dq_state_lock);
 		spin_unlock(&dq_list_lock);
 		goto out;
 	}
 	spin_unlock(&dq_state_lock);
 
-	dquot = find_dquot(hashent, sb, id, type);
+	dquot = find_dquot(hashent, sb, qid);
 	if (!dquot) {
 		if (!empty) {
 			spin_unlock(&dq_list_lock);
-			empty = get_empty_dquot(sb, type);
+			empty = get_empty_dquot(sb, qid.type);
 			if (!empty)
 				schedule();	/* Try to wait for a moment... */
 			goto we_slept;
@@ -1158,7 +1157,7 @@ static int need_print_warning(struct dquot_warn *warn)
 
 	switch (warn->w_dq_id.type) {
 		case USRQUOTA:
-			return current_fsuid() == warn->w_dq_id.uid;
+			return uid_eq(current_fsuid(), warn->w_dq_id.uid);
 		case GRPQUOTA:
 			return in_group_p(warn->w_dq_id.gid);
 	}
@@ -1898,9 +1897,9 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
 	if (!dquot_active(inode))
 		return 0;
 
-	if (iattr->ia_valid & ATTR_UID && iattr->ia_uid != inode->i_uid)
+	if (iattr->ia_valid & ATTR_UID && !uid_eq(iattr->ia_uid, inode->i_uid))
 		transfer_to[USRQUOTA] = dqget(sb, make_kqid_uid(iattr->ia_uid));
-	if (iattr->ia_valid & ATTR_GID && iattr->ia_gid != inode->i_gid)
+	if (iattr->ia_valid & ATTR_GID && !gid_eq(iattr->ia_gid, inode->i_gid))
 		transfer_to[GRPQUOTA] = dqget(sb, make_kqid_gid(iattr->ia_gid));
 
 	ret = __dquot_transfer(inode, transfer_to);
diff --git a/init/Kconfig b/init/Kconfig
index 9c8aa8c..296d48b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -927,7 +927,6 @@ config UIDGID_CONVERTED
 	# Features
 	depends on IMA = n
 	depends on EVM = n
-	depends on QUOTA = n
 
 	# Networking
 	depends on NET_9P = n
-- 
1.7.5.4

