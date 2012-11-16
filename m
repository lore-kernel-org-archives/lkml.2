Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab2KPRKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:10:23 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:10164 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399Ab2KPRKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:10:21 -0500
Subject: [PATCH 11/14] fuse: fuse_flush() should wait on writeback
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        xemul@openvz.org
Date: Fri, 16 Nov 2012 21:10:07 +0400
Message-ID: <20121116171000.3196.55778.stgit@maximpc.sw.ru>
In-Reply-To: <20121116170123.3196.93431.stgit@maximpc.sw.ru>
References: <20121116170123.3196.93431.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The aim of .flush fop is to hint file-system that flushing its state or caches
or any other important data to reliable storage would be desirable now.
fuse_flush() passes this hint by sending FUSE_FLUSH request to userspace.
However, dirty pages and pages under writeback may be not visible to userspace
yet if we won't ensure it explicitly.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/file.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 4e4f6fd..b73fe2a 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -17,6 +17,7 @@
 #include <linux/swap.h>
 
 static const struct file_operations fuse_direct_io_file_operations;
+static void fuse_sync_writes(struct inode *inode);
 
 static int fuse_send_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 			  int opcode, struct fuse_open_out *outargp)
@@ -413,6 +414,14 @@ static int fuse_flush(struct file *file, fl_owner_t id)
 	if (fc->no_flush)
 		return 0;
 
+	err = filemap_write_and_wait(file->f_mapping);
+	if (err)
+		return err;
+
+	mutex_lock(&inode->i_mutex);
+	fuse_sync_writes(inode);
+	mutex_unlock(&inode->i_mutex);
+
 	req = fuse_get_req_nofail(fc, file);
 	memset(&inarg, 0, sizeof(inarg));
 	inarg.fh = ff->fh;

