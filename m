Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965263Ab2I1S7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:59:40 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965250Ab2I1S7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:59:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Ming Lei <ming.lei@canonical.com>, Oliver Neukum <oneukum@suse.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: =?UTF-8?q?=5B=20116/262=5D=20net=3A=20usbnet=3A=20fix=20softirq=20storm=20on=20suspend?=
Date: Fri, 28 Sep 2012 11:50:45 -0700
Message-Id: <20120928183011.841430575@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 85e87870fa18ec9f5df98e2d3b48f3699560a570 upstream.

Suspending an open usbnet device results in constant
rescheduling of usbnet_bh.

commit 65841fd5 "usbnet: handle remote wakeup asap"
refactored the usbnet_bh code to allow sharing the
urb allocate and submit code with usbnet_resume. In
this process, a test for, and immediate return on,
ENOLINK from rx_submit was unintentionally dropped.

The rx queue will not grow if rx_submit fails,
making usbnet_bh reschedule itself.  This results
in a softirq storm if the error is persistent.
rx_submit translates the usb_submit_urb error
EHOSTUNREACH into ENOLINK, so this is an expected
and persistent error for a suspended device. The
old code tested for this condition and avoided
rescheduling.  Putting this test back.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Oliver Neukum <oneukum@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/usbnet.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1204,19 +1204,26 @@ deferred:
 }
 EXPORT_SYMBOL_GPL(usbnet_start_xmit);
 
-static void rx_alloc_submit(struct usbnet *dev, gfp_t flags)
+static int rx_alloc_submit(struct usbnet *dev, gfp_t flags)
 {
 	struct urb	*urb;
 	int		i;
+	int		ret = 0;
 
 	/* don't refill the queue all at once */
 	for (i = 0; i < 10 && dev->rxq.qlen < RX_QLEN(dev); i++) {
 		urb = usb_alloc_urb(0, flags);
 		if (urb != NULL) {
-			if (rx_submit(dev, urb, flags) == -ENOLINK)
-				return;
+			ret = rx_submit(dev, urb, flags);
+			if (ret)
+				goto err;
+		} else {
+			ret = -ENOMEM;
+			goto err;
 		}
 	}
+err:
+	return ret;
 }
 
 /*-------------------------------------------------------------------------*/
@@ -1260,7 +1267,8 @@ static void usbnet_bh (unsigned long par
 		int	temp = dev->rxq.qlen;
 
 		if (temp < RX_QLEN(dev)) {
-			rx_alloc_submit(dev, GFP_ATOMIC);
+			if (rx_alloc_submit(dev, GFP_ATOMIC) == -ENOLINK)
+				return;
 			if (temp != dev->rxq.qlen)
 				netif_dbg(dev, link, dev->net,
 					  "rxqlen %d --> %d\n",


