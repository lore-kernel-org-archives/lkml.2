Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768903Ab2KOUB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 15:01:57 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34460 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768435Ab2KOUB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 15:01:56 -0500
MIME-Version: 1.0
In-Reply-To: <20121114124110.GG11515@mwanda>
References: <1352496782-7246-1-git-send-email-yamanetoshi@gmail.com>
	<1352496836-7280-1-git-send-email-yamanetoshi@gmail.com>
	<20121114124110.GG11515@mwanda>
Date: Fri, 16 Nov 2012 05:01:55 +0900
Message-ID: <CAOTypNR_dDjg=XA-yP2OhyrLs3LEBPDFSRBORZUPh6Qzo4w8xA@mail.gmail.com>
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

I feel it so diffcult to consider the fixing this patch more.

There are some reasons why I have become such a description.
- The purpose of this patch is the resolution of the
  line over 80 characters issue
- I Wrote the code to be aware of the following:
-- Do not change the procedure
-- The shallow nest
-- To avoid the redundancy

If I do not use a function pointer, which take the form below.

        if (0x00 == data[i + 2])
                dev_dbg(&port->dev, "Line status status.\n");
        else
                dev_dbg(&port->dev, "Modem status status.\n");

        if (i > limit) {
                dev_dbg(&port->dev,
                        "Illegal escape seuences in received data\n");
                return 0;
        }

        if (0x00 == data[i + 2])
                ProcessLineStatus(qt_port, data[i + 3]);
        else
                ProcessModemStatus(qt_port, data[i + 3]);

	return 1;

I also feel it may be...

And I am against to move the dev_dbg procedure call to
qt_status_change_check procedure because the nesting will be so deep.

>>       if (urb->status) {
>>               qt_port->ReadBulkStopped = 1;
>> -             dev_dbg(&urb->dev->dev, "%s - nonzero write bulk status received: %d\n",
>> +             dev_dbg(&urb->dev->dev,
>> +                     "%s - nonzero write bulk status received: %d\n",
>>                       __func__, urb->status);
>
> Don't mix in these unrelated 80 character limit changes.

I think the purpose of refactoring is the resolution of the line over 80
characters issue. I think that the separation of the patch should stop taking
because they are already applied in the linux-next tree.

Thanks.


YAMANE Toshiaki
yamanetoshi@gmail.com
