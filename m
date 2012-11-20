Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab2KTMok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:44:40 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:32946 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab2KTMof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:44:35 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Petr Vandrovec <petr@vandrovec.name>
Date: Tue, 20 Nov 2012 04:43:35 -0800
Message-Id: <1353415420-5457-7-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353415420-5457-1-git-send-email-ebiederm@xmission.com>
References: <87pq38wimv.fsf@xmission.com>
 <1353415420-5457-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/F4avsAxyFLFJDE/aONEWtfEKDWpt1JFA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2305]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *******;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH RFC 07/12] userns: Convert ncpfs to use kuid and kgid where appropriate
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Petr Vandrovec <petr@vandrovec.name>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/ncpfs/inode.c     |   55 ++++++++++++++++++++++++++++++--------------------
 fs/ncpfs/ioctl.c     |   25 ++++++++++++----------
 fs/ncpfs/ncp_fs_sb.h |    6 ++--
 init/Kconfig         |    1 -
 4 files changed, 50 insertions(+), 37 deletions(-)

diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index d7e9fe7..3dd2cfd 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -331,12 +331,15 @@ static int  ncp_show_options(struct seq_file *seq, struct dentry *root)
 	struct ncp_server *server = NCP_SBP(root->d_sb);
 	unsigned int tmp;
 
-	if (server->m.uid != 0)
-		seq_printf(seq, ",uid=%u", server->m.uid);
-	if (server->m.gid != 0)
-		seq_printf(seq, ",gid=%u", server->m.gid);
-	if (server->m.mounted_uid != 0)
-		seq_printf(seq, ",owner=%u", server->m.mounted_uid);
+	if (!uid_eq(server->m.uid, GLOBAL_ROOT_UID))
+		seq_printf(seq, ",uid=%u",
+			   from_kuid_munged(&init_user_ns, server->m.uid));
+	if (!gid_eq(server->m.gid, GLOBAL_ROOT_GID))
+		seq_printf(seq, ",gid=%u",
+			   from_kgid_munged(&init_user_ns, server->m.gid));
+	if (!uid_eq(server->m.mounted_uid, GLOBAL_ROOT_UID))
+		seq_printf(seq, ",owner=%u",
+			   from_kuid_munged(&init_user_ns, server->m.mounted_uid));
 	tmp = server->m.file_mode & S_IALLUGO;
 	if (tmp != NCP_DEFAULT_FILE_MODE)
 		seq_printf(seq, ",mode=0%o", tmp);
@@ -381,13 +384,13 @@ static int ncp_parse_options(struct ncp_mount_data_kernel *data, char *options)
 
 	data->flags = 0;
 	data->int_flags = 0;
-	data->mounted_uid = 0;
+	data->mounted_uid = GLOBAL_ROOT_UID;
 	data->wdog_pid = NULL;
 	data->ncp_fd = ~0;
 	data->time_out = NCP_DEFAULT_TIME_OUT;
 	data->retry_count = NCP_DEFAULT_RETRY_COUNT;
-	data->uid = 0;
-	data->gid = 0;
+	data->uid = GLOBAL_ROOT_UID;
+	data->gid = GLOBAL_ROOT_GID;
 	data->file_mode = NCP_DEFAULT_FILE_MODE;
 	data->dir_mode = NCP_DEFAULT_DIR_MODE;
 	data->info_fd = -1;
@@ -399,13 +402,19 @@ static int ncp_parse_options(struct ncp_mount_data_kernel *data, char *options)
 			goto err;
 		switch (optval) {
 			case 'u':
-				data->uid = optint;
+				data->uid = make_kuid(current_user_ns(), optint);
+				if (!uid_valid(data->uid))
+					goto err;
 				break;
 			case 'g':
-				data->gid = optint;
+				data->gid = make_kgid(current_user_ns(), optint);
+				if (!gid_valid(data->gid))
+					goto err;
 				break;
 			case 'o':
-				data->mounted_uid = optint;
+				data->mounted_uid = make_kuid(current_user_ns(), optint);
+				if (!uid_valid(data->mounted_uid))
+					goto err;
 				break;
 			case 'm':
 				data->file_mode = optint;
@@ -480,13 +489,13 @@ static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
 
 				data.flags = md->flags;
 				data.int_flags = NCP_IMOUNT_LOGGEDIN_POSSIBLE;
-				data.mounted_uid = md->mounted_uid;
+				data.mounted_uid = make_kuid(current_user_ns(), md->mounted_uid);
 				data.wdog_pid = find_get_pid(md->wdog_pid);
 				data.ncp_fd = md->ncp_fd;
 				data.time_out = md->time_out;
 				data.retry_count = md->retry_count;
-				data.uid = md->uid;
-				data.gid = md->gid;
+				data.uid = make_kuid(current_user_ns(), md->uid);
+				data.gid = make_kgid(current_user_ns(), md->gid);
 				data.file_mode = md->file_mode;
 				data.dir_mode = md->dir_mode;
 				data.info_fd = -1;
@@ -499,13 +508,13 @@ static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
 				struct ncp_mount_data_v4* md = (struct ncp_mount_data_v4*)raw_data;
 
 				data.flags = md->flags;
-				data.mounted_uid = md->mounted_uid;
+				data.mounted_uid = make_kuid(current_user_ns(), md->mounted_uid);
 				data.wdog_pid = find_get_pid(md->wdog_pid);
 				data.ncp_fd = md->ncp_fd;
 				data.time_out = md->time_out;
 				data.retry_count = md->retry_count;
-				data.uid = md->uid;
-				data.gid = md->gid;
+				data.uid = make_kuid(current_user_ns(), md->uid);
+				data.gid = make_kgid(current_user_ns(), md->gid);
 				data.file_mode = md->file_mode;
 				data.dir_mode = md->dir_mode;
 				data.info_fd = -1;
@@ -520,6 +529,10 @@ static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
 				goto out;
 			break;
 	}
+	error = -EINVAL;
+	if (!uid_valid(data.mounted_uid) || !uid_valid(data.uid) ||
+	    !gid_valid(data.gid))
+		goto out;
 	error = -EBADF;
 	ncp_filp = fget(data.ncp_fd);
 	if (!ncp_filp)
@@ -886,12 +899,10 @@ int ncp_notify_change(struct dentry *dentry, struct iattr *attr)
 		goto out;
 
 	result = -EPERM;
-	if (((attr->ia_valid & ATTR_UID) &&
-	     (attr->ia_uid != server->m.uid)))
+	if ((attr->ia_valid & ATTR_UID) && !uid_eq(attr->ia_uid, server->m.uid))
 		goto out;
 
-	if (((attr->ia_valid & ATTR_GID) &&
-	     (attr->ia_gid != server->m.gid)))
+	if ((attr->ia_valid & ATTR_GID) && !gid_eq(attr->ia_gid, server->m.gid))
 		goto out;
 
 	if (((attr->ia_valid & ATTR_MODE) &&
diff --git a/fs/ncpfs/ioctl.c b/fs/ncpfs/ioctl.c
index 6958adf..d44318d 100644
--- a/fs/ncpfs/ioctl.c
+++ b/fs/ncpfs/ioctl.c
@@ -45,7 +45,7 @@ ncp_get_fs_info(struct ncp_server * server, struct inode *inode,
 		return -EINVAL;
 	}
 	/* TODO: info.addr = server->m.serv_addr; */
-	SET_UID(info.mounted_uid, server->m.mounted_uid);
+	SET_UID(info.mounted_uid, from_kuid_munged(current_user_ns(), server->m.mounted_uid));
 	info.connection		= server->connection;
 	info.buffer_size	= server->buffer_size;
 	info.volume_number	= NCP_FINFO(inode)->volNumber;
@@ -69,7 +69,7 @@ ncp_get_fs_info_v2(struct ncp_server * server, struct inode *inode,
 		DPRINTK("info.version invalid: %d\n", info2.version);
 		return -EINVAL;
 	}
-	info2.mounted_uid   = server->m.mounted_uid;
+	info2.mounted_uid   = from_kuid_munged(current_user_ns(), server->m.mounted_uid);
 	info2.connection    = server->connection;
 	info2.buffer_size   = server->buffer_size;
 	info2.volume_number = NCP_FINFO(inode)->volNumber;
@@ -135,7 +135,7 @@ ncp_get_compat_fs_info_v2(struct ncp_server * server, struct inode *inode,
 		DPRINTK("info.version invalid: %d\n", info2.version);
 		return -EINVAL;
 	}
-	info2.mounted_uid   = server->m.mounted_uid;
+	info2.mounted_uid   = from_kuid_munged(current_user_ns(), server->m.mounted_uid);
 	info2.connection    = server->connection;
 	info2.buffer_size   = server->buffer_size;
 	info2.volume_number = NCP_FINFO(inode)->volNumber;
@@ -348,22 +348,25 @@ static long __ncp_ioctl(struct inode *inode, unsigned int cmd, unsigned long arg
 		{
 			u16 uid;
 
-			SET_UID(uid, server->m.mounted_uid);
+			SET_UID(uid, from_kuid_munged(current_user_ns(), server->m.mounted_uid));
 			if (put_user(uid, (u16 __user *)argp))
 				return -EFAULT;
 			return 0;
 		}
 	case NCP_IOC_GETMOUNTUID32:
-		if (put_user(server->m.mounted_uid,
-			     (u32 __user *)argp))
+	{
+		uid_t uid = from_kuid_munged(current_user_ns(), server->m.mounted_uid);
+		if (put_user(uid, (u32 __user *)argp))
 			return -EFAULT;
 		return 0;
+	}
 	case NCP_IOC_GETMOUNTUID64:
-		if (put_user(server->m.mounted_uid,
-			     (u64 __user *)argp))
+	{
+		uid_t uid = from_kuid_munged(current_user_ns(), server->m.mounted_uid);
+		if (put_user(uid, (u64 __user *)argp))
 			return -EFAULT;
 		return 0;
-
+	}
 	case NCP_IOC_GETROOT:
 		{
 			struct ncp_setroot_ioctl sr;
@@ -810,7 +813,7 @@ long ncp_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = filp->f_dentry->d_inode;
 	struct ncp_server *server = NCP_SERVER(inode);
-	uid_t uid = current_uid();
+	kuid_t uid = current_uid();
 	int need_drop_write = 0;
 	long ret;
 
@@ -824,7 +827,7 @@ long ncp_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		}
 		break;
 	}
-	if (server->m.mounted_uid != uid) {
+	if (!uid_eq(server->m.mounted_uid, uid)) {
 		switch (cmd) {
 		/*
 		 * Only mount owner can issue these ioctls.  Information
diff --git a/fs/ncpfs/ncp_fs_sb.h b/fs/ncpfs/ncp_fs_sb.h
index 54cc0cd..c51b2c5 100644
--- a/fs/ncpfs/ncp_fs_sb.h
+++ b/fs/ncpfs/ncp_fs_sb.h
@@ -23,15 +23,15 @@ struct ncp_mount_data_kernel {
 	unsigned long    flags;		/* NCP_MOUNT_* flags */
 	unsigned int	 int_flags;	/* internal flags */
 #define NCP_IMOUNT_LOGGEDIN_POSSIBLE	0x0001
-	uid_t		 mounted_uid;	/* Who may umount() this filesystem? */
+	kuid_t		 mounted_uid;	/* Who may umount() this filesystem? */
 	struct pid      *wdog_pid;	/* Who cares for our watchdog packets? */
 	unsigned int     ncp_fd;	/* The socket to the ncp port */
 	unsigned int     time_out;	/* How long should I wait after
 					   sending a NCP request? */
 	unsigned int     retry_count;	/* And how often should I retry? */
 	unsigned char	 mounted_vol[NCP_VOLNAME_LEN + 1];
-	uid_t		 uid;
-	gid_t		 gid;
+	kuid_t		 uid;
+	kgid_t		 gid;
 	umode_t		 file_mode;
 	umode_t		 dir_mode;
 	int		 info_fd;
diff --git a/init/Kconfig b/init/Kconfig
index 53b61cd..433e6e0 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -999,7 +999,6 @@ config UIDGID_CONVERTED
 	default y
 
 	# Filesystems
-	depends on NCP_FS = n
 	depends on NFSD = n
 	depends on NFS_FS = n
 	depends on OCFS2_FS = n
-- 
1.7.5.4

