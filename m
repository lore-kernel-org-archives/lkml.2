Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab0IBWuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 18:50:06 -0400
Received: from ns2.cypress.com ([157.95.67.5]:55754 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab0IBWuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 18:50:03 -0400
Subject: Re: [PATCH] West Bridge Astoria Driver 2.6.35, minor block and
 device driver updates
From: David Cross <david.cross@cypress.com>
Reply-To: david.cross@cypress.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1283386101.17399.10.camel@odc-laptop>
References: <5BFACB1451C1459BA8562A5561D0A4E6@stanford.edu>
	 <1283386101.17399.10.camel@odc-laptop>
Content-Type: text/plain
Organization: Cypress
Date: Thu, 02 Sep 2010 15:49:54 -0700
Message-Id: <1283467794.4378.17.camel@odc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains minor updates to the west bridge block and device
drivers, including the addition of a common lock and a minor update to
remove the blk_fs_request call based on a kernel update. These changes
could possibly be separated, but are very minor in scope and as such
have been submitted together.
Thanks,
David

Signed-off-by: David Cross <david.cross@cypress.com>

diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c linux-next-incl-sdk/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
--- linux-next-vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c	2010-08-31 19:32:51.000000000 -0700
+++ linux-next-incl-sdk/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c	2010-08-25 18:29:44.000000000 -0700
@@ -389,7 +389,7 @@ int cyasblkdev_media_changed(struct gend
 	struct cyasblkdev_blk_data *bd;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("cyasblkdev_media_changed() is called\n");
+	cy_as_hal_print_message(KERN_INFO"cyasblkdev_media_changed() is called\n");
 	#endif
 
 	if (gd)
@@ -466,7 +466,7 @@ static int cyasblkdev_blk_prep_rq(
 
 	/* Check for excessive requests.*/
 	if (blk_rq_pos(req) + blk_rq_sectors(req) > get_capacity(req->rq_disk)) {
-		cy_as_hal_print_message("cyasblkdev: bad request address\n");
+		cy_as_hal_print_message(KERN_INFO"cyasblkdev: bad request address\n");
 		stat = BLKPREP_KILL;
 	}
 
@@ -493,7 +493,7 @@ static void cyasblkdev_issuecallback(
 {
 	int retry_cnt = 0;
 	DBGPRN_FUNC_NAME;
-
+	
 	if (status != CY_AS_ERROR_SUCCESS) {
 		#ifndef WESTBRIDGE_NDEBUG
 		cy_as_hal_print_message(
@@ -509,7 +509,10 @@ static void cyasblkdev_issuecallback(
 		__func__, (unsigned int) gl_bd->queue.req, status,
 		(unsigned int) blk_rq_sectors(gl_bd->queue.req)) ;
 	#endif
-
+	
+	if(rq_data_dir(gl_bd->queue.req) != READ) {
+		cy_as_release_common_lock();
+	}
 	/* note: blk_end_request w/o __ prefix should
 	 * not require spinlocks on the queue*/
 	while (blk_end_request(gl_bd->queue.req,
@@ -533,7 +536,7 @@ static void cyasblkdev_issuecallback(
 		/* queue is not plugged */
 		gl_bd->queue.req = blk_fetch_request(gl_bd->queue.queue);
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s blkdev_callback: "
+		cy_as_hal_print_message(KERN_INFO"%s blkdev_callback: "
 		"blk_fetch_request():%p\n",
 			__func__, gl_bd->queue.req);
 		#endif
@@ -543,7 +546,7 @@ static void cyasblkdev_issuecallback(
 		spin_unlock_irq(&gl_bd->lock);
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s blkdev_callback: about to "
+		cy_as_hal_print_message(KERN_INFO"%s blkdev_callback: about to "
 		"call issue_fn:%p\n", __func__, gl_bd->queue.req);
 		#endif
 
@@ -585,7 +588,7 @@ static int cyasblkdev_blk_issue_rq(
 		lcl_unit_no = gl_bd->user_disk_0_unit_no;
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: request made to disk 0 "
+		cy_as_hal_print_message(KERN_INFO"%s: request made to disk 0 "
 			"for sector=%d, num_sectors=%d, unit_no=%d\n",
 			__func__, req_sector, (int) blk_rq_sectors(req),
 			lcl_unit_no);
@@ -598,7 +601,7 @@ static int cyasblkdev_blk_issue_rq(
 		lcl_unit_no = gl_bd->user_disk_1_unit_no;
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: request made to disk 1 for "
+		cy_as_hal_print_message(KERN_INFO"%s: request made to disk 1 for "
 			"sector=%d, num_sectors=%d, unit_no=%d\n", __func__,
 			req_sector, (int) blk_rq_sectors(req), lcl_unit_no);
 		#endif
@@ -609,7 +612,7 @@ static int cyasblkdev_blk_issue_rq(
 		lcl_unit_no = gl_bd->system_disk_unit_no;
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: request made to system disk "
+		cy_as_hal_print_message(KERN_INFO"%s: request made to system disk "
 			"for sector=%d, num_sectors=%d, unit_no=%d\n", __func__,
 			req_sector, (int) blk_rq_sectors(req), lcl_unit_no);
 		#endif
@@ -625,7 +628,7 @@ static int cyasblkdev_blk_issue_rq(
 
 	if (rq_data_dir(req) == READ) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: calling readasync() "
+		cy_as_hal_print_message(KERN_INFO"%s: calling readasync() "
 			"req_sector=0x%x, req_nr_sectors=0x%x, bd->sg:%x\n\n",
 			__func__, req_sector, req_nr_sectors, (uint32_t)bd->sg);
 		#endif
@@ -636,10 +639,10 @@ static int cyasblkdev_blk_issue_rq(
 
 		if (ret != CY_AS_ERROR_SUCCESS) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s:readasync() error %d at "
+			cy_as_hal_print_message(KERN_INFO"%s:readasync() error %d at "
 				"address %ld, unit no %d\n", __func__, ret,
 				blk_rq_pos(req), lcl_unit_no);
-			cy_as_hal_print_message("%s:ending i/o request "
+			cy_as_hal_print_message(KERN_INFO"%s:ending i/o request "
 				"on reg:%x\n", __func__, (uint32_t)req);
 			#endif
 
@@ -651,13 +654,14 @@ static int cyasblkdev_blk_issue_rq(
 			bq->req = NULL ;
 		}
 	} else {
+		cy_as_acquire_common_lock();
 		ret = cy_as_storage_write_async(bd->dev_handle, bus_num, 0,
 			lcl_unit_no, req_sector, bd->sg, req_nr_sectors,
 			(cy_as_storage_callback)cyasblkdev_issuecallback);
 
 		if (ret != CY_AS_ERROR_SUCCESS) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: write failed with "
+			cy_as_hal_print_message(KERN_INFO"%s: write failed with "
 			"error %d at address %ld, unit no %d\n",
 			__func__, ret, blk_rq_pos(req), lcl_unit_no);
 			#endif
@@ -690,7 +694,7 @@ static void cyasblkdev_storage_callback(
 					)
 {
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("%s: bus:%d, device:%d, evtype:%d, "
+	cy_as_hal_print_message(KERN_INFO"%s: bus:%d, device:%d, evtype:%d, "
 	"evdata:%p\n ", __func__, bus, device, evtype, evdata);
 	#endif
 
@@ -746,7 +750,7 @@ uint32_t cyasblkdev_get_vfat_offset(int 
 
 	for (sect_no = 0; sect_no < SECTORS_TO_SCAN; sect_no++) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s before cyasstorageread "
+		cy_as_hal_print_message(KERN_INFO"%s before cyasstorageread "
 			"gl_bd->sg addr=0x%x\n", __func__,
 			(unsigned int) gl_bd->sg);
 		#endif
@@ -787,8 +791,8 @@ uint32_t cyasblkdev_get_vfat_offset(int 
 
 		if (stat != 0) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s sector scan error\n",
-				__func__);
+			cy_as_hal_print_message(KERN_INFO"%s sector scan error: %d\n",
+				__func__, stat);
 			#endif
 			break;
 		}
@@ -821,7 +825,7 @@ static int cyasblkdev_add_disks(int bus_
 	cy_as_storage_query_unit_data unit_data = {0} ;
 
 	#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s:query device: "
+		cy_as_hal_print_message(KERN_INFO"%s:query device: "
 		"type:%d, removable:%d, writable:%d, "
 		"blksize %d, units:%d, locked:%d, "
 		"erase_sz:%d\n",
@@ -846,7 +850,7 @@ static int cyasblkdev_add_disks(int bus_
 			bd->dev_handle, bus_num, 0, 0, 0) ;
 		if (ret != CY_AS_ERROR_SUCCESS) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s cannot release"
+			cy_as_hal_print_message(KERN_INFO"%s cannot release"
 				" storage\n", __func__) ;
 			#endif
 			goto out;
@@ -861,7 +865,7 @@ static int cyasblkdev_add_disks(int bus_
 		&unit_data, 0, 0) ;
 	if (ret != CY_AS_ERROR_SUCCESS) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: cannot query "
+		cy_as_hal_print_message(KERN_INFO"%s: cannot query "
 			"%d device unit - reason code %d\n",
 			__func__, bus_num, ret) ;
 		#endif
@@ -876,7 +880,7 @@ static int cyasblkdev_add_disks(int bus_
 			if ((ret != CY_AS_ERROR_SUCCESS) &&
 			(ret != CY_AS_ERROR_ALREADY_PARTITIONED)) {
 			#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message("%s: cy_as_storage_"
+				cy_as_hal_print_message(KERN_INFO"%s: cy_as_storage_"
 				"create_p_partition after size > 0 check "
 				"failed with error code %d\n",
 				__func__, ret);
@@ -976,7 +980,7 @@ static int cyasblkdev_add_disks(int bus_
 					}
 				} else {
 					#ifndef WESTBRIDGE_NDEBUG
-					cy_as_hal_print_message("%s: partition "
+					cy_as_hal_print_message(KERN_INFO"%s: partition "
 						"exists and sizes equal\n",
 						__func__);
 					#endif
@@ -1054,13 +1058,13 @@ static int cyasblkdev_add_disks(int bus_
 		#endif
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: setting gendisk disk "
+		cy_as_hal_print_message(KERN_INFO"%s: setting gendisk disk "
 			"capacity to %d\n", __func__, (int) disk_cap);
 		#endif
 
 		/* initializing bd->queue */
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: init bd->queue\n",
+		cy_as_hal_print_message(KERN_INFO"%s: init bd->queue\n",
 			__func__);
 		#endif
 
@@ -1111,7 +1115,8 @@ static int cyasblkdev_add_disks(int bus_
 		 * public partition beginning */
 		if (vfat_search) {
 			bd->user_disk_0_first_sector =
-				cyasblkdev_get_vfat_offset(0,
+				cyasblkdev_get_vfat_offset(
+					bd->user_disk_0_bus_num,
 					bd->user_disk_0_unit_no);
 		} else {
 			bd->user_disk_0_first_sector = 0;
@@ -1244,7 +1249,8 @@ static int cyasblkdev_add_disks(int bus_
 		if (vfat_search) {
 			bd->user_disk_1_first_sector =
 				cyasblkdev_get_vfat_offset(
-					1, bd->user_disk_1_unit_no);
+					bd->user_disk_1_bus_num,
+					bd->user_disk_1_unit_no);
 		} else {
 			bd->user_disk_1_first_sector
 				= 0;
@@ -1342,7 +1348,7 @@ static struct cyasblkdev_blk_data *cyasb
 		}
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s west bridge device handle:%x\n",
+		cy_as_hal_print_message(KERN_INFO"%s west bridge device handle:%x\n",
 			__func__, (uint32_t)bd->dev_handle);
 		#endif
 
@@ -1356,7 +1362,7 @@ static struct cyasblkdev_blk_data *cyasb
 		if ((stat != CY_AS_ERROR_SUCCESS) &&
 		(stat != CY_AS_ERROR_RESOURCE_NOT_OWNED)) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: cannot release "
+			cy_as_hal_print_message(KERN_INFO"%s: cannot release "
 				"resource bus 0 - reason code %d\n",
 				__func__, stat) ;
 			#endif
@@ -1366,7 +1372,7 @@ static struct cyasblkdev_blk_data *cyasb
 		if ((stat != CY_AS_ERROR_SUCCESS) &&
 		(stat != CY_AS_ERROR_RESOURCE_NOT_OWNED)) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: cannot release "
+			cy_as_hal_print_message(KERN_INFO"%s: cannot release "
 				"resource bus 0 - reason code %d\n",
 				__func__, stat) ;
 			#endif
@@ -1376,14 +1382,14 @@ static struct cyasblkdev_blk_data *cyasb
 		stat = cy_as_storage_start(bd->dev_handle, 0, 0x101) ;
 		if (stat != CY_AS_ERROR_SUCCESS) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: cannot start storage "
+			cy_as_hal_print_message(KERN_INFO"%s: cannot start storage "
 				"stack - reason code %d\n", __func__, stat) ;
 			#endif
 			goto out;
 		}
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: storage started:%d ok\n",
+		cy_as_hal_print_message(KERN_INFO"%s: storage started:%d ok\n",
 			__func__, stat);
 		#endif
 
@@ -1391,7 +1397,7 @@ static struct cyasblkdev_blk_data *cyasb
 			cyasblkdev_storage_callback);
 		if (stat != CY_AS_ERROR_SUCCESS) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: cannot register callback "
+			cy_as_hal_print_message(KERN_INFO"%s: cannot register callback "
 				"- reason code %d\n", __func__, stat) ;
 			#endif
 			goto out;
@@ -1405,7 +1411,7 @@ static struct cyasblkdev_blk_data *cyasb
 					bd->media_count[bus_num];
 			} else {
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message("%s: cannot query %d, "
+				cy_as_hal_print_message(KERN_INFO"%s: cannot query %d, "
 					"reason code: %d\n",
 					__func__, bus_num, stat) ;
 				#endif
@@ -1433,7 +1439,7 @@ static struct cyasblkdev_blk_data *cyasb
 			}
 			#ifndef WESTBRIDGE_NDEBUG
 			else {
-				cy_as_hal_print_message("%s: no available "
+				cy_as_hal_print_message(KERN_INFO"%s: no available "
 					"gen_disk for disk 0, "
 					"physically inconsistent\n", __func__);
 			}
@@ -1453,7 +1459,7 @@ static struct cyasblkdev_blk_data *cyasb
 			}
 			#ifndef WESTBRIDGE_NDEBUG
 			else {
-				cy_as_hal_print_message("%s: no available "
+				cy_as_hal_print_message(KERN_INFO"%s: no available "
 					"gen_disk for media, "
 					"physically inconsistent\n", __func__);
 			}
@@ -1461,13 +1467,13 @@ static struct cyasblkdev_blk_data *cyasb
 		}
 		#ifndef WESTBRIDGE_NDEBUG
 		else if (total_media_count > 2) {
-			cy_as_hal_print_message("%s: count corrupted = 0x%d\n",
+			cy_as_hal_print_message(KERN_INFO"%s: count corrupted = 0x%d\n",
 				__func__, total_media_count);
 		}
 		#endif
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: %d device(s) found\n",
+		cy_as_hal_print_message(KERN_INFO"%s: %d device(s) found\n",
 			__func__, total_media_count) ;
 		#endif
 
@@ -1476,7 +1482,7 @@ static struct cyasblkdev_blk_data *cyasb
 			stat = cy_as_storage_claim(bd->dev_handle,
 				bus_num, 0, 0, 0) ;
 			if (stat != CY_AS_ERROR_SUCCESS) {
-				cy_as_hal_print_message("%s: cannot claim "
+				cy_as_hal_print_message(KERN_INFO"%s: cannot claim "
 					"%d bus - reason code %d\n",
 					__func__, bus_num, stat) ;
 				goto out;
@@ -1570,7 +1576,7 @@ static int __init cyasblkdev_blk_init(vo
 		return 0;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("cyasblkdev init error:%d\n", res);
+	cy_as_hal_print_message(KERN_INFO"cyasblkdev init error:%d\n", res);
 	#endif
 	return res;
 }
diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c linux-next-incl-sdk/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c
--- linux-next-vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c	2010-09-01 15:56:46.000000000 -0700
+++ linux-next-incl-sdk/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c	2010-09-01 15:57:26.000000000 -0700
@@ -95,9 +95,9 @@ static int cyasblkdev_prep_request(
 	DBGPRN_FUNC_NAME;
 
 	/* we only like normal block requests.*/
-	if (!blk_fs_request(req)) {
+	if (req->cmd_type != REQ_TYPE_FS && !(req->cmd_flags & REQ_DISCARD)) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s:%x bad request received\n",
+		cy_as_hal_print_message(KERN_INFO"%s:%x bad request received\n",
 			__func__, current->pid) ;
 		#endif
 
@@ -192,7 +192,7 @@ static int cyasblkdev_queue_thread(void 
 				"thread_sem->count=%d\n",
 				__func__, bq->thread_sem.count);
 			if (spin_is_locked(q->queue_lock)) {
-				cy_as_hal_print_message("%s: queue_lock "
+				cy_as_hal_print_message(KERN_INFO"%s: queue_lock "
 				"is locked, need to release\n", __func__);
 				spin_unlock(q->queue_lock);
 
@@ -249,7 +249,7 @@ static int cyasblkdev_queue_thread(void 
 	complete_and_exit(&bq->thread_complete, 0);
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("%s: is finished\n", __func__) ;
+	cy_as_hal_print_message(KERN_INFO"%s: is finished\n", __func__) ;
 	#endif
 
 	return 0;
@@ -274,7 +274,7 @@ static void cyasblkdev_request(struct re
 
 	if (!bq->req) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s wake_up(&bq->thread_wq)\n",
+		cy_as_hal_print_message(KERN_INFO"%s wake_up(&bq->thread_wq)\n",
 			__func__);
 		#endif
 
@@ -282,7 +282,7 @@ static void cyasblkdev_request(struct re
 		wake_up(&bq->thread_wq);
 	} else {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: don't wake Q_thr, bq->req:%x\n",
+		cy_as_hal_print_message(KERN_INFO"%s: don't wake Q_thr, bq->req:%x\n",
 			__func__, (uint32_t)bq->req);
 		#endif
 	}
diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.h linux-next-incl-sdk/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.h
--- linux-next-vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.h	2010-08-31 19:32:51.000000000 -0700
+++ linux-next-incl-sdk/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.h	2010-08-23 16:45:15.000000000 -0700
@@ -54,6 +54,8 @@ extern int cyasblkdev_init_queue(struct 
 extern void cyasblkdev_cleanup_queue(struct cyasblkdev_queue *);
 extern void cyasblkdev_queue_suspend(struct cyasblkdev_queue *);
 extern void cyasblkdev_queue_resume(struct cyasblkdev_queue *);
+extern void cy_as_acquire_common_lock(void);
+extern void cy_as_release_common_lock(void);
 
 extern cy_as_device_handle cyasdevice_getdevhandle(void) ;
 #define MOD_LOGS 1
diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/device/cyasdevice.c linux-next-incl-sdk/drivers/staging/westbridge/astoria/device/cyasdevice.c
--- linux-next-vanilla/drivers/staging/westbridge/astoria/device/cyasdevice.c	2010-08-31 19:32:51.000000000 -0700
+++ linux-next-incl-sdk/drivers/staging/westbridge/astoria/device/cyasdevice.c	2010-08-27 17:49:42.000000000 -0700
@@ -48,6 +48,8 @@ typedef struct cyasdevice {
 		cy_as_device_handle			dev_handle;
 		/* Handle to the HAL */
 		cy_as_hal_device_tag			hal_tag;
+		spinlock_t	  common_lock;
+		unsigned long flags;
 } cyasdevice ;
 
 /* global ptr to astoria device */
@@ -82,12 +84,19 @@ static void cyasdevice_deinit(cyasdevice
 	if (cy_as_dev->hal_tag) {
 
  #ifdef CONFIG_MACH_OMAP3_WESTBRIDGE_AST_PNAND_HAL
-		if (stop_o_m_a_p_kernel(dev_handle_name,
+		if (cy_as_hal_omap_pnand_stop(dev_handle_name,
 			cy_as_dev->hal_tag) != 0)
 			cy_as_hal_print_message("<1>_cy_as_device: stopping "
-				"OMAP kernel HAL failed\n");
+				"OMAP PNAND HAL failed\n");
 
  #endif
+ 
+  #ifdef CONFIG_MACH_OMAP3_WESTBRIDGE_AST_CRAM_HAL
+		if (cy_as_hal_omap_cram_stop(dev_handle_name,
+			cy_as_dev->hal_tag) != 0)
+			cy_as_hal_print_message("<1>_cy_as_device: stopping "
+				"OMAP CRAM HAL failed\n");
+ #endif
 	}
 	cy_as_hal_print_message("<1>_cy_as_device:HAL layer stopped\n") ;
 
@@ -126,6 +135,28 @@ static void cy_misc_callback(cy_as_devic
 	}
 }
 
+void cy_as_acquire_common_lock()
+{
+	/*printk("%s: lock address is 0x%x, is_locked=0x%x\n", __func__,
+		&cy_as_device_controller->common_lock,
+		spin_is_locked(&cy_as_device_controller->common_lock));*/
+	spin_lock_irqsave(&cy_as_device_controller->common_lock, 
+		cy_as_device_controller->flags);/*
+		printk("%s: -- is_locked=0x%x\n", __func__,
+		spin_is_locked(&cy_as_device_controller->common_lock));*/
+}
+EXPORT_SYMBOL(cy_as_acquire_common_lock);
+
+void cy_as_release_common_lock()
+{
+	/*printk("%s: lock address is 0x%x, is_locked=0x%x\n", __func__,
+		&cy_as_device_controller->common_lock,
+		spin_is_locked(&cy_as_device_controller->common_lock));*/
+	spin_unlock_irqrestore(&cy_as_device_controller->common_lock,
+	cy_as_device_controller->flags);
+}
+EXPORT_SYMBOL(cy_as_release_common_lock);
+
 /* reset astoria and reinit all regs */
  #define PNAND_REG_CFG_INIT_VAL 0x0000
 void  hal_reset(cy_as_hal_device_tag tag)
@@ -188,7 +219,7 @@ static int cyasdevice_initialize(void)
 	cy_as_device_init_done = 0;
 
 	cy_as_misc_set_log_level(8);
-
+	
 	cy_as_hal_print_message("<1>_cy_as_device initialize called\n") ;
 
 	if (cy_as_device_controller != 0) {
@@ -212,7 +243,7 @@ static int cyasdevice_initialize(void)
  #ifdef CONFIG_MACH_OMAP3_WESTBRIDGE_AST_PNAND_HAL
  /* start OMAP HAL init instsnce */
 
-	if (!start_o_m_a_p_kernel(dev_handle_name,
+	if (!cy_as_hal_omap_pnand_start(dev_handle_name,
 		&(cy_as_dev->hal_tag), cy_false)) {
 
 		cy_as_hal_print_message(
@@ -221,6 +252,17 @@ static int cyasdevice_initialize(void)
 	}
  #endif
 
+ #ifdef CONFIG_MACH_OMAP3_WESTBRIDGE_AST_CRAM_HAL
+ /* start OMAP HAL init instsnce */
+
+	if (!cy_as_hal_omap_cram_start(dev_handle_name,
+		&(cy_as_dev->hal_tag), cy_false)) {
+
+		cy_as_hal_print_message(
+			"<1>_cy_as_device: start OMAP34xx HAL failed\n") ;
+		goto done;
+	}
+ #endif
 	/* Now create the device */
 	if (cy_as_misc_create_device(&(cy_as_dev->dev_handle),
 		cy_as_dev->hal_tag) != CY_AS_ERROR_SUCCESS) {
@@ -331,9 +373,15 @@ static int cyasdevice_initialize(void)
 		((ver_data.is_debug_mode) ? "debug" : "release"),
 		ver_data.major, ver_data.minor, ver_data.build, str) ;
 
+	printk("%s: lock address is 0x%x\n", __func__, &cy_as_dev->common_lock);
+	spin_lock_init(&cy_as_dev->common_lock);
+	printk("%s: lock address is 0x%x\n", __func__, &cy_as_dev->common_lock);
+
 	/* done now */
 	cy_as_device_controller = cy_as_dev ;
-
+	
+	
+	
 	return 0 ;
 
 done:


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

