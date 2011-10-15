Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab1JOTuQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 15:50:16 -0400
Received: from lunge.queued.net ([173.255.254.236]:42545 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab1JOTuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 15:50:13 -0400
Date: Sat, 15 Oct 2011 12:50:12 -0700
From: Andres Salomon <dilinger@queued.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: [PATCH 2/2] jffs2: add compr=lzo and compr=zlib options
Message-ID: <20111015125012.5c9fd572@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

..to allow forcing of either compression scheme.  This will override
compiled-in defaults.  jffs2_compress is reworked a bit, as the lzo/zlib
override shares lots of code w/ the PRIORITY mode.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 fs/jffs2/compr.c |  119 ++++++++++++++++++++++++++++++++++++++----------------
 fs/jffs2/compr.h |    2 +
 fs/jffs2/super.c |   18 +++++++-
 3 files changed, 102 insertions(+), 37 deletions(-)

diff --git a/fs/jffs2/compr.c b/fs/jffs2/compr.c
index 97bc74d..5b6c9d1 100644
--- a/fs/jffs2/compr.c
+++ b/fs/jffs2/compr.c
@@ -53,6 +53,78 @@ static int jffs2_is_best_compression(struct jffs2_compressor *this,
 	return 0;
 }
 
+/*
+ * jffs2_selected_compress:
+ * @compr: Explicit compression type to use (ie, JFFS2_COMPR_ZLIB).
+ *	If 0, just take the first available compression mode.
+ * @data_in: Pointer to uncompressed data
+ * @cpage_out: Pointer to returned pointer to buffer for compressed data
+ * @datalen: On entry, holds the amount of data available for compression.
+ *	On exit, expected to hold the amount of data actually compressed.
+ * @cdatalen: On entry, holds the amount of space available for compressed
+ *	data. On exit, expected to hold the actual size of the compressed
+ *	data.
+ *
+ * Returns: the compression type used.  Zero is used to show that the data
+ * could not be compressed; probably because we couldn't find the requested
+ * compression mode.
+ */
+static int jffs2_selected_compress(u8 compr, unsigned char *data_in,
+		unsigned char **cpage_out, u32 *datalen, u32 *cdatalen)
+{
+	struct jffs2_compressor *this;
+	int err, ret = JFFS2_COMPR_NONE;
+	uint32_t orig_slen, orig_dlen;
+	char *output_buf;
+
+	output_buf = kmalloc(*cdatalen, GFP_KERNEL);
+	if (!output_buf) {
+		printk(KERN_WARNING "JFFS2: No memory for compressor allocation. Compression failed.\n");
+		return ret;
+	}
+	orig_slen = *datalen;
+	orig_dlen = *cdatalen;
+	spin_lock(&jffs2_compressor_list_lock);
+	list_for_each_entry(this, &jffs2_compressor_list, list) {
+		/* Skip decompress-only and disabled modules */
+		if (!this->compress || this->disabled)
+			continue;
+
+		/* Skip if not the desired compression type */
+		if (compr && (compr != this->compr))
+			continue;
+
+		/*
+		 * Either compression type was unspecified, or we found our
+		 * compressor; either way, we're good to go.
+		 */
+		this->usecount++;
+		spin_unlock(&jffs2_compressor_list_lock);
+
+		*datalen  = orig_slen;
+		*cdatalen = orig_dlen;
+		err = this->compress(data_in, output_buf, datalen, cdatalen);
+
+		spin_lock(&jffs2_compressor_list_lock);
+		this->usecount--;
+		if (!err) {
+			/* Success */
+			ret = this->compr;
+			this->stat_compr_blocks++;
+			this->stat_compr_orig_size += *datalen;
+			this->stat_compr_new_size += *cdatalen;
+			break;
+		}
+	}
+	spin_unlock(&jffs2_compressor_list_lock);
+	if (ret == JFFS2_COMPR_NONE)
+		kfree(output_buf);
+	else
+		*cpage_out = output_buf;
+
+	return ret;
+}
+
 /* jffs2_compress:
  * @data_in: Pointer to uncompressed data
  * @cpage_out: Pointer to returned pointer to buffer for compressed data
@@ -91,37 +163,8 @@ uint16_t jffs2_compress(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 	case JFFS2_COMPR_MODE_NONE:
 		break;
 	case JFFS2_COMPR_MODE_PRIORITY:
-		output_buf = kmalloc(*cdatalen,GFP_KERNEL);
-		if (!output_buf) {
-			printk(KERN_WARNING "JFFS2: No memory for compressor allocation. Compression failed.\n");
-			goto out;
-		}
-		orig_slen = *datalen;
-		orig_dlen = *cdatalen;
-		spin_lock(&jffs2_compressor_list_lock);
-		list_for_each_entry(this, &jffs2_compressor_list, list) {
-			/* Skip decompress-only backwards-compatibility and disabled modules */
-			if ((!this->compress)||(this->disabled))
-				continue;
-
-			this->usecount++;
-			spin_unlock(&jffs2_compressor_list_lock);
-			*datalen  = orig_slen;
-			*cdatalen = orig_dlen;
-			compr_ret = this->compress(data_in, output_buf, datalen, cdatalen);
-			spin_lock(&jffs2_compressor_list_lock);
-			this->usecount--;
-			if (!compr_ret) {
-				ret = this->compr;
-				this->stat_compr_blocks++;
-				this->stat_compr_orig_size += *datalen;
-				this->stat_compr_new_size  += *cdatalen;
-				break;
-			}
-		}
-		spin_unlock(&jffs2_compressor_list_lock);
-		if (ret == JFFS2_COMPR_NONE)
-			kfree(output_buf);
+		ret = jffs2_selected_compress(0, data_in, cpage_out, datalen,
+				cdatalen);
 		break;
 	case JFFS2_COMPR_MODE_SIZE:
 	case JFFS2_COMPR_MODE_FAVOURLZO:
@@ -179,22 +222,28 @@ uint16_t jffs2_compress(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 			best->stat_compr_orig_size += best_slen;
 			best->stat_compr_new_size  += best_dlen;
 			ret = best->compr;
+			*cpage_out = output_buf;
 		}
 		spin_unlock(&jffs2_compressor_list_lock);
 		break;
+	case JFFS2_COMPR_MODE_FORCELZO:
+		ret = jffs2_selected_compress(JFFS2_COMPR_LZO, data_in,
+				cpage_out, datalen, cdatalen);
+		break;
+	case JFFS2_COMPR_MODE_FORCEZLIB:
+		ret = jffs2_selected_compress(JFFS2_COMPR_ZLIB, data_in,
+				cpage_out, datalen, cdatalen);
+		break;
 	default:
 		printk(KERN_ERR "JFFS2: unknown compression mode.\n");
 	}
- out:
+
 	if (ret == JFFS2_COMPR_NONE) {
 		*cpage_out = data_in;
 		*datalen = *cdatalen;
 		none_stat_compr_blocks++;
 		none_stat_compr_size += *datalen;
 	}
-	else {
-		*cpage_out = output_buf;
-	}
 	return ret;
 }
 
diff --git a/fs/jffs2/compr.h b/fs/jffs2/compr.h
index 13bb759..5e91d57 100644
--- a/fs/jffs2/compr.h
+++ b/fs/jffs2/compr.h
@@ -40,6 +40,8 @@
 #define JFFS2_COMPR_MODE_PRIORITY   1
 #define JFFS2_COMPR_MODE_SIZE       2
 #define JFFS2_COMPR_MODE_FAVOURLZO  3
+#define JFFS2_COMPR_MODE_FORCELZO   4
+#define JFFS2_COMPR_MODE_FORCEZLIB  5
 
 #define FAVOUR_LZO_PERCENT 80
 
diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index bf40d3e..26366db 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -171,11 +171,25 @@ static int jffs2_parse_options(struct jffs2_sb_info *c, char *data)
 
 			if (!name)
 				return -ENOMEM;
-			if (!strcmp(name, "none")) {
+			if (!strcmp(name, "none"))
 				c->mount_opts.compr = JFFS2_COMPR_MODE_NONE;
-				c->mount_opts.override_compr = true;
+#ifdef CONFIG_JFFS2_LZO
+			else if (!strcmp(name, "lzo"))
+				c->mount_opts.compr = JFFS2_COMPR_MODE_FORCELZO;
+#endif
+#ifdef CONFIG_JFFS2_ZLIB
+			else if (!strcmp(name, "zlib"))
+				c->mount_opts.compr =
+						JFFS2_COMPR_MODE_FORCEZLIB;
+#endif
+			else {
+				printk(KERN_ERR "JFFS2 Error: unknown compressor \"%s\"",
+						name);
+				kfree(name);
+				return -EINVAL;
 			}
 			kfree(name);
+			c->mount_opts.override_compr = true;
 			break;
 		default:
 			printk(KERN_ERR "JFFS2 Error: unrecognized mount option '%s' or missing value\n",
-- 
1.7.2.5

