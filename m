Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab0KSV6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:58:49 -0500
Received: from kroah.org ([198.145.64.141]:45171 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757464Ab0KSV6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:47 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:42 2010
Message-Id: <20101119215642.620524105@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:56:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [47/82] USB: visor: fix initialisation of UX50/TH55 devices
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit cfb8da8f69b81d367b766888e83ec0483a31bf01 upstream.

Fix regression introduced by commit
214916f2ec6701e1c9972f26c60b3dc37d3153c6 (USB: visor: reimplement using
generic framework) which broke initialisation of UX50/TH55 devices that
used re-mapped bulk-out endpoint addresses.

Reported-by: Robert Gadsdon <rgadsdon@bayarea.net>
Tested-by: Robert Gadsdon <rgadsdon@bayarea.net>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/visor.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -606,6 +606,10 @@ static int treo_attach(struct usb_serial
 
 static int clie_5_attach(struct usb_serial *serial)
 {
+	struct usb_serial_port *port;
+	unsigned int pipe;
+	int j;
+
 	dbg("%s", __func__);
 
 	/* TH55 registers 2 ports.
@@ -621,9 +625,14 @@ static int clie_5_attach(struct usb_seri
 		return -1;
 
 	/* port 0 now uses the modified endpoint Address */
-	serial->port[0]->bulk_out_endpointAddress =
+	port = serial->port[0];
+	port->bulk_out_endpointAddress =
 				serial->port[1]->bulk_out_endpointAddress;
 
+	pipe = usb_sndbulkpipe(serial->dev, port->bulk_out_endpointAddress);
+	for (j = 0; j < ARRAY_SIZE(port->write_urbs); ++j)
+		port->write_urbs[j]->pipe = pipe;
+
 	return 0;
 }
 


