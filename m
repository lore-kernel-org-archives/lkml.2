Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab2GSMmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:42:35 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37267 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab2GSMma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:42:30 -0400
X-AuditID: b753bd60-9ea82ba000000655-a5-500800b3b688
X-AuditID: b753bd60-9ea82ba000000655-a5-500800b3b688
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH -v2 3/6] fuse: remove cache for fuse request allocation
To: Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muthukumar R <muthur@gmail.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Miklos Szeredi <miklos@szeredi.hu>, Nikolaus Rath <Nikolaus@rath.org>,
        Liu Yuan <namei.unix@gmail.com>, Has-Wen Nienhuys <hanwen@xs4all.nl>
Date: Thu, 19 Jul 2012 21:49:34 +0900
Message-ID: <20120719124934.6250.47335.stgit@ltc137.sdl.hitachi.co.jp>
In-Reply-To: <20120719124851.6250.43316.stgit@ltc137.sdl.hitachi.co.jp>
References: <20120719124851.6250.43316.stgit@ltc137.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove fuse_req_cachep, which was used for fuse request buffer.
It is no longer used since the buffer is allocated dynamically
due to the tunable maximum read/write request size.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nikolaus Rath <Nikolaus@rath.org>
Cc: Liu Yuan <namei.unix@gmail.com>
Cc: Has-Wen Nienhuys <hanwen@xs4all.nl>
---

 fs/fuse/dev.c |   21 +--------------------
 1 files changed, 1 insertions(+), 20 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 511560b..4087ff4 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -23,8 +23,6 @@
 MODULE_ALIAS_MISCDEV(FUSE_MINOR);
 MODULE_ALIAS("devname:fuse");
 
-static struct kmem_cache *fuse_req_cachep;
-
 static struct fuse_conn *fuse_get_conn(struct file *file)
 {
 	/*
@@ -2075,27 +2073,10 @@ static struct miscdevice fuse_miscdevice = {
 
 int __init fuse_dev_init(void)
 {
-	int err = -ENOMEM;
-	fuse_req_cachep = kmem_cache_create("fuse_request",
-					    sizeof(struct fuse_req),
-					    0, 0, NULL);
-	if (!fuse_req_cachep)
-		goto out;
-
-	err = misc_register(&fuse_miscdevice);
-	if (err)
-		goto out_cache_clean;
-
-	return 0;
-
- out_cache_clean:
-	kmem_cache_destroy(fuse_req_cachep);
- out:
-	return err;
+	return misc_register(&fuse_miscdevice);
 }
 
 void fuse_dev_cleanup(void)
 {
 	misc_deregister(&fuse_miscdevice);
-	kmem_cache_destroy(fuse_req_cachep);
 }

