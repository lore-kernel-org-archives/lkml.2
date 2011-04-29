Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638Ab1D2S7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:59:47 -0400
Received: from kroah.org ([198.145.64.141]:35144 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933657Ab1D2S6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:54 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:58 2011
Message-Id: <20110429185657.956847209@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:56:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Olaf Hering <olaf@aepfle.de>, Igor Mammedov <imammedo@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [55/55] Input: xen-kbdfront - fix mouse getting stuck after save/restore
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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
@@ -286,7 +286,7 @@ static void xenkbd_backend_changed(struc
 				   enum xenbus_state backend_state)
 {
 	struct xenkbd_info *info = dev_get_drvdata(&dev->dev);
-	int val;
+	int ret, val;
 
 	switch (backend_state) {
 	case XenbusStateInitialising:
@@ -299,6 +299,16 @@ static void xenkbd_backend_changed(struc
 
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
 


