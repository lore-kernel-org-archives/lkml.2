Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031110Ab2CITtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:49:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031092Ab2CITtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:49:42 -0500
Message-Id: <20120309190208.279572058@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Hutchings <ben@decadent.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 74/95] media: staging: lirc_serial: Do not assume error codes returned by request_irq()
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit affc9a0d59ac49bd304e2137bd5e4ffdd6fdfa52 upstream.

lirc_serial_probe() must fail if request_irq() returns an error, even if
it isn't EBUSY or EINVAL,

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/media/lirc/lirc_serial.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -843,18 +843,15 @@ static int __devinit lirc_serial_probe(s
 	result = request_irq(irq, irq_handler,
 			     (share_irq ? IRQF_SHARED : 0),
 			     LIRC_DRIVER_NAME, (void *)&hardware);
-
-	switch (result) {
-	case -EBUSY:
-		printk(KERN_ERR LIRC_DRIVER_NAME ": IRQ %d busy\n", irq);
-		return -EBUSY;
-	case -EINVAL:
-		printk(KERN_ERR LIRC_DRIVER_NAME
-		       ": Bad irq number or handler\n");
-		return -EINVAL;
-	default:
-		break;
-	};
+	if (result < 0) {
+		if (result == -EBUSY)
+			printk(KERN_ERR LIRC_DRIVER_NAME ": IRQ %d busy\n",
+			       irq);
+		else if (result == -EINVAL)
+			printk(KERN_ERR LIRC_DRIVER_NAME
+			       ": Bad irq number or handler\n");
+		return result;
+	}
 
 	/* Reserve io region. */
 	/*


