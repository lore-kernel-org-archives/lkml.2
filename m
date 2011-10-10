Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab1JJRcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:32:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49753 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490Ab1JJRcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:32:22 -0400
Date: Mon, 10 Oct 2011 19:32:19 +0200
From: Jan Kara <jack@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Jan Kara <jack@suse.cz>, NamJae Jeon <linkinjeon@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] udf: Promote some debugging messages to udf_error
Message-ID: <20111010173219.GI3944@quack.suse.cz>
References: <CAKYAXd9csZyMXAy_uopb-fHKtY8VBjWD6UVdbQ3QTHYPogLVrw@mail.gmail.com>
 <cover.1318233879.git.joe@perches.com>
 <e72525141cf56c5add8c3fda53f89641bd09a848.1318233879.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e72525141cf56c5add8c3fda53f89641bd09a848.1318233879.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 10-10-11 01:08:02, Joe Perches wrote:
> If there is a problem with a scratched disc or loader,
> it's valuable to know which error occurred.
> 
> Convert some debug messages to udf_error, neaten those messages too.
> Add the calculated tag checksum and the read checksum to error message.
> Make udf_error a public function and move the logging prototypes together.
> 
> Original-patch-by: NamJae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Joe Perches <joe@perches.com>
  I have now tested this patch and found out it's not such a good idea as
it seems at the first sight. UDF uses udf_read_tagged() to probe whether
some structure is in some location (because some structures can be placed
at several places in the filesystem and the only way to determine where the
structure is to load blocks from all the places and check block headers).
So as a result of this patch normal UDF mount produces about 20 error
messages... So I've altered this patch to change only some messages in
udf_read_tagged(). The result is below.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

>From 7e273e3b41e32716dc122b293b5f15635af495ff Mon Sep 17 00:00:00 2001
From: Joe Perches <joe@perches.com>
Date: Mon, 10 Oct 2011 01:08:02 -0700
Subject: [PATCH] udf: Promote some debugging messages to udf_error

If there is a problem with a scratched disc or loader, it's valuable to know
which error occurred.

Convert some debug messages to udf_error, neaten those messages too.
Add the calculated tag checksum and the read checksum to error message.
Make udf_error a public function and move the logging prototypes together.

Original-patch-by: NamJae Jeon <linkinjeon@gmail.com>
Reviewed-by: NamJae Jeon <linkinjeon@gmail.com>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/misc.c    |   13 +++++++++----
 fs/udf/super.c   |    6 ++----
 fs/udf/udfdecl.h |    9 +++++++--
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/udf/misc.c b/fs/udf/misc.c
index 9215700..a85fa7c 100644
--- a/fs/udf/misc.c
+++ b/fs/udf/misc.c
@@ -204,6 +204,7 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
 {
 	struct tag *tag_p;
 	struct buffer_head *bh = NULL;
+	u8 checksum;
 
 	/* Read the block */
 	if (block == 0xFFFFFFFF)
@@ -211,7 +212,7 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
 
 	bh = udf_tread(sb, block);
 	if (!bh) {
-		udf_debug("block=%d, location=%d: read failed\n",
+		udf_error(sb, __func__, "read failed, block=%u, location=%d\n",
 			  block, location);
 		return NULL;
 	}
@@ -227,15 +228,19 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
 	}
 
 	/* Verify the tag checksum */
-	if (udf_tag_checksum(tag_p) != tag_p->tagChecksum) {
-		printk(KERN_ERR "udf: tag checksum failed block %d\n", block);
+	checksum = udf_tag_checksum(tag_p);
+	if (checksum != tag_p->tagChecksum) {
+		udf_error(sb, __func__,
+			  "tag checksum failed, block %u: 0x%02x != 0x%02x\n",
+			  block, checksum, tag_p->tagChecksum);
 		goto error_out;
 	}
 
 	/* Verify the tag version */
 	if (tag_p->descVersion != cpu_to_le16(0x0002U) &&
 	    tag_p->descVersion != cpu_to_le16(0x0003U)) {
-		udf_debug("tag version 0x%04x != 0x0002 || 0x0003 block %d\n",
+		udf_error(sb, __func__,
+			  "tag version 0x%04x != 0x0002 || 0x0003, block %u\n",
 			  le16_to_cpu(tag_p->descVersion), block);
 		goto error_out;
 	}
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 7b27b06..80f47ce 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -92,8 +92,6 @@ static void udf_close_lvid(struct super_block *);
 static unsigned int udf_count_free(struct super_block *);
 static int udf_statfs(struct dentry *, struct kstatfs *);
 static int udf_show_options(struct seq_file *, struct vfsmount *);
-static void udf_error(struct super_block *sb, const char *function,
-		      const char *fmt, ...);
 
 struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct udf_sb_info *sbi)
 {
@@ -2096,8 +2094,8 @@ error_out:
 	return -EINVAL;
 }
 
-static void udf_error(struct super_block *sb, const char *function,
-		      const char *fmt, ...)
+void udf_error(struct super_block *sb, const char *function,
+	       const char *fmt, ...)
 {
 	va_list args;
 
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index dbd52d4..81e66af 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -29,6 +29,13 @@ do { \
 #define udf_debug(f, a...) /**/
 #endif
 
+__attribute__((format(printf, 3, 4)))
+extern void udf_warning(struct super_block *, const char *, const char *, ...);
+
+__attribute__((format(printf, 3, 4)))
+extern void udf_error(struct super_block *sb, const char *function,
+		      const char *fmt, ...);
+
 #define udf_info(f, a...) \
 	printk(KERN_INFO "UDF-fs INFO " f, ##a);
 
@@ -112,8 +119,6 @@ struct extent_position {
 
 /* super.c */
 
-__attribute__((format(printf, 3, 4)))
-extern void udf_warning(struct super_block *, const char *, const char *, ...);
 static inline void udf_updated_lvid(struct super_block *sb)
 {
 	struct buffer_head *bh = UDF_SB(sb)->s_lvid_bh;
-- 
1.7.1

