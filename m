Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab0EOVTK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:19:10 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:51347 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564Ab0EOVTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:19:04 -0400
Date: Sat, 15 May 2010 23:18:58 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Petko Manolov <petkan@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 19/37] drivers/net/usb: Use kmemdup
Message-ID: <Pine.LNX.4.64.1005152318410.21345@ask.diku.dk>
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
 drivers/net/usb/pegasus.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -u -p a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -203,13 +203,12 @@ static int set_registers(pegasus_t * peg
 	char *buffer;
 	DECLARE_WAITQUEUE(wait, current);
 
-	buffer = kmalloc(size, GFP_KERNEL);
+	buffer = kmemdup(data, size, GFP_KERNEL);
 	if (!buffer) {
 		netif_warn(pegasus, drv, pegasus->net,
 			   "out of memory in %s\n", __func__);
 		return -ENOMEM;
 	}
-	memcpy(buffer, data, size);
 
 	add_wait_queue(&pegasus->ctrl_wait, &wait);
 	set_current_state(TASK_UNINTERRUPTIBLE);
@@ -255,13 +254,12 @@ static int set_register(pegasus_t * pega
 	char *tmp;
 	DECLARE_WAITQUEUE(wait, current);
 
-	tmp = kmalloc(1, GFP_KERNEL);
+	tmp = kmemdup(&data, 1, GFP_KERNEL);
 	if (!tmp) {
 		netif_warn(pegasus, drv, pegasus->net,
 			   "out of memory in %s\n", __func__);
 		return -ENOMEM;
 	}
-	memcpy(tmp, &data, 1);
 	add_wait_queue(&pegasus->ctrl_wait, &wait);
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	while (pegasus->flags & ETH_REGS_CHANGED)
