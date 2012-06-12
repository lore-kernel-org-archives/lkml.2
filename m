Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab2FLIM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 04:12:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:27666 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab2FLIMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 04:12:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164501689"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/6] hfs: remove extra mdb write on unmount
Date: Tue, 12 Jun 2012 11:13:35 +0300
Message-Id: <1339488818-14461-4-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1339488818-14461-1-git-send-email-dedekind1@gmail.com>
References: <1339488818-14461-1-git-send-email-dedekind1@gmail.com>
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

