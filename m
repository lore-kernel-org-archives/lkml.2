Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab2H1Ii1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 04:38:27 -0400
Received: from svenfoo.org ([82.94.215.22]:42906 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989Ab2H1IiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 04:38:13 -0400
From: Daniel Mack <zonque@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <zonque@gmail.com>, Brian Foster <bfoster@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [PATCH] fuse: mark variables uninitialized
Date: Tue, 28 Aug 2012 10:38:03 +0200
Message-Id: <1346143083-30710-1-git-send-email-zonque@gmail.com>
X-Mailer: git-send-email 1.7.11.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc 4.6.3 complains about uninitialized variables in fs/fuse/control.c:

  CC      fs/fuse/control.o
fs/fuse/control.c: In function ‘fuse_conn_congestion_threshold_write’:
fs/fuse/control.c:165:29: warning: ‘val’ may be used uninitialized in this function [-Wuninitialized]
fs/fuse/control.c: In function ‘fuse_conn_max_background_write’:
fs/fuse/control.c:128:23: warning: ‘val’ may be used uninitialized in this function [-Wuninitialized]

fuse_conn_limit_write() will always return non-zero unless the &val
is modified, so the warning is misleading. Let the compiler know
about it by marking 'val' with 'uninitialized_var'.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/control.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index 03ff5b1..75a20c0 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -117,7 +117,7 @@ static ssize_t fuse_conn_max_background_write(struct file *file,
 					      const char __user *buf,
 					      size_t count, loff_t *ppos)
 {
-	unsigned val;
+	unsigned uninitialized_var(val);
 	ssize_t ret;
 
 	ret = fuse_conn_limit_write(file, buf, count, ppos, &val,
@@ -154,7 +154,7 @@ static ssize_t fuse_conn_congestion_threshold_write(struct file *file,
 						    const char __user *buf,
 						    size_t count, loff_t *ppos)
 {
-	unsigned val;
+	unsigned uninitialized_var(val);
 	ssize_t ret;
 
 	ret = fuse_conn_limit_write(file, buf, count, ppos, &val,
-- 
1.7.11.4

