Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206Ab0D3Rhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:37:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57711 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758691Ab0D3Rhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:37:33 -0400
Date: Fri, 30 Apr 2010 15:51:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Axel Lin <axel.lin@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: linux-next: manual merge of the usb tree with the input tree
Message-Id: <20100430155115.fbc54b24.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/input/tablet/kbtab.c between commits
ee7aa6ce41e08c68f72b5ca8f14fb61286dc2418 ("Input: kbtab - fix incorrect
size parameter in usb_buffer_free") and
331cb022d3ac1f85f7842a51495c33c629e947bc ("Input: kbtab - simplify
kbtab_disconnect()") from the input tree and commit
3cc96f50329227fbf34de2459491901b6ee1c98c ("USB: rename usb_buffer_alloc()
and usb_buffer_free() users") from the usb tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/input/tablet/kbtab.c
index b9969f1,d31b9c7..0000000
--- a/drivers/input/tablet/kbtab.c
+++ b/drivers/input/tablet/kbtab.c
@@@ -173,7 -182,7 +173,7 @@@ static int kbtab_probe(struct usb_inter
  	return 0;
  
   fail3:	usb_free_urb(kbtab->irq);
-  fail2:	usb_buffer_free(dev, 8, kbtab->data, kbtab->data_dma);
 - fail2:	usb_free_coherent(dev, 10, kbtab->data, kbtab->data_dma);
++ fail2:	usb_free_coherent(dev, 8, kbtab->data, kbtab->data_dma);
   fail1:	input_free_device(input_dev);
  	kfree(kbtab);
  	return error;
@@@ -184,11 -193,13 +184,11 @@@ static void kbtab_disconnect(struct usb
  	struct kbtab *kbtab = usb_get_intfdata(intf);
  
  	usb_set_intfdata(intf, NULL);
 -	if (kbtab) {
 -		usb_kill_urb(kbtab->irq);
 -		input_unregister_device(kbtab->dev);
 -		usb_free_urb(kbtab->irq);
 -		usb_free_coherent(interface_to_usbdev(intf), 10, kbtab->data, kbtab->data_dma);
 -		kfree(kbtab);
 -	}
 +
 +	input_unregister_device(kbtab->dev);
 +	usb_free_urb(kbtab->irq);
- 	usb_buffer_free(kbtab->usbdev, 8, kbtab->data, kbtab->data_dma);
++	usb_free_coherent(kbtab->usbdev, 8, kbtab->data, kbtab->data_dma);
 +	kfree(kbtab);
  }
  
  static struct usb_driver kbtab_driver = {
