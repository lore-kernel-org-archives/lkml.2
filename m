Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab2JGXXL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:23:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38494 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754296Ab2JGXWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:48 -0400
Message-Id: <20121007225843.550386485@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:38 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 064/108] usb: gadget: dummy_hcd: fixup error probe path
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

commit 1b68a4ca2d038addb7314211d122fb6d7002b38b upstream.

If USB2 host controller probes fine but USB3 does not then we don't
remove the USB controller properly and lock up the system while the HUB
code will try to enumerate the USB2 controller and access memory which
is no longer available in case the dummy_hcd was compiled as a module.

This is a problem since 448b6eb1 ("USB: Make sure to fetch the BOS desc
for roothubs.) if used in USB3 mode because dummy does not provide this
descriptor and explodes later.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/gadget/dummy_hcd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index b799106..0e58a46 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -2503,10 +2503,8 @@ static int dummy_hcd_probe(struct platform_device *pdev)
 	hs_hcd->has_tt = 1;
 
 	retval = usb_add_hcd(hs_hcd, 0, 0);
-	if (retval != 0) {
-		usb_put_hcd(hs_hcd);
-		return retval;
-	}
+	if (retval)
+		goto put_usb2_hcd;
 
 	if (mod_data.is_super_speed) {
 		ss_hcd = usb_create_shared_hcd(&dummy_hcd, &pdev->dev,
@@ -2525,6 +2523,8 @@ static int dummy_hcd_probe(struct platform_device *pdev)
 put_usb3_hcd:
 	usb_put_hcd(ss_hcd);
 dealloc_usb2_hcd:
+	usb_remove_hcd(hs_hcd);
+put_usb2_hcd:
 	usb_put_hcd(hs_hcd);
 	the_controller.hs_hcd = the_controller.ss_hcd = NULL;
 	return retval;


