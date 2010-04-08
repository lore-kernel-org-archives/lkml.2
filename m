Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab0DHEIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 00:08:10 -0400
Received: from senator.holtmann.net ([87.106.208.187]:40985 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab0DHEII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 00:08:08 -0400
Subject: Re: [PATCH] btusb: Raw mode and ACL/SCO data
From: Marcel Holtmann <marcel@holtmann.org>
To: "Kim B. Heino" <Kim.Heino@bluegiga.com>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100407155358.083823f9@bluegiga.com>
References: <20100407155358.083823f9@bluegiga.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 06:08:02 +0200
Message-ID: <1270699682.6375.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

> This patch allows sending ACL/SCO packets if device is in RAW mode.
> Previously only command packets were allowed.

so do I really wanna know why such a change is required?

> diff -ur orig/drivers/bluetooth/btusb.c linux-2.6.33.2/drivers/bluetooth/btusb.c
> --- orig/drivers/bluetooth/btusb.c	2010-04-02 02:02:33.000000000 +0300
> +++ linux-2.6.33.2/drivers/bluetooth/btusb.c	2010-04-07 15:17:55.696672710 +0300
> @@ -663,7 +663,9 @@
>  		break;
>  
>  	case HCI_ACLDATA_PKT:
> -		if (!data->bulk_tx_ep || hdev->conn_hash.acl_num < 1)
> +		if (!data->bulk_tx_ep ||
> +		    (!test_bit(HCI_RAW, &hdev->flags) &&
> +		     hdev->conn_hash.acl_num < 1))
>  			return -ENODEV;

Actually this one is wrong. The conn_hash.acl_num check just has to go
away. We always start the bulk URBs anyway since otherwise a lot of
devices break. We had to figure this out the hard way. Some device
manufactures have endpoints that rely on each other and do their flow
control based on submitted URBs.

So no need to do another HCI_RAW test here.
 
>  		urb = usb_alloc_urb(0, GFP_ATOMIC);
> @@ -680,7 +682,9 @@
>  		break;
>  
>  	case HCI_SCODATA_PKT:
> -		if (!data->isoc_tx_ep || hdev->conn_hash.sco_num < 1)
> +		if (!data->isoc_tx_ep ||
> +		    (!test_bit(HCI_RAW, &hdev->flags) &&
> +		     hdev->conn_hash.sco_num < 1))
>  			return -ENODEV;
>  
>  		urb = usb_alloc_urb(BTUSB_MAX_ISOC_FRAMES, GFP_ATOMIC);

And my assumption is that you only tested ACL data since this clearly
doesn't do anything useful. The isoc URBs and incoming data are not
magically started only because you pass this checkpoint.

No SCO links and no isoc URBs in the system. Period. If you wanna
disable the kernel Bluetooth stack, then you don't get SCO support over
USB.

Regards

Marcel


