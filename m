Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821Ab2JAXBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:01:05 -0400
Received: from 1wt.eu ([62.212.114.60]:35281 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932800Ab2JAXBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:00 -0400
Message-Id: <20121001225202.869841003@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:01 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Zach Brown <zab@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 124/180] fuse: verify all ioctl retry iov elements
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Zach Brown <zab@redhat.com>

commit fb6ccff667712c46b4501b920ea73a326e49626a upstream.

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
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/fuse/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index f6104a95..102d582 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1664,7 +1664,7 @@ static int fuse_verify_ioctl_iov(struct iovec *iov, size_t count)
 	size_t n;
 	u32 max = FUSE_MAX_PAGES_PER_REQ << PAGE_SHIFT;
 
-	for (n = 0; n < count; n++) {
+	for (n = 0; n < count; n++, iov++) {
 		if (iov->iov_len > (size_t) max)
 			return -ENOMEM;
 		max -= iov->iov_len;
-- 
1.7.2.1.45.g54fbc



