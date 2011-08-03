Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab1HCGGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 02:06:45 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43962 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab1HCGGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 02:06:39 -0400
Message-ID: <4E38E552.2030207@oracle.com>
Date: Wed, 03 Aug 2011 14:06:10 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
CC: Joe Jin <joe.jin@oracle.com>, Daniel Stodden <daniel.stodden@citrix.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Annie Li <annie.li@oracle.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>,
        Greg Marsden <greg.marsden@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -v2 2/3] xen-blkback: repleace check kthread_should_stop()
 to remove_requested in xen_blkif_schedule() loop.
References: <4E38E4A2.3070003@oracle.com>
In-Reply-To: <4E38E4A2.3070003@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4E38E568.00E8:SCFMA922111,ss=1,re=-4.000,fgs=0
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When backend state change to XenbusStateClosed, remove_requested will be set,
so repleace check kthread_should_stop() to remove_requested in 
xen_blkif_schedule() loop.

Signed-off-by: Joe Jin <joe.jin@oracle.com>
Cc: Daniel Stodden <daniel.stodden@citrix.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Annie Li <annie.li@oracle.com>
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>
--
 drivers/block/xen-blkback/blkback.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 2330a9a..3d64b52 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -274,7 +274,7 @@ int xen_blkif_schedule(void *arg)
 
 	xen_blkif_get(blkif);
 
-	while (!kthread_should_stop()) {
+	while (!blkif->remove_requested) {
 		if (try_to_freeze())
 			continue;
 		if (unlikely(vbd->size != vbd_sz(vbd)))
@@ -282,11 +282,11 @@ int xen_blkif_schedule(void *arg)
 
 		wait_event_interruptible(
 			blkif->wq,
-			blkif->waiting_reqs || kthread_should_stop());
+			blkif->waiting_reqs || blkif->remove_requested);
 		wait_event_interruptible(
 			blkbk->pending_free_wq,
 			!list_empty(&blkbk->pending_free) ||
-			kthread_should_stop());
+			blkif->remove_requested);
 
 		blkif->waiting_reqs = 0;
 		smp_mb(); /* clear flag *before* checking for work */
@@ -301,8 +301,8 @@ int xen_blkif_schedule(void *arg)
 	if (log_stats)
 		print_stats(blkif);
 
-	blkif->xenblkd = NULL;
 	xen_blkif_put(blkif);
+	xen_blkback_close(blkif);
 
 	return 0;
 }
@@ -476,7 +476,7 @@ __do_block_io_op(struct xen_blkif *blkif)
 		if (RING_REQUEST_CONS_OVERFLOW(&blk_rings->common, rc))
 			break;
 
-		if (kthread_should_stop()) {
+		if (blkif->remove_requested) {
 			more_to_do = 1;
 			break;
 		}

