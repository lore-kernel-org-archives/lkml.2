Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab0FDOLH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 10:11:07 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:55617 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756035Ab0FDOLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 10:11:05 -0400
To: miklos@szeredi.hu
Cc: viro@ZenIV.linux.org.uk, akpm@linux-foundation.org,
       john.johansen@canonical.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vfs: sanitize __d_path()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <E1OKVRc-0002Zk-Sc@pomaz-ex.szeredi.hu>
In-Reply-To: <E1OKVRc-0002Zk-Sc@pomaz-ex.szeredi.hu>
Message-Id: <201006042310.BBJ82837.tFOMFJHLQVOSFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 4 Jun 2010 23:10:59 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> -extern char *__d_path(const struct path *path, struct path *root, char *, int);
> +extern int __d_path(const struct path *path, struct path *root, char **, int *);
Does somebody use buflen after returning from __d_path()?
If nobody uses, we can pass it as "int" rather than "int *".

> --- linux-2.6.orig/security/tomoyo/realpath.c	2010-05-27 12:13:46.000000000 +0200
> +++ linux-2.6/security/tomoyo/realpath.c	2010-05-27 12:13:48.000000000 +0200
Sorry. This hunk will not apply because I modified this part
in order to support longer pathnames.
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=blob;f=security/tomoyo/realpath.c;h=153fa23a05ccd90a9ff3b90c02cefbd9e0cb9126;hb=006dacc8a64e91f6d47c52aec6a9d894e5f93eba
New hunk will look like below.
---
 security/tomoyo/realpath.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- security-testing-2.6.orig/security/tomoyo/realpath.c
+++ security-testing-2.6/security/tomoyo/realpath.c
@@ -94,6 +94,8 @@ char *tomoyo_realpath_from_path(struct p
 		return NULL;
 	is_dir = dentry->d_inode && S_ISDIR(dentry->d_inode->i_mode);
 	while (1) {
+		int error;
+		int len;
 		struct path ns_root = { .mnt = NULL, .dentry = NULL };
 		char *pos;
 		buf_len <<= 1;
@@ -127,21 +129,24 @@ char *tomoyo_realpath_from_path(struct p
 		/* If we don't have a vfsmount, we can't calculate. */
 		if (!path->mnt)
 			break;
+		len = buflen - 1;
+		pos = buf + len;
+		*pos = '\0';
 		spin_lock(&dcache_lock);
 		/* go to whatever namespace root we are under */
-		pos = __d_path(path, &ns_root, buf, buf_len);
+		error = __d_path(path, &ns_root, &pos, &len);
 		spin_unlock(&dcache_lock);
+		if (error)
+			continue;
 		/* Prepend "/proc" prefix if using internal proc vfs mount. */
-		if (!IS_ERR(pos) && (path->mnt->mnt_flags & MNT_INTERNAL) &&
+		if ((path->mnt->mnt_flags & MNT_INTERNAL) &&
 		    (path->mnt->mnt_sb->s_magic == PROC_SUPER_MAGIC)) {
 			pos -= 5;
 			if (pos >= buf)
 				memcpy(pos, "/proc", 5);
 			else
-				pos = ERR_PTR(-ENOMEM);
+				continue;
 		}
-		if (IS_ERR(pos))
-			continue;
 		name = tomoyo_encode(pos);
 		break;
 	}
