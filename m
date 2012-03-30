Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965549Ab2C3WBO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:01:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935955Ab2C3VRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:17:36 -0400
Message-Id: <20120330194828.357882388@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:48:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Paul Zimmerman <paulz@synopsys.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 018/175] usb: dwc3: gadget: dont wrap around the TRB poll on non-ISOC
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Zimmerman <paulz@synopsys.com>

commit 8d62cd65d74d0e241b3a152f7347bb66126b705b upstream.

If we have a non-ISOC endpoint, we will not have a Link TRB
pointing to the beginning of the TRB pool. On such endpoints,
we don't want to let the driver wrap around the TRB pool
otherwise controller will hang waiting for a valid TRB.

Signed-off-by: Paul Zimmerman <paulz@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -667,6 +667,7 @@ static void dwc3_prepare_trbs(struct dwc
 {
 	struct dwc3_request	*req, *n;
 	u32			trbs_left;
+	u32			max;
 	unsigned int		last_one = 0;
 
 	BUILD_BUG_ON_NOT_POWER_OF_2(DWC3_TRB_NUM);
@@ -674,6 +675,13 @@ static void dwc3_prepare_trbs(struct dwc
 	/* the first request must not be queued */
 	trbs_left = (dep->busy_slot - dep->free_slot) & DWC3_TRB_MASK;
 
+	/* Can't wrap around on a non-isoc EP since there's no link TRB */
+	if (!usb_endpoint_xfer_isoc(dep->desc)) {
+		max = DWC3_TRB_NUM - (dep->free_slot & DWC3_TRB_MASK);
+		if (trbs_left > max)
+			trbs_left = max;
+	}
+
 	/*
 	 * if busy & slot are equal than it is either full or empty. If we are
 	 * starting to proceed requests then we are empty. Otherwise we ar


