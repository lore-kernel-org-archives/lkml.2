Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594Ab0HLAEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:04:40 -0400
Received: from kroah.org ([198.145.64.141]:60202 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759225Ab0HLAEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:04:16 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:01:25 2010
Message-Id: <20100812000125.743096150@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:00:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Subject: [27/54] bio, fs: update RWA_MASK, READA and SWRITE to match the corresponding BIO_RW_* bits
In-Reply-To: <20100812000249.GA30948@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit aca27ba9618276dd2f777bcd5a1419589ccf1ca8 upstream.

Commit a82afdf (block: use the same failfast bits for bio and request)
moved BIO_RW_* bits around such that they match up with REQ_* bits.
Unfortunately, fs.h hard coded RW_MASK, RWA_MASK, READ, WRITE, READA
and SWRITE as 0, 1, 2 and 3, and expected them to match with BIO_RW_*
bits.  READ/WRITE didn't change but BIO_RW_AHEAD was moved to bit 4
instead of bit 1, breaking RWA_MASK, READA and SWRITE.

This patch updates RWA_MASK, READA and SWRITE such that they match the
BIO_RW_* bits again.  A follow up patch will update the definitions to
directly use BIO_RW_* bits so that this kind of breakage won't happen
again.

Neil also spotted missing RWA_MASK conversion.

Stable: The offending commit a82afdf was released with v2.6.32, so
this patch should be applied to all kernels since then but it must
_NOT_ be applied to kernels earlier than that.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-and-bisected-by: Vladislav Bolkhovitin <vst@vlnb.net>
Root-caused-by: Neil Brown <neilb@suse.de>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/fs.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -145,11 +145,11 @@ struct inodes_stat_t {
  *
  */
 #define RW_MASK		1
-#define RWA_MASK	2
+#define RWA_MASK		16
 #define READ 0
 #define WRITE 1
-#define READA 2		/* read-ahead  - don't block if no resources */
-#define SWRITE 3	/* for ll_rw_block() - wait for buffer lock */
+#define READA			16 /* readahead - don't block if no resources */
+#define SWRITE			17 /* for ll_rw_block(), wait for buffer lock */
 #define READ_SYNC	(READ | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
 #define READ_META	(READ | (1 << BIO_RW_META))
 #define WRITE_SYNC_PLUG	(WRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_NOIDLE))


