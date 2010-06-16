Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab0FPPHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 11:07:48 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53131 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab0FPPHr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 11:07:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=eFOMuwVGyVwE72ohm4IXuUCJ4VTAuy+CGy+1WFUl14jzYtEgq9ntQ1bXEWnJPsZXVh
         oLLWoD9rnrN00KRbkUUdOOCmHhdkuCEoce6JtMeFfx90uWleNujF+F+hCsvffNtTRdio
         MqHyoQFTwLn/Ro7AKe94096hk80a5UfAPsA4A=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20100614223304.GB31069@kroah.com>
References: <1275982163.17060.3.camel@mola> <20100614223304.GB31069@kroah.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 16 Jun 2010 23:07:26 +0800
Message-ID: <AANLkTilvoCwXuSFK5-jO9ZW6di2LQZQdF_9oFxaLtYTo@mail.gmail.com>
Subject: Re: [PATCH] qcserial: fix a memory leak in qcprobe error path
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Matthew Garrett <mjg@redhat.com>,
       Anssi Hannula <anssi.hannula@gmail.com>,
       Bernhard Rosenkraenzer <bero@arklinux.org>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Greg,

2010/6/15 Greg KH <greg@kroah.com>:
> On Tue, Jun 08, 2010 at 03:29:23PM +0800, Axel Lin wrote:
>> In current implemtation, the "data" is not kfreed in qcprobe error path.
>> This patch moves the memory allocation a little bit latter and only
>> allocate memory when no error is detected in previous checking.
>
> Yeah, but it's now pretty messy.
>
>> --- a/drivers/usb/serial/qcserial.c
>> +++ b/drivers/usb/serial/qcserial.c
>> @@ -109,13 +109,6 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
>>       ifnum = intf->desc.bInterfaceNumber;
>>       dbg("This Interface = %d", ifnum);
>>
>> -     data = serial->private = kzalloc(sizeof(struct usb_wwan_intf_private),
>> -                                      GFP_KERNEL);
>> -     if (!data)
>> -             return -ENOMEM;
>> -
>> -     spin_lock_init(&data->susp_lock);
>> -
>
> Moving this to the end is fine.
>
>> @@ -140,7 +135,7 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
>>                                       retval);
>>                               retval = -ENODEV;
>>                       }
>> -                     return retval;
>> +                     goto out;
>
> But this doesn't need to be changed, right?
> Or this.
>
>>               }
>>               break;
>>
>> @@ -156,17 +151,26 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
>>                                       retval);
>>                               retval = -ENODEV;
>>                       }
>> -                     return retval;
>> +                     goto out;
>
> Or this?
>
>>               }
>>               break;
>>
>>       default:
>>               dev_err(&serial->dev->dev,
>>                       "unknown number of interfaces: %d\n", nintf);
>> -             return -ENODEV;
>
> Hm. maybe.
>
>>       }
>>
>> -     return retval;
>> +out:
>> +     if (retval)
>> +             return retval;
>> +
>> +     data = serial->private = kzalloc(sizeof(struct usb_wwan_intf_private),
>> +                                      GFP_KERNEL);
>> +     if (!data)
>> +             return -ENOMEM;
>> +
>> +     spin_lock_init(&data->susp_lock);
>> +     return 0;
>
> I guess it's ok, I just don't like doing data initialization on the
> "out" path, it's messy.
>
> Care to neaten this up a bit more and resend it?  Perhaps just free the
> memory on the error path instead of moving it later on?

I will send a revised patch that just free the memory on the error path.
Thanks for the review.

Axel
>
> thanks,
>
> greg k-h
>
