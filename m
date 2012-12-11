Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab2LKRCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 12:02:22 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:54943 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753404Ab2LKRCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 12:02:21 -0500
Date: Tue, 11 Dec 2012 12:02:20 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        <zihan@huawei.com>, <Lin.Lei@huawei.com>, <greg@kroah.com>,
        <neil.yi@huawei.com>, <wangyuhua@huawei.com>
Subject: Re: [PATCH 1/1]linux-usb: optimize to match the Huawei USB storage
 devices
In-Reply-To: <fdcfdf1db48.b48fdcfdf1d@huawei.com>
Message-ID: <Pine.LNX.4.44L0.1212111155220.1372-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2012, fangxiaozhi 00110321 wrote:

> From: fangxiaozhi <huananhu@huawei.com>
> 
> To optimize the match rules for the Huawei USB storage devices. Avoid to load USB storage driver for modem interface with Huawei devices.
> 
> Signed-off-by: fangxiaozhi <huananhu@huawei.com>
> 
> ---------------------------------------------------------------------------------
> diff -uprN linux-3.7_bak/drivers/usb/storage/initializers.c linux-3.7/drivers/usb/storage/initializers.c
> --- linux-3.7_bak/drivers/usb/storage/initializers.c	2012-12-11 09:56:11.000000000 +0800
> +++ linux-3.7/drivers/usb/storage/initializers.c	2012-12-11 15:33:24.000000000 +0800
> @@ -93,14 +93,20 @@ int usb_stor_ucr61s2b_init(struct us_dat
>  }
>  
>  /* This places the HUAWEI E220 devices in multi-port mode */
> -int usb_stor_huawei_e220_init(struct us_data *us)
> +int usb_stor_huawei_init(struct us_data *us)

If this routine is no longer meant for E220 devices, shouldn't the 
comment be changed?

>  {
>  	int result;
> +	struct usb_interface_descriptor *idesc = NULL;
>  
> -	result = usb_stor_control_msg(us, us->send_ctrl_pipe,
> -				      USB_REQ_SET_FEATURE,
> -				      USB_TYPE_STANDARD | USB_RECIP_DEVICE,
> -				      0x01, 0x0, NULL, 0x0, 1000);
> -	US_DEBUGP("Huawei mode set result is %d\n", result);
> +	idesc = &us->pusb_intf->cur_altsetting->desc;
> +	if (NULL != idesc ) {
> +		if ( (0x0000 == idesc->bInterfaceNumber)) {

You could write:

	if (idesc != NULL && idesc->bInterfaceNumber == 0) {

> +			result = usb_stor_control_msg(us, us->send_ctrl_pipe,
> +					USB_REQ_SET_FEATURE,
> +					USB_TYPE_STANDARD | USB_RECIP_DEVICE,
> +					0x01, 0x0, NULL, 0x0, 1000);
> +			US_DEBUGP("Huawei mode set result is %d\n", result);
> +		}
> +	}
>  	return 0;
>  }

> --- linux-3.7_bak/drivers/usb/storage/unusual_devs.h	2012-12-11 09:56:11.000000000 +0800
> +++ linux-3.7/drivers/usb/storage/unusual_devs.h	2012-12-11 15:34:29.000000000 +0800
> @@ -1527,335 +1527,335 @@ UNUSUAL_DEV(  0x1210, 0x0003, 0x0100, 0x
>  /* Reported by fangxiaozhi <huananhu@huawei.com>
>   * This brings the HUAWEI data card devices into multi-port mode
>   */
> -UNUSUAL_DEV(  0x12d1, 0x1001, 0x0000, 0x0000,
> +HW_UNUSUAL_DEV(  0x12d1, 0x1001, 0x08, 0x06, 0x50,

Where does the name "HW_UNUSUAL_DEV" come from?  You should use a 
better name, something that indicates what it is for.  And bear in mind 
that this new macro could be used for other devices, not just Huawei's.
Maybe something like UNUSUAL_DEV_INTF.

Alan Stern

