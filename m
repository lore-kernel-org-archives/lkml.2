Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab2JZAHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:07:53 -0400
Received: from mail.kernel.org ([198.145.19.201]:53600 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175Ab2JZAHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:07:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Moiz Sonasath <m-sonasath@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 45/85] usb: dwc3: gadget: fix endpoint always busy bug
Date: Thu, 25 Oct 2012 17:06:03 -0700
Message-Id: <20121026000035.661888335@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit 041d81f493d90c940ec41f0ec98bc7c4f2fba431 upstream.

If a USB transfer has already been started, meaning
we have already issued StartTransfer command to that
particular endpoint, DWC3_EP_BUSY flag has also
already been set.

When we try to cancel this transfer which is already
in controller's cache, we will not receive XferComplete
event and we must clear DWC3_EP_BUSY in order to allow
subsequent requests to be properly started.

The best place to clear that flag is right after issuing
DWC3_DEPCMD_ENDTRANSFER.

Reported-by: Moiz Sonasath <m-sonasath@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1899,6 +1899,7 @@ static void dwc3_stop_active_transfer(st
 	ret = dwc3_send_gadget_ep_cmd(dwc, dep->number, cmd, &params);
 	WARN_ON_ONCE(ret);
 	dep->resource_index = 0;
+	dep->flags &= ~DWC3_EP_BUSY;
 }
 
 static void dwc3_stop_active_transfers(struct dwc3 *dwc)


