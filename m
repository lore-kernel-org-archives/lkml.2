Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab0LERub (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:50:31 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64682 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603Ab0LERu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:50:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WFHnQyGdALsBYGBh+OFO9dFtLva/ILf4lVkIAGu7I4YpR8oxK3mRw8NrYYFE5FYFRM
         4+gzwXtQ+5c1pu1/GJ4sb6VCq8rKxvs7mcS9VLNYQN7AgNGfFAyXRGTigmk+isK5N1NT
         D6Lux4JHYxhBRnuoB1u4wdexfLs3r3I6e4M3w=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 08/45] kstrtox: convert fs/nfs/
Date: Sun,  5 Dec 2010 19:49:05 +0200
Message-Id: <1291571382-2719-8-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
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
index 93a8b3b..05a9f3d 100644
--- a/fs/nfs/callback.c
+++ b/fs/nfs/callback.c
@@ -46,13 +46,15 @@ unsigned short nfs_callback_tcpport6;
 
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
index 4e2d9b6..b3a915a 100644
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
index e6356b7..f12ef9f 100644
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
index 3c04504..ddfdc3c 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1013,7 +1013,8 @@ static int nfs_parse_mount_options(char *raw,
 
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
@@ -1300,13 +1293,13 @@ static int nfs_parse_mount_options(char *raw,
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
1.7.2.2

