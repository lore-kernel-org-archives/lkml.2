Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab2ITCNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 22:13:23 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51762 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab2ITCLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 22:11:32 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>
Date: Wed, 19 Sep 2012 18:52:26 -0700
Message-Id: <1348105949-25454-24-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
References: <871uhx1n71.fsf@xmission.com>
 <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18sUNdDEdf5tv5VrUarsnYfFNt/6H5Rgto=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4449]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 24/27] userns: Convert quota netlink aka quota_send_warning
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Modify quota_send_warning to take struct kqid instead a type and
identifier pair.

When sending netlink broadcasts always convert uids and quota
identifiers into the intial user namespace.  There is as yet no way to
send a netlink broadcast message with different contents to receivers
in different namespaces, so for the time being just map all of the
identifiers into the initial user namespace which preserves the
current behavior.

Change the callers of quota_send_warning in gfs2, xfs and dquot
to generate a struct kqid to pass to quota send warning.  When
all of the user namespaces convesions are complete a struct kqid
values will be availbe without need for conversion, but a conversion
is needed now to avoid needing to convert everything at once.

Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/gfs2/quota.c          |   12 ++++++++----
 fs/quota/dquot.c         |    2 +-
 fs/quota/netlink.c       |   10 ++++++----
 fs/xfs/xfs_trans_dquot.c |    8 +++++---
 include/linux/quota.h    |    4 ++--
 init/Kconfig             |    1 -
 6 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index b311539..d554dff 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1070,8 +1070,10 @@ int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid)
 
 		if (be64_to_cpu(qd->qd_qb.qb_limit) && (s64)be64_to_cpu(qd->qd_qb.qb_limit) < value) {
 			print_message(qd, "exceeded");
-			quota_send_warning(test_bit(QDF_USER, &qd->qd_flags) ?
-					   USRQUOTA : GRPQUOTA, qd->qd_id,
+			quota_send_warning(make_kqid(&init_user_ns,
+						     test_bit(QDF_USER, &qd->qd_flags) ?
+						     USRQUOTA : GRPQUOTA,
+						     qd->qd_id),
 					   sdp->sd_vfs->s_dev, QUOTA_NL_BHARDWARN);
 
 			error = -EDQUOT;
@@ -1081,8 +1083,10 @@ int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid)
 			   time_after_eq(jiffies, qd->qd_last_warn +
 					 gfs2_tune_get(sdp,
 						gt_quota_warn_period) * HZ)) {
-			quota_send_warning(test_bit(QDF_USER, &qd->qd_flags) ?
-					   USRQUOTA : GRPQUOTA, qd->qd_id,
+			quota_send_warning(make_kqid(&init_user_ns,
+						     test_bit(QDF_USER, &qd->qd_flags) ?
+						     USRQUOTA : GRPQUOTA,
+						     qd->qd_id),
 					   sdp->sd_vfs->s_dev, QUOTA_NL_BSOFTWARN);
 			error = print_message(qd, "warning");
 			qd->qd_last_warn = jiffies;
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 7714b16..80d3378 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1236,7 +1236,7 @@ static void flush_warnings(struct dquot_warn *warn)
 #ifdef CONFIG_PRINT_QUOTA_WARNING
 		print_warning(&warn[i]);
 #endif
-		quota_send_warning(warn[i].w_dq_type, warn[i].w_dq_id,
+		quota_send_warning(make_kqid(&init_user_ns, warn[i].w_dq_type, warn[i].w_dq_id),
 				   warn[i].w_sb->s_dev, warn[i].w_type);
 	}
 }
diff --git a/fs/quota/netlink.c b/fs/quota/netlink.c
index d67908b..16e8abb 100644
--- a/fs/quota/netlink.c
+++ b/fs/quota/netlink.c
@@ -30,7 +30,7 @@ static struct genl_family quota_genl_family = {
  *
  */
 
-void quota_send_warning(short type, unsigned int id, dev_t dev,
+void quota_send_warning(struct kqid qid, dev_t dev,
 			const char warntype)
 {
 	static atomic_t seq;
@@ -56,10 +56,11 @@ void quota_send_warning(short type, unsigned int id, dev_t dev,
 		  "VFS: Cannot store netlink header in quota warning.\n");
 		goto err_out;
 	}
-	ret = nla_put_u32(skb, QUOTA_NL_A_QTYPE, type);
+	ret = nla_put_u32(skb, QUOTA_NL_A_QTYPE, qid.type);
 	if (ret)
 		goto attr_err_out;
-	ret = nla_put_u64(skb, QUOTA_NL_A_EXCESS_ID, id);
+	ret = nla_put_u64(skb, QUOTA_NL_A_EXCESS_ID,
+			  from_kqid_munged(&init_user_ns, qid));
 	if (ret)
 		goto attr_err_out;
 	ret = nla_put_u32(skb, QUOTA_NL_A_WARNING, warntype);
@@ -71,7 +72,8 @@ void quota_send_warning(short type, unsigned int id, dev_t dev,
 	ret = nla_put_u32(skb, QUOTA_NL_A_DEV_MINOR, MINOR(dev));
 	if (ret)
 		goto attr_err_out;
-	ret = nla_put_u64(skb, QUOTA_NL_A_CAUSED_ID, current_uid());
+	ret = nla_put_u64(skb, QUOTA_NL_A_CAUSED_ID,
+			  from_kuid_munged(&init_user_ns, current_uid()));
 	if (ret)
 		goto attr_err_out;
 	genlmsg_end(skb, msg_head);
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index bcb6054..0c7fa54 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -578,9 +578,11 @@ xfs_quota_warn(
 	/* no warnings for project quotas - we just return ENOSPC later */
 	if (dqp->dq_flags & XFS_DQ_PROJ)
 		return;
-	quota_send_warning((dqp->dq_flags & XFS_DQ_USER) ? USRQUOTA : GRPQUOTA,
-			   be32_to_cpu(dqp->q_core.d_id), mp->m_super->s_dev,
-			   type);
+	quota_send_warning(make_kqid(&init_user_ns,
+				     (dqp->dq_flags & XFS_DQ_USER) ?
+				     USRQUOTA : GRPQUOTA,
+				     be32_to_cpu(dqp->q_core.d_id)),
+			   mp->m_super->s_dev, type);
 }
 
 /*
diff --git a/include/linux/quota.h b/include/linux/quota.h
index f96427a..8b27604 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -511,10 +511,10 @@ static inline unsigned int dquot_generic_flag(unsigned int flags, int type)
 }
 
 #ifdef CONFIG_QUOTA_NETLINK_INTERFACE
-extern void quota_send_warning(short type, unsigned int id, dev_t dev,
+extern void quota_send_warning(struct kqid qid, dev_t dev,
 			       const char warntype);
 #else
-static inline void quota_send_warning(short type, unsigned int id, dev_t dev,
+static inline void quota_send_warning(struct kqid qid, dev_t dev,
 				      const char warntype)
 {
 	return;
diff --git a/init/Kconfig b/init/Kconfig
index 15bb1dc..9c8aa8c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -928,7 +928,6 @@ config UIDGID_CONVERTED
 	depends on IMA = n
 	depends on EVM = n
 	depends on QUOTA = n
-	depends on QUOTA_NETLINK_INTERFACE = n
 
 	# Networking
 	depends on NET_9P = n
-- 
1.7.5.4

