Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab0IGVLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 17:11:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50374 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab0IGVLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 17:11:14 -0400
Date: Tue, 7 Sep 2010 14:09:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: david.cross@cypress.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] west bridge, block driver fixes
Message-Id: <20100907140920.452907b0.randy.dunlap@oracle.com>
In-Reply-To: <1283888253.7250.21.camel@odc-laptop>
References: <1283888253.7250.21.camel@odc-laptop>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Sep 2010 12:37:33 -0700 David Cross wrote:

> This patch makes minor fixes to the block driver for locking issues,
> printk statements and minor change for a kernel update to 2.6.36.
> Please let me know if there are issues or concerns with this patch.
> Thanks,
> David
> 
> Signed-off-by: David Cross <david.cross@cypress.com>

Missing "---" line after S-O-B line and before the first diff.

It's a good idea (but not required) to include a diffstat, like so:

> diffstat -p1 -w70 wb-block-drvr.patch 
 drivers/staging/westbridge/astoria/block/cyasblkdev_block.c |  188 +++++-----
 drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c |   12 
 drivers/staging/westbridge/astoria/block/cyasblkdev_queue.h |    2 
 3 files changed, 105 insertions(+), 97 deletions(-)


See Documentation/SubmittingPatches for info on both of these.


> 
> diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c linux-next-incl-sdk/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
> --- linux-next-vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c	2010-08-31 19:32:51.000000000 -0700
> +++ linux-next-incl-sdk/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c	2010-09-07 11:28:49.000000000 -0700
> @@ -202,7 +202,7 @@ static struct cyasblkdev_blk_data *cyasb
>  	if (bd) {
>  		bd->usage++;
>  		#ifndef NBDEBUG
> -		cy_as_hal_print_message(
> +		printk(KERN_INFO
>  			"cyasblkdev_blk_get: usage = %d\n", bd->usage) ;

No space before ';'.
Better to use __func__ for the function name, especially when it's long.

What usage is this telling about?
(This is what I thought should have been in userspace, but I was reading
this as telling someone about usage syntax and I now see that it's not
doing that at all.)


>  		#endif
>  	}
> @@ -222,12 +222,12 @@ static void cyasblkdev_blk_put(
>  	if (bd) {
>  		bd->usage--;
>  		#ifndef WESTBRIDGE_NDEBUG
> -		cy_as_hal_print_message(
> +		printk(KERN_INFO
>  			" cyasblkdev_blk_put , bd->usage= %d\n", bd->usage);

same question here.

>  		#endif
>  	} else  {
>  		#ifndef WESTBRIDGE_NDEBUG
> -		cy_as_hal_print_message(
> +		printk(KERN_INFO
>  			"cyasblkdev: blk_put(bd) on bd = NULL!: usage = %d\n",
>  			bd->usage);

This appears to be a debugging message, not user info.

>  		#endif
> @@ -244,7 +244,7 @@ static void cyasblkdev_blk_put(
>  		if (CY_AS_ERROR_SUCCESS !=
>  			cy_as_storage_release(bd->dev_handle, 0, 0, 0, 0)) {
>  			#ifndef WESTBRIDGE_NDEBUG
> -			cy_as_hal_print_message(
> +			printk(KERN_INFO
>  				"cyasblkdev: cannot release bus 0\n") ;

Ditto.
And no space before ';'.

>  			#endif
>  		}
> @@ -252,7 +252,7 @@ static void cyasblkdev_blk_put(
>  		if (CY_AS_ERROR_SUCCESS !=
>  			cy_as_storage_release(bd->dev_handle, 1, 0, 0, 0)) {
>  			#ifndef WESTBRIDGE_NDEBUG
> -			cy_as_hal_print_message(
> +			printk(KERN_INFO
>  				"cyasblkdev: cannot release bus 1\n") ;

Ditto.

>  			#endif
>  		}
> @@ -260,7 +260,7 @@ static void cyasblkdev_blk_put(
>  		if (CY_AS_ERROR_SUCCESS !=
>  			cy_as_storage_stop(bd->dev_handle, 0, 0)) {
>  			#ifndef WESTBRIDGE_NDEBUG
> -			cy_as_hal_print_message(
> +			printk(KERN_INFO
>  				"cyasblkdev: cannot stop storage stack\n") ;

Ditto.

>  			#endif
>  		}
> @@ -278,7 +278,7 @@ static void cyasblkdev_blk_put(
>  	}
>  
>  	#ifndef WESTBRIDGE_NDEBUG
> -	cy_as_hal_print_message(
> +	printk(KERN_INFO
>  		"cyasblkdev (blk_put): usage = %d\n",
>  		bd->usage) ;
>  	#endif
> @@ -304,7 +304,7 @@ static int cyasblkdev_blk_open(
>  		if (bdev->bd_disk == bd->user_disk_0) {
>  			if ((mode & FMODE_WRITE) && bd->user_disk_0_read_only) {
>  				#ifndef WESTBRIDGE_NDEBUG
> -				cy_as_hal_print_message(
> +				printk(KERN_INFO
>  					"device marked as readonly "
>  					"and write requested\n");

More debugging code.

>  				#endif
> @@ -315,7 +315,7 @@ static int cyasblkdev_blk_open(
>  		} else if (bdev->bd_disk == bd->user_disk_1) {
>  			if ((mode & FMODE_WRITE) && bd->user_disk_1_read_only) {
>  				#ifndef WESTBRIDGE_NDEBUG
> -				cy_as_hal_print_message(
> +				printk(KERN_INFO
>  					"device marked as readonly "
>  					"and write requested\n");
>  				#endif
> @@ -326,7 +326,7 @@ static int cyasblkdev_blk_open(
>  		} else if (bdev->bd_disk == bd->system_disk) {
>  			if ((mode & FMODE_WRITE) && bd->system_disk_read_only) {
>  				#ifndef WESTBRIDGE_NDEBUG
> -				cy_as_hal_print_message(
> +				printk(KERN_INFO
>  					"device marked as readonly "
>  					"and write requested\n");
>  				#endif
...
> @@ -452,7 +452,7 @@ static int cyasblkdev_blk_prep_rq(
>  	/* If we have no device, we haven't finished initialising. */
>  	if (!bd || !bd->dev_handle) {
>  		#ifndef WESTBRIDGE_NDEBUG
> -		cy_as_hal_print_message(KERN_ERR
> +		printk(KERN_ERR
>  			"cyasblkdev %s: killing request - no device/host\n",

ditto.

>  			req->rq_disk->disk_name);
>  		#endif
> @@ -466,7 +466,7 @@ static int cyasblkdev_blk_prep_rq(
>  
>  	/* Check for excessive requests.*/
>  	if (blk_rq_pos(req) + blk_rq_sectors(req) > get_capacity(req->rq_disk)) {
> -		cy_as_hal_print_message("cyasblkdev: bad request address\n");
> +		printk(KERN_INFO "cyasblkdev: bad request address\n");

ditto.

>  		stat = BLKPREP_KILL;
>  	}
>  
> @@ -496,20 +496,23 @@ static void cyasblkdev_issuecallback(
>  
>  	if (status != CY_AS_ERROR_SUCCESS) {
>  		#ifndef WESTBRIDGE_NDEBUG
> -		cy_as_hal_print_message(
> +		printk(KERN_INFO
>  		  "%s: async r/w: op:%d failed with error %d at address %d\n",
>  			__func__, op, status, block_number) ;
>  		#endif
>  	}
>  
>  	#ifndef WESTBRIDGE_NDEBUG
> -	cy_as_hal_print_message(
> +	printk(KERN_INFO
>  		"%s calling blk_end_request from issue_callback "
>  		"req=0x%x, status=0x%x, nr_sectors=0x%x\n",
>  		__func__, (unsigned int) gl_bd->queue.req, status,
>  		(unsigned int) blk_rq_sectors(gl_bd->queue.req)) ;

ditto.

>  	#endif
>  
> +	if (rq_data_dir(gl_bd->queue.req) != READ)
> +		cy_as_release_common_lock();
> +
>  	/* note: blk_end_request w/o __ prefix should
>  	 * not require spinlocks on the queue*/
>  	while (blk_end_request(gl_bd->queue.req,
> @@ -533,7 +536,7 @@ static void cyasblkdev_issuecallback(
>  		/* queue is not plugged */
>  		gl_bd->queue.req = blk_fetch_request(gl_bd->queue.queue);
>  		#ifndef WESTBRIDGE_NDEBUG
> -		cy_as_hal_print_message("%s blkdev_callback: "
> +		printk(KERN_INFO "%s blkdev_callback: "
>  		"blk_fetch_request():%p\n",

Line above should be indented same as the line below.

>  			__func__, gl_bd->queue.req);
>  		#endif
> @@ -543,7 +546,7 @@ static void cyasblkdev_issuecallback(
>  		spin_unlock_irq(&gl_bd->lock);
>  
>  		#ifndef WESTBRIDGE_NDEBUG
> -		cy_as_hal_print_message("%s blkdev_callback: about to "
> +		printk(KERN_INFO "%s blkdev_callback: about to "
>  		"call issue_fn:%p\n", __func__, gl_bd->queue.req);

Indent line above more.

>  		#endif
>  
...
> @@ -651,13 +654,14 @@ static int cyasblkdev_blk_issue_rq(
>  			bq->req = NULL ;
>  		}
>  	} else {
> +		cy_as_acquire_common_lock();
>  		ret = cy_as_storage_write_async(bd->dev_handle, bus_num, 0,
>  			lcl_unit_no, req_sector, bd->sg, req_nr_sectors,
>  			(cy_as_storage_callback)cyasblkdev_issuecallback);
>  
>  		if (ret != CY_AS_ERROR_SUCCESS) {
>  			#ifndef WESTBRIDGE_NDEBUG
> -			cy_as_hal_print_message("%s: write failed with "
> +			printk(KERN_INFO "%s: write failed with "

indentation

>  			"error %d at address %ld, unit no %d\n",
>  			__func__, ret, blk_rq_pos(req), lcl_unit_no);
>  			#endif
> @@ -690,7 +694,7 @@ static void cyasblkdev_storage_callback(
>  					)
>  {
>  	#ifndef WESTBRIDGE_NDEBUG
> -	cy_as_hal_print_message("%s: bus:%d, device:%d, evtype:%d, "
> +	printk(KERN_INFO "%s: bus:%d, device:%d, evtype:%d, "

indentation

>  	"evdata:%p\n ", __func__, bus, device, evtype, evdata);
>  	#endif
>  
...
> @@ -821,7 +825,7 @@ static int cyasblkdev_add_disks(int bus_
>  	cy_as_storage_query_unit_data unit_data = {0} ;
>  
>  	#ifndef WESTBRIDGE_NDEBUG
> -		cy_as_hal_print_message("%s:query device: "
> +		printk(KERN_INFO "%s:query device: "

indentation

>  		"type:%d, removable:%d, writable:%d, "
>  		"blksize %d, units:%d, locked:%d, "
>  		"erase_sz:%d\n",
> @@ -876,7 +880,7 @@ static int cyasblkdev_add_disks(int bus_
>  			if ((ret != CY_AS_ERROR_SUCCESS) &&
>  			(ret != CY_AS_ERROR_ALREADY_PARTITIONED)) {
>  			#ifndef WESTBRIDGE_NDEBUG
> -				cy_as_hal_print_message("%s: cy_as_storage_"
> +				printk(KERN_INFO "%s: cy_as_storage_"

indentation.
But it shouldn't be here at all, unless it's in a debugging form.
(i.e., not like this)

>  				"create_p_partition after size > 0 check "
>  				"failed with error code %d\n",
>  				__func__, ret);
> @@ -888,7 +892,7 @@ static int cyasblkdev_add_disks(int bus_
>  
>  			} else if (ret == CY_AS_ERROR_ALREADY_PARTITIONED) {
>  				#ifndef WESTBRIDGE_NDEBUG
> -				cy_as_hal_print_message(
> +				printk(KERN_INFO

indentation

>  				"%s: cy_as_storage_create_p_partition "
>  				"indicates memory already partitioned\n",
>  				__func__);
> @@ -911,7 +915,7 @@ static int cyasblkdev_add_disks(int bus_
>  							unit_data.unit = 1 ;
>  						} else {
>  							#ifndef WESTBRIDGE_NDEBUG
> -							cy_as_hal_print_message(
> +							printk(KERN_INFO

indentation

>  							"%s: cy_as_storage_create_p_partition "
>  							"after removal unexpectedly failed "
>  							"with error %d\n", __func__, ret) ;
> @@ -932,7 +936,7 @@ static int cyasblkdev_add_disks(int bus_
>  						&unit_data, 0, 0) ;
>  						if (ret != CY_AS_ERROR_SUCCESS) {
>  							#ifndef WESTBRIDGE_NDEBUG
> -							cy_as_hal_print_message(
> +							printk(KERN_INFO

same

>  							"%s: cannot query %d "
>  							"device unit - reason code %d\n",
>  							__func__, bus_num, ret) ;
> @@ -946,7 +950,7 @@ static int cyasblkdev_add_disks(int bus_
>  						}
>  					} else {
>  					#ifndef WESTBRIDGE_NDEBUG
> -					cy_as_hal_print_message(
> +					printk(KERN_INFO

same

>  					"%s: cy_as_storage_remove_p_partition "
>  					"failed with error %d\n",
>  					__func__, ret);
> @@ -960,7 +964,7 @@ static int cyasblkdev_add_disks(int bus_
>  							bd->dev_handle, &unit_data, 0, 0) ;
>  						if (ret != CY_AS_ERROR_SUCCESS) {
>  						#ifndef WESTBRIDGE_NDEBUG
> -							cy_as_hal_print_message(
> +							printk(KERN_INFO

same

>  							"%s: cannot query %d "
>  							"device unit - reason "
>  							"code %d\n", __func__,
> @@ -1006,7 +1010,7 @@ static int cyasblkdev_add_disks(int bus_
>  				}
>  			} else {
>  				#ifndef WESTBRIDGE_NDEBUG
> -				cy_as_hal_print_message(
> +				printk(KERN_INFO

same

>  				"%s: cy_as_storage_create_p_partition "
>  				"created successfully\n", __func__);
>  				#endif
> @@ -1020,7 +1024,7 @@ static int cyasblkdev_add_disks(int bus_
>  		}
>  		#ifndef WESTBRIDGE_NDEBUG
>  		else {
> -			cy_as_hal_print_message(
> +			printk(KERN_INFO

same

>  			"%s: invalid partition_size%d\n", __func__,
>  			private_partition_size);
>  
...
> @@ -1224,7 +1229,7 @@ static int cyasblkdev_add_disks(int bus_
>  			blk_queue_logical_block_size(bd->queue.queue,
>  				bd->user_disk_0_blk_size);
>  			#ifndef WESTBRIDGE_NDEBUG
> -			cy_as_hal_print_message(
> +			printk(KERN_INFO

indentation

>  			"%s: set hard sect_sz:%d\n",
>  			__func__,
>  			bd->user_disk_0_blk_size);
> @@ -1233,7 +1238,7 @@ static int cyasblkdev_add_disks(int bus_
>  			blk_queue_logical_block_size(bd->queue.queue,
>  				bd->user_disk_1_blk_size);
>  			#ifndef WESTBRIDGE_NDEBUG
> -			cy_as_hal_print_message(
> +			printk(KERN_INFO

same

>  			"%s: set hard sect_sz:%d\n",
>  			__func__,
>  			bd->user_disk_1_blk_size);
...
> diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c linux-next-incl-sdk/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c
> --- linux-next-vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c	2010-09-01 15:56:46.000000000 -0700
> +++ linux-next-incl-sdk/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c	2010-09-07 11:51:23.000000000 -0700
...
> @@ -192,7 +192,7 @@ static int cyasblkdev_queue_thread(void 
>  				"thread_sem->count=%d\n",
>  				__func__, bq->thread_sem.count);
>  			if (spin_is_locked(q->queue_lock)) {
> -				cy_as_hal_print_message("%s: queue_lock "
> +				printk(KERN_INFO "%s: queue_lock "

indentation

>  				"is locked, need to release\n", __func__);
>  				spin_unlock(q->queue_lock);
>  


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
