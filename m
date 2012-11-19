Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab2KSKve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 05:51:34 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49330 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab2KSKuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 05:50:51 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 19 Nov 2012 02:50:20 -0800
Message-Id: <1353322222-27060-4-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353322222-27060-1-git-send-email-ebiederm@xmission.com>
References: <87k3thc1h3.fsf@xmission.com>
 <1353322222-27060-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/wOVIjJcca+n7zemkDFqQyLMBj3Z+XRyY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0238]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 4/6] vfs: Only support slave subtrees across different user namespaces
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Sharing mount subtress with mount namespaces created by unprivileged
users allows unprivileged mounts created by unprivileged users to
propagate to mount namespaces controlled by privileged users.

Prevent nasty consequences by changing shared subtrees to slave
subtress when an unprivileged users creates a new mount namespace.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/namespace.c |   11 ++++++++---
 fs/pnode.h     |    1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 207c7ba..4dfcaf0 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -786,7 +786,7 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 	if (!mnt)
 		return ERR_PTR(-ENOMEM);
 
-	if (flag & (CL_SLAVE | CL_PRIVATE))
+	if (flag & (CL_SLAVE | CL_PRIVATE | CL_SHARED_TO_SLAVE))
 		mnt->mnt_group_id = 0; /* not a peer of original */
 	else
 		mnt->mnt_group_id = old->mnt_group_id;
@@ -807,7 +807,8 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 	list_add_tail(&mnt->mnt_instance, &sb->s_mounts);
 	br_write_unlock(&vfsmount_lock);
 
-	if (flag & CL_SLAVE) {
+	if ((flag & CL_SLAVE) ||
+	    ((flag & CL_SHARED_TO_SLAVE) && IS_MNT_SHARED(old))) {
 		list_add(&mnt->mnt_slave, &old->mnt_slave_list);
 		mnt->mnt_master = old;
 		CLEAR_MNT_SHARED(mnt);
@@ -2331,6 +2332,7 @@ static struct mnt_namespace *dup_mnt_ns(struct mnt_namespace *mnt_ns,
 	struct mount *p, *q;
 	struct mount *old = mnt_ns->root;
 	struct mount *new;
+	int copy_flags;
 
 	new_ns = alloc_mnt_ns(user_ns);
 	if (IS_ERR(new_ns))
@@ -2338,7 +2340,10 @@ static struct mnt_namespace *dup_mnt_ns(struct mnt_namespace *mnt_ns,
 
 	down_write(&namespace_sem);
 	/* First pass: copy the tree topology */
-	new = copy_tree(old, old->mnt.mnt_root, CL_COPY_ALL | CL_EXPIRE);
+	copy_flags = CL_COPY_ALL | CL_EXPIRE;
+	if (user_ns != mnt_ns->user_ns)
+		copy_flags |= CL_SHARED_TO_SLAVE;
+	new = copy_tree(old, old->mnt.mnt_root, copy_flags);
 	if (IS_ERR(new)) {
 		up_write(&namespace_sem);
 		free_mnt_ns(new_ns);
diff --git a/fs/pnode.h b/fs/pnode.h
index 65c6097..19b853a3 100644
--- a/fs/pnode.h
+++ b/fs/pnode.h
@@ -22,6 +22,7 @@
 #define CL_COPY_ALL 		0x04
 #define CL_MAKE_SHARED 		0x08
 #define CL_PRIVATE 		0x10
+#define CL_SHARED_TO_SLAVE	0x20
 
 static inline void set_mnt_shared(struct mount *mnt)
 {
-- 
1.7.5.4

