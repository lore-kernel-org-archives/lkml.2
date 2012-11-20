Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab2KTMo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:44:28 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:50465 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab2KTMoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:44:22 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jan Harkes <jaharkes@cs.cmu.edu>
Date: Tue, 20 Nov 2012 04:43:33 -0800
Message-Id: <1353415420-5457-5-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353415420-5457-1-git-send-email-ebiederm@xmission.com>
References: <87pq38wimv.fsf@xmission.com>
 <1353415420-5457-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1+WCEpPAnaR5uXch23u14LbOZi4D4nRvgA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0318]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 
X-Spam-Combo: ****;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH RFC 05/12] userns: Convert coda's to use kuid/kgid where appropriate
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/coda/cache.c            |    4 ++--
 fs/coda/coda_fs_i.h        |    2 +-
 fs/coda/coda_linux.c       |    8 ++++----
 fs/coda/inode.c            |    2 +-
 fs/coda/upcall.c           |    6 +++---
 include/linux/coda_psdev.h |    2 +-
 init/Kconfig               |    1 -
 7 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/coda/cache.c b/fs/coda/cache.c
index 958ae0e..1da168c 100644
--- a/fs/coda/cache.c
+++ b/fs/coda/cache.c
@@ -33,7 +33,7 @@ void coda_cache_enter(struct inode *inode, int mask)
 
 	spin_lock(&cii->c_lock);
 	cii->c_cached_epoch = atomic_read(&permission_epoch);
-	if (cii->c_uid != current_fsuid()) {
+	if (!uid_eq(cii->c_uid, current_fsuid())) {
 		cii->c_uid = current_fsuid();
                 cii->c_cached_perm = mask;
         } else
@@ -65,7 +65,7 @@ int coda_cache_check(struct inode *inode, int mask)
 	
 	spin_lock(&cii->c_lock);
 	hit = (mask & cii->c_cached_perm) == mask &&
-	    cii->c_uid == current_fsuid() &&
+	    uid_eq(cii->c_uid, current_fsuid()) &&
 	    cii->c_cached_epoch == atomic_read(&permission_epoch);
 	spin_unlock(&cii->c_lock);
 
diff --git a/fs/coda/coda_fs_i.h b/fs/coda/coda_fs_i.h
index b24fdfd..c640752 100644
--- a/fs/coda/coda_fs_i.h
+++ b/fs/coda/coda_fs_i.h
@@ -25,7 +25,7 @@ struct coda_inode_info {
 	u_short	           c_flags;     /* flags (see below) */
 	unsigned int	   c_mapcount;  /* nr of times this inode is mapped */
 	unsigned int	   c_cached_epoch; /* epoch for cached permissions */
-	vuid_t		   c_uid;	/* fsuid for cached permissions */
+	kuid_t		   c_uid;	/* fsuid for cached permissions */
 	unsigned int       c_cached_perm; /* cached access permissions */
 	spinlock_t	   c_lock;
 	struct inode	   vfs_inode;
diff --git a/fs/coda/coda_linux.c b/fs/coda/coda_linux.c
index 854ace7..38a0a6e 100644
--- a/fs/coda/coda_linux.c
+++ b/fs/coda/coda_linux.c
@@ -100,9 +100,9 @@ void coda_vattr_to_iattr(struct inode *inode, struct coda_vattr *attr)
 	if (attr->va_mode != (u_short) -1)
 	        inode->i_mode = attr->va_mode | inode_type;
         if (attr->va_uid != -1) 
-	        inode->i_uid = (uid_t) attr->va_uid;
+		i_uid_write(inode, (uid_t) attr->va_uid);
         if (attr->va_gid != -1)
-	        inode->i_gid = (gid_t) attr->va_gid;
+		i_gid_write(inode, (gid_t) attr->va_gid);
 	if (attr->va_nlink != -1)
 		set_nlink(inode, attr->va_nlink);
 	if (attr->va_size != -1)
@@ -171,10 +171,10 @@ void coda_iattr_to_vattr(struct iattr *iattr, struct coda_vattr *vattr)
                 vattr->va_mode = iattr->ia_mode;
 	}
         if ( valid & ATTR_UID ) {
-                vattr->va_uid = (vuid_t) iattr->ia_uid;
+                vattr->va_uid = (vuid_t) from_kuid(&init_user_ns, iattr->ia_uid);
 	}
         if ( valid & ATTR_GID ) {
-                vattr->va_gid = (vgid_t) iattr->ia_gid;
+                vattr->va_gid = (vgid_t) from_kgid(&init_user_ns, iattr->ia_gid);
 	}
         if ( valid & ATTR_SIZE ) {
                 vattr->va_size = iattr->ia_size;
diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index be2aa49..19a8018 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -48,7 +48,7 @@ static struct inode *coda_alloc_inode(struct super_block *sb)
 		return NULL;
 	memset(&ei->c_fid, 0, sizeof(struct CodaFid));
 	ei->c_flags = 0;
-	ei->c_uid = 0;
+	ei->c_uid = GLOBAL_ROOT_UID;
 	ei->c_cached_perm = 0;
 	spin_lock_init(&ei->c_lock);
 	return &ei->vfs_inode;
diff --git a/fs/coda/upcall.c b/fs/coda/upcall.c
index 0c68fd3..efbc665 100644
--- a/fs/coda/upcall.c
+++ b/fs/coda/upcall.c
@@ -52,7 +52,7 @@ static void *alloc_upcall(int opcode, int size)
         inp->ih.opcode = opcode;
 	inp->ih.pid = current->pid;
 	inp->ih.pgid = task_pgrp_nr(current);
-	inp->ih.uid = current_fsuid();
+	inp->ih.uid = from_kuid(&init_user_ns, current_fsuid());
 
 	return (void*)inp;
 }
@@ -157,7 +157,7 @@ int venus_lookup(struct super_block *sb, struct CodaFid *fid,
 }
 
 int venus_close(struct super_block *sb, struct CodaFid *fid, int flags,
-		vuid_t uid)
+		kuid_t uid)
 {
 	union inputArgs *inp;
 	union outputArgs *outp;
@@ -166,7 +166,7 @@ int venus_close(struct super_block *sb, struct CodaFid *fid, int flags,
 	insize = SIZE(release);
 	UPARG(CODA_CLOSE);
 	
-	inp->ih.uid = uid;
+	inp->ih.uid = from_kuid(&init_user_ns, uid);
         inp->coda_close.VFid = *fid;
         inp->coda_close.flags = flags;
 
diff --git a/include/linux/coda_psdev.h b/include/linux/coda_psdev.h
index 8031d6e..5b8721e 100644
--- a/include/linux/coda_psdev.h
+++ b/include/linux/coda_psdev.h
@@ -34,7 +34,7 @@ int venus_lookup(struct super_block *sb, struct CodaFid *fid,
 		 const char *name, int length, int *type, 
 		 struct CodaFid *resfid);
 int venus_close(struct super_block *sb, struct CodaFid *fid, int flags,
-		vuid_t uid);
+		kuid_t uid);
 int venus_open(struct super_block *sb, struct CodaFid *fid, int flags,
 	       struct file **f);
 int venus_mkdir(struct super_block *sb, struct CodaFid *dirfid, 
diff --git a/init/Kconfig b/init/Kconfig
index 58959ea..2573664 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -999,7 +999,6 @@ config UIDGID_CONVERTED
 	default y
 
 	# Filesystems
-	depends on CODA_FS = n
 	depends on GFS2_FS = n
 	depends on NCP_FS = n
 	depends on NFSD = n
-- 
1.7.5.4

