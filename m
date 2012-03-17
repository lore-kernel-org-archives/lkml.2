Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030987Ab2CQQAk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 12:00:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47310 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab2CQQAg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 12:00:36 -0400
MIME-Version: 1.0
In-Reply-To: <201203161859.35104.oliver@neukum.org>
References: <1331915038-11231-1-git-send-email-santoshprasadnayak@gmail.com>
	<201203161732.17246.oliver@neukum.org>
	<CAOD=uF4pJMousyB2FPrAF-H5nJ7W4p_NEkGdrOpT9xyLVHYQPg@mail.gmail.com>
	<201203161859.35104.oliver@neukum.org>
Date: Sat, 17 Mar 2012 21:30:36 +0530
Message-ID: <CAOD=uF6wD1sx2=Rk3ZaxtykBR32_GMsHmiuXuAQP2U_=c-Ytbw@mail.gmail.com>
Subject: Re: [PATCH] [media] staging: Return -EINTR in s2250_probe() if fails
 to get lock.
From: santosh prasad nayak <santoshprasadnayak@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: mchehab@infradead.org, gregkh@linuxfoundation.org, khoroshilov@ispras.ru,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver,

The following changes are for review only  not a formal patch.

-------------------------------------------------------------------------------------------------------------
-       if (mutex_lock_interruptible(&usb->i2c_lock) == 0) {
+       mutex_lock(&usb->i2c_lock);
                data = kzalloc(16, GFP_KERNEL);
-               if (data != NULL) {
+               if(data == NULL) {
+                       i2c_unregister_device(audio);
+                       kfree(state);
+                       return -ENOMEM;
+               } else {
                        int rc;
                        rc = go7007_usb_vendor_request(go, 0x41, 0, 0,
                                                       data, 16, 1);
@@ -657,7 +661,7 @@ static int s2250_probe(struct i2c_client *client,
                        kfree(data);
                }
                mutex_unlock(&usb->i2c_lock);
-       }
+

----------------------------------------------------------------------


Is it ok ?


regards
Santosh


On Fri, Mar 16, 2012 at 11:29 PM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Freitag, 16. März 2012, 17:56:20 schrieb santosh prasad nayak:
>> On Fri, Mar 16, 2012 at 10:02 PM, Oliver Neukum <oliver@neukum.org> wrote:
>> >
>> > Indeed there's a lot wrong here. The idea of having an interruptible
>> > sleep in probe() is arcane. You need a very, very, very good reason for that.
>>
>> Can you please explain why interruptible  sleep  should not be  in probe() ?
>> I am curious to know.
>
> -EINTR is supposed to be returned to user space, so that it can repeat
> an interrupted syscall.
>
> - There is no user space for probe()
> - probe() cannot be easily repeated from user space
> - there is no syscall for probe
>>
>>
>> > The sane fix is using an uninterruptable sleep here.
>> >
>> > Second, while you are at it, fix the error case for no initialization
>> > due to a failing kmalloc(). You need to return -ENOMEM.
>>
>> Are you talking about kmalloc or kzalloc ?
>> Because for failing kmalloc -ENOMEM is returned as shown below:
>
>                data = kzalloc(16, GFP_KERNEL);
>                if (data != NULL) {
>                        int rc;
>                        rc = go7007_usb_vendor_request(go, 0x41, 0, 0,
>                                                       data, 16, 1);
>                        if (rc > 0) {
>                                u8 mask;
>                                data[0] = 0;
>                                mask = 1<<5;
>                                data[0] &= ~mask;
>                                data[1] |= mask;
>                                go7007_usb_vendor_request(go, 0x40, 0,
>                                                          (data[1]<<8)
>                                                          + data[1],
>                                                          data, 16, 0);
>                        }
>                        kfree(data);
>                }
>                mutex_unlock(&usb->i2c_lock)
>
> This code has no error handling.
>
>        Regards
>                Oliver
