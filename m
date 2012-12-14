Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab2LNPgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 10:36:25 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56250 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755955Ab2LNPgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 10:36:23 -0500
Date: Fri, 14 Dec 2012 10:36:22 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        <zihan@huawei.com>, <Lin.Lei@huawei.com>, <greg@kroah.com>,
        <neil.yi@huawei.com>, <wangyuhua@huawei.com>, <huqiao36@huawei.com>
Subject: Re: [PATCH 1/1]linux-usb: optimize to match rules in USB storage
 for Huawei dongles.
In-Reply-To: <fe6cdb1d63dd.63ddfe6cdb1d@huawei.com>
Message-ID: <Pine.LNX.4.44L0.1212141030470.1438-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2012, fangxiaozhi 00110321 wrote:

> From: fangxiaozhi <huananhu@huawei.com>
> 
> 1. Add a new macro define for USB storage match rule.
> 2. Optimize the match rules with new macro for Huawei USB storage devices, 
>    to avoid to load USB storage driver for the modem interface 
>    with Huawei devices.
> 3. Add to support new switch command for new Huawei USB dongles.
> 
> Signed-off-by: fangxiaozhi <huananhu@huawei.com>
> --------------------------------------------------------------------
> 
> diff -uprN linux-3.7_bak/drivers/usb/storage/initializers.c linux-3.7/drivers/usb/storage/initializers.c
> --- linux-3.7_bak/drivers/usb/storage/initializers.c	2012-12-11 09:56:11.000000000 +0800
> +++ linux-3.7/drivers/usb/storage/initializers.c	2012-12-13 20:53:40.000000000 +0800

> @@ -104,3 +104,55 @@ int usb_stor_huawei_e220_init(struct us_
>  	US_DEBUGP("Huawei mode set result is %d\n", result);
>  	return 0;
>  }
> +
> +/* Find the supported Huawei USB dongles */
> +static int usb_stor_huawei_dongles_pid(struct us_data *us)
> +{
> +	struct usb_interface_descriptor *idesc;
> +	int idProduct;

There should be a blank line here.

> +	idesc = &us->pusb_intf->cur_altsetting->desc;
> +	idProduct = us->pusb_dev->descriptor.idProduct;
> +	if (idesc && idesc->bInterfaceNumber == 0) {
> +		if ((idProduct == 0x1001)
> +			|| (idProduct == 0x1003)
> +			|| (idProduct == 0x1004)
> +			|| (idProduct >= 0x1401 && idProduct < 0x1501)
> +			|| (idProduct > 0x1504 && idProduct <= 0x1600)
> +			|| (idProduct >= 0x1c02 && idProduct <= 0x2202)) {
> +			return 1;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static int usb_stor_huawei_scsi_init(struct us_data *us)
> +{
> +	int result = 0;
> +	int act_len = 0;
> +	char rewind_cmd[] = {0x11, 0x06, 0x20, 0x00, 0x00, 0x01, 0x01, 0x00,
> +			0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
> +	struct bulk_cb_wrap bcbw = {0};

This is wrong.  You cannot use a buffer that is allocated on the
stack.  You should use us->iobuf for this purpose, like
usb_stor_Bulk_transport() does.

There should be a blank line here.

> +	bcbw.Signature = cpu_to_le32(US_BULK_CB_SIGN);
> +	bcbw.Tag = 0;
> +	bcbw.DataTransferLength = cpu_to_le32(0);

What is the purpose of rearranging the byte order of a 0 value?  All
the bytes are equal to 0; the order doesn't matter.

> +	bcbw.Flags = bcbw.Lun = 0;
> +	bcbw.Length = sizeof(rewind_cmd);
> +	memcpy(bcbw.CDB, rewind_cmd, sizeof(rewind_cmd));
> +
> +	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe, &bcbw,
> +					US_BULK_CS_WRAP_LEN, &act_len);
> +	US_DEBUGP("transfer actual length=%d, result=%d\n", act_len, result);
> +	return result;
> +}

Alan Stern

