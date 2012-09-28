Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965014Ab2I1S5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:57:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964972Ab2I1S5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:57:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 080/262] usb: gadget: dummy_hcd: fixup error probe path
Date: Fri, 28 Sep 2012 11:50:09 -0700
Message-Id: <20120928183007.576522849@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/dummy_hcd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -2503,10 +2503,8 @@ static int dummy_hcd_probe(struct platfo
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
@@ -2525,6 +2523,8 @@ static int dummy_hcd_probe(struct platfo
 put_usb3_hcd:
 	usb_put_hcd(ss_hcd);
 dealloc_usb2_hcd:
+	usb_remove_hcd(hs_hcd);
+put_usb2_hcd:
 	usb_put_hcd(hs_hcd);
 	the_controller.hs_hcd = the_controller.ss_hcd = NULL;
 	return retval;


