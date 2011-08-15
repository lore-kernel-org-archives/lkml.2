Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab1HOEwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 00:52:11 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17228 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab1HOEwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 00:52:09 -0400
Message-ID: <4E48A5D3.6020501@oracle.com>
Date: Mon, 15 Aug 2011 12:51:31 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Daniel Stodden <daniel.stodden@citrix.com>,
        Annie Li <annie.li@oracle.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: Greg Marsden <greg.marsden@oracle.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Jin <joe.jin@oracle.com>
Subject: [PATCH] xen-blkback: Don't disconnect backend until state switched
 to XenbusStateClosed.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4E48A5F0.0028:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When do block-attach/block-detach test with below steps, umount hang
in guest. Also shutdown ends up being stuck when umounting filesystems.

1. start guest.
2. attach new block device by xm block-attach in Dom0.
3. mount new disk in guest.
4. execute xm block-detach to detach the block device in dom0 until timeout
5. Any request to the disk will hung.

Root cause:
  This issue caused by when setting backend device's state to
  'XenbusStateClosing', which will send frontend XenbusStateClosing 
  notification. When frontend receives the notification it tries to release
  the disk by blkfront_closing(), but at that moment, the disk is still in use
  by guest, so frontend refuses to close. 
  In blkfront_closing(), it sets the disk state to XenbusStateClosing and send
  a state switch to Closing notification to backend, when backend received the
  event, it disconnect the vbd from real device, set the vbd device state to
  XenbusStateClosing. For backend disconnected from real device/file, any IO
  requests to the disk in guest will end up, leaving disk DEAD disk and set to
  "XenbusStateClosing". For the disk have been disconnected, umount will hang
  on blkif_release()->xlvbd_release_gendisk() for unable send any IO to the
  disk, this prevent system clean shutdown.

Solution:
  Don't disconnect backend until frontend state switch to XenbusStateClosed.

Signed-off-by: Joe Jin <joe.jin@oracle.com>
Cc: Daniel Stodden <daniel.stodden@citrix.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Annie Li <annie.li@oracle.com>
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>
---
 drivers/block/xen-blkback/xenbus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 3f129b4..1a87f5b 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -601,11 +601,11 @@ static void frontend_changed(struct xenbus_device *dev,
 		break;
 
 	case XenbusStateClosing:
-		xen_blkif_disconnect(be->blkif);
 		xenbus_switch_state(dev, XenbusStateClosing);
 		break;
 
 	case XenbusStateClosed:
+		xen_blkif_disconnect(be->blkif);
 		xenbus_switch_state(dev, XenbusStateClosed);
 		if (xenbus_dev_is_online(dev))
 			break;
