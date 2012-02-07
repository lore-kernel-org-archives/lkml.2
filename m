Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab2BGDbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 22:31:17 -0500
Received: from masquerade.micron.com ([137.201.242.130]:33590 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab2BGDbQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 22:31:16 -0500
X-Greylist: delayed 958 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Feb 2012 22:31:15 EST
From: "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONT - Type 2]" 
	<asamymuthupa@micron.com>
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
Subject: [PATCH v2 resend] mtip32xx: removed the irrelevant argument of
 mtip_hw_submit_io() and the unused member of struct driver_data
Thread-Topic: [PATCH v2 resend] mtip32xx: removed the irrelevant argument of
 mtip_hw_submit_io() and the unused member of struct driver_data
Thread-Index: AczlRmn7QfvCa9xJQTiA2J2o9I8A5w==
Date: Tue, 7 Feb 2012 03:15:02 +0000
Message-ID: <4F3096C3.7090100@micron.com>
Reply-To: "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONT - Type 2]" 
	  <asamymuthupa@micron.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222
 Thunderbird/9.0.1
x-ms-exchange-imapappendstamp: NTXBOICAS04.micron.com (14.01.0325.000)
x-originating-ip: [137.201.88.182]
x-tm-as-product-ver: SMEX-10.0.0.4152-6.500.1024-18694.004
x-tm-as-result: No--38.255500-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FA69D48259900E4882E758FACE27E146@exchange>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending the patch in plain text format. 

From: Asai Thambi S P <asamymuthupa@micron.com>

Removed the following:
	* irrelevant argument 'barrier' of mtip_hw_submit_io()
	* unused member 'eh_active' of struct driver_data

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Signed-off-by: Sam Bradshaw <sbradshaw@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |   11 +++++------
 drivers/block/mtip32xx/mtip32xx.h |    5 -----
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index b74eab7..8eb81c9 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -2068,8 +2068,6 @@ static int mtip_hw_ioctl(struct driver_data *dd, unsigned int cmd,
  *	     when the read completes.
  * @data     Callback data passed to the callback function
  *	     when the read completes.
- * @barrier  If non-zero, this command must be completed before
- *	     issuing any other commands.
  * @dir      Direction (read or write)
  *
  * return value
@@ -2077,7 +2075,7 @@ static int mtip_hw_ioctl(struct driver_data *dd, unsigned int cmd,
  */
 static void mtip_hw_submit_io(struct driver_data *dd, sector_t start,
 			      int nsect, int nents, int tag, void *callback,
-			      void *data, int barrier, int dir)
+			      void *data, int dir)
 {
 	struct host_to_dev_fis	*fis;
 	struct mtip_port *port = dd->port;
@@ -2108,8 +2106,6 @@ static void mtip_hw_submit_io(struct driver_data *dd, sector_t start,
 	*((unsigned int *) &fis->lba_low) = (start & 0xFFFFFF);
 	*((unsigned int *) &fis->lba_low_ex) = ((start >> 24) & 0xFFFFFF);
 	fis->device	 = 1 << 6;
-	if (barrier)
-		fis->device |= FUA_BIT;
 	fis->features    = nsect & 0xFF;
 	fis->features_ex = (nsect >> 8) & 0xFF;
 	fis->sect_count  = ((tag << 3) | (tag >> 5));
@@ -3087,7 +3083,6 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 				tag,
 				bio_endio,
 				bio,
-				bio->bi_rw & REQ_FUA,
 				bio_data_dir(bio));
 	} else
 		bio_io_error(bio);
@@ -3187,6 +3182,10 @@ skip_create_disk:
 	blk_queue_max_segments(dd->queue, MTIP_MAX_SG);
 	blk_queue_physical_block_size(dd->queue, 4096);
 	blk_queue_io_min(dd->queue, 4096);
+	/*
+	 * write back cache is not supported in the device. FUA depends on
+	 * write back cache support, hence setting flush support to zero.
+	 */
 	blk_queue_flush(dd->queue, 0);
 
 	/* Set the capacity of the device in 512 byte sectors. */
diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index 723d7c4..e0554a8 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -104,9 +104,6 @@
 /* BAR number used to access the HBA registers. */
 #define MTIP_ABAR		5
 
-/* Forced Unit Access Bit */
-#define FUA_BIT			0x80
-
 #ifdef DEBUG
  #define dbg_printk(format, arg...)	\
 	printk(pr_fmt(format), ##arg);
@@ -415,8 +412,6 @@ struct driver_data {
 
 	atomic_t resumeflag; /* Atomic variable to track suspend/resume */
 
-	atomic_t eh_active; /* Flag for error handling tracking */
-
 	struct task_struct *mtip_svc_handler; /* task_struct of svc thd */
 };
 
-- 

