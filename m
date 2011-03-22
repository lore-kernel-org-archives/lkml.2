Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab1CVXVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:21:09 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:48017 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753924Ab1CVXVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:21:08 -0400
Message-ID: <4D892ED9.4040405@lougher.demon.co.uk>
Date: Tue, 22 Mar 2011 23:20:57 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] Squashfs: Use vmalloc rather than kmalloc for zlib workspace
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bugzilla bug 31422 reports occasional "page allocation failure. order:4"
at Squashfs mount time.  Fix this by making zlib workspace allocation
use vmalloc rather than kmalloc.

Reported-by: Mehmet Giritli <mehmet@giritli.eu>
Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
  fs/squashfs/zlib_wrapper.c |    6 +++---
  1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/squashfs/zlib_wrapper.c b/fs/squashfs/zlib_wrapper.c
index 195b0d0..517688b 100644
--- a/fs/squashfs/zlib_wrapper.c
+++ b/fs/squashfs/zlib_wrapper.c
@@ -26,6 +26,7 @@
  #include <linux/buffer_head.h>
  #include <linux/slab.h>
  #include <linux/zlib.h>
+#include <linux/vmalloc.h>

  #include "squashfs_fs.h"
  #include "squashfs_fs_sb.h"
@@ -37,8 +38,7 @@ static void *zlib_init(struct squashfs_sb_info *dummy, void *buff, int len)
  	z_stream *stream = kmalloc(sizeof(z_stream), GFP_KERNEL);
  	if (stream == NULL)
  		goto failed;
-	stream->workspace = kmalloc(zlib_inflate_workspacesize(),
-		GFP_KERNEL);
+	stream->workspace = vmalloc(zlib_inflate_workspacesize());
  	if (stream->workspace == NULL)
  		goto failed;

@@ -56,7 +56,7 @@ static void zlib_free(void *strm)
  	z_stream *stream = strm;

  	if (stream)
-		kfree(stream->workspace);
+		vfree(stream->workspace);
  	kfree(stream);
  }

-- 
1.7.1

