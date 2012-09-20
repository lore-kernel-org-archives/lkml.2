Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab2ITCLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 22:11:33 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51718 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2ITCLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 22:11:30 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 19 Sep 2012 18:52:23 -0700
Message-Id: <1348105949-25454-21-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
References: <871uhx1n71.fsf@xmission.com>
 <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+RExRfYwgkHS/x2D7zKIM53zCyjsAv6wg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3501]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 21/27] userns: Implement struct kqid
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Add the data type struct kqid which holds the kernel internal form of
the owning identifier of a quota.  struct kqid is a replacement for
the implicit union of uid, gid and project id stored in an unsigned
int and the quota type field that is was used in the quota data
structures.  Making the data type explicit allows the kuid_t and
kgid_t type safety to propogate more thoroughly through the code,
revealing more places where uid/gid conversions need be made.

Along with the data type struct kqid comes the helper functions
qid_eq, qid_lt, from_kqid, from_kqid_munged, qid_valid, make_kqid,
make_kqid_invalid, make_kqid_uid, make_kqid_gid.

Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/quota/Makefile     |    2 +-
 fs/quota/kqid.c       |  132 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/quota.h |  125 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 258 insertions(+), 1 deletions(-)
 create mode 100644 fs/quota/kqid.c

diff --git a/fs/quota/Makefile b/fs/quota/Makefile
index 5f9e9e2..c66c37c 100644
--- a/fs/quota/Makefile
+++ b/fs/quota/Makefile
@@ -2,6 +2,6 @@ obj-$(CONFIG_QUOTA)		+= dquot.o
 obj-$(CONFIG_QFMT_V1)		+= quota_v1.o
 obj-$(CONFIG_QFMT_V2)		+= quota_v2.o
 obj-$(CONFIG_QUOTA_TREE)	+= quota_tree.o
-obj-$(CONFIG_QUOTACTL)		+= quota.o
+obj-$(CONFIG_QUOTACTL)		+= quota.o kqid.o
 obj-$(CONFIG_QUOTACTL_COMPAT)	+= compat.o
 obj-$(CONFIG_QUOTA_NETLINK_INTERFACE)	+= netlink.o
diff --git a/fs/quota/kqid.c b/fs/quota/kqid.c
new file mode 100644
index 0000000..2f97b0e
--- /dev/null
+++ b/fs/quota/kqid.c
@@ -0,0 +1,132 @@
+#include <linux/fs.h>
+#include <linux/quota.h>
+#include <linux/export.h>
+
+/**
+ *	qid_eq - Test to see if to kquid values are the same
+ *	@left: A qid value
+ *	@right: Another quid value
+ *
+ *	Return true if the two qid values are equal and false otherwise.
+ */
+bool qid_eq(struct kqid left, struct kqid right)
+{
+	if (left.type != right.type)
+		return false;
+	switch(left.type) {
+	case USRQUOTA:
+		return uid_eq(left.uid, right.uid);
+	case GRPQUOTA:
+		return gid_eq(left.gid, right.gid);
+	case PRJQUOTA:
+		return projid_eq(left.projid, right.projid);
+	default:
+		BUG();
+	}
+}
+EXPORT_SYMBOL(qid_eq);
+
+/**
+ *	qid_lt - Test to see if one qid value is less than another
+ *	@left: The possibly lesser qid value
+ *	@right: The possibly greater qid value
+ *
+ *	Return true if left is less than right and false otherwise.
+ */
+bool qid_lt(struct kqid left, struct kqid right)
+{
+	if (left.type < right.type)
+		return true;
+	if (left.type > right.type)
+		return false;
+	switch (left.type) {
+	case USRQUOTA:
+		return uid_lt(left.uid, right.uid);
+	case GRPQUOTA:
+		return gid_lt(left.gid, right.gid);
+	case PRJQUOTA:
+		return projid_lt(left.projid, right.projid);
+	default:
+		BUG();
+	}
+}
+EXPORT_SYMBOL(qid_lt);
+
+/**
+ *	from_kqid - Create a qid from a kqid user-namespace pair.
+ *	@targ: The user namespace we want a qid in.
+ *	@kuid: The kernel internal quota identifier to start with.
+ *
+ *	Map @kqid into the user-namespace specified by @targ and
+ *	return the resulting qid.
+ *
+ *	There is always a mapping into the initial user_namespace.
+ *
+ *	If @kqid has no mapping in @targ (qid_t)-1 is returned.
+ */
+qid_t from_kqid(struct user_namespace *targ, struct kqid kqid)
+{
+	switch (kqid.type) {
+	case USRQUOTA:
+		return from_kuid(targ, kqid.uid);
+	case GRPQUOTA:
+		return from_kgid(targ, kqid.gid);
+	case PRJQUOTA:
+		return from_kprojid(targ, kqid.projid);
+	default:
+		BUG();
+	}
+}
+EXPORT_SYMBOL(from_kqid);
+
+/**
+ *	from_kqid_munged - Create a qid from a kqid user-namespace pair.
+ *	@targ: The user namespace we want a qid in.
+ *	@kqid: The kernel internal quota identifier to start with.
+ *
+ *	Map @kqid into the user-namespace specified by @targ and
+ *	return the resulting qid.
+ *
+ *	There is always a mapping into the initial user_namespace.
+ *
+ *	Unlike from_kqid from_kqid_munged never fails and always
+ *	returns a valid projid.  This makes from_kqid_munged
+ *	appropriate for use in places where failing to provide
+ *	a qid_t is not a good option.
+ *
+ *	If @kqid has no mapping in @targ the kqid.type specific
+ *	overflow identifier is returned.
+ */
+qid_t from_kqid_munged(struct user_namespace *targ, struct kqid kqid)
+{
+	switch (kqid.type) {
+	case USRQUOTA:
+		return from_kuid_munged(targ, kqid.uid);
+	case GRPQUOTA:
+		return from_kgid_munged(targ, kqid.gid);
+	case PRJQUOTA:
+		return from_kprojid_munged(targ, kqid.projid);
+	default:
+		BUG();
+	}
+}
+EXPORT_SYMBOL(from_kqid_munged);
+
+/**
+ *	qid_valid - Report if a valid value is stored in a kqid.
+ *	@qid: The kernel internal quota identifier to test.
+ */
+bool qid_valid(struct kqid qid)
+{
+	switch (qid.type) {
+	case USRQUOTA:
+		return uid_valid(qid.uid);
+	case GRPQUOTA:
+		return gid_valid(qid.gid);
+	case PRJQUOTA:
+		return projid_valid(qid.projid);
+	default:
+		BUG();
+	}
+}
+EXPORT_SYMBOL(qid_valid);
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 524ede8..00ac8d8 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -181,10 +181,135 @@ enum {
 #include <linux/dqblk_v2.h>
 
 #include <linux/atomic.h>
+#include <linux/uidgid.h>
+#include <linux/projid.h>
+
+#undef USRQUOTA
+#undef GRPQUOTA
+enum quota_type {
+	USRQUOTA = 0,		/* element used for user quotas */
+	GRPQUOTA = 1,		/* element used for group quotas */
+	PRJQUOTA = 2,		/* element used for project quotas */
+};
 
 typedef __kernel_uid32_t qid_t; /* Type in which we store ids in memory */
 typedef long long qsize_t;	/* Type in which we store sizes */
 
+struct kqid {			/* Type in which we store the quota identifier */
+	union {
+		kuid_t uid;
+		kgid_t gid;
+		kprojid_t projid;
+	};
+	enum quota_type type;  /* USRQUOTA (uid) or GRPQUOTA (gid) or PRJQUOTA (projid) */
+};
+
+extern bool qid_eq(struct kqid left, struct kqid right);
+extern bool qid_lt(struct kqid left, struct kqid right);
+extern qid_t from_kqid(struct user_namespace *to, struct kqid qid);
+extern qid_t from_kqid_munged(struct user_namespace *to, struct kqid qid);
+extern bool qid_valid(struct kqid qid);
+
+/**
+ *	make_kqid - Map a user-namespace, type, qid tuple into a kqid.
+ *	@from: User namespace that the qid is in
+ *	@type: The type of quota
+ *	@qid: Quota identifier
+ *
+ *	Maps a user-namespace, type qid tuple into a kernel internal
+ *	kqid, and returns that kqid.
+ *
+ *	When there is no mapping defined for the user-namespace, type,
+ *	qid tuple an invalid kqid is returned.  Callers are expected to
+ *	test for and handle handle invalid kqids being returned.
+ *	Invalid kqids may be tested for using qid_valid().
+ */
+static inline struct kqid make_kqid(struct user_namespace *from,
+				    enum quota_type type, qid_t qid)
+{
+	struct kqid kqid;
+
+	kqid.type = type;
+	switch (type) {
+	case USRQUOTA:
+		kqid.uid = make_kuid(from, qid);
+		break;
+	case GRPQUOTA:
+		kqid.gid = make_kgid(from, qid);
+		break;
+	case PRJQUOTA:
+		kqid.projid = make_kprojid(from, qid);
+		break;
+	default:
+		BUG();
+	}
+	return kqid;
+}
+
+/**
+ *	make_kqid_invalid - Explicitly make an invalid kqid
+ *	@type: The type of quota identifier
+ *
+ *	Returns an invalid kqid with the specified type.
+ */
+static inline struct kqid make_kqid_invalid(enum quota_type type)
+{
+	struct kqid kqid;
+
+	kqid.type = type;
+	switch (type) {
+	case USRQUOTA:
+		kqid.uid = INVALID_UID;
+		break;
+	case GRPQUOTA:
+		kqid.gid = INVALID_GID;
+		break;
+	case PRJQUOTA:
+		kqid.projid = INVALID_PROJID;
+		break;
+	default:
+		BUG();
+	}
+	return kqid;
+}
+
+/**
+ *	make_kqid_uid - Make a kqid from a kuid
+ *	@uid: The kuid to make the quota identifier from
+ */
+static inline struct kqid make_kqid_uid(kuid_t uid)
+{
+	struct kqid kqid;
+	kqid.type = USRQUOTA;
+	kqid.uid = uid;
+	return kqid;
+}
+
+/**
+ *	make_kqid_gid - Make a kqid from a kgid
+ *	@gid: The kgid to make the quota identifier from
+ */
+static inline struct kqid make_kqid_gid(kgid_t gid)
+{
+	struct kqid kqid;
+	kqid.type = GRPQUOTA;
+	kqid.gid = gid;
+	return kqid;
+}
+
+/**
+ *	make_kqid_projid - Make a kqid from a projid
+ *	@projid: The kprojid to make the quota identifier from
+ */
+static inline struct kqid make_kqid_projid(kprojid_t projid)
+{
+	struct kqid kqid;
+	kqid.type = PRJQUOTA;
+	kqid.projid = projid;
+	return kqid;
+}
+
+
 extern spinlock_t dq_data_lock;
 
 /* Maximal numbers of writes for quota operation (insert/delete/update)
-- 
1.7.5.4

