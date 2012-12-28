Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab2L1T1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:27:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55615 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932412Ab2L1TTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:38 -0500
Message-Id: <20121228190338.694642024@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:12 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 042/173] usb: gadget: phonet: free requests in pn_bind()s error path
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit d0eca719dd11ad0619e8dd6a1f3eceb95b0216dd upstream.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/gadget/f_phonet.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/f_phonet.c b/drivers/usb/gadget/f_phonet.c
index 8ee9268..a6c19a4 100644
--- a/drivers/usb/gadget/f_phonet.c
+++ b/drivers/usb/gadget/f_phonet.c
@@ -531,7 +531,7 @@ int pn_bind(struct usb_configuration *c, struct usb_function *f)
 
 		req = usb_ep_alloc_request(fp->out_ep, GFP_KERNEL);
 		if (!req)
-			goto err;
+			goto err_req;
 
 		req->complete = pn_rx_complete;
 		fp->out_reqv[i] = req;
@@ -540,14 +540,18 @@ int pn_bind(struct usb_configuration *c, struct usb_function *f)
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


