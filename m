Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab2JZAZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:25:22 -0400
Received: from mail.kernel.org ([198.145.19.201]:53524 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909Ab2JZAHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:07:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 23/85] USB: io_ti: fix sysfs-attribute creation
Date: Thu, 25 Oct 2012 17:05:41 -0700
Message-Id: <20121026000033.440846638@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 5d8c61bc283826827e1f06816c146bfc507d3834 upstream.

Make sure port data is initialised before creating sysfs attributes to
avoid a race.

A recent patch ("USB: io_ti: fix port-data memory leak") got the
sysfs-attribute creation and port-data initialisation ordering wrong.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/io_ti.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -2641,13 +2641,6 @@ static int edge_port_probe(struct usb_se
 		return -ENOMEM;
 	}
 
-	ret = edge_create_sysfs_attrs(port);
-	if (ret) {
-		kfifo_free(&edge_port->write_fifo);
-		kfree(edge_port);
-		return ret;
-	}
-
 	spin_lock_init(&edge_port->ep_lock);
 	edge_port->port = port;
 	edge_port->edge_serial = usb_get_serial_data(port->serial);
@@ -2655,6 +2648,13 @@ static int edge_port_probe(struct usb_se
 
 	usb_set_serial_port_data(port, edge_port);
 
+	ret = edge_create_sysfs_attrs(port);
+	if (ret) {
+		kfifo_free(&edge_port->write_fifo);
+		kfree(edge_port);
+		return ret;
+	}
+
 	return 0;
 }
 


