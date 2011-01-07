Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab1AGKWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 05:22:10 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:59228 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab1AGKWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 05:22:08 -0500
Message-ID: <4D26E906.3080608@oracle.com>
Date: Fri, 07 Jan 2011 18:20:54 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre OracleBeehiveExtension/1.0.0.2-OracleInternal ObetStats/CATLAF_1292475699435-498544290 Thunderbird/3.1.7
MIME-Version: 1.0
To: jeremy@goop.org, ian.campbell@citrix.com,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-fbdev@vger.kernel.org, xen-devel@lists.xensource.com,
        gurudas.pai@oracle.com, guru.anbalagane@oracle.com,
        greg.marsden@oracle.com, joe.jin@oracle.com,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [patch] xenfb: fix potential memory leak
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch fix potential memory leak when xenfb connect backend failed.
Thanks for Ian's review and comments.

Signed-off-by: Joe Jin <joe.jin@oracle.com>
Tested-by: Gurudas Pai <gurudas.pai@oracle.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>

---
  xen-fbfront.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index dc72563..953334a 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -561,26 +561,24 @@ static void xenfb_init_shared_page(struct xenfb_info *info,
 static int xenfb_connect_backend(struct xenbus_device *dev,
 				 struct xenfb_info *info)
 {
-	int ret, evtchn;
+	int ret, evtchn, irq;
 	struct xenbus_transaction xbt;
 
 	ret = xenbus_alloc_evtchn(dev, &evtchn);
 	if (ret)
 		return ret;
-	ret = bind_evtchn_to_irqhandler(evtchn, xenfb_event_handler,
+	irq = bind_evtchn_to_irqhandler(evtchn, xenfb_event_handler,
 					0, dev->devicetype, info);
-	if (ret < 0) {
+	if (irq < 0) {
 		xenbus_free_evtchn(dev, evtchn);
 		xenbus_dev_fatal(dev, ret, "bind_evtchn_to_irqhandler");
-		return ret;
+		return irq;
 	}
-	info->irq = ret;
-
  again:
 	ret = xenbus_transaction_start(&xbt);
 	if (ret) {
 		xenbus_dev_fatal(dev, ret, "starting transaction");
-		return ret;
+		goto unbind_irq;
 	}
 	ret = xenbus_printf(xbt, dev->nodename, "page-ref", "%lu",
 			    virt_to_mfn(info->page));
@@ -602,15 +600,18 @@ static int xenfb_connect_backend(struct xenbus_device *dev,
 		if (ret == -EAGAIN)
 			goto again;
 		xenbus_dev_fatal(dev, ret, "completing transaction");
-		return ret;
+		goto unbind_irq;
 	}
 
 	xenbus_switch_state(dev, XenbusStateInitialised);
+	info->irq = irq;
 	return 0;
 
  error_xenbus:
 	xenbus_transaction_end(xbt, 1);
 	xenbus_dev_fatal(dev, ret, "writing xenstore");
+ unbind_irq:
+	unbind_from_irqhandler(irq, info);
 	return ret;
 }
 
