Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab0HTVbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 17:31:53 -0400
Received: from gateway08.websitewelcome.com ([67.18.53.17]:40279 "HELO
	gateway08.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750828Ab0HTVbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 17:31:51 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Aug 2010 17:31:51 EDT
Date: Fri, 20 Aug 2010 15:25:10 -0600
From: Kevin Vigor <kevin@vigor.nu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, kevin@vigor.nu
Subject: PATCH: dangling pointer when switching to noop elevator in obscure
 block drivers.
Message-ID: <20100820212510.GB29022@jimi.int.fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator417.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - vigor.nu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux 2.6.35 introduced a test in the beginning of elevator_init(), like
so:

     if (unlikely(q->elevator))
         return 0;

So the following code sequence, which appears in two (obscure) block
drivers is now a serious error:

        elevator_exit(q);
        elevator_init(q, "noop");

The intent is to cleanup the default system elevator and replace it with
the noop elevator. Instead, elevator_exit() frees the existing elevator
object, but leaves q->elevator pointing to it; elevator_init() then
silently fails since q->elevator is non-NULL, and the queue is left with
the elevator pointer invalid, This leads to untold woe and segfaults
later.

The fix is trivial: zero the q->elevator pointer before calling
elevator_init(). Note that drivers/s390/block/dasd.c already follows
this pattern.

I do not have the hardware to actually test either of the two afflicted 
drivers, but I believe the fix to be sufficiently obvious. The following
patches are against the current version of Linus' tree.

Signed-off-by: Kevin Vigor <kevin@vigor.nu>

   Thanks, 
      Kevin Vigor


diff --git a/drivers/s390/char/tape_block.c b/drivers/s390/char/tape_block.c
index b7de025..a1028c9 100644
--- a/drivers/s390/char/tape_block.c
+++ b/drivers/s390/char/tape_block.c
@@ -218,6 +218,7 @@ tapeblock_setup_device(struct tape_device * device)
 		return -ENOMEM;
 
 	elevator_exit(blkdat->request_queue->elevator);
+	blkdat->request_queue->elevator = NULL;
 	rc = elevator_init(blkdat->request_queue, "noop");
 	if (rc)
 		goto cleanup_queue;


diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index b82c5ce..c553404 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -975,6 +975,7 @@ static int mg_probe(struct platform_device *plat_dev)
 
 	/* mflash is random device, thanx for the noop */
 	elevator_exit(host->breq->elevator);
+	host->breq->elevator = NULL;
 	err = elevator_init(host->breq, "noop");
 	if (err) {
 		printk(KERN_ERR "%s:%d (elevator_init) fail\n",
