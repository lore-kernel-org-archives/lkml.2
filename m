Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab2KTMpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:45:44 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:33035 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2KTMou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:44:50 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Date: Tue, 20 Nov 2012 04:43:37 -0800
Message-Id: <1353415420-5457-9-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353415420-5457-1-git-send-email-ebiederm@xmission.com>
References: <87pq38wimv.fsf@xmission.com>
 <1353415420-5457-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/9NSdTVlpnVA4CRkLoV4U3KYmUM4d4wEI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0661]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 
X-Spam-Combo: *******;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH RFC 09/12] userns: Convert ocfs2 to use kuid and kgid where appropriate
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/ocfs2/acl.c          |   31 +++++++++++++++++++++++++++++--
 fs/ocfs2/dlmglue.c      |    8 ++++----
 fs/ocfs2/file.c         |   11 ++++++-----
 fs/ocfs2/inode.c        |   12 ++++++------
 fs/ocfs2/namei.c        |    4 ++--
 fs/ocfs2/refcounttree.c |    2 +-
 init/Kconfig            |    1 -
 7 files changed, 48 insertions(+), 21 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index 260b162..8a40457 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -65,7 +65,20 @@ static struct posix_acl *ocfs2_acl_from_xattr(const void *value, size_t size)
 
 		acl->a_entries[n].e_tag  = le16_to_cpu(entry->e_tag);
 		acl->a_entries[n].e_perm = le16_to_cpu(entry->e_perm);
-		acl->a_entries[n].e_id   = le32_to_cpu(entry->e_id);
+		switch(acl->a_entries[n].e_tag) {
+		case ACL_USER:
+			acl->a_entries[n].e_uid =
+				make_kuid(&init_user_ns,
+					  le32_to_cpu(entry->e_id));
+			break;
+		case ACL_GROUP:
+			acl->a_entries[n].e_gid =
+				make_kgid(&init_user_ns,
+					  le32_to_cpu(entry->e_id));
+			break;
+		default:
+			break;
+		}
 		value += sizeof(struct posix_acl_entry);
 
 	}
@@ -91,7 +104,21 @@ static void *ocfs2_acl_to_xattr(const struct posix_acl *acl, size_t *size)
 	for (n = 0; n < acl->a_count; n++, entry++) {
 		entry->e_tag  = cpu_to_le16(acl->a_entries[n].e_tag);
 		entry->e_perm = cpu_to_le16(acl->a_entries[n].e_perm);
-		entry->e_id   = cpu_to_le32(acl->a_entries[n].e_id);
+		switch(acl->a_entries[n].e_tag) {
+		case ACL_USER:
+			entry->e_id = cpu_to_le32(
+				from_kuid(&init_user_ns,
+					  acl->a_entries[n].e_uid));
+			break;
+		case ACL_GROUP:
+			entry->e_id = cpu_to_le32(
+				from_kgid(&init_user_ns,
+					  acl->a_entries[n].e_gid));
+			break;
+		default:
+			entry->e_id = cpu_to_le32(ACL_UNDEFINED_ID);
+			break;
+		}
 	}
 	return ocfs2_acl;
 }
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 4f7795f..f99af1c 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2045,8 +2045,8 @@ static void __ocfs2_stuff_meta_lvb(struct inode *inode)
 	lvb->lvb_version   = OCFS2_LVB_VERSION;
 	lvb->lvb_isize	   = cpu_to_be64(i_size_read(inode));
 	lvb->lvb_iclusters = cpu_to_be32(oi->ip_clusters);
-	lvb->lvb_iuid      = cpu_to_be32(inode->i_uid);
-	lvb->lvb_igid      = cpu_to_be32(inode->i_gid);
+	lvb->lvb_iuid      = cpu_to_be32(i_uid_read(inode));
+	lvb->lvb_igid      = cpu_to_be32(i_gid_read(inode));
 	lvb->lvb_imode     = cpu_to_be16(inode->i_mode);
 	lvb->lvb_inlink    = cpu_to_be16(inode->i_nlink);
 	lvb->lvb_iatime_packed  =
@@ -2095,8 +2095,8 @@ static void ocfs2_refresh_inode_from_lvb(struct inode *inode)
 	else
 		inode->i_blocks = ocfs2_inode_sector_count(inode);
 
-	inode->i_uid     = be32_to_cpu(lvb->lvb_iuid);
-	inode->i_gid     = be32_to_cpu(lvb->lvb_igid);
+	i_uid_write(inode, be32_to_cpu(lvb->lvb_iuid));
+	i_gid_write(inode, be32_to_cpu(lvb->lvb_igid));
 	inode->i_mode    = be16_to_cpu(lvb->lvb_imode);
 	set_nlink(inode, be16_to_cpu(lvb->lvb_inlink));
 	ocfs2_unpack_timespec(&inode->i_atime,
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 5a4ee77..dc19b69 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1116,7 +1116,8 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
 			    dentry->d_name.len, dentry->d_name.name,
 			    attr->ia_valid, attr->ia_mode,
-			    attr->ia_uid, attr->ia_gid);
+			    from_kuid(&init_user_ns, attr->ia_uid),
+			    from_kgid(&init_user_ns, attr->ia_gid));
 
 	/* ensuring we don't even attempt to truncate a symlink */
 	if (S_ISLNK(inode->i_mode))
@@ -1174,14 +1175,14 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 		}
 	}
 
-	if ((attr->ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid) ||
-	    (attr->ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid)) {
+	if ((attr->ia_valid & ATTR_UID && !uid_eq(attr->ia_uid, inode->i_uid)) ||
+	    (attr->ia_valid & ATTR_GID && !gid_eq(attr->ia_gid, inode->i_gid))) {
 		/*
 		 * Gather pointers to quota structures so that allocation /
 		 * freeing of quota structures happens here and not inside
 		 * dquot_transfer() where we have problems with lock ordering
 		 */
-		if (attr->ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid
+		if (attr->ia_valid & ATTR_UID && !uid_eq(attr->ia_uid, inode->i_uid)
 		    && OCFS2_HAS_RO_COMPAT_FEATURE(sb,
 		    OCFS2_FEATURE_RO_COMPAT_USRQUOTA)) {
 			transfer_to[USRQUOTA] = dqget(sb, make_kqid_uid(attr->ia_uid));
@@ -1190,7 +1191,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 				goto bail_unlock;
 			}
 		}
-		if (attr->ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid
+		if (attr->ia_valid & ATTR_GID && !gid_eq(attr->ia_gid, inode->i_gid)
 		    && OCFS2_HAS_RO_COMPAT_FEATURE(sb,
 		    OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)) {
 			transfer_to[GRPQUOTA] = dqget(sb, make_kqid_gid(attr->ia_gid));
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index d89e08a..f87f9bd 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -269,8 +269,8 @@ void ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
 	inode->i_generation = le32_to_cpu(fe->i_generation);
 	inode->i_rdev = huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev));
 	inode->i_mode = le16_to_cpu(fe->i_mode);
-	inode->i_uid = le32_to_cpu(fe->i_uid);
-	inode->i_gid = le32_to_cpu(fe->i_gid);
+	i_uid_write(inode, le32_to_cpu(fe->i_uid));
+	i_gid_write(inode, le32_to_cpu(fe->i_gid));
 
 	/* Fast symlinks will have i_size but no allocated clusters. */
 	if (S_ISLNK(inode->i_mode) && !fe->i_clusters) {
@@ -1259,8 +1259,8 @@ int ocfs2_mark_inode_dirty(handle_t *handle,
 
 	fe->i_size = cpu_to_le64(i_size_read(inode));
 	ocfs2_set_links_count(fe, inode->i_nlink);
-	fe->i_uid = cpu_to_le32(inode->i_uid);
-	fe->i_gid = cpu_to_le32(inode->i_gid);
+	fe->i_uid = cpu_to_le32(i_uid_read(inode));
+	fe->i_gid = cpu_to_le32(i_gid_read(inode));
 	fe->i_mode = cpu_to_le16(inode->i_mode);
 	fe->i_atime = cpu_to_le64(inode->i_atime.tv_sec);
 	fe->i_atime_nsec = cpu_to_le32(inode->i_atime.tv_nsec);
@@ -1290,8 +1290,8 @@ void ocfs2_refresh_inode(struct inode *inode,
 	ocfs2_set_inode_flags(inode);
 	i_size_write(inode, le64_to_cpu(fe->i_size));
 	set_nlink(inode, ocfs2_read_links_count(fe));
-	inode->i_uid = le32_to_cpu(fe->i_uid);
-	inode->i_gid = le32_to_cpu(fe->i_gid);
+	i_uid_write(inode, le32_to_cpu(fe->i_uid));
+	i_gid_write(inode, le32_to_cpu(fe->i_gid));
 	inode->i_mode = le16_to_cpu(fe->i_mode);
 	if (S_ISLNK(inode->i_mode) && le32_to_cpu(fe->i_clusters) == 0)
 		inode->i_blocks = 0;
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index f1fd074..04ee1b5 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -512,8 +512,8 @@ static int __ocfs2_mknod_locked(struct inode *dir,
 	fe->i_suballoc_loc = cpu_to_le64(suballoc_loc);
 	fe->i_suballoc_bit = cpu_to_le16(suballoc_bit);
 	fe->i_suballoc_slot = cpu_to_le16(inode_ac->ac_alloc_slot);
-	fe->i_uid = cpu_to_le32(inode->i_uid);
-	fe->i_gid = cpu_to_le32(inode->i_gid);
+	fe->i_uid = cpu_to_le32(i_uid_read(inode));
+	fe->i_gid = cpu_to_le32(i_gid_read(inode));
 	fe->i_mode = cpu_to_le16(inode->i_mode);
 	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode))
 		fe->id1.dev1.i_rdev = cpu_to_le64(huge_encode_dev(dev));
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 30a0550..934a4ac 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4407,7 +4407,7 @@ static int ocfs2_vfs_reflink(struct dentry *old_dentry, struct inode *dir,
 	 * rights to do so.
 	 */
 	if (preserve) {
-		if ((current_fsuid() != inode->i_uid) && !capable(CAP_CHOWN))
+		if (!uid_eq(current_fsuid(), inode->i_uid) && !capable(CAP_CHOWN))
 			return -EPERM;
 		if (!in_group_p(inode->i_gid) && !capable(CAP_CHOWN))
 			return -EPERM;
diff --git a/init/Kconfig b/init/Kconfig
index 1bcc523..ee7e5b6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -999,7 +999,6 @@ config UIDGID_CONVERTED
 	default y
 
 	# Filesystems
-	depends on OCFS2_FS = n
 	depends on XFS_FS = n
 
 config UIDGID_STRICT_TYPE_CHECKS
-- 
1.7.5.4

