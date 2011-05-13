Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab1EMPay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:30:54 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:56938 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932345Ab1EMPav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:30:51 -0400
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: kernel-janitors@vger.kernel.org, Alon Ziv <alon-git@nolaviz.org>,
        Alan Cox <alan@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Martin Jansen <martin.jansen@opticon.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/usb/serial/opticon.c: Release resources on kmalloc failure
Date: Fri, 13 May 2011 17:30:46 +0200
Message-Id: <1305300646-10382-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Several resources have been allocated before this kmalloc failure, and thus
they should be released in this error handling code, as done in nearby
error handling code.

The semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression urb;
statement S;
position p1,p2;
@@

urb = usb_alloc_urb@p1(...);
... when != urb
if (urb == NULL) S
... when != urb
(
return <+...urb...+>;
|
return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

cocci.print_main("",p1)
cocci.print_secs("",p2)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/usb/serial/opticon.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index 1b5633f..96423f3 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -289,8 +289,11 @@ static int opticon_write(struct tty_struct *tty, struct usb_serial_port *port,
 	/* The conncected devices do not have a bulk write endpoint,
 	 * to transmit data to de barcode device the control endpoint is used */
 	dr = kmalloc(sizeof(struct usb_ctrlrequest), GFP_NOIO);
-	if (!dr)
-		return -ENOMEM;
+	if (!dr) {
+		dev_err(&port->dev, "out of memory\n");
+		count = -ENOMEM;
+		goto error;
+	}
 
 	dr->bRequestType = USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT;
 	dr->bRequest = 0x01;

