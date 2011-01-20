Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab1ATUxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 15:53:50 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22886 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab1ATUxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:53:49 -0500
Date: Thu, 20 Jan 2011 21:54:08 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] SquashFS, zlib: Don't use uninitialized variable in
 zlib_uncompress
Message-ID: <alpine.LNX.2.00.1101202146340.11854@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fs/squashfs/zlib_wrapper.c::zlib_uncompress() we have this code:

	int zlib_err, zlib_init = 0;
	...
	do {
		if (stream->avail_in == 0 && k < b) {
		... [no code that assigns to 'zlib_err'] ...
			if (avail == 0) {
				offset = 0;
				put_bh(bh[k++]);
				continue;
			}
		...
	} while (zlib_err == Z_OK);

If we hit that 'continue' statement the first time through, then the
'while' condition will be testing an uninitialized 'zlib_err' - not what 
we want.

This patch should take care of the problem by making sure that 'zlib_err' 
is initialized to 'Z_OK' at the start of the function.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 zlib_wrapper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

  Compile tested only.

diff --git a/fs/squashfs/zlib_wrapper.c b/fs/squashfs/zlib_wrapper.c
index 818a5e0..5970993 100644
--- a/fs/squashfs/zlib_wrapper.c
+++ b/fs/squashfs/zlib_wrapper.c
@@ -65,7 +65,7 @@ static int zlib_uncompress(struct squashfs_sb_info *msblk, void **buffer,
 	struct buffer_head **bh, int b, int offset, int length, int srclength,
 	int pages)
 {
-	int zlib_err, zlib_init = 0;
+	int zlib_err = Z_OK, zlib_init = 0;
 	int k = 0, page = 0;
 	z_stream *stream = msblk->stream;
 

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

