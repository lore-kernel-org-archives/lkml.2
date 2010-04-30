Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703Ab0D3R1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:27:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34014 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757525Ab0D3R1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:27:40 -0400
Date: Fri, 30 Apr 2010 15:51:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ping Cheng <pingc@wacom.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: linux-next: manual merge of the usb tree with the input tree
Message-Id: <20100430155122.db4d0b54.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/input/tablet/wacom_sys.c between commits
4492efffffeb88d87e7aa74765f3c53b3a7dd40f ("Input: wacom - share pen info
with touch of the same ID") and 51269fe86c263ec4fafbafe82970e6d7f6f79102
("Input: wacom - do not allocate wacom_wac separately") from the input
tree and commit 3cc96f50329227fbf34de2459491901b6ee1c98c ("USB: rename
usb_buffer_alloc() and usb_buffer_free() users") from the usb tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/input/tablet/wacom_sys.c
index d90f4e0,191197c..0000000
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@@ -534,11 -632,11 +534,11 @@@ static int wacom_probe(struct usb_inter
  	usb_set_intfdata(intf, wacom);
  	return 0;
  
 + fail4:	wacom_remove_shared_data(wacom_wac);
   fail3:	usb_free_urb(wacom->irq);
-  fail2:	usb_buffer_free(dev, WACOM_PKGLEN_MAX, wacom_wac->data, wacom->data_dma);
+  fail2:	usb_free_coherent(dev, WACOM_PKGLEN_MAX, wacom_wac->data, wacom->data_dma);
   fail1:	input_free_device(input_dev);
  	kfree(wacom);
 -	kfree(wacom_wac);
  	return error;
  }
  
@@@ -549,11 -647,11 +549,11 @@@ static void wacom_disconnect(struct usb
  	usb_set_intfdata(intf, NULL);
  
  	usb_kill_urb(wacom->irq);
 -	input_unregister_device(wacom->dev);
 +	input_unregister_device(wacom->wacom_wac.input);
  	usb_free_urb(wacom->irq);
- 	usb_buffer_free(interface_to_usbdev(intf), WACOM_PKGLEN_MAX,
+ 	usb_free_coherent(interface_to_usbdev(intf), WACOM_PKGLEN_MAX,
 -			  wacom->wacom_wac->data, wacom->data_dma);
 -	kfree(wacom->wacom_wac);
 +			wacom->wacom_wac.data, wacom->data_dma);
 +	wacom_remove_shared_data(&wacom->wacom_wac);
  	kfree(wacom);
  }
  
