Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab1DNSiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:38:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59962 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759300Ab1DNSiV (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 14 Apr 2011 14:38:21 -0400
Date: Thu, 14 Apr 2011 14:38:04 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Olaf Hering <olaf@aepfle.de>, dtor@mail.ru, linux-kernel@vger.kernel.org
Cc: Igor Mammedov <imammedo@redhat.com>, xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] [PATCH] [PV Xen] Mouse stuck after save/restore of
 guest.
Message-ID: <20110414183804.GB1467@dumpdata.com>
References: <1302795907-321-1-git-send-email-imammedo@redhat.com>
 <20110414155915.GA23629@dumpdata.com>
 <20110414172649.GA7569@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110414172649.GA7569@aepfle.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DA73F0F.00DC:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 07:26:50PM +0200, Olaf Hering wrote:
> On Thu, Apr 14, Konrad Rzeszutek Wilk wrote:
> 
> > On Thu, Apr 14, 2011 at 05:45:07PM +0200, Igor Mammedov wrote:
> > >     Mouse stuck after restore of PV guest but buttons are
> > >     in working condition.
> > >     If driver has been configured for ABS coordinates at
> > >     start it will get XENKBD_TYPE_POS events and then
> > >     suddenly after restore it'll start getting
> > >     XENKBD_TYPE_MOTION events, that will be dropped later
> > >     and they won't get into user-space.
> > > 
> > >     Regression was introduced by hunk 5 and 6 of 5ea5254
> > >     in upstream.
> > > 
> > >     Driver on restore should ask xen for request-abs-pointer
> > >     again if it's available. So restore parts that did it 
> > >     before 5ea5254.
> > 
> > Olaf?
> 
> This change is correct. Thanks for spotting, Igor.

Dmitry,

Was wondering if you are OK pushing this for 2.6.39-rc3 or whether you are OK
with me doing. It fixes a regression introduced by the last hunk of 
5ea5254aa0ad269cfbd2875c973ef25ab5b5e9db

The patch rebase on top of 2.6.39-rc3 looks as so:

(and the patch is in git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/bug-fixes-rc3)
commit 876f162fe6831273fc5d678fa066f26f58be4a2c
Author: Igor Mammedov <imammedo@redhat.com>
Date:   Thu Apr 14 17:45:07 2011 +0200

    Input: xen-kbdfront: Mouse stuck after save/restore of guest.
    
    Mouse stuck after restore of PV guest but buttons are
    in working condition.
    
    If driver has been configured for ABS coordinates at
    start it will get XENKBD_TYPE_POS events and then
    suddenly after restore it'll start getting
    XENKBD_TYPE_MOTION events, that will be dropped later
    and they won't get into user-space.
    
    Regression was introduced by hunk 5 and 6 of
    5ea5254aa0ad269cfbd2875c973ef25ab5b5e9db
    ("Input: xen-kbdfront - advertise either absolute or relative coordinates"
    
    Driver on restore should ask xen for request-abs-pointer
    again if it's available. So restore parts that did it
    before 5ea5254.
    
    CC: Dmitry Torokhov <dtor@mail.ru>
    Acked-by: Olaf Hering <olaf@aepfle.de>
    Signed-off-by: Igor Mammedov <imammedo@redhat.com>
    [v1: Expanded the commit description]
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

diff --git a/drivers/input/misc/xen-kbdfront.c b/drivers/input/misc/xen-kbdfront.c
index 7077f9b..6d119d5 100644
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
+                                   "feature-abs-pointer", "%d", &val);
+                if (ret < 0)
+                        val = 0;
+                if (val) {
+                        ret = xenbus_printf(XBT_NIL, info->xbdev->nodename,
+                                            "request-abs-pointer", "1");
+                        if (ret)
+                                pr_warning("xenkbd: can't request abs-pointer");
+                }
+
 		xenbus_switch_state(dev, XenbusStateConnected);
 		break;
 
