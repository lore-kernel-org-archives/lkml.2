Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab0HPQgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 12:36:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:42340 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642Ab0HPQgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 12:36:37 -0400
Message-ID: <4C696852.1080709@kernel.org>
Date: Mon, 16 Aug 2010 18:33:22 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH UPDATED 10/11] fs, block: propagate REQ_FLUSH/FUA interface
 to upper layers
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <1281616891-5691-11-git-send-email-tj@kernel.org>
In-Reply-To: <1281616891-5691-11-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 16 Aug 2010 16:36:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Propagate deprecation of REQ_HARDBARRIER and new REQ_FLUSH/FUA
interface to upper layers.

* WRITE_BARRIER is marked deprecated and WRITE_FLUSH, WRITE_FUA and
  WRITE_FLUSH_FUA are added.

* REQ_COMMON_MASK now includes REQ_FLUSH | REQ_FUA so that they are
  copied from bio to request.

* BH_Ordered and BH_Eopnotsupp are marked deprecated.  BH_Flush/FUA
  are _NOT_ added as they can and should be specified when calling
  submit_bh() as @rw parameter as suggested by Jan Kara.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>
---
Dropped BH_Flush/FUA as suggested.

Thanks.

 include/linux/blk_types.h   |    2 +-
 include/linux/buffer_head.h |    4 ++--
 include/linux/fs.h          |   20 +++++++++++++-------
 3 files changed, 16 insertions(+), 10 deletions(-)

Index: block/include/linux/fs.h
===================================================================
--- block.orig/include/linux/fs.h
+++ block/include/linux/fs.h
@@ -138,13 +138,13 @@ struct inodes_stat_t {
  * SWRITE_SYNC
  * SWRITE_SYNC_PLUG	Like WRITE_SYNC/WRITE_SYNC_PLUG, but locks the buffer.
  *			See SWRITE.
- * WRITE_BARRIER	Like WRITE_SYNC, but tells the block layer that all
- *			previously submitted writes must be safely on storage
- *			before this one is started. Also guarantees that when
- *			this write is complete, it itself is also safely on
- *			storage. Prevents reordering of writes on both sides
- *			of this IO.
- *
+ * WRITE_BARRIER	DEPRECATED. Always fails. Use FLUSH/FUA instead.
+ * WRITE_FLUSH		Like WRITE_SYNC but with preceding cache flush.
+ * WRITE_FUA		Like WRITE_SYNC but data is guaranteed to be on
+ *			non-volatile media on completion.
+ * WRITE_FLUSH_FUA	Combination of WRITE_FLUSH and FUA.  The IO is preceded
+ *			by a cache flush and data is guaranteed to be on
+ *			non-volatile media on completion.
  */
 #define RW_MASK			REQ_WRITE
 #define RWA_MASK		REQ_RAHEAD
@@ -162,6 +162,12 @@ struct inodes_stat_t {
 #define WRITE_META		(WRITE | REQ_META)
 #define WRITE_BARRIER		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
 				 REQ_HARDBARRIER)
+#define WRITE_FLUSH		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
+				 REQ_FLUSH)
+#define WRITE_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
+				 REQ_FUA)
+#define WRITE_FLUSH_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
+				 REQ_FLUSH | REQ_FUA)
 #define SWRITE_SYNC_PLUG	(SWRITE | REQ_SYNC | REQ_NOIDLE)
 #define SWRITE_SYNC		(SWRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG)

Index: block/include/linux/blk_types.h
===================================================================
--- block.orig/include/linux/blk_types.h
+++ block/include/linux/blk_types.h
@@ -164,7 +164,7 @@ enum rq_flag_bits {
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
 #define REQ_COMMON_MASK \
 	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_HARDBARRIER | REQ_SYNC | \
-	 REQ_META| REQ_DISCARD | REQ_NOIDLE)
+	 REQ_META | REQ_DISCARD | REQ_NOIDLE | REQ_FLUSH | REQ_FUA)

 #define REQ_UNPLUG		(1 << __REQ_UNPLUG)
 #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
Index: block/include/linux/buffer_head.h
===================================================================
--- block.orig/include/linux/buffer_head.h
+++ block/include/linux/buffer_head.h
@@ -32,8 +32,8 @@ enum bh_state_bits {
 	BH_Delay,	/* Buffer is not yet allocated on disk */
 	BH_Boundary,	/* Block is followed by a discontiguity */
 	BH_Write_EIO,	/* I/O error on write */
-	BH_Ordered,	/* ordered write */
-	BH_Eopnotsupp,	/* operation not supported (barrier) */
+	BH_Ordered,	/* DEPRECATED: ordered write */
+	BH_Eopnotsupp,	/* DEPRECATED: operation not supported (barrier) */
 	BH_Unwritten,	/* Buffer is allocated on disk but not written */
 	BH_Quiet,	/* Buffer Error Prinks to be quiet */

