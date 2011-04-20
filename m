Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab1DTSb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 14:31:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58974 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab1DTSb5 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 20 Apr 2011 14:31:57 -0400
Date: Wed, 20 Apr 2011 14:29:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stable@kernel.org, stable@suse.de
Cc: dtor@mail.ru, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Igor Mammedov <imammedo@redhat.com>, olaf@aepfle.de
Subject: Re: [Xen-devel] [PATCH] [PV Xen] Mouse stuck after save/restore of
 guest. - stable tree candidate.
Message-ID: <20110420182941.GA3148@dumpdata.com>
References: <1302795907-321-1-git-send-email-imammedo@redhat.com>
 <20110414155915.GA23629@dumpdata.com>
 <20110414172649.GA7569@aepfle.de>
 <20110414183804.GB1467@dumpdata.com>
 <20110415093737.GA15122@aepfle.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <20110415093737.GA15122@aepfle.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020205.4DAF2655.00B7:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> > > > On Thu, Apr 14, 2011 at 05:45:07PM +0200, Igor Mammedov wrote:
> > > > >     Mouse stuck after restore of PV guest but buttons are
> > > > >     in working condition.
> > > > >     If driver has been configured for ABS coordinates at
> > > > >     start it will get XENKBD_TYPE_POS events and then
> > > > >     suddenly after restore it'll start getting
> > > > >     XENKBD_TYPE_MOTION events, that will be dropped later
> > > > >     and they won't get into user-space.
> > > > > 
> > > > >     Regression was introduced by hunk 5 and 6 of 5ea5254
> > > > >     in upstream.
> > > > > 
> > > > >     Driver on restore should ask xen for request-abs-pointer
> > > > >     again if it's available. So restore parts that did it 
> > > > >     before 5ea5254.
> > > > 
> > > > Olaf?
> > > 
> > > This change is correct. Thanks for spotting, Igor.
> > 
> > Dmitry,
> > 
> > Was wondering if you are OK pushing this for 2.6.39-rc3 or whether you are OK
> > with me doing. It fixes a regression introduced by the last hunk of 
> > 5ea5254aa0ad269cfbd2875c973ef25ab5b5e9db

Hello stable-tree maintainers.

Please apply the upstream git commit c36b58e8a9112017c2bcc322cc98e71241814303
(Input: xen-kbdfront - fix mouse getting stuck after save/restore)
which fixes a regression introduced by 8c3c283e6bf463ab498d6e7823aff6c4762314b6
(Input: xen-kbdfront - advertise either absolute or relative coordinates)

The 2.6.38 and 2.6.37 tree both contain the regression.

For convience, attached and inline is the patch for stable tree submission.

commit c36b58e8a9112017c2bcc322cc98e71241814303
Author: Igor Mammedov <imammedo@redhat.com>
Date:   Mon Apr 18 10:17:17 2011 -0700

    Input: xen-kbdfront - fix mouse getting stuck after save/restore
    
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

diff --git a/drivers/input/misc/xen-kbdfront.c b/drivers/input/misc/xen-kbdfront.c
index 7077f9b..62bae99 100644
--- a/drivers/input/misc/xen-kbdfront.c
+++ b/drivers/input/misc/xen-kbdfront.c
@@ -303,7 +303,7 @@ static void xenkbd_backend_changed(struct xenbus_device *dev,
 				   enum xenbus_state backend_state)
 {
 	struct xenkbd_info *info = dev_get_drvdata(&dev->dev);
-	int val;
+	int ret, val;
 
 	switch (backend_state) {
 	case XenbusStateInitialising:
@@ -316,6 +316,17 @@ static void xenkbd_backend_changed(struct xenbus_device *dev,
 
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
+				pr_warning("xenkbd: can't request abs-pointer");
+		}
+
 		xenbus_switch_state(dev, XenbusStateConnected);
 		break;
 

--LZvS9be/3tNcYl/X
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="c36b58e8a9112017c2bcc322cc98e71241814303.patch"

commit c36b58e8a9112017c2bcc322cc98e71241814303
Author: Igor Mammedov <imammedo@redhat.com>
Date:   Mon Apr 18 10:17:17 2011 -0700

    Input: xen-kbdfront - fix mouse getting stuck after save/restore
    
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

diff --git a/drivers/input/misc/xen-kbdfront.c b/drivers/input/misc/xen-kbdfront.c
index 7077f9b..62bae99 100644
--- a/drivers/input/misc/xen-kbdfront.c
+++ b/drivers/input/misc/xen-kbdfront.c
@@ -303,7 +303,7 @@ static void xenkbd_backend_changed(struct xenbus_device *dev,
 				   enum xenbus_state backend_state)
 {
 	struct xenkbd_info *info = dev_get_drvdata(&dev->dev);
-	int val;
+	int ret, val;
 
 	switch (backend_state) {
 	case XenbusStateInitialising:
@@ -316,6 +316,17 @@ static void xenkbd_backend_changed(struct xenbus_device *dev,
 
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
+				pr_warning("xenkbd: can't request abs-pointer");
+		}
+
 		xenbus_switch_state(dev, XenbusStateConnected);
 		break;
 

--LZvS9be/3tNcYl/X--
