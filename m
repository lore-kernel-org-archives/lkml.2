Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724Ab0GBSsD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 14:48:03 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:35873 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759521Ab0GBSoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 14:44:38 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de, adilger@sun.com,
       sandeen@redhat.com, tytso@mit.edu, staubach@redhat.com,
       bfields@citi.umich.edu, jlayton@redhat.com
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
       nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH -V2 06/16] richacl: Compute maximum file masks from an acl
Date: Sat,  3 Jul 2010 00:13:37 +0530
Message-Id: <1278096227-16784-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.rc1
In-Reply-To: <1278096227-16784-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1278096227-16784-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@suse.de>

Compute upper bound owner, group, and other file masks with as few
permissions as possible without denying any permissions that the NFSv4
acl in a richacl grants.

This algorithm is used when a file inherits an acl at create time and
when an acl is set via a mechanism that does not specify file modes
(such as via nfsd).  When user-space sets an acl, the file masks are
passed in as part of the xattr.

When setting a richacl, the file masks determine what the file
permission bits will be set to; see richacl_masks_to_mode().

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/richacl_base.c       |  126 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/richacl.h |    1 +
 2 files changed, 127 insertions(+), 0 deletions(-)

diff --git a/fs/richacl_base.c b/fs/richacl_base.c
index bfc0abf4..d78ef35 100644
--- a/fs/richacl_base.c
+++ b/fs/richacl_base.c
@@ -205,3 +205,129 @@ richace_set_who(struct richace *ace, const char *who)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(richace_set_who);
+
+/**
+ * richacl_allowed_to_who  -  mask flags allowed to a specific who value
+ *
+ * Computes the mask values allowed to a specific who value, taking
+ * EVERYONE@ entries into account.
+ */
+static unsigned int richacl_allowed_to_who(struct richacl *acl,
+					   struct richace *who)
+{
+	struct richace *ace;
+	unsigned int allowed = 0;
+
+	richacl_for_each_entry_reverse(ace, acl) {
+		if (richace_is_inherit_only(ace))
+			continue;
+		if (richace_is_same_identifier(ace, who) ||
+		    richace_is_everyone(ace)) {
+			if (richace_is_allow(ace))
+				allowed |= ace->e_mask;
+			else if (richace_is_deny(ace))
+				allowed &= ~ace->e_mask;
+		}
+	}
+	return allowed;
+}
+
+/**
+ * richacl_group_class_allowed  -  maximum permissions the group class is allowed
+ *
+ * See richacl_compute_max_masks().
+ */
+static unsigned int richacl_group_class_allowed(struct richacl *acl)
+{
+	struct richace *ace;
+	unsigned int everyone_allowed = 0, group_class_allowed = 0;
+	int had_group_ace = 0;
+
+	richacl_for_each_entry_reverse(ace, acl) {
+		if (richace_is_inherit_only(ace) ||
+		    richace_is_owner(ace))
+			continue;
+
+		if (richace_is_everyone(ace)) {
+			if (richace_is_allow(ace))
+				everyone_allowed |= ace->e_mask;
+			else if (richace_is_deny(ace))
+				everyone_allowed &= ~ace->e_mask;
+		} else {
+			group_class_allowed |=
+				richacl_allowed_to_who(acl, ace);
+
+			if (richace_is_group(ace))
+				had_group_ace = 1;
+		}
+	}
+	if (!had_group_ace)
+		group_class_allowed |= everyone_allowed;
+	return group_class_allowed;
+}
+
+/**
+ * richacl_compute_max_masks  -  compute upper bound masks
+ *
+ * Computes upper bound owner, group, and other masks so that none of
+ * the mask flags allowed by the acl are disabled (for any choice of the
+ * file owner or group membership).
+ */
+void richacl_compute_max_masks(struct richacl *acl)
+{
+	unsigned int gmask = ~0;
+	struct richace *ace;
+
+	/*
+	 * @gmask contains all permissions which the group class is ever
+	 * allowed.  We use it to avoid adding permissions to the group mask
+	 * from everyone@ allow aces which the group class is always denied
+	 * through other aces.  For example, the following acl would otherwise
+	 * result in a group mask or rw:
+	 *
+	 *	group@:w::deny
+	 *	everyone@:rw::allow
+	 *
+	 * Avoid computing @gmask for acls which do not include any group class
+	 * deny aces: in such acls, the group class is never denied any
+	 * permissions from everyone@ allow aces.
+	 */
+
+restart:
+	acl->a_owner_mask = 0;
+	acl->a_group_mask = 0;
+	acl->a_other_mask = 0;
+
+	richacl_for_each_entry_reverse(ace, acl) {
+		if (richace_is_inherit_only(ace))
+			continue;
+
+		if (richace_is_owner(ace)) {
+			if (richace_is_allow(ace))
+				acl->a_owner_mask |= ace->e_mask;
+			else if (richace_is_deny(ace))
+				acl->a_owner_mask &= ~ace->e_mask;
+		} else if (richace_is_everyone(ace)) {
+			if (richace_is_allow(ace)) {
+				acl->a_owner_mask |= ace->e_mask;
+				acl->a_group_mask |= ace->e_mask & gmask;
+				acl->a_other_mask |= ace->e_mask;
+			} else if (richace_is_deny(ace)) {
+				acl->a_owner_mask &= ~ace->e_mask;
+				acl->a_group_mask &= ~ace->e_mask;
+				acl->a_other_mask &= ~ace->e_mask;
+			}
+		} else {
+			if (richace_is_allow(ace)) {
+				acl->a_owner_mask |= ace->e_mask & gmask;
+				acl->a_group_mask |= ace->e_mask & gmask;
+			} else if (richace_is_deny(ace) && gmask == ~0) {
+				gmask = richacl_group_class_allowed(acl);
+				if (likely(gmask != ~0))
+					/* should always be true */
+					goto restart;
+			}
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(richacl_compute_max_masks);
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index 8b9f7ef..738fd76 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -268,5 +268,6 @@ extern int richace_set_who(struct richace *, const char *);
 extern int richacl_masks_to_mode(const struct richacl *);
 extern unsigned int richacl_mode_to_mask(mode_t);
 extern unsigned int richacl_want_to_mask(int);
+extern void richacl_compute_max_masks(struct richacl *);
 
 #endif /* __RICHACL_H */
-- 
1.7.2.rc1

