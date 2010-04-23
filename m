Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab0DWCXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 22:23:47 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:33725 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755058Ab0DWCXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 22:23:45 -0400
Message-ID: <4BD10475.4060005@lougher.demon.co.uk>
Date: Fri, 23 Apr 2010 03:22:45 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
CC: linux-fsdevel@vger.kernel.org
Subject: [PATCH 4/4] squashfs: fix potential buffer over-run on 4K block file
 systems
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sizing the buffer based on block size is incorrect, leading
to a potential buffer over-run on 4K block size file systems
(because the metadata block size is always 8K).  This bug
doesn't seem have triggered because 4K block size file systems
are not default, and also because metadata blocks after
compression tend to be less than 4K.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
  fs/squashfs/block.c |    5 ++---
  1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 1cb0d81..653c030 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -87,9 +87,8 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
  	u64 cur_index = index >> msblk->devblksize_log2;
  	int bytes, compressed, b = 0, k = 0, page = 0, avail;

-
-	bh = kcalloc((msblk->block_size >> msblk->devblksize_log2) + 1,
-				sizeof(*bh), GFP_KERNEL);
+	bh = kcalloc(((srclength + msblk->devblksize - 1)
+		>> msblk->devblksize_log2) + 1, sizeof(*bh), GFP_KERNEL);
  	if (bh == NULL)
  		return -ENOMEM;

-- 
1.6.3.3

