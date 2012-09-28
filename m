Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031273Ab2I1Tat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:30:49 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030216Ab2I1TBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:01:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Pratyush Anand <pratyush.anand@st.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 158/262] usb: dwc3: ep0: correct cache sync issue in case of ep0_bounced
Date: Fri, 28 Sep 2012 11:51:27 -0700
Message-Id: <20120928183016.638373562@linuxfoundation.org>
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

From: Pratyush Anand <pratyush.anand@st.com>

commit 0416e494ce7dc84e2719bc9fb7daecb330476074 upstream.

In case of ep0 out, if length is not aligned to maxpacket size then we use
dwc->ep_bounce_addr for dma transfer and not request->dma. Since, we have
alreday done memcpy from dwc->ep0_bounce to request->buf, so we do not need to
issue cache sync function. In fact, cache sync function will bring wrong data
in request->buf from request->dma in this scenario.

So, cache sync function must not be executed in case of ep0 bounced.

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/ep0.c    |    1 -
 drivers/usb/dwc3/gadget.c |    7 +++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -702,7 +702,6 @@ static void dwc3_ep0_complete_data(struc
 		transferred = min_t(u32, ur->length,
 				transfer_size - length);
 		memcpy(ur->buf, dwc->ep0_bounce, transferred);
-		dwc->ep0_bounced = false;
 	} else {
 		transferred = ur->length - length;
 	}
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -238,8 +238,11 @@ void dwc3_gadget_giveback(struct dwc3_ep
 	if (req->request.status == -EINPROGRESS)
 		req->request.status = status;
 
-	usb_gadget_unmap_request(&dwc->gadget, &req->request,
-			req->direction);
+	if (dwc->ep0_bounced && dep->number == 0)
+		dwc->ep0_bounced = false;
+	else
+		usb_gadget_unmap_request(&dwc->gadget, &req->request,
+				req->direction);
 
 	dev_dbg(dwc->dev, "request %p from %s completed %d/%d ===> %d\n",
 			req, dep->name, req->request.actual,


