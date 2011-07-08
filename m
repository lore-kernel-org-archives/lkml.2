Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252Ab1GHHQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 03:16:42 -0400
Received: from rcsinet14.oracle.com ([148.87.113.126]:54102 "EHLO
	rcsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab1GHHQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 03:16:41 -0400
Message-ID: <4E16AE55.50500@oracle.com>
Date: Fri, 08 Jul 2011 15:14:29 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre OracleBeehiveExtension/1.0.0.2-OracleInternal ObetStats/CATLAF_1292475699435-498544290 Thunderbird/3.1.10
MIME-Version: 1.0
To: Daniel Stodden <daniel.stodden@citrix.com>,
        Jens Axboe <jaxboe@fusionio.com>, annie.li@oracle.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>,
        Greg Marsden <greg.marsden@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: xen-blkfront: Don't send closing  notification to backend in blkfront_closing()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4E16AE6F.009C:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we do block attach detach test with below steps, umount hang and the
guest unable to shutdown:

1. start guest with the latest kernel.
2. attach new disk by xm-attach in Dom0
3. mount new disk in guest
4. detach the disk by xm-detach in dom0
5. umount the partition/disk in guest, command hung. exactly at here, any
   IO request to the partition/disk will hang.

Checking the code we found when xm-detach command set backend state to 
Closing, will trigger blkback_changed() -> blkfront_closing() call.
At the moment, the disk still opened by guest, so frontend will refuse the 
request, but in the blkfront_closing(), it send a notification to backend 
said that the frontend state switched to Closing, when backend got the
event, it will disconnect from real device, at here any IO request will
be stuck, even tried to release the disk by umount.

Per our test, below patch fix this issue.

Signed-off-by: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Annie Li <annie.li@oracle.com>
---
 xen-blkfront.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index b536a9c..f6d8ac2 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1088,7 +1088,7 @@ blkfront_closing(struct blkfront_info *info)
 	if (bdev->bd_openers) {
 		xenbus_dev_error(xbdev, -EBUSY,
 				 "Device in use; refusing to close");
-		xenbus_switch_state(xbdev, XenbusStateClosing);
+		xbdev->state = XenbusStateClosing;
 	} else {
 		xlvbd_release_gendisk(info);
 		xenbus_frontend_closed(xbdev);
