Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965571Ab2C3WAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:00:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965525Ab2C3VRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:17:39 -0400
Message-Id: <20120330194828.511468068@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:48:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Paul Zimmerman <paulz@synopsys.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 019/175] usb: dwc3: fix bogus test in dwc3_gadget_start_isoc
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>

commit 9bafa56c7cee5c6fa68de5924220abb220c7e229 upstream.

Zero is a valid value for a microframe number. So remove the bogus
test for non-zero in dwc3_gadget_start_isoc().

Signed-off-by: Paul Zimmerman <paulz@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1498,7 +1498,7 @@ static void dwc3_endpoint_transfer_compl
 static void dwc3_gadget_start_isoc(struct dwc3 *dwc,
 		struct dwc3_ep *dep, const struct dwc3_event_depevt *event)
 {
-	u32 uf;
+	u32 uf, mask;
 
 	if (list_empty(&dep->request_list)) {
 		dev_vdbg(dwc->dev, "ISOC ep %s run out for requests.\n",
@@ -1506,16 +1506,10 @@ static void dwc3_gadget_start_isoc(struc
 		return;
 	}
 
-	if (event->parameters) {
-		u32 mask;
-
-		mask = ~(dep->interval - 1);
-		uf = event->parameters & mask;
-		/* 4 micro frames in the future */
-		uf += dep->interval * 4;
-	} else {
-		uf = 0;
-	}
+	mask = ~(dep->interval - 1);
+	uf = event->parameters & mask;
+	/* 4 micro frames in the future */
+	uf += dep->interval * 4;
 
 	__dwc3_gadget_kick_transfer(dep, uf, 1);
 }


