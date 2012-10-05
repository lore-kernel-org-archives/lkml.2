Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab2JEOzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:55:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60195 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab2JEOzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:55:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 05/16] vfs: bogus warnings in fs/namei.c
Date: Fri,  5 Oct 2012 16:55:19 +0200
Message-Id: <1349448930-23976-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349448930-23976-1-git-send-email-arnd@arndb.de>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:/d/nXk3/xy5hi5Wq/VQejeaCvOERxxJn2uBOaUyxiXT
 bXvXvR/bhOrocHZjnAbXw1PHLyJZTPCQu3c+EwEZ5OHIsNxXfc
 Ngpusy+2GWN4ekE+RRaNR6zHc5nIuQjUoMWeeFyqrBufeP5pSW
 kT7Njcvcv7Lf0hAN0dDmbqex8vtAqChR5q/HQaIcKbrIQ5+dcH
 t5450JKZe38IHJEjLoMN0rKgv6kuDmipysJww77juDh16W+hbk
 r5VtoNiSy4kC+8ISDpl/Y2yvk1p7T74tIbmcHec7tSMi0a/CXz
 fNSBKniOX8hP2RI+rHla9atd6Iv6P4aKOnagvLDzIEG9Grk26o
 mtIxj+dBKSUTCfk5DbJ3GZEY8altqpzH1W3SzqQuX0Kehh66cc
 WXySddJY+Hsj4JqVNGwI811PJZIPZ7xQXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The follow_link() function always initializes its *p argument,
or returns an error, but not all versions of gcc figure this
out, so we have to work around this using the uninitialized_var()
macro.

Without this patch, building with arm-linux-gnueabi-gcc-4.6 results in:

fs/namei.c: In function 'link_path_walk':
fs/namei.c:649:24: warning: 'cookie' may be used uninitialized in this function [-Wuninitialized]
fs/namei.c:1544:9: note: 'cookie' was declared here
fs/namei.c: In function 'path_lookupat':
fs/namei.c:649:24: warning: 'cookie' may be used uninitialized in this function [-Wuninitialized]
fs/namei.c:1934:10: note: 'cookie' was declared here
fs/namei.c: In function 'path_openat':
fs/namei.c:649:24: warning: 'cookie' may be used uninitialized in this function [-Wuninitialized]
fs/namei.c:2899:9: note: 'cookie' was declared here

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>
---
 fs/namei.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index dd1ed1b..62a1725 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1543,7 +1543,7 @@ static inline int nested_symlink(struct path *path, struct nameidata *nd)
 
 	do {
 		struct path link = *path;
-		void *cookie;
+		void *uninitialized_var(cookie);
 
 		res = follow_link(&link, nd, &cookie);
 		if (res)
@@ -1933,7 +1933,7 @@ static int path_lookupat(int dfd, const char *name,
 	if (!err && !(flags & LOOKUP_PARENT)) {
 		err = lookup_last(nd, &path);
 		while (err > 0) {
-			void *cookie;
+			void *uninitialized_var(cookie);
 			struct path link = path;
 			err = may_follow_link(&link, nd);
 			if (unlikely(err))
@@ -2902,7 +2902,7 @@ static struct file *path_openat(int dfd, const char *pathname,
 	error = do_last(nd, &path, file, op, &opened, pathname);
 	while (unlikely(error > 0)) { /* trailing symlink */
 		struct path link = path;
-		void *cookie;
+		void *uninitialized_var(cookie);
 		if (!(nd->flags & LOOKUP_FOLLOW)) {
 			path_put_conditional(&path, nd);
 			path_put(&nd->path);
-- 
1.7.10

