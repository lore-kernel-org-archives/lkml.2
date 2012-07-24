Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab2GXTQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 15:16:41 -0400
Received: from 50-193-208-193-static.hfc.comcastbusiness.net ([50.193.208.193]:54559
	"EHLO tetsuo.zabbo.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab2GXTQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 15:16:40 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jul 2012 15:16:40 EDT
From: Zach Brown <zab@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] fuse: verify all ioctl retry iov elements
Date: Tue, 24 Jul 2012 12:10:11 -0700
Message-Id: <10c600c845bf89db85c5126c49e78cfee8909b1d.1343157011.git.zab@zabbo.net>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7572777eef78ebdee1ecb7c258c0ef94d35bad16 attempted to verify that
the total iovec from the client doesn't overflow iov_length() but it
only checked the first element.  The iovec could still overflow by
starting with a small element.  The obvious fix is to check all the
elements.

The overflow case doesn't look dangerous to the kernel as the copy is
limited by the length after the overflow.  This fix restores the
intention of returning an error instead of successfully copying less
than the iovec represented.

I found this by code inspection.  I built it but don't have a test case.
I'm cc:ing stable because the initial commit did as well.

Signed-off-by: Zach Brown <zab@redhat.com>
CC: <stable@kernel.org>         [2.6.37+]
---
 fs/fuse/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index b321a68..514f12a 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1700,7 +1700,7 @@ static int fuse_verify_ioctl_iov(struct iovec *iov, size_t count)
 	size_t n;
 	u32 max = FUSE_MAX_PAGES_PER_REQ << PAGE_SHIFT;
 
-	for (n = 0; n < count; n++) {
+	for (n = 0; n < count; n++, iov++) {
 		if (iov->iov_len > (size_t) max)
 			return -ENOMEM;
 		max -= iov->iov_len;
-- 
1.7.6.5

