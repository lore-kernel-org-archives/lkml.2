Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab2ITMW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:22:59 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:54167 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab2ITMLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:11:30 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Anton Altaparmakov <anton@tuxera.com>
Date: Thu, 20 Sep 2012 04:42:00 -0700
Message-Id: <1348141326-23355-19-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
References: <877grox6ql.fsf@xmission.com>
 <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18/M6v3h7SveOxA/S2yOdbcxYXWbc21fAw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0062]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 19/25] userns: Convert ntfs to use kuid and kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Anton Altaparmakov <anton@tuxera.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/ntfs/inode.c  |    7 ++++---
 fs/ntfs/super.c  |   39 ++++++++++++++++++++++++++++++++-------
 fs/ntfs/volume.h |    5 +++--
 init/Kconfig     |    1 -
 4 files changed, 39 insertions(+), 13 deletions(-)

diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index c6dbd3d..1d27331 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -2124,7 +2124,8 @@ int ntfs_read_inode_mount(struct inode *vi)
 			 * ntfs_read_inode() will have set up the default ones.
 			 */
 			/* Set uid and gid to root. */
-			vi->i_uid = vi->i_gid = 0;
+			vi->i_uid = GLOBAL_ROOT_UID;
+			vi->i_gid = GLOBAL_ROOT_GID;
 			/* Regular file. No access for anyone. */
 			vi->i_mode = S_IFREG;
 			/* No VFS initiated operations allowed for $MFT. */
@@ -2312,8 +2313,8 @@ int ntfs_show_options(struct seq_file *sf, struct dentry *root)
 	ntfs_volume *vol = NTFS_SB(root->d_sb);
 	int i;
 
-	seq_printf(sf, ",uid=%i", vol->uid);
-	seq_printf(sf, ",gid=%i", vol->gid);
+	seq_printf(sf, ",uid=%i", from_kuid_munged(&init_user_ns, vol->uid));
+	seq_printf(sf, ",gid=%i", from_kgid_munged(&init_user_ns, vol->gid));
 	if (vol->fmask == vol->dmask)
 		seq_printf(sf, ",umask=0%o", vol->fmask);
 	else {
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 2bc149d..da01c16 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -102,8 +102,8 @@ static bool parse_options(ntfs_volume *vol, char *opt)
 	char *p, *v, *ov;
 	static char *utf8 = "utf8";
 	int errors = 0, sloppy = 0;
-	uid_t uid = (uid_t)-1;
-	gid_t gid = (gid_t)-1;
+	kuid_t uid = INVALID_UID;
+	kgid_t gid = INVALID_GID;
 	umode_t fmask = (umode_t)-1, dmask = (umode_t)-1;
 	int mft_zone_multiplier = -1, on_errors = -1;
 	int show_sys_files = -1, case_sensitive = -1, disable_sparse = -1;
@@ -128,6 +128,30 @@ static bool parse_options(ntfs_volume *vol, char *opt)
 		if (*v)							\
 			goto needs_val;					\
 	}
+#define NTFS_GETOPT_UID(option, variable)				\
+	if (!strcmp(p, option)) {					\
+		uid_t uid_value;					\
+		if (!v || !*v)						\
+			goto needs_arg;					\
+		uid_value = simple_strtoul(ov = v, &v, 0);		\
+		if (*v)							\
+			goto needs_val;					\
+		variable = make_kuid(current_user_ns(), uid_value);	\
+		if (!uid_valid(variable))				\
+			goto needs_val;					\
+	}
+#define NTFS_GETOPT_GID(option, variable)				\
+	if (!strcmp(p, option)) {					\
+		gid_t gid_value;					\
+		if (!v || !*v)						\
+			goto needs_arg;					\
+		gid_value = simple_strtoul(ov = v, &v, 0);		\
+		if (*v)							\
+			goto needs_val;					\
+		variable = make_kgid(current_user_ns(), gid_value);	\
+		if (!gid_valid(variable))				\
+			goto needs_val;					\
+	}
 #define NTFS_GETOPT_OCTAL(option, variable)				\
 	if (!strcmp(p, option)) {					\
 		if (!v || !*v)						\
@@ -165,8 +189,8 @@ static bool parse_options(ntfs_volume *vol, char *opt)
 	while ((p = strsep(&opt, ","))) {
 		if ((v = strchr(p, '=')))
 			*v++ = 0;
-		NTFS_GETOPT("uid", uid)
-		else NTFS_GETOPT("gid", gid)
+		NTFS_GETOPT_UID("uid", uid)
+		else NTFS_GETOPT_GID("gid", gid)
 		else NTFS_GETOPT_OCTAL("umask", fmask = dmask)
 		else NTFS_GETOPT_OCTAL("fmask", fmask)
 		else NTFS_GETOPT_OCTAL("dmask", dmask)
@@ -283,9 +307,9 @@ no_mount_options:
 		vol->on_errors = on_errors;
 	if (!vol->on_errors || vol->on_errors == ON_ERRORS_RECOVER)
 		vol->on_errors |= ON_ERRORS_CONTINUE;
-	if (uid != (uid_t)-1)
+	if (uid_valid(uid))
 		vol->uid = uid;
-	if (gid != (gid_t)-1)
+	if (gid_valid(gid))
 		vol->gid = gid;
 	if (fmask != (umode_t)-1)
 		vol->fmask = fmask;
@@ -1023,7 +1047,8 @@ static bool load_and_init_mft_mirror(ntfs_volume *vol)
 	 * ntfs_read_inode() will have set up the default ones.
 	 */
 	/* Set uid and gid to root. */
-	tmp_ino->i_uid = tmp_ino->i_gid = 0;
+	tmp_ino->i_uid = GLOBAL_ROOT_UID;
+	tmp_ino->i_gid = GLOBAL_ROOT_GID;
 	/* Regular file.  No access for anyone. */
 	tmp_ino->i_mode = S_IFREG;
 	/* No VFS initiated operations allowed for $MFTMirr. */
diff --git a/fs/ntfs/volume.h b/fs/ntfs/volume.h
index 15e3ba8..4f579b0 100644
--- a/fs/ntfs/volume.h
+++ b/fs/ntfs/volume.h
@@ -25,6 +25,7 @@
 #define _LINUX_NTFS_VOLUME_H
 
 #include <linux/rwsem.h>
+#include <linux/uidgid.h>
 
 #include "types.h"
 #include "layout.h"
@@ -46,8 +47,8 @@ typedef struct {
 					   sized blocks on the device. */
 	/* Configuration provided by user at mount time. */
 	unsigned long flags;		/* Miscellaneous flags, see below. */
-	uid_t uid;			/* uid that files will be mounted as. */
-	gid_t gid;			/* gid that files will be mounted as. */
+	kuid_t uid;			/* uid that files will be mounted as. */
+	kgid_t gid;			/* gid that files will be mounted as. */
 	umode_t fmask;			/* The mask for file permissions. */
 	umode_t dmask;			/* The mask for directory
 					   permissions. */
diff --git a/init/Kconfig b/init/Kconfig
index 90c9e06..0f65a02 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -949,7 +949,6 @@ config UIDGID_CONVERTED
 	depends on NCP_FS = n
 	depends on NFSD = n
 	depends on NFS_FS = n
-	depends on NTFS_FS = n
 	depends on OCFS2_FS = n
 	depends on OMFS_FS = n
 	depends on QNX4FS_FS = n
-- 
1.7.5.4

