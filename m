Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab2ITCNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 22:13:21 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:60576 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab2ITCLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 22:11:33 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Theodore Tso <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Date: Wed, 19 Sep 2012 18:52:18 -0700
Message-Id: <1348105949-25454-16-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
References: <871uhx1n71.fsf@xmission.com>
 <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/jDPnnYW3OqhfAFVmdIY2ovdGhnssReIM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1172]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *******;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 16/27] userns: Convert vfs posix_acl support to use kuids and kgids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- In setxattr if we are setting a posix acl convert uids and gids from
  the current user namespace into the initial user namespace, before
  the xattrs are passed to the underlying filesystem.

  Untranslatable uids and gids are represented as -1 which
  posix_acl_from_xattr will represent as INVALID_UID or INVALID_GID.
  posix_acl_valid will fail if an acl from userspace has any
  INVALID_UID or INVALID_GID values.  In net this guarantees that
  untranslatable posix acls will not be stored by filesystems.

- In getxattr if we are reading a posix acl convert uids and gids from
  the initial user namespace into the current user namespace.

  Uids and gids that can not be tranlsated into the current user namespace
  will be represented as -1.

- Replace e_id in struct posix_acl_entry with an anymouns union of
  e_uid and e_gid.  For the short term retain the e_id field
  until all of the users are converted.

- Don't set struct posix_acl.e_id in the cases where the acl type
  does not use e_id.  Greatly reducing the use of ACL_UNDEFINED_ID.

- Rework the ordering checks in posix_acl_valid so that I use kuid_t
  and kgid_t types throughout the code, and so that I don't need
  arithmetic on uid and gid types.

Cc: Theodore Tso <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/posix_acl.c                  |   30 ++++++------
 fs/xattr.c                      |    7 +++
 fs/xattr_acl.c                  |   90 ++++++++++++++++++++++++++++++++++++--
 include/linux/posix_acl.h       |    8 +++-
 include/linux/posix_acl_xattr.h |   12 +++++
 5 files changed, 126 insertions(+), 21 deletions(-)

diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 5e325a4..8bd2135 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -78,7 +78,8 @@ posix_acl_valid(const struct posix_acl *acl)
 {
 	const struct posix_acl_entry *pa, *pe;
 	int state = ACL_USER_OBJ;
-	unsigned int id = 0;  /* keep gcc happy */
+	kuid_t prev_uid = INVALID_UID;
+	kgid_t prev_gid = INVALID_GID;
 	int needs_mask = 0;
 
 	FOREACH_ACL_ENTRY(pa, acl, pe) {
@@ -87,7 +88,6 @@ posix_acl_valid(const struct posix_acl *acl)
 		switch (pa->e_tag) {
 			case ACL_USER_OBJ:
 				if (state == ACL_USER_OBJ) {
-					id = 0;
 					state = ACL_USER;
 					break;
 				}
@@ -96,16 +96,17 @@ posix_acl_valid(const struct posix_acl *acl)
 			case ACL_USER:
 				if (state != ACL_USER)
 					return -EINVAL;
-				if (pa->e_id == ACL_UNDEFINED_ID ||
-				    pa->e_id < id)
+				if (!uid_valid(pa->e_uid))
 					return -EINVAL;
-				id = pa->e_id + 1;
+				if (uid_valid(prev_uid) &&
+				    uid_lte(pa->e_uid, prev_uid))
+					return -EINVAL;
+				prev_uid = pa->e_uid;
 				needs_mask = 1;
 				break;
 
 			case ACL_GROUP_OBJ:
 				if (state == ACL_USER) {
-					id = 0;
 					state = ACL_GROUP;
 					break;
 				}
@@ -114,10 +115,12 @@ posix_acl_valid(const struct posix_acl *acl)
 			case ACL_GROUP:
 				if (state != ACL_GROUP)
 					return -EINVAL;
-				if (pa->e_id == ACL_UNDEFINED_ID ||
-				    pa->e_id < id)
+				if (!gid_valid(pa->e_gid))
+					return -EINVAL;
+				if (gid_valid(prev_gid) &&
+				    gid_lte(pa->e_gid, prev_gid))
 					return -EINVAL;
-				id = pa->e_id + 1;
+				prev_gid = pa->e_gid;
 				needs_mask = 1;
 				break;
 
@@ -195,15 +198,12 @@ posix_acl_from_mode(umode_t mode, gfp_t flags)
 		return ERR_PTR(-ENOMEM);
 
 	acl->a_entries[0].e_tag  = ACL_USER_OBJ;
-	acl->a_entries[0].e_id   = ACL_UNDEFINED_ID;
 	acl->a_entries[0].e_perm = (mode & S_IRWXU) >> 6;
 
 	acl->a_entries[1].e_tag  = ACL_GROUP_OBJ;
-	acl->a_entries[1].e_id   = ACL_UNDEFINED_ID;
 	acl->a_entries[1].e_perm = (mode & S_IRWXG) >> 3;
 
 	acl->a_entries[2].e_tag  = ACL_OTHER;
-	acl->a_entries[2].e_id   = ACL_UNDEFINED_ID;
 	acl->a_entries[2].e_perm = (mode & S_IRWXO);
 	return acl;
 }
@@ -224,11 +224,11 @@ posix_acl_permission(struct inode *inode, const struct posix_acl *acl, int want)
                 switch(pa->e_tag) {
                         case ACL_USER_OBJ:
 				/* (May have been checked already) */
-				if (inode->i_uid == current_fsuid())
+				if (uid_eq(inode->i_uid, current_fsuid()))
                                         goto check_perm;
                                 break;
                         case ACL_USER:
-				if (pa->e_id == current_fsuid())
+				if (uid_eq(pa->e_uid, current_fsuid()))
                                         goto mask;
 				break;
                         case ACL_GROUP_OBJ:
@@ -239,7 +239,7 @@ posix_acl_permission(struct inode *inode, const struct posix_acl *acl, int want)
                                 }
 				break;
                         case ACL_GROUP:
-                                if (in_group_p(pa->e_id)) {
+				if (in_group_p(pa->e_gid)) {
 					found = 1;
 					if ((pa->e_perm & want) == want)
 						goto mask;
diff --git a/fs/xattr.c b/fs/xattr.c
index 4d45b71..c111745 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -20,6 +20,7 @@
 #include <linux/fsnotify.h>
 #include <linux/audit.h>
 #include <linux/vmalloc.h>
+#include <linux/posix_acl_xattr.h>
 
 #include <asm/uaccess.h>
 
@@ -347,6 +348,9 @@ setxattr(struct dentry *d, const char __user *name, const void __user *value,
 			error = -EFAULT;
 			goto out;
 		}
+		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
+		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
+			posix_acl_fix_xattr_from_user(kvalue, size);
 	}
 
 	error = vfs_setxattr(d, kname, kvalue, size, flags);
@@ -450,6 +454,9 @@ getxattr(struct dentry *d, const char __user *name, void __user *value,
 
 	error = vfs_getxattr(d, kname, kvalue, size);
 	if (error > 0) {
+		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
+		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
+			posix_acl_fix_xattr_to_user(kvalue, size);
 		if (size && copy_to_user(value, kvalue, error))
 			error = -EFAULT;
 	} else if (error == -ERANGE && size >= XATTR_SIZE_MAX) {
diff --git a/fs/xattr_acl.c b/fs/xattr_acl.c
index 69d06b0..bf472ca 100644
--- a/fs/xattr_acl.c
+++ b/fs/xattr_acl.c
@@ -9,7 +9,65 @@
 #include <linux/fs.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/gfp.h>
+#include <linux/user_namespace.h>
 
+/*
+ * Fix up the uids and gids in posix acl extended attributes in place.
+ */
+static void posix_acl_fix_xattr_userns(
+	struct user_namespace *to, struct user_namespace *from,
+	void *value, size_t size)
+{
+	posix_acl_xattr_header *header = (posix_acl_xattr_header *)value;
+	posix_acl_xattr_entry *entry = (posix_acl_xattr_entry *)(header+1), *end;
+	int count;
+	kuid_t uid;
+	kgid_t gid;
+
+	if (!value)
+		return;
+	if (size < sizeof(posix_acl_xattr_header))
+		return;
+	if (header->a_version != cpu_to_le32(POSIX_ACL_XATTR_VERSION))
+		return;
+
+	count = posix_acl_xattr_count(size);
+	if (count < 0)
+		return;
+	if (count == 0)
+		return;
+
+	for (end = entry + count; entry != end; entry++) {
+		switch(le16_to_cpu(entry->e_tag)) {
+		case ACL_USER:
+			uid = make_kuid(from, le32_to_cpu(entry->e_id));
+			entry->e_id = cpu_to_le32(from_kuid(to, uid));
+			break;
+		case ACL_GROUP:
+			gid = make_kgid(from, le32_to_cpu(entry->e_id));
+			entry->e_id = cpu_to_le32(from_kuid(to, uid));
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+void posix_acl_fix_xattr_from_user(void *value, size_t size)
+{
+	struct user_namespace *user_ns = current_user_ns();
+	if (user_ns == &init_user_ns)
+		return;
+	posix_acl_fix_xattr_userns(&init_user_ns, user_ns, value, size);
+}
+
+void posix_acl_fix_xattr_to_user(void *value, size_t size)
+{
+	struct user_namespace *user_ns = current_user_ns();
+	if (user_ns == &init_user_ns)
+		return;
+	posix_acl_fix_xattr_userns(user_ns, &init_user_ns, value, size);
+}
 
 /*
  * Convert from extended attribute to in-memory representation.
@@ -50,12 +108,21 @@ posix_acl_from_xattr(const void *value, size_t size)
 			case ACL_GROUP_OBJ:
 			case ACL_MASK:
 			case ACL_OTHER:
-				acl_e->e_id = ACL_UNDEFINED_ID;
 				break;
 
 			case ACL_USER:
+				acl_e->e_uid =
+					make_kuid(&init_user_ns,
+						  le32_to_cpu(entry->e_id));
+				if (!uid_valid(acl_e->e_uid))
+					goto fail;
+				break;
 			case ACL_GROUP:
-				acl_e->e_id = le32_to_cpu(entry->e_id);
+				acl_e->e_gid =
+					make_kgid(&init_user_ns,
+						  le32_to_cpu(entry->e_id));
+				if (!gid_valid(acl_e->e_gid))
+					goto fail;
 				break;
 
 			default:
@@ -89,9 +156,22 @@ posix_acl_to_xattr(const struct posix_acl *acl, void *buffer, size_t size)
 	ext_acl->a_version = cpu_to_le32(POSIX_ACL_XATTR_VERSION);
 
 	for (n=0; n < acl->a_count; n++, ext_entry++) {
-		ext_entry->e_tag  = cpu_to_le16(acl->a_entries[n].e_tag);
-		ext_entry->e_perm = cpu_to_le16(acl->a_entries[n].e_perm);
-		ext_entry->e_id   = cpu_to_le32(acl->a_entries[n].e_id);
+		const struct posix_acl_entry *acl_e = &acl->a_entries[n];
+		ext_entry->e_tag  = cpu_to_le16(acl_e->e_tag);
+		ext_entry->e_perm = cpu_to_le16(acl_e->e_perm);
+		switch(acl_e->e_tag) {
+		case ACL_USER:
+			ext_entry->e_id =
+				cpu_to_le32(from_kuid(&init_user_ns, acl_e->e_uid));
+			break;
+		case ACL_GROUP:
+			ext_entry->e_id =
+				cpu_to_le32(from_kgid(&init_user_ns, acl_e->e_gid));
+			break;
+		default:
+			ext_entry->e_id = cpu_to_le32(ACL_UNDEFINED_ID);
+			break;
+		}
 	}
 	return real_size;
 }
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 11bad91..7931efe 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -36,7 +36,13 @@
 struct posix_acl_entry {
 	short			e_tag;
 	unsigned short		e_perm;
-	unsigned int		e_id;
+	union {
+		kuid_t		e_uid;
+		kgid_t		e_gid;
+#ifndef CONFIG_UIDGID_STRICT_TYPE_CHECKS
+		unsigned int	e_id;
+#endif
+	};
 };
 
 struct posix_acl {
diff --git a/include/linux/posix_acl_xattr.h b/include/linux/posix_acl_xattr.h
index 6e53c34..8bd5fcf 100644
--- a/include/linux/posix_acl_xattr.h
+++ b/include/linux/posix_acl_xattr.h
@@ -52,6 +52,18 @@ posix_acl_xattr_count(size_t size)
 	return size / sizeof(posix_acl_xattr_entry);
 }
 
+#ifdef CONFIG_FS_POSIX_ACL
+void posix_acl_fix_xattr_from_user(void *value, size_t size);
+void posix_acl_fix_xattr_to_user(void *value, size_t size);
+#else
+static inline void posix_acl_fix_xattr_from_user(void *value, size_t size)
+{
+}
+static inline void posix_acl_fix_xattr_to_user(void *value, size_t size)
+{
+}
+#endif
+
 struct posix_acl *posix_acl_from_xattr(const void *value, size_t size);
 int posix_acl_to_xattr(const struct posix_acl *acl, void *buffer, size_t size);
 
-- 
1.7.5.4

