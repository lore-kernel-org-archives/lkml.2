Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab0LWFRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 00:17:51 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:56447 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab0LWFRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 00:17:49 -0500
To: dhowells@redhat.com, jmorris@namei.org, viro@zeniv.linux.org.uk
Cc: tomoyo-dev-en@lists.sourceforge.jp, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CacheFiles: Add calls to path-based security hooks
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20101222172129.30524.17341.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101222172129.30524.17341.stgit@warthog.procyon.org.uk>
Message-Id: <201012231417.CGG82855.JVHSFQLOFtOMOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 23 Dec 2010 14:17:38 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote ( http://marc.info/?l=linux-security-module&m=129303225204910&w=2 ):
> > Both kernels did not check other permissions (e.g. create, unlink, rename)
> > at all (probably because security_path_*() are not called when cache files
> > are manipulated).
> 
> I think the security_path_*() functions postdate the inclusion of CacheFiles
> upstream.  This needs to be addressed.  It's not affected me directly thus far,
> so I haven't come across it yet.

I proposed inserting security_path_*() functions into only pre VFS helper
functions. This was my intention that only pathnames supplied from userspace
are checked so that users can enumerate pathnames without being bothered by
kernel internal business (e.g. filesystem needs to access pathname which was
not supplied from userspace).

> Furthermore, as mentioned above, CacheFiles needs updating to make use of
> path-based security, and TOMOYO should offer the administrator the option to
> nominate a context from which the kernel will manipulate the filesystem.

Well, I prefer enabling both inode based MAC (e.g. SELinux/Smack) and name
based MAC (e.g. TOMOYO/AppArmor) at the same time.

The reason why name based MAC checks filename is that filename has meaning.
Filename determines

(1) whether application can find the file or not

(2) for what purpose the file is used if access to that file is granted

. Therefore, name based MAC strictly restricts pathname changes.

However, checking filenames like

  /var/fscache/cache/@4a/I03nfs/@30/Ji000000000000000--fHg8hi8400/@75/Es0g000w...DB1ry

makes little sense because they are merely sequential (or random) names.

Our concerns regarding cachefilesd are mostly

(3) whether application can access the cached files or not

(4) what security label should be assigned to cached files

. Definitely inode based MAC can do better.



Anyway, we want below patch if we adopt your patch.

  ERROR: "security_path_rename" [fs/cachefiles/cachefiles.ko] undefined!
  ERROR: "security_path_unlink" [fs/cachefiles/cachefiles.ko] undefined!
  ERROR: "security_path_mkdir" [fs/cachefiles/cachefiles.ko] undefined!

Regards.
--------------------
 From 861f928bff6de99e0cfad54fa0cf803d35080a29 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Thu, 23 Dec 2010 11:33:16 +0900
Subject: [PATCH] Export security_path hooks for cachefiles.

cachefiles module calls security_path hooks. Export them.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/security.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/security/security.c b/security/security.c
index 1b798d3..568b98d 100644
--- a/security/security.c
+++ b/security/security.c
@@ -360,6 +360,7 @@ int security_path_mkdir(struct path *dir, struct dentry *dentry, int mode)
 		return 0;
 	return security_ops->path_mkdir(dir, dentry, mode);
 }
+EXPORT_SYMBOL(security_path_mkdir);
 
 int security_path_rmdir(struct path *dir, struct dentry *dentry)
 {
@@ -374,6 +375,7 @@ int security_path_unlink(struct path *dir, struct dentry *dentry)
 		return 0;
 	return security_ops->path_unlink(dir, dentry);
 }
+EXPORT_SYMBOL(security_path_unlink);
 
 int security_path_symlink(struct path *dir, struct dentry *dentry,
 			  const char *old_name)
@@ -400,6 +402,7 @@ int security_path_rename(struct path *old_dir, struct dentry *old_dentry,
 	return security_ops->path_rename(old_dir, old_dentry, new_dir,
 					 new_dentry);
 }
+EXPORT_SYMBOL(security_path_rename);
 
 int security_path_truncate(struct path *path)
 {
-- 
1.6.1
