Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761727Ab2C3XJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:09:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37370 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761583Ab2C3VEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:04:00 -0400
Message-Id: <20120330195724.848675367@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:57:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stephen Hemminger <shemminger@vyatta.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 019/108] USB: serial: fix console error reporting
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 548dd4b6da8a8e428453d55f7fa7b8a46498d147 upstream.

Do not report errors in write path if port is used as a console as this
may trigger the same error (and error report) resulting in a loop.

Reported-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/generic.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -215,8 +215,10 @@ retry:
 	clear_bit(i, &port->write_urbs_free);
 	result = usb_submit_urb(urb, GFP_ATOMIC);
 	if (result) {
-		dev_err(&port->dev, "%s - error submitting urb: %d\n",
+		if (!port->port.console) {
+			dev_err(&port->dev, "%s - error submitting urb: %d\n",
 						__func__, result);
+		}
 		set_bit(i, &port->write_urbs_free);
 		spin_lock_irqsave(&port->lock, flags);
 		port->tx_bytes -= count;


