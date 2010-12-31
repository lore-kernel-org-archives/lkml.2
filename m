Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378Ab0LaA5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 19:57:31 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:60710 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab0LaA53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 19:57:29 -0500
Message-ID: <4D1D2A2D.80206@oracle.com>
Date: Fri, 31 Dec 2010 08:56:13 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre OracleBeehiveExtension/1.0.0.2-OracleInternal ObetStats/CATLAF_1292475699435-498544290 Thunderbird/3.1.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: jeremy@goop.org, ian.campbell@citrix.com,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        gurudas.pai@oracle.com, greg.marsden@oracle.com,
        guru.anbalagane@oracle.com
Subject: Re: [patch] xenfb: fix xenfb suspend/resume race
References: <20101230125616.GA31537@joejin-pc.cn.oracle.com> <20101230164051.GC24313@dumpdata.com>
In-Reply-To: <20101230164051.GC24313@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/10 00:40, Konrad Rzeszutek Wilk wrote:
> On Thu, Dec 30, 2010 at 08:56:16PM +0800, Joe Jin wrote:
>> Hi,
> 
> Joe,
> 
> Patch looks good, however..
> 
> I am unclear from your description whether the patch fixes
> the problem (I would presume so). Or does it take a long time
> to hit this race?
> 
Yes, more than 100 migrations. we hit this issue around 3 times.

I dumped vmcore when guest crashed, from vmcore everything
looked good, fb_info, xenfb_info and so on.

Checked the calltrace I suspected when guest resuming, the process kevent
scheduled and refresh xenfb. look like when call notify_remote_via_irq(),  better
to confirm irq is valid? 

Please review new patch.

Signed-off-by: Joe Jin <joe.jin@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
 
---
 video/xen-fbfront.c |   19 +++++++++++--------
 xen/events.c        |    2 ++
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index dc72563..367fb1c 100644
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
@@ -602,15 +600,20 @@ static int xenfb_connect_backend(struct xenbus_device *dev,
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
+	printk(KERN_ERR "xenfb_connect_backend failed!\n");
+	unbind_from_irqhandler(irq, info);
+	xenbus_free_evtchn(dev, evtchn);
 	return ret;
 }
 
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index ac7b42f..4cfb5e2 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -175,6 +175,8 @@ static struct irq_info *info_for_irq(unsigned irq)
 
 static unsigned int evtchn_from_irq(unsigned irq)
 {
+	if (unlikely(irq < 0 || irq >= nr_irqs))
+		return 0;
 	return info_for_irq(irq)->evtchn;
 }
 
