Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473Ab2JKXK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 19:10:27 -0400
Received: from smtp.outflux.net ([198.145.64.163]:52589 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758274Ab2JKXKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 19:10:25 -0400
Date: Thu, 11 Oct 2012 16:10:16 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, Brad Spengler <spender@grsecurity.net>,
        PaX Team <pageexec@freemail.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] compat: VIDEO_SET_SPU_PALETTE missing error check
Message-ID: <20121011231016.GA26406@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compat ioctl for VIDEO_SET_SPU_PALETTE was missing an error check
while converting ioctl arguments. This could lead to leaking kernel
stack contents into userspace.

Patch extracted from existing fix in grsecurity.

Cc: David Miller <davem@davemloft.net>
Cc: Brad Spengler <spender@grsecurity.net>
Cc: PaX Team <pageexec@freemail.hu>
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/compat_ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index f505402..4c6285f 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -210,6 +210,8 @@ static int do_video_set_spu_palette(unsigned int fd, unsigned int cmd,
 
 	err  = get_user(palp, &up->palette);
 	err |= get_user(length, &up->length);
+	if (err)
+		return -EFAULT;
 
 	up_native = compat_alloc_user_space(sizeof(struct video_spu_palette));
 	err  = put_user(compat_ptr(palp), &up_native->palette);
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
