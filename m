Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031086Ab2CITtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:49:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031065Ab2CITtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:49:35 -0500
Message-Id: <20120309190208.121400556@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Torsten Crass <torsten.crass@eBiology.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 72/95] media: staging: lirc_serial: Free resources on failure paths of lirc_serial_probe()
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit c8e57e1b766c2321aa76ee5e6878c69bd2313d62 upstream.

Failure to allocate the I/O region leaves the IRQ allocated.
A later failure leaves them both allocated.

Reported-by: Torsten Crass <torsten.crass@eBiology.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/media/lirc/lirc_serial.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -875,11 +875,14 @@ static int __devinit lirc_serial_probe(s
 		       ": or compile the serial port driver as module and\n");
 		printk(KERN_WARNING LIRC_DRIVER_NAME
 		       ": make sure this module is loaded first\n");
-		return -EBUSY;
+		result = -EBUSY;
+		goto exit_free_irq;
 	}
 
-	if (hardware_init_port() < 0)
-		return -EINVAL;
+	if (hardware_init_port() < 0) {
+		result = -EINVAL;
+		goto exit_release_region;
+	}
 
 	/* Initialize pulse/space widths */
 	init_timing_params(duty_cycle, freq);
@@ -911,6 +914,16 @@ static int __devinit lirc_serial_probe(s
 
 	dprintk("Interrupt %d, port %04x obtained\n", irq, io);
 	return 0;
+
+exit_release_region:
+	if (iommap != 0)
+		release_mem_region(iommap, 8 << ioshift);
+	else
+		release_region(io, 8);
+exit_free_irq:
+	free_irq(irq, (void *)&hardware);
+
+	return result;
 }
 
 static int __devexit lirc_serial_remove(struct platform_device *dev)


