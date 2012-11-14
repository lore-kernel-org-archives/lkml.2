Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423324Ab2KNUJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 15:09:56 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43245 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423139Ab2KNUJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 15:09:54 -0500
MIME-Version: 1.0
In-Reply-To: <20121114124110.GG11515@mwanda>
References: <1352496782-7246-1-git-send-email-yamanetoshi@gmail.com>
	<1352496836-7280-1-git-send-email-yamanetoshi@gmail.com>
	<20121114124110.GG11515@mwanda>
Date: Thu, 15 Nov 2012 05:09:53 +0900
Message-ID: <CAOTypNTpwpYEJ4=euz1YJEOm1NMMxsv8ksiyOCVLjJaicZsnzg@mail.gmail.com>
Subject: Re: [PATCH 2/4] staging/serqt_usb2: refactor qt_read_bulk_callback()
 in serqt_usb2.c
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Devendra Naga <devendra.aaru@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Alan Stern <stern@rowland.harvard.edu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 9:41 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Sat, Nov 10, 2012 at 06:33:56AM +0900, YAMANE Toshiaki wrote:
>> Modified to eliminate the deep nesting and redundant description.
>>
>> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
>> ---
>>  drivers/staging/serqt_usb2/serqt_usb2.c |  147 +++++++++++++++++--------------
>>  1 file changed, 80 insertions(+), 67 deletions(-)
>>
>> diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
>> index 9bc8923..0395bdf 100644
>> --- a/drivers/staging/serqt_usb2/serqt_usb2.c
>> +++ b/drivers/staging/serqt_usb2/serqt_usb2.c
>> @@ -291,22 +291,89 @@ static void qt_interrupt_callback(struct urb *urb)
>>       /* FIXME */
>>  }
>>
>> +static int qt_status_change(unsigned int limit,
>> +                         unsigned char *data,
>> +                         int i,
>> +                         struct quatech_port *qt_port,
>> +                         struct usb_serial_port *port)
>> +{
>> +     void (*fn)(struct quatech_port *, unsigned char);
>> +
>> +     if (0x00 == data[i + 2]) {
>> +             dev_dbg(&port->dev, "Line status status.\n");
>> +             fn = ProcessLineStatus;
>> +     } else {
>> +             dev_dbg(&port->dev, "Modem status status.\n");
>> +             fn = ProcessModemStatus;
>> +     }
>> +
>> +     if (i > limit) {
>
> Why can't we test whether i == (RxCount - 3) earlier and handle
> the errors there?  That way we wouldn't need to pass the limit
> variable.
>
> In fact, this whole function is sort of nasty.  We start by doing
> a switch (data[i + 2]) { then we combine the 0x00 and 0x01 and call
> this function which separates them out and sets a function pointer
> and then calls the function point?  Get rid of this whole function.
>
> You shouldn't need to use function pointers to do this; that's too
> many levels of abstraction.
>
>> +             dev_dbg(&port->dev,
>> +                     "Illegal escape seuences in received data\n");
>> +             return 0;
>> +     }
>> +
>> +     (*fn)(qt_port, data[i + 3]);
>> +
>> +     return 1;
>> +}
>> +
>
> [snip]
>
>>       if (urb->status) {
>>               qt_port->ReadBulkStopped = 1;
>> -             dev_dbg(&urb->dev->dev, "%s - nonzero write bulk status received: %d\n",
>> +             dev_dbg(&urb->dev->dev,
>> +                     "%s - nonzero write bulk status received: %d\n",
>>                       __func__, urb->status);
>
> Don't mix in these unrelated 80 character limit changes.

Dan-san,

Thanks for your follow-ups.
I will try to resend this patch.



-- 

Regards,

YAMANE Toshiaki
