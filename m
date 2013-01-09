Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452Ab3AIUjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:39:04 -0500
Received: from mail.kernel.org ([198.145.19.201]:42470 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933440Ab3AIUjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:39:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 31/80] usb: gadget: phonet: free requests in pn_bind()s error path
Date: Wed,  9 Jan 2013 12:35:23 -0800
Message-Id: <20130109201504.393263770@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit d0eca719dd11ad0619e8dd6a1f3eceb95b0216dd upstream.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/f_phonet.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/f_phonet.c
+++ b/drivers/usb/gadget/f_phonet.c
@@ -531,7 +531,7 @@ int pn_bind(struct usb_configuration *c,
 
 		req = usb_ep_alloc_request(fp->out_ep, GFP_KERNEL);
 		if (!req)
-			goto err;
+			goto err_req;
 
 		req->complete = pn_rx_complete;
 		fp->out_reqv[i] = req;
@@ -540,14 +540,18 @@ int pn_bind(struct usb_configuration *c,
 	/* Outgoing USB requests */
 	fp->in_req = usb_ep_alloc_request(fp->in_ep, GFP_KERNEL);
 	if (!fp->in_req)
-		goto err;
+		goto err_req;
 
 	INFO(cdev, "USB CDC Phonet function\n");
 	INFO(cdev, "using %s, OUT %s, IN %s\n", cdev->gadget->name,
 		fp->out_ep->name, fp->in_ep->name);
 	return 0;
 
+err_req:
+	for (i = 0; i < phonet_rxq_size && fp->out_reqv[i]; i++)
+		usb_ep_free_request(fp->out_ep, fp->out_reqv[i]);
 err:
+
 	if (fp->out_ep)
 		fp->out_ep->driver_data = NULL;
 	if (fp->in_ep)


