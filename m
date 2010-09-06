Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab0IFVXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 17:23:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56418 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab0IFVW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 17:22:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=hB2byJ/uupyBmGi9uE5GT2y2IUqFgJ8kBP7yL/ptuyfYbDi3JwykTdLzuah+JC3cg1
         JkFp8Mo77rthA+HKvBmYgiKqFsGeVSYg275uJuFowhytd9yIvXuJgXrIHZxmIaNULLG/
         VJf6h71UNA7cUCUzPssA6XYFpGkqU+NVWcREc=
Message-ID: <4C855BAA.4000900@gmail.com>
Date: Mon, 06 Sep 2010 23:22:50 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Rafi Rubin <rafi@seas.upenn.edu>, jkosina@suse.cz,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        micki@n-trig.com, rydberg@euromail.se, chatty@enac.fr
Subject: Re: [PATCH] identify firmware version
References: <4C7EB3A3.7050402@gmail.com> <1283791362-27780-1-git-send-email-rafi@seas.upenn.edu> <20100906194838.GB31384@core.coreip.homeip.net>
In-Reply-To: <20100906194838.GB31384@core.coreip.homeip.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2010 09:48 PM, Dmitry Torokhov wrote:
>> @@ -848,10 +871,43 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
>>  	if (report)
>>  		usbhid_submit_report(hdev, report, USB_DIR_OUT);
>>  
>> +	data = kmalloc(8, GFP_KERNEL);
>> +	if (!data) {
>> +		ret = -ENOMEM;
>> +		goto err_free;
>> +	}
>> +
>> +	ret = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
>> +			      USB_REQ_CLEAR_FEATURE,
>> +			      USB_TYPE_CLASS | USB_RECIP_INTERFACE |
>> +			      USB_DIR_IN,
>> +			      0x30c, 1, data, 8,
>> +			      USB_CTRL_SET_TIMEOUT);
>> +
>> +	if (ret == 8) {
>> +		buf = kmalloc(20, GFP_KERNEL);
>> +		if (!buf) {
>> +			ret = -ENOMEM;
>> +			goto err_free_data;
>> +		}
> 
> Why do you allocate this from heap? Surely we can spare 20 bytes on
> stack (you aren't doing DMA into it).

Hi, yeah, I think so too.

> I'd also split all this code into ntrig_report_version() to simplifu
> error handling here.
> 
>> +
>> +		ret = ntrig_version_string(&data[2], buf);
>> +
>> +		dev_info(&hdev->dev,
>> +			 "Firmware version: %s (%02x%02x %02x%02x)\n",
>> +			 buf, data[2], data[3], data[4], data[5]);
>> +
>> +		kfree(buff);

In any case, this doesn't compile...

>> +	}

regards,
-- 
js
