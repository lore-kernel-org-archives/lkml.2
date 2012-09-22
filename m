Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014Ab2IVBft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 21:35:49 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56129 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701Ab2IVBfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 21:35:44 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Woodhouse <dwmw2@infradead.org>
Date: Fri, 21 Sep 2012 18:35:06 -0700
Message-Id: <1348277712-30055-5-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348277712-30055-1-git-send-email-ebiederm@xmission.com>
References: <877grmj115.fsf@xmission.com>
 <1348277712-30055-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18jd7QXOFAW3JDjYZyAY6lTtKv6GBdXMQE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1789]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 05/11] userns: Convert jffs2 to use kuid and kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- General routine uid/gid conversion work
- When storing posix acls treat ACL_USER and ACL_GROUP separately
  so I can call from_kuid or from_kgid as appropriate.
- When reading posix acls treat ACL_USER and ACL_GROUP separately
  so I can call make_kuid or make_kgid as appropriate.

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/jffs2/acl.c      |   26 ++++++++++++++++++++------
 fs/jffs2/file.c     |    8 ++++----
 fs/jffs2/fs.c       |   24 +++++++++++++-----------
 fs/jffs2/os-linux.h |    4 ++--
 init/Kconfig        |    1 -
 5 files changed, 39 insertions(+), 24 deletions(-)

diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
index 42e4edc..223283c 100644
--- a/fs/jffs2/acl.c
+++ b/fs/jffs2/acl.c
@@ -94,15 +94,23 @@ static struct posix_acl *jffs2_acl_from_medium(void *value, size_t size)
 			case ACL_MASK:
 			case ACL_OTHER:
 				value += sizeof(struct jffs2_acl_entry_short);
-				acl->a_entries[i].e_id = ACL_UNDEFINED_ID;
 				break;
 
 			case ACL_USER:
+				value += sizeof(struct jffs2_acl_entry);
+				if (value > end)
+					goto fail;
+				acl->a_entries[i].e_uid =
+					make_kuid(&init_user_ns,
+						  je32_to_cpu(entry->e_id));
+				break;
 			case ACL_GROUP:
 				value += sizeof(struct jffs2_acl_entry);
 				if (value > end)
 					goto fail;
-				acl->a_entries[i].e_id = je32_to_cpu(entry->e_id);
+				acl->a_entries[i].e_gid =
+					make_kgid(&init_user_ns,
+						  je32_to_cpu(entry->e_id));
 				break;
 
 			default:
@@ -131,13 +139,19 @@ static void *jffs2_acl_to_medium(const struct posix_acl *acl, size_t *size)
 	header->a_version = cpu_to_je32(JFFS2_ACL_VERSION);
 	e = header + 1;
 	for (i=0; i < acl->a_count; i++) {
+		const struct posix_acl_entry *acl_e = &acl->a_entries[i];
 		entry = e;
-		entry->e_tag = cpu_to_je16(acl->a_entries[i].e_tag);
-		entry->e_perm = cpu_to_je16(acl->a_entries[i].e_perm);
-		switch(acl->a_entries[i].e_tag) {
+		entry->e_tag = cpu_to_je16(acl_e->e_tag);
+		entry->e_perm = cpu_to_je16(acl_e->e_perm);
+		switch(acl_e->e_tag) {
 			case ACL_USER:
+				entry->e_id = cpu_to_je32(
+					from_kuid(&init_user_ns, acl_e->e_uid));
+				e += sizeof(struct jffs2_acl_entry);
+				break;
 			case ACL_GROUP:
-				entry->e_id = cpu_to_je32(acl->a_entries[i].e_id);
+				entry->e_id = cpu_to_je32(
+					from_kgid(&init_user_ns, acl_e->e_gid));
 				e += sizeof(struct jffs2_acl_entry);
 				break;
 
diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index db3889b..60ef3fb 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -175,8 +175,8 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 		ri.ino = cpu_to_je32(f->inocache->ino);
 		ri.version = cpu_to_je32(++f->highest_version);
 		ri.mode = cpu_to_jemode(inode->i_mode);
-		ri.uid = cpu_to_je16(inode->i_uid);
-		ri.gid = cpu_to_je16(inode->i_gid);
+		ri.uid = cpu_to_je16(i_uid_read(inode));
+		ri.gid = cpu_to_je16(i_gid_read(inode));
 		ri.isize = cpu_to_je32(max((uint32_t)inode->i_size, pageofs));
 		ri.atime = ri.ctime = ri.mtime = cpu_to_je32(get_seconds());
 		ri.offset = cpu_to_je32(inode->i_size);
@@ -283,8 +283,8 @@ static int jffs2_write_end(struct file *filp, struct address_space *mapping,
 	/* Set the fields that the generic jffs2_write_inode_range() code can't find */
 	ri->ino = cpu_to_je32(inode->i_ino);
 	ri->mode = cpu_to_jemode(inode->i_mode);
-	ri->uid = cpu_to_je16(inode->i_uid);
-	ri->gid = cpu_to_je16(inode->i_gid);
+	ri->uid = cpu_to_je16(i_uid_read(inode));
+	ri->gid = cpu_to_je16(i_gid_read(inode));
 	ri->isize = cpu_to_je32((uint32_t)inode->i_size);
 	ri->atime = ri->ctime = ri->mtime = cpu_to_je32(get_seconds());
 
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index 3d3092e..fe3c052 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -99,8 +99,10 @@ int jffs2_do_setattr (struct inode *inode, struct iattr *iattr)
 	ri->ino = cpu_to_je32(inode->i_ino);
 	ri->version = cpu_to_je32(++f->highest_version);
 
-	ri->uid = cpu_to_je16((ivalid & ATTR_UID)?iattr->ia_uid:inode->i_uid);
-	ri->gid = cpu_to_je16((ivalid & ATTR_GID)?iattr->ia_gid:inode->i_gid);
+	ri->uid = cpu_to_je16((ivalid & ATTR_UID)?
+		from_kuid(&init_user_ns, iattr->ia_uid):i_uid_read(inode));
+	ri->gid = cpu_to_je16((ivalid & ATTR_GID)?
+		from_kgid(&init_user_ns, iattr->ia_gid):i_gid_read(inode));
 
 	if (ivalid & ATTR_MODE)
 		ri->mode = cpu_to_jemode(iattr->ia_mode);
@@ -147,8 +149,8 @@ int jffs2_do_setattr (struct inode *inode, struct iattr *iattr)
 	inode->i_ctime = ITIME(je32_to_cpu(ri->ctime));
 	inode->i_mtime = ITIME(je32_to_cpu(ri->mtime));
 	inode->i_mode = jemode_to_cpu(ri->mode);
-	inode->i_uid = je16_to_cpu(ri->uid);
-	inode->i_gid = je16_to_cpu(ri->gid);
+	i_uid_write(inode, je16_to_cpu(ri->uid));
+	i_gid_write(inode, je16_to_cpu(ri->gid));
 
 
 	old_metadata = f->metadata;
@@ -276,8 +278,8 @@ struct inode *jffs2_iget(struct super_block *sb, unsigned long ino)
 		return ERR_PTR(ret);
 	}
 	inode->i_mode = jemode_to_cpu(latest_node.mode);
-	inode->i_uid = je16_to_cpu(latest_node.uid);
-	inode->i_gid = je16_to_cpu(latest_node.gid);
+	i_uid_write(inode, je16_to_cpu(latest_node.uid));
+	i_gid_write(inode, je16_to_cpu(latest_node.gid));
 	inode->i_size = je32_to_cpu(latest_node.isize);
 	inode->i_atime = ITIME(je32_to_cpu(latest_node.atime));
 	inode->i_mtime = ITIME(je32_to_cpu(latest_node.mtime));
@@ -440,14 +442,14 @@ struct inode *jffs2_new_inode (struct inode *dir_i, umode_t mode, struct jffs2_r
 
 	memset(ri, 0, sizeof(*ri));
 	/* Set OS-specific defaults for new inodes */
-	ri->uid = cpu_to_je16(current_fsuid());
+	ri->uid = cpu_to_je16(from_kuid(&init_user_ns, current_fsuid()));
 
 	if (dir_i->i_mode & S_ISGID) {
-		ri->gid = cpu_to_je16(dir_i->i_gid);
+		ri->gid = cpu_to_je16(i_gid_read(dir_i));
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else {
-		ri->gid = cpu_to_je16(current_fsgid());
+		ri->gid = cpu_to_je16(from_kgid(&init_user_ns, current_fsgid()));
 	}
 
 	/* POSIX ACLs have to be processed now, at least partly.
@@ -467,8 +469,8 @@ struct inode *jffs2_new_inode (struct inode *dir_i, umode_t mode, struct jffs2_r
 	set_nlink(inode, 1);
 	inode->i_ino = je32_to_cpu(ri->ino);
 	inode->i_mode = jemode_to_cpu(ri->mode);
-	inode->i_gid = je16_to_cpu(ri->gid);
-	inode->i_uid = je16_to_cpu(ri->uid);
+	i_gid_write(inode, je16_to_cpu(ri->gid));
+	i_uid_write(inode, je16_to_cpu(ri->uid));
 	inode->i_atime = inode->i_ctime = inode->i_mtime = CURRENT_TIME_SEC;
 	ri->atime = ri->mtime = ri->ctime = cpu_to_je32(I_SEC(inode->i_mtime));
 
diff --git a/fs/jffs2/os-linux.h b/fs/jffs2/os-linux.h
index bcd983d..d200a9b 100644
--- a/fs/jffs2/os-linux.h
+++ b/fs/jffs2/os-linux.h
@@ -27,8 +27,8 @@ struct kvec;
 
 #define JFFS2_F_I_SIZE(f) (OFNI_EDONI_2SFFJ(f)->i_size)
 #define JFFS2_F_I_MODE(f) (OFNI_EDONI_2SFFJ(f)->i_mode)
-#define JFFS2_F_I_UID(f) (OFNI_EDONI_2SFFJ(f)->i_uid)
-#define JFFS2_F_I_GID(f) (OFNI_EDONI_2SFFJ(f)->i_gid)
+#define JFFS2_F_I_UID(f) (i_uid_read(OFNI_EDONI_2SFFJ(f)))
+#define JFFS2_F_I_GID(f) (i_gid_read(OFNI_EDONI_2SFFJ(f)))
 #define JFFS2_F_I_RDEV(f) (OFNI_EDONI_2SFFJ(f)->i_rdev)
 
 #define ITIME(sec) ((struct timespec){sec, 0})
diff --git a/init/Kconfig b/init/Kconfig
index 1db1b0f..cf2d50b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -935,7 +935,6 @@ config UIDGID_CONVERTED
 	depends on CODA_FS = n
 	depends on FUSE_FS = n
 	depends on GFS2_FS = n
-	depends on JFFS2_FS = n
 	depends on JFS_FS = n
 	depends on NCP_FS = n
 	depends on NFSD = n
-- 
1.7.5.4

