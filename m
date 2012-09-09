Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab2IIXRe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:17:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51425 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756283Ab2IIXQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:57 -0400
Message-Id: <20120909224152.058452500@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:41:58 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Zach Brown <zab@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [ 08/95] fuse: verify all ioctl retry iov elements
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/fuse/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 5800101..2eed3ac 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1703,7 +1703,7 @@ static int fuse_verify_ioctl_iov(struct iovec *iov, size_t count)
 	size_t n;
 	u32 max = FUSE_MAX_PAGES_PER_REQ << PAGE_SHIFT;
 
-	for (n = 0; n < count; n++) {
+	for (n = 0; n < count; n++, iov++) {
 		if (iov->iov_len > (size_t) max)
 			return -ENOMEM;
 		max -= iov->iov_len;


