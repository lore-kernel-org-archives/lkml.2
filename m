Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993321Ab2K3TIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:08:43 -0500
Received: from mail.kernel.org ([198.145.19.201]:59758 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab2K3TCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:02:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Thierry Escande <thierry.escande@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>
Subject: [ 45/54] NFC: Fix pn533 target mode memory leak
Date: Fri, 30 Nov 2012 10:56:16 -0800
Message-Id: <20121130185212.456298784@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thierry Escande <thierry.escande@linux.intel.com>

commit 5b412fd11c918171c98a253d8a3484afa9f69ca5 upstream.

In target mode, sent sk_buff were not freed in pn533_tm_send_complete

Signed-off-by: Thierry Escande <thierry.escande@linux.intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nfc/pn533.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -2014,8 +2014,12 @@ error:
 static int pn533_tm_send_complete(struct pn533 *dev, void *arg,
 				  u8 *params, int params_len)
 {
+	struct sk_buff *skb_out = arg;
+
 	nfc_dev_dbg(&dev->interface->dev, "%s", __func__);
 
+	dev_kfree_skb(skb_out);
+
 	if (params_len < 0) {
 		nfc_dev_err(&dev->interface->dev,
 			    "Error %d when sending data",
@@ -2053,7 +2057,7 @@ static int pn533_tm_send(struct nfc_dev
 
 	rc = pn533_send_cmd_frame_async(dev, out_frame, dev->in_frame,
 					dev->in_maxlen, pn533_tm_send_complete,
-					NULL, GFP_KERNEL);
+					skb, GFP_KERNEL);
 	if (rc) {
 		nfc_dev_err(&dev->interface->dev,
 			    "Error %d when trying to send data", rc);


