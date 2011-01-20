Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab1ATUxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 15:53:06 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22868 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab1ATUxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:53:04 -0500
Date: Thu, 20 Jan 2011 21:53:23 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] SquashFS, XZ: Don't use uninitialized variable in
 squashfs_xz_uncompress
Message-ID: <alpine.LNX.2.00.1101202140070.11854@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fs/squashfs/xz_wrapper.c::squashfs_xz_uncompress() we have this code:

	enum xz_ret xz_err;
	...
	do {
		if (stream->buf.in_pos == stream->buf.in_size && k < b) {
		... [nothing that assigns to 'xz_err'] ...
			if (avail == 0) {
				offset = 0;
				put_bh(bh[k++]);
				continue;
			}
		...
	} while (xz_err == XZ_OK);

If we hit that 'continue' statement the first time through, then the 
'while' condition will be testing an uninitialized 'xz_err' - not what we 
want.

This patch should take care of the problem by making sure that 'xz_err' is 
initialized to 'XZ_OK' at the start of the function.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 xz_wrapper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

  compile tested only.

diff --git a/fs/squashfs/xz_wrapper.c b/fs/squashfs/xz_wrapper.c
index 856756c..daf76c3 100644
--- a/fs/squashfs/xz_wrapper.c
+++ b/fs/squashfs/xz_wrapper.c
@@ -74,7 +74,7 @@ static int squashfs_xz_uncompress(struct squashfs_sb_info *msblk, void **buffer,
 	struct buffer_head **bh, int b, int offset, int length, int srclength,
 	int pages)
 {
-	enum xz_ret xz_err;
+	enum xz_ret xz_err = XZ_OK;
 	int avail, total = 0, k = 0, page = 0;
 	struct squashfs_xz *stream = msblk->stream;
 


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

