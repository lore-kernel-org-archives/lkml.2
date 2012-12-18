Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab2LROKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 09:10:35 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56971 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755000Ab2LROKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 09:10:34 -0500
Date: Tue, 18 Dec 2012 15:10:14 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
        Lin.Lei@huawei.com, greg@kroah.com, neil.yi@huawei.com,
        wangyuhua@huawei.com, huqiao36@huawei.com, balbi@ti.com
Subject: Re: [PATCH 2/2]linux-usb:optimize to match the Huawei USB storage
 devices and support new switch command
Message-ID: <20121218141013.GB4939@breakpoint.cc>
References: <fdcd8d23149d.149dfdcd8d23@huawei.com>
 <fdcdb3e12b55.2b55fdcdb3e1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdcdb3e12b55.2b55fdcdb3e1@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 10:44:19AM +0800, fangxiaozhi 00110321 wrote:
> diff -uprN linux-3.7_bak/drivers/usb/storage/initializers.c linux-3.7/drivers/usb/storage/initializers.c
> --- linux-3.7_bak/drivers/usb/storage/initializers.c	2012-12-11 09:56:11.000000000 +0800
> +++ linux-3.7/drivers/usb/storage/initializers.c	2012-12-17 11:12:12.000000000 +0800
>  	US_DEBUGP("Huawei mode set result is %d\n", result);
>  	return 0;
>  }
> +
> +/* Find the supported Huawei USB dongles */
> +static int usb_stor_huawei_dongles_pid(struct us_data *us)
> +{
> +	struct usb_interface_descriptor *idesc;
> +	int idProduct;
> +	
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

Has this something to do with the SPACE command as defined in SSC-2? I don't
see the code (0x6 here) to be defined. But then you name is rewind.

> +	struct bulk_cb_wrap *bcbw = (struct bulk_cb_wrap *) us->iobuf;
> +	
> +	memset(bcbw, 0, sizeof(struct bulk_cb_wrap));
> +	bcbw->Signature = cpu_to_le32(US_BULK_CB_SIGN);
> +	bcbw->Tag = 0;
> +	bcbw->DataTransferLength = 0;
> +	bcbw->Flags = bcbw->Lun = 0;

A memset() followed by an init of each member of the struct. Could please
chose one side?

> +	bcbw->Length = sizeof(rewind_cmd);
> +	memcpy(bcbw->CDB, rewind_cmd, sizeof(rewind_cmd));
> +
> +	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe, &bcbw,
> +					US_BULK_CS_WRAP_LEN, &act_len);

I am a little confused here. Shouldn't this be bcbw aka us->iobuf and not
&bcbw ?

And shouldn't you read something from the us->recv_bulk_pipe after that?

> +	US_DEBUGP("transfer actual length=%d, result=%d\n", act_len, result);
> +	return result;
> +}
> +

Sebastian
