Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab1G0Ajx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:39:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:17764 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722Ab1G0AfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="34855671"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: imammedo@redhat.com, olaf@aepfle.de, ak@linux.intel.com,
        konrad.wilk@oracle.com, dtor@mail.ru, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] [18/98] Input: xen-kbdfront - fix mouse getting stuck after save/restore
Message-Id: <20110727003510.4B1E82403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
[v1: Expanded the commit description]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

---
 drivers/input/xen-kbdfront.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/input/xen-kbdfront.c
===================================================================
--- linux-2.6.35.y.orig/drivers/input/xen-kbdfront.c
+++ linux-2.6.35.y/drivers/input/xen-kbdfront.c
@@ -285,7 +285,7 @@ static void xenkbd_backend_changed(struc
 				   enum xenbus_state backend_state)
 {
 	struct xenkbd_info *info = dev_get_drvdata(&dev->dev);
-	int val;
+	int ret, val;
 
 	switch (backend_state) {
 	case XenbusStateInitialising:
@@ -296,6 +296,16 @@ static void xenkbd_backend_changed(struc
 
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
 
