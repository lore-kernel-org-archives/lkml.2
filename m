Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534Ab1EMPst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:48:49 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:58359 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756567Ab1EMPsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:48:46 -0400
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: kernel-janitors@vger.kernel.org, Andres More <more.andres@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/staging/vt6656/main_usb.c: Delete unnecessary call to usb_kill_urb
Date: Fri, 13 May 2011 17:48:41 +0200
Message-Id: <1305301721-21330-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since in each case nothing has been done with the recently allocated urb,
it is not necessary to kill it before freeing it.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression urb;
statement S;
position p1,p2;
@@

urb = usb_alloc_urb@p1(...);
... when != urb
if (urb == NULL) S
... when != urb
usb_kill_urb@p2(urb);

@other exists@
position r.p1,r.p2;
@@

... when != usb_alloc_urb@p1(...)
usb_kill_urb@p2(...);

@depends on !other exists@
expression urb;
position r.p1,r.p2;
@@

urb = usb_alloc_urb@p1(...);
...
(
-usb_kill_urb@p2(urb);
+usb_free_urb(urb);
... when != urb
|
-usb_kill_urb@p2(urb);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/vt6656/main_usb.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 9a8eaf1..e18efd4 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -955,7 +955,6 @@ static BOOL device_alloc_bufs(PSDevice pDevice) {
 	pDevice->pInterruptURB = usb_alloc_urb(0, GFP_ATOMIC);
 	if (pDevice->pInterruptURB == NULL) {
 	    DBG_PRT(MSG_LEVEL_ERR,KERN_ERR"Failed to alloc int urb\n");
-   	    usb_kill_urb(pDevice->pControlURB);
 	    usb_free_urb(pDevice->pControlURB);
 	    goto free_rx_tx;
 	}
@@ -963,8 +962,6 @@ static BOOL device_alloc_bufs(PSDevice pDevice) {
     pDevice->intBuf.pDataBuf = kmalloc(MAX_INTERRUPT_SIZE, GFP_KERNEL);
 	if (pDevice->intBuf.pDataBuf == NULL) {
 	    DBG_PRT(MSG_LEVEL_ERR,KERN_ERR"Failed to alloc int buf\n");
-   	    usb_kill_urb(pDevice->pControlURB);
-   	    usb_kill_urb(pDevice->pInterruptURB);
 	    usb_free_urb(pDevice->pControlURB);
 	    usb_free_urb(pDevice->pInterruptURB);
 	    goto free_rx_tx;

