Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab3AHK5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 05:57:38 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38344 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755828Ab3AHK5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 05:57:36 -0500
Date: Tue, 8 Jan 2013 11:57:30 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
        Lin.Lei@huawei.com, greg@kroah.com, neil.yi@huawei.com,
        wangyuhua@huawei.com, huqiao36@huawei.com, balbi@ti.com,
        mdharm-usb@one-eyed-alien.net
Subject: Re: [PATCH 1/1]linux-usb:optimize to match the Huawei USB storage
 devices and support new switch command
Message-ID: <20130108105730.GB3983@breakpoint.cc>
References: <fe8ab374645a.645afe8ab374@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe8ab374645a.645afe8ab374@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2013 at 10:57:42AM +0800, fangxiaozhi 00110321 wrote:
> From: fangxiaozhi <huananhu@huawei.com>
> 
> 1. Optimize the match rules with new macro for Huawei USB storage devices, 
>    to avoid to load USB storage driver for the modem interface 
>    with Huawei devices.
> 2. Add to support new switch command for new Huawei USB dongles.
> 
> Signed-off-by: fangxiaozhi <huananhu@huawei.com>
> --------------------------------------------------------------------
> diff -uprN linux-3.8-rc2_orig/drivers/usb/storage/initializers.c linux-3.8-rc2/drivers/usb/storage/initializers.c
> --- linux-3.8-rc2_orig/drivers/usb/storage/initializers.c	2013-01-04 10:12:01.441356344 +0800
> +++ linux-3.8-rc2/drivers/usb/storage/initializers.c	2013-01-04 10:55:49.512500933 +0800
> @@ -92,8 +92,8 @@ int usb_stor_ucr61s2b_init(struct us_dat
>  	return 0;
>  }
>  
> -/* This places the HUAWEI E220 devices in multi-port mode */
> -int usb_stor_huawei_e220_init(struct us_data *us)
> +/* This places the HUAWEI usb dongles in multi-port mode */
> +static int usb_stor_huawei_feature_init(struct us_data *us)
>  {
>  	int result;
>  
> @@ -104,3 +104,75 @@ int usb_stor_huawei_e220_init(struct us_
>  	US_DEBUGP("Huawei mode set result is %d\n", result);
>  	return 0;
>  }
> +
> +/* This function will send
> + * a scsi switch command called rewind' to huawei dongle.
> + * When the dongle receives this command at the first time,
> + * it will reboot immediately,
> + * after rebooted, it will ignore this command and do nothing,
> + * if it receives this command again.
> + * So it is  unnecessary to read its response. */

This is not how a proper multi line comment looks like. The line break in the
middle of the sentence does not look good IMHO.

> +static int usb_stor_huawei_scsi_init(struct us_data *us)
> +{
> +	int result = 0;
> +	int act_len = 0;
> +	struct bulk_cb_wrap *bcbw = (struct bulk_cb_wrap *) us->iobuf;
> +	char rewind_cmd[] = {0x11, 0x06, 0x20, 0x00, 0x00, 0x01, 0x01, 0x00,
> +			0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
> +	
> +	memset(bcbw, 0, sizeof(struct bulk_cb_wrap));
> +	bcbw->Signature = cpu_to_le32(US_BULK_CB_SIGN);
> +	bcbw->Tag = 0;
> +	bcbw->DataTransferLength = 0;
> +	bcbw->Flags = bcbw->Lun = 0;
> +	bcbw->Length = sizeof(rewind_cmd);

I asked earlier and I ask again: why memset to zero followed by init to zero.
Could we stick to one thing?

> +	memcpy(bcbw->CDB, rewind_cmd, sizeof(rewind_cmd));
> +
> +	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe, bcbw,
> +					US_BULK_CB_WRAP_LEN, &act_len);

This looks like it could work. Was it really tested before sending this
time? :P

> +	US_DEBUGP("transfer actual length=%d, result=%d\n", act_len, result);
> +	return result;
> +}
> +
> +/* usb_stor_huawei_dongles_pid: try to find the supported Huawei USB dongles
> + * In Huawei, they assign the following product IDs
> + * for all of their mobile broadband dongles,
> + * including the new dongles in the future.
> + * So if the product ID is not included in this list,
> + * it means it is not Huawei's mobile broadband dongles.
> + */

Not a proper multiple line comment. Kernel doc format is different btw. and is
described in Documentation/kernel-doc-nano-HOWTO.txt 

> +static int usb_stor_huawei_dongles_pid(struct us_data *us)
> +{
> +	struct usb_interface_descriptor *idesc;
> +	int idProduct;
> +	
> +	idesc = &us->pusb_intf->cur_altsetting->desc;
> +	idProduct = us->pusb_dev->descriptor.idProduct;
> +	/* The first port is CDROM,
> +	 * means the dongle in the single port mode,
> +	 * and a switch command is required to be sent. */
> +	if (idesc && idesc->bInterfaceNumber == 0) {
> +		if ((idProduct == 0x1001)
> +			|| (idProduct == 0x1003)
> +			|| (idProduct == 0x1004)
> +			|| (idProduct >= 0x1401 && idProduct < 0x1501)
> +			|| (idProduct > 0x1504 && idProduct <= 0x1600)

why not >= 1505 and <= 1500 instead of the < and > operators? It would look
better. Do you exclude them on purpose or by accident?
On a second look, why not do this instead:

	switch (idProduct)
	case 0x1001:
	case 0x1401 .. 0x1500
		return 1;
	default:
		return 0;

This reads way way beter.

> +			|| (idProduct >= 0x1c02 && idProduct <= 0x2202)) {
> +			return 1;
> +		}
> +	}
> +	return 0;
> +}
> +
> +int usb_stor_huawei_init(struct us_data *us)
> +{
> +	int result = 0;
> +	
> +	if (usb_stor_huawei_dongles_pid(us)) {
> +		if (us->pusb_dev->descriptor.idProduct >= 0x1446)
> +			result = usb_stor_huawei_scsi_init(us);
> +		else
> +			result = usb_stor_huawei_feature_init(us);
> +	}
> +	return result;
> +}

Sebastian
