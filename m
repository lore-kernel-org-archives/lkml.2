Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab2HTD5z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 23:57:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39891 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab2HTD5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 23:57:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Zach Brown <zab@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>
Subject: [ 04/32] fuse: verify all ioctl retry iov elements
Date: Sun, 19 Aug 2012 20:57:00 -0700
Message-Id: <20120820035648.469927264@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035647.862247088@linuxfoundation.org>
References: <20120820035647.862247088@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 fs/fuse/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1698,7 +1698,7 @@ static int fuse_verify_ioctl_iov(struct
 	size_t n;
 	u32 max = FUSE_MAX_PAGES_PER_REQ << PAGE_SHIFT;
 
-	for (n = 0; n < count; n++) {
+	for (n = 0; n < count; n++, iov++) {
 		if (iov->iov_len > (size_t) max)
 			return -ENOMEM;
 		max -= iov->iov_len;


