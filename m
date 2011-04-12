Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab1DLOlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:41:05 -0400
Received: from kroah.org ([198.145.64.141]:57877 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932462Ab1DLOi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:57 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:58 2011
Message-Id: <20110412143558.430852027@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:35:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: [098/105] Squashfs: Use vmalloc rather than kmalloc for zlib workspace
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Phillip Lougher <phillip@lougher.demon.co.uk>

commit 117a91e0f25fd7698e20ac3dfa62086be3dc82a3 upstream.

Bugzilla bug 31422 reports occasional "page allocation failure. order:4"
at Squashfs mount time.  Fix this by making zlib workspace allocation
use vmalloc rather than kmalloc.

Reported-by: Mehmet Giritli <mehmet@giritli.eu>
Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/squashfs/zlib_wrapper.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/squashfs/zlib_wrapper.c
+++ b/fs/squashfs/zlib_wrapper.c
@@ -26,6 +26,7 @@
 #include <linux/buffer_head.h>
 #include <linux/slab.h>
 #include <linux/zlib.h>
+#include <linux/vmalloc.h>
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
@@ -37,8 +38,7 @@ static void *zlib_init(struct squashfs_s
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
 


