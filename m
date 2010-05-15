Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab0EOVPx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:15:53 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59055 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201Ab0EOVPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:15:49 -0400
Date: Sat, 15 May 2010 23:15:44 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, kernel@avr32linux.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 9/37] drivers/usb/gadget: Use kmemdup
Message-ID: <Pine.LNX.4.64.1005152315280.21345@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kmemdup when some other buffer is immediately copied into the
allocated region.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to,size,flag;
statement S;
@@

-  to = \(kmalloc\|kzalloc\)(size,flag);
+  to = kmemdup(from,size,flag);
   if (to==NULL || ...) S
-  memcpy(to, from, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/usb/gadget/atmel_usba_udc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -48,10 +48,9 @@ static int queue_dbg_open(struct inode *
 
 	spin_lock_irq(&ep->udc->lock);
 	list_for_each_entry(req, &ep->queue, queue) {
-		req_copy = kmalloc(sizeof(*req_copy), GFP_ATOMIC);
+		req_copy = kmemdup(req, sizeof(*req_copy), GFP_ATOMIC);
 		if (!req_copy)
 			goto fail;
-		memcpy(req_copy, req, sizeof(*req_copy));
 		list_add_tail(&req_copy->queue, queue_data);
 	}
 	spin_unlock_irq(&ep->udc->lock);
