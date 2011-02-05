Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab1BEOV2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:21:28 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57576 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab1BEOV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:21:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wGJzWKECQPmXRM8QjPXFHjEQvqfA2swHTp838AeIe935zMi4WxzHQCSYEd3Dg4Ity3
         dVBxhnFhUVs3Bkfat2we6HqpramCLGh0FJgLcy7YVzStzM5eVKvEUlfKiPwH1MqLqpup
         2QtVU1ILPWN3UvEOMRCLReO9jwhxiP2g255PM=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 08/52] kstrtox: convert fs/nfs/
Date: Sat,  5 Feb 2011 16:20:11 +0200
Message-Id: <1296915654-7458-8-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/nfs/callback.c |    8 +++--
 fs/nfs/idmap.c    |   12 +++------
 fs/nfs/internal.h |    8 +++---
 fs/nfs/super.c    |   73 ++++++++++++++++++++++++-----------------------------
 4 files changed, 46 insertions(+), 55 deletions(-)

diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
index e3d2942..0c8b5d8 100644
--- a/fs/nfs/callback.c
+++ b/fs/nfs/callback.c
@@ -44,13 +44,15 @@ unsigned short nfs_callback_tcpport6;
 
 static int param_set_portnr(const char *val, const struct kernel_param *kp)
 {
-	unsigned long num;
+	unsigned int num;
 	int ret;
 
 	if (!val)
 		return -EINVAL;
-	ret = strict_strtoul(val, 0, &num);
-	if (ret == -EINVAL || num > NFS_CALLBACK_MAXPORTNR)
+	ret = kstrtouint(val, 0, &num);
+	if (ret < 0)
+		return ret;
+	if (num > NFS_CALLBACK_MAXPORTNR)
 		return -EINVAL;
 	*((unsigned int *)kp->arg) = num;
 	return 0;
diff --git a/fs/nfs/idmap.c b/fs/nfs/idmap.c
index 1869688..714def8 100644
--- a/fs/nfs/idmap.c
+++ b/fs/nfs/idmap.c
@@ -205,17 +205,13 @@ static int nfs_idmap_lookup_id(const char *name, size_t namelen,
 				const char *type, __u32 *id)
 {
 	char id_str[NFS_UINT_MAXLEN];
-	long id_long;
 	ssize_t data_size;
-	int ret = 0;
+	int ret;
 
 	data_size = nfs_idmap_request_key(name, namelen, type, id_str, NFS_UINT_MAXLEN);
-	if (data_size <= 0) {
-		ret = -EINVAL;
-	} else {
-		ret = strict_strtol(id_str, 10, &id_long);
-		*id = (__u32)id_long;
-	}
+	ret = -EINVAL;
+	if (data_size > 0)
+		ret = kstrtou32(id_str, 10, id);
 	return ret;
 }
 
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index cf9fdbd..6415783 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -73,11 +73,11 @@ struct nfs_clone_mount {
  */
 struct nfs_parsed_mount_data {
 	int			flags;
-	int			rsize, wsize;
-	int			timeo, retrans;
-	int			acregmin, acregmax,
+	unsigned int		rsize, wsize;
+	unsigned int		timeo, retrans;
+	unsigned int		acregmin, acregmax,
 				acdirmin, acdirmax;
-	int			namlen;
+	unsigned int		namlen;
 	unsigned int		options;
 	unsigned int		bsize;
 	unsigned int		auth_flavor_len;
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index b68c860..1902bd4 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1015,7 +1015,8 @@ static int nfs_parse_mount_options(char *raw,
 
 	while ((p = strsep(&raw, ",")) != NULL) {
 		substring_t args[MAX_OPT_ARGS];
-		unsigned long option;
+		unsigned int val_uint;
+		u16 val_u16;
 		int token;
 
 		if (!*p)
@@ -1130,154 +1131,146 @@ static int nfs_parse_mount_options(char *raw,
 			string = match_strdup(args);
 			if (string == NULL)
 				goto out_nomem;
-			rc = strict_strtoul(string, 10, &option);
+			rc = kstrtou16(string, 10, &val_u16);
 			kfree(string);
-			if (rc != 0 || option > USHRT_MAX)
+			if (rc != 0)
 				goto out_invalid_value;
-			mnt->nfs_server.port = option;
+			mnt->nfs_server.port = val_u16;
 			break;
 		case Opt_rsize:
 			string = match_strdup(args);
 			if (string == NULL)
 				goto out_nomem;
-			rc = strict_strtoul(string, 10, &option);
+			rc = kstrtouint(string, 10, &mnt->rsize);
 			kfree(string);
 			if (rc != 0)
 				goto out_invalid_value;
-			mnt->rsize = option;
 			break;
 		case Opt_wsize:
 			string = match_strdup(args);
 			if (string == NULL)
 				goto out_nomem;
-			rc = strict_strtoul(string, 10, &option);
+			rc = kstrtouint(string, 10, &mnt->wsize);
 			kfree(string);
 			if (rc != 0)
 				goto out_invalid_value;
-			mnt->wsize = option;
 			break;
 		case Opt_bsize:
 			string = match_strdup(args);
 			if (string == NULL)
 				goto out_nomem;
-			rc = strict_strtoul(string, 10, &option);
+			rc = kstrtouint(string, 10, &mnt->bsize);
 			kfree(string);
 			if (rc != 0)
 				goto out_invalid_value;
-			mnt->bsize = option;
 			break;
 		case Opt_timeo:
 			string = match_strdup(args);
 			if (string == NULL)
 				goto out_nomem;
-			rc = strict_strtoul(string, 10, &option);
+			rc = kstrtouint(string, 10, &val_uint);
 			kfree(string);
-			if (rc != 0 || option == 0)
+			if (rc != 0 || val_uint == 0)
 				goto out_invalid_value;
-			mnt->timeo = option;
+			mnt->timeo = val_uint;
 			break;
 		case Opt_retrans:
 			string = match_strdup(args);
 			if (string == NULL)
 				goto out_nomem;
-			rc = strict_strtoul(string, 10, &option);
+			rc = kstrtouint(string, 10, &val_uint);
 			kfree(string);
-			if (rc != 0 || option == 0)
+			if (rc != 0 || val_uint == 0)
 				goto out_invalid_value;
-			mnt->retrans = option;
+			mnt->retrans = val_uint;
 			break;
 		case Opt_acregmin:
 			string = match_strdup(args);
 			if (string == NULL)
 				goto out_nomem;
-			rc = strict_strtoul(string, 10, &option);
+			rc = kstrtouint(string, 10, &mnt->acregmin);
 			kfree(string);
 			if (rc != 0)
 				goto out_invalid_value;
-			mnt->acregmin = option;
 			break;
 		case Opt_acregmax:
 			string = match_strdup(args);
 			if (string == NULL)
 				goto out_nomem;
-			rc = strict_strtoul(string, 10, &option);
+			rc = kstrtouint(string, 10, &mnt->acregmax);
 			kfree(string);
 			if (rc != 0)
 				goto out_invalid_value;
-			mnt->acregmax = option;
 			break;
 		case Opt_acdirmin:
 			string = match_strdup(args);
 			if (string == NULL)
 				goto out_nomem;
-			rc = strict_strtoul(string, 10, &option);
+			rc = kstrtouint(string, 10, &mnt->acdirmin);
 			kfree(string);
 			if (rc != 0)
 				goto out_invalid_value;
-			mnt->acdirmin = option;
 			break;
 		case Opt_acdirmax:
 			string = match_strdup(args);
 			if (string == NULL)
 				goto out_nomem;
-			rc = strict_strtoul(string, 10, &option);
+			rc = kstrtouint(string, 10, &mnt->acdirmax);
 			kfree(string);
 			if (rc != 0)
 				goto out_invalid_value;
-			mnt->acdirmax = option;
 			break;
 		case Opt_actimeo:
 			string = match_strdup(args);
 			if (string == NULL)
 				goto out_nomem;
-			rc = strict_strtoul(string, 10, &option);
+			rc = kstrtouint(string, 10, &val_uint);
 			kfree(string);
 			if (rc != 0)
 				goto out_invalid_value;
 			mnt->acregmin = mnt->acregmax =
-			mnt->acdirmin = mnt->acdirmax = option;
+			mnt->acdirmin = mnt->acdirmax = val_uint;
 			break;
 		case Opt_namelen:
 			string = match_strdup(args);
 			if (string == NULL)
 				goto out_nomem;
-			rc = strict_strtoul(string, 10, &option);
+			rc = kstrtouint(string, 10, &mnt->namlen);
 			kfree(string);
 			if (rc != 0)
 				goto out_invalid_value;
-			mnt->namlen = option;
 			break;
 		case Opt_mountport:
 			string = match_strdup(args);
 			if (string == NULL)
 				goto out_nomem;
-			rc = strict_strtoul(string, 10, &option);
+			rc = kstrtou16(string, 10, &val_u16);
 			kfree(string);
-			if (rc != 0 || option > USHRT_MAX)
+			if (rc != 0)
 				goto out_invalid_value;
-			mnt->mount_server.port = option;
+			mnt->mount_server.port = val_u16;
 			break;
 		case Opt_mountvers:
 			string = match_strdup(args);
 			if (string == NULL)
 				goto out_nomem;
-			rc = strict_strtoul(string, 10, &option);
+			rc = kstrtouint(string, 10, &val_uint);
 			kfree(string);
 			if (rc != 0 ||
-			    option < NFS_MNT_VERSION ||
-			    option > NFS_MNT3_VERSION)
+			    val_uint < NFS_MNT_VERSION ||
+			    val_uint > NFS_MNT3_VERSION)
 				goto out_invalid_value;
-			mnt->mount_server.version = option;
+			mnt->mount_server.version = val_uint;
 			break;
 		case Opt_nfsvers:
 			string = match_strdup(args);
 			if (string == NULL)
 				goto out_nomem;
-			rc = strict_strtoul(string, 10, &option);
+			rc = kstrtouint(string, 10, &val_uint);
 			kfree(string);
 			if (rc != 0)
 				goto out_invalid_value;
-			switch (option) {
+			switch (val_uint) {
 			case NFS2_VERSION:
 				mnt->flags &= ~NFS_MOUNT_VER3;
 				mnt->version = 2;
@@ -1298,13 +1291,13 @@ static int nfs_parse_mount_options(char *raw,
 			string = match_strdup(args);
 			if (string == NULL)
 				goto out_nomem;
-			rc = strict_strtoul(string, 10, &option);
+			rc = kstrtouint(string, 10, &val_uint);
 			kfree(string);
 			if (rc != 0)
 				goto out_invalid_value;
-			if (option > NFS4_MAX_MINOR_VERSION)
+			if (val_uint > NFS4_MAX_MINOR_VERSION)
 				goto out_invalid_value;
-			mnt->minorversion = option;
+			mnt->minorversion = val_uint;
 			break;
 
 		/*
-- 
1.7.3.4

