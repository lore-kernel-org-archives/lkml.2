Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab2IYRx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 13:53:58 -0400
Received: from smtp.citrix.com ([66.165.176.89]:22876 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454Ab2IYRx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 13:53:57 -0400
X-IronPort-AV: E=Sophos;i="4.80,484,1344211200"; 
   d="scan'208";a="39125379"
Message-ID: <5061EFB2.1080407@citrix.com>
Date: Tue, 25 Sep 2012 18:53:54 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] xen-blkfront: handle backend CLOSED without CLOSING
References: <1348243464-15903-1-git-send-email-david.vrabel@citrix.com> <1348243464-15903-3-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1348243464-15903-3-git-send-email-david.vrabel@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/09/12 17:04, David Vrabel wrote:
> From: David Vrabel <david.vrabel@citrix.com>
> 
> Backend drivers shouldn't transistion to CLOSED unless the frontend is
> CLOSED.  If a backend does transition to CLOSED too soon then the
> frontend may not see the CLOSING state and will not properly shutdown.
> 
> So, treat an unexpected backend CLOSED state the same as CLOSING.

Didn't handle the frontend block device being mounted. Updated patch here.

8<---------------------------------
xen-blkfront: handle backend CLOSED without CLOSING

Backend drivers shouldn't transistion to CLOSED unless the frontend is
CLOSED.  If a backend does transition to CLOSED too soon then the
frontend may not see the CLOSING state and will not properly shutdown.

So, treat an unexpected backend CLOSED state the same as CLOSING.

If the backend is CLOSED then the frontend can't talk to it so go to
CLOSED immediately without waiting for the block device to be closed
or unmounted.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 drivers/block/xen-blkfront.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 2c2d2e5..c1f5f38 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1143,7 +1143,8 @@ static int blkfront_resume(struct xenbus_device *dev)
 }
 
 static void
-blkfront_closing(struct blkfront_info *info)
+blkfront_closing(struct blkfront_info *info,
+		 enum xenbus_state backend_state)
 {
 	struct xenbus_device *xbdev = info->xbdev;
 	struct block_device *bdev = NULL;
@@ -1167,7 +1168,8 @@ blkfront_closing(struct blkfront_info *info)
 
 	mutex_lock(&bdev->bd_mutex);
 
-	if (bdev->bd_openers) {
+	/* If the backend is already CLOSED, close now. */
+	if (bdev->bd_openers && backend_state != XenbusStateClosed) {
 		xenbus_dev_error(xbdev, -EBUSY,
 				 "Device in use; refusing to close");
 		xenbus_switch_state(xbdev, XenbusStateClosing);
@@ -1340,15 +1342,18 @@ static void blkback_changed(struct xenbus_device *dev,
 	case XenbusStateReconfiguring:
 	case XenbusStateReconfigured:
 	case XenbusStateUnknown:
-	case XenbusStateClosed:
 		break;
 
 	case XenbusStateConnected:
 		blkfront_connect(info);
 		break;
 
+	case XenbusStateClosed:
+		if (dev->state == XenbusStateClosed)
+			break;
+		/* Missed the backend's Closing state -- fallthrough */
 	case XenbusStateClosing:
-		blkfront_closing(info);
+		blkfront_closing(info, backend_state);
 		break;
 	}
 }
-- 
1.7.2.5
