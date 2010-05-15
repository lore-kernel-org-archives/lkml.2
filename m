Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab0EOVMh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:12:37 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:48179 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564Ab0EOVMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:12:35 -0400
Date: Sat, 15 May 2010 23:12:28 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Dan Williams <dcbw@redhat.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/37] drivers/net/wireless/libertas: Use kmemdup
Message-ID: <Pine.LNX.4.64.1005152312060.21345@ask.diku.dk>
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
 drivers/net/wireless/libertas/if_usb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -u -p a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -618,16 +618,14 @@ static void if_usb_receive_fwload(struct
 		return;
 	}
 
-	syncfwheader = kmalloc(sizeof(struct fwsyncheader), GFP_ATOMIC);
+	syncfwheader = kmemdup(skb->data + IPFIELD_ALIGN_OFFSET,
+			       sizeof(struct fwsyncheader), GFP_ATOMIC);
 	if (!syncfwheader) {
 		lbs_deb_usbd(&cardp->udev->dev, "Failure to allocate syncfwheader\n");
 		kfree_skb(skb);
 		return;
 	}
 
-	memcpy(syncfwheader, skb->data + IPFIELD_ALIGN_OFFSET,
-	       sizeof(struct fwsyncheader));
-
 	if (!syncfwheader->cmd) {
 		lbs_deb_usb2(&cardp->udev->dev, "FW received Blk with correct CRC\n");
 		lbs_deb_usb2(&cardp->udev->dev, "FW received Blk seqnum = %d\n",
