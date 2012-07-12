Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161195Ab2GLO2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:28:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:18972 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933939Ab2GLO1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:27:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="167258310"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 3/6] hfs: remove extra mdb write on unmount
Date: Thu, 12 Jul 2012 17:28:46 +0300
Message-Id: <1342103329-17526-4-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1342103329-17526-1-git-send-email-dedekind1@gmail.com>
References: <1342103329-17526-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

HFS calls 'hfs_write_super()' from 'hfs_put_super()' in order to write the MDB
to the media. However, it is not needed because VFS calls '->sync_fs()' before
calling '->put_super()' - so by the time we are in 'hfs_write_super()', the MDB
is already synchronized.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/hfs/super.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index f7c06bb..47e4119 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -74,8 +74,6 @@ static int hfs_sync_fs(struct super_block *sb, int wait)
  */
 static void hfs_put_super(struct super_block *sb)
 {
-	if (sb->s_dirt)
-		hfs_write_super(sb);
 	hfs_mdb_close(sb);
 	/* release the MDB's resources */
 	hfs_mdb_put(sb);
-- 
1.7.7.6

