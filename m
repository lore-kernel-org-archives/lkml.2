Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab2LTMcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 07:32:35 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:45886 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab2LTMc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 07:32:29 -0500
Subject: [PATCH 4/5] fuse: enable close_wait feature
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org,
        anand.avati@gmail.com
Date: Thu, 20 Dec 2012 16:32:32 +0400
Message-ID: <20121220123204.4101.14064.stgit@maximpc.sw.ru>
In-Reply-To: <20121220122702.4101.80042.stgit@maximpc.sw.ru>
References: <20121220122702.4101.80042.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch enables feature by passing 'true' to fuse_file_put in
fuse_release_common.

Previously, this was safe only in special cases when we sure that
multi-threaded userspace won't deadlock if we'll synchronously send
FUSE_RELEASE in the context of read-ahead or write-back callback. Now, it's
always safe because callbacks don't send requests to userspace anymore.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index aed9be2..dac3a7c 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -272,7 +272,8 @@ void fuse_release_common(struct file *file, int opcode)
 	if (ff->fc->close_wait)
 		BUG_ON(atomic_read(&ff->count) != 1);
 
-	fuse_file_put(ff, ff->fc->destroy_req != NULL);
+	fuse_file_put(ff, ff->fc->destroy_req != NULL ||
+			  ff->fc->close_wait);
 }
 
 static int fuse_open(struct inode *inode, struct file *file)

