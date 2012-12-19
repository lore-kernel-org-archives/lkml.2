Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab2LSDOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 22:14:04 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:58931 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab2LSDOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 22:14:00 -0500
From: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        "greg@kroah.com" <greg@kroah.com>, "Yili (Neil)" <neil.yi@huawei.com>,
        "Wangyuhua (Roger, Credit)" <wangyuhua@huawei.com>,
        Huqiao <huqiao36@huawei.com>, "balbi@ti.com" <balbi@ti.com>
Subject: RE: [PATCH 2/2]linux-usb:optimize to match the Huawei USB storage
 devices and support new switch command
Thread-Topic: [PATCH 2/2]linux-usb:optimize to match the Huawei USB storage
 devices and support new switch command
Thread-Index: AQHN3S0ND+lW0hLXaU2nh0KFaWLeCZgfb78g
Date: Wed, 19 Dec 2012 03:13:32 +0000
Message-ID: <910F9D9E13B84F4C8FA771DC9BDE99F326FCB006@szxeml546-mbs.china.huawei.com>
References: <fdcd8d23149d.149dfdcd8d23@huawei.com>
 <fdcdb3e12b55.2b55fdcdb3e1@huawei.com> <20121218141013.GB4939@breakpoint.cc>
In-Reply-To: <20121218141013.GB4939@breakpoint.cc>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.11.34.182]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBJ3E9hD021937

Dear Sebastian:
	Please see the comments follows yours.
	
	By the way, I found the kernel is updated to 3.7.1 today. So I have to update my patch based on 3.7.1, and resubmit it?
	Right?

Best Regards,
Franko Fang

> -----Original Message-----
> From: Sebastian Andrzej Siewior [mailto:sebastian@breakpoint.cc]
> Sent: Tuesday, December 18, 2012 10:10 PM
> To: Fangxiaozhi (Franko)
> Cc: linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Xueguiying
> (Zihan); Linlei (Lei Lin); greg@kroah.com; Yili (Neil); Wangyuhua (Roger,
> Credit); Huqiao; balbi@ti.com
> Subject: Re: [PATCH 2/2]linux-usb:optimize to match the Huawei USB
> storage devices and support new switch command
> 
> On Tue, Dec 18, 2012 at 10:44:19AM +0800, fangxiaozhi 00110321 wrote:
> > diff -uprN linux-3.7_bak/drivers/usb/storage/initializers.c
> linux-3.7/drivers/usb/storage/initializers.c
> > --- linux-3.7_bak/drivers/usb/storage/initializers.c	2012-12-11
> 09:56:11.000000000 +0800
> > +++ linux-3.7/drivers/usb/storage/initializers.c	2012-12-17
> 11:12:12.000000000 +0800
> >  	US_DEBUGP("Huawei mode set result is %d\n", result);
> >  	return 0;
> >  }
> > +
> > +/* Find the supported Huawei USB dongles */ static int
> > +usb_stor_huawei_dongles_pid(struct us_data *us) {
> > +	struct usb_interface_descriptor *idesc;
> > +	int idProduct;
> > +
> > +	idesc = &us->pusb_intf->cur_altsetting->desc;
> > +	idProduct = us->pusb_dev->descriptor.idProduct;
> > +	if (idesc && idesc->bInterfaceNumber == 0) {
> > +		if ((idProduct == 0x1001)
> > +			|| (idProduct == 0x1003)
> > +			|| (idProduct == 0x1004)
> > +			|| (idProduct >= 0x1401 && idProduct < 0x1501)
> > +			|| (idProduct > 0x1504 && idProduct <= 0x1600)
> > +			|| (idProduct >= 0x1c02 && idProduct <= 0x2202)) {
> > +			return 1;
> > +		}
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int usb_stor_huawei_scsi_init(struct us_data *us) {
> > +	int result = 0;
> > +	int act_len = 0;
> > +	char rewind_cmd[] = {0x11, 0x06, 0x20, 0x00, 0x00, 0x01, 0x01, 0x00,
> > +			0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
> 
> Has this something to do with the SPACE command as defined in SSC-2? I
> don't see the code (0x6 here) to be defined. But then you name is rewind.

	Yes, we redefine the SPACE based on our need, and named it "rewind"

> 
> > +	struct bulk_cb_wrap *bcbw = (struct bulk_cb_wrap *) us->iobuf;
> > +
> > +	memset(bcbw, 0, sizeof(struct bulk_cb_wrap));
> > +	bcbw->Signature = cpu_to_le32(US_BULK_CB_SIGN);
> > +	bcbw->Tag = 0;
> > +	bcbw->DataTransferLength = 0;
> > +	bcbw->Flags = bcbw->Lun = 0;
> 
> A memset() followed by an init of each member of the struct. Could please
> chose one side?
> 
> > +	bcbw->Length = sizeof(rewind_cmd);
> > +	memcpy(bcbw->CDB, rewind_cmd, sizeof(rewind_cmd));
> > +
> > +	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe, &bcbw,
> > +					US_BULK_CS_WRAP_LEN, &act_len);
> 
> I am a little confused here. Shouldn't this be bcbw aka us->iobuf and not
> &bcbw ?
	Yes, you are right.
> 
> And shouldn't you read something from the us->recv_bulk_pipe after
> that?
	Well, because our device will re-connect to switch the ports if it receives the command.
	So it is not necessary to read the response of the command.
> 
> > +	US_DEBUGP("transfer actual length=%d, result=%d\n", act_len,
> result);
> > +	return result;
> > +}
> > +
> 
> Sebastian
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
