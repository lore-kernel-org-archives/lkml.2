Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711Ab1EFA1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:27:42 -0400
Received: from kroah.org ([198.145.64.141]:37595 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932685Ab1EFA1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:27:38 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:26:09 2011
Message-Id: <20110506002609.706040485@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:25:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Olaf Hering <olaf@aepfle.de>, Igor Mammedov <imammedo@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [25/43] Input: xen-kbdfront - fix mouse getting stuck after save/restore
In-Reply-To: <20110506002625.GA20426@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Igor Mammedov <imammedo@redhat.com>

commit c36b58e8a9112017c2bcc322cc98e71241814303 upstream.

Mouse gets "stuck" after restore of PV guest but buttons are in working
condition.

If driver has been configured for ABS coordinates at start it will get
XENKBD_TYPE_POS events and then suddenly after restore it'll start getting
XENKBD_TYPE_MOTION events, that will be dropped later and they won't get
into user-space.

Regression was introduced by hunk 5 and 6 of
5ea5254aa0ad269cfbd2875c973ef25ab5b5e9db
("Input: xen-kbdfront - advertise either absolute or relative
coordinates").

Driver on restore should ask xen for request-abs-pointer again if it is
available. So restore parts that did it before 5ea5254.

Acked-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Igor Mammedov <imammedo@redhat.com>
[v1: Expanded the commit description]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

---
 drivers/input/xen-kbdfront.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -284,7 +284,7 @@ static void xenkbd_backend_changed(struc
 				   enum xenbus_state backend_state)
 {
 	struct xenkbd_info *info = dev_get_drvdata(&dev->dev);
-	int val;
+	int ret, val;
 
 	switch (backend_state) {
 	case XenbusStateInitialising:
@@ -295,6 +295,16 @@ static void xenkbd_backend_changed(struc
 
 	case XenbusStateInitWait:
 InitWait:
+		ret = xenbus_scanf(XBT_NIL, info->xbdev->otherend,
+				   "feature-abs-pointer", "%d", &val);
+		if (ret < 0)
+			val = 0;
+		if (val) {
+			ret = xenbus_printf(XBT_NIL, info->xbdev->nodename,
+					    "request-abs-pointer", "1");
+			if (ret)
+				pr_warning("can't request abs-pointer\n");
+		}
 		xenbus_switch_state(dev, XenbusStateConnected);
 		break;
 


