Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab2FDLpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:45:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:59598 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105Ab2FDLpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:45:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="151277070"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH] udf: stop using s_dirt
Date: Mon,  4 Jun 2012 14:46:24 +0300
Message-Id: <1338810384-26437-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

The UDF file-system does not need the 's_dirt' superblock flag because it does
not define the 'write_super()' method. This flag was set to 1 in few places and
set to 0 in '->sync_fs()' and was basically useless. Stop using it because it
is on its way out.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/udf/super.c   |    6 ------
 fs/udf/udfdecl.h |    1 -
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index ac8a348..34e6b87 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1948,7 +1948,6 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	sb->s_op = &udf_sb_ops;
 	sb->s_export_op = &udf_export_ops;
 
-	sb->s_dirt = 0;
 	sb->s_magic = UDF_SUPER_MAGIC;
 	sb->s_time_gran = 1000;
 
@@ -2070,10 +2069,6 @@ void _udf_err(struct super_block *sb, const char *function,
 	struct va_format vaf;
 	va_list args;
 
-	/* mark sb error */
-	if (!(sb->s_flags & MS_RDONLY))
-		sb->s_dirt = 1;
-
 	va_start(args, fmt);
 
 	vaf.fmt = fmt;
@@ -2135,7 +2130,6 @@ static int udf_sync_fs(struct super_block *sb, int wait)
 		 * the buffer for IO
 		 */
 		mark_buffer_dirty(sbi->s_lvid_bh);
-		sb->s_dirt = 0;
 		sbi->s_lvid_dirty = 0;
 	}
 	mutex_unlock(&sbi->s_alloc_mutex);
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index ebe1031..de038da 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -129,7 +129,6 @@ static inline void udf_updated_lvid(struct super_block *sb)
 	WARN_ON_ONCE(((struct logicalVolIntegrityDesc *)
 		     bh->b_data)->integrityType !=
 		     cpu_to_le32(LVID_INTEGRITY_TYPE_OPEN));
-	sb->s_dirt = 1;
 	UDF_SB(sb)->s_lvid_dirty = 1;
 }
 extern u64 lvid_get_unique_id(struct super_block *sb);
-- 
1.7.7.6

