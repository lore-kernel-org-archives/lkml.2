Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab2LTMcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 07:32:52 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:44908 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab2LTMcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 07:32:46 -0500
Subject: [PATCH 5/5] fuse: fix synchronous case of fuse_file_put()
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org,
        anand.avati@gmail.com
Date: Thu, 20 Dec 2012 16:32:49 +0400
Message-ID: <20121220123237.4101.93351.stgit@maximpc.sw.ru>
In-Reply-To: <20121220122702.4101.80042.stgit@maximpc.sw.ru>
References: <20121220122702.4101.80042.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If fuse_file_put() is called with sync==true, the user may be blocked for
a while, until userspace ACKs our FUSE_RELEASE request. This blocking must be
uninterruptible. Otherwise request could be interrupted, but file association
in user space remains.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index dac3a7c..e6770b8 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -126,6 +126,10 @@ static void fuse_file_put(struct fuse_file *ff, bool sync)
 		struct fuse_req *req = ff->reserved_req;
 
 		if (sync) {
+			/* Must force. Otherwise request could be interrupted,
+			 * but file association in user space remains.
+			 */
+			req->force = 1;
 			fuse_request_send(ff->fc, req);
 			path_put(&req->misc.release.path);
 			fuse_put_request(ff->fc, req);

