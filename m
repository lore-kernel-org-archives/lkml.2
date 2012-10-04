Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946611Ab2JDVrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:47:49 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:50177 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946086Ab2JDVYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:24:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 05/52] usb: gadget: dummy_hcd: fixup error probe path
Date: Thu,  4 Oct 2012 14:20:56 -0700
Message-Id: <20121004210636.012779615@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.372689554@linuxfoundation.org>
References: <20121004210635.372689554@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2505,10 +2505,8 @@ static int dummy_hcd_probe(struct platfo
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
@@ -2527,6 +2525,8 @@ static int dummy_hcd_probe(struct platfo
 put_usb3_hcd:
 	usb_put_hcd(ss_hcd);
 dealloc_usb2_hcd:
+	usb_remove_hcd(hs_hcd);
+put_usb2_hcd:
 	usb_put_hcd(hs_hcd);
 	the_controller.hs_hcd = the_controller.ss_hcd = NULL;
 	return retval;


