Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab0E0Mh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 08:37:28 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:52135 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086Ab0E0MhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 08:37:25 -0400
Date: Thu, 27 May 2010 14:37:19 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 10/11] drivers/staging: Eliminate a NULL pointer dereference
Message-ID: <Pine.LNX.4.64.1005271437010.5422@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Eliminate a NULL or near NULL pointer dereference.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E,E1;
identifier f;
statement S1,S2,S3;
@@

if ((E == NULL && ...) || ...)
{
  ... when != if (...) S1 else S2
      when != E = E1
* E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/comedi/drivers/usbdux.c |    3 +--
 drivers/staging/dt3155/allocator.c      |    4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/dt3155/allocator.c b/drivers/staging/dt3155/allocator.c
index bd5adbc..d33947b 100644
--- a/drivers/staging/dt3155/allocator.c
+++ b/drivers/staging/dt3155/allocator.c
@@ -176,9 +176,7 @@ int allocator_free_dma(unsigned long address)
 	prev = ptr; ptr = ptr->next;
 
 	if (!ptr) {
-		printk(KERN_ERR ALL_MSG
-			"free_dma(0x%08lx) but add. not allocated\n",
-			ptr->address);
+		pr_err(ALL_MSG "free_dma but add. not allocated\n");
 		return -EINVAL;
 	}
 	PDEBUGG("freeing: %08lx (%li) next %08lx\n", ptr->address, ptr->size,
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 86f035d..27b4cb2 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -351,8 +351,7 @@ static int usbdux_ai_stop(struct usbduxsub *this_usbduxsub, int do_unlink)
 	int ret = 0;
 
 	if (!this_usbduxsub) {
-		dev_err(&this_usbduxsub->interface->dev,
-			"comedi?: usbdux_ai_stop: this_usbduxsub=NULL!\n");
+		pr_err("comedi?: usbdux_ai_stop: this_usbduxsub=NULL!\n");
 		return -EFAULT;
 	}
 	dev_dbg(&this_usbduxsub->interface->dev, "comedi: usbdux_ai_stop\n");
