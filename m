Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072Ab0DHRRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 13:17:36 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:64964 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932986Ab0DHRRR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 13:17:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GpOSLnXTotOjzgOV5jjsg9OLPUHERPJ4blJjuIsdgtG5xkbz6FMgeKA9dGPA7rPo1t
         Bbvn8L2K5wGrn0CvsW4pvFjkjUgsqF7ivL7+o2yKAoo65fHmeG0Ueo/J5hi8VTSkxXB6
         8qwxQgb3tuY6p94jyNinWMc+XQPfo7ikoYY94=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1004081245330.1720-100000@iolanthe.rowland.org>
References: <20100408073041.GO30801@buzzloop.caiaq.de>
	 <Pine.LNX.4.44L0.1004081245330.1720-100000@iolanthe.rowland.org>
Date: Thu, 8 Apr 2010 18:17:15 +0100
Message-ID: <h2m74fd948d1004081017p6fe8652cpee34d79edf65508b@mail.gmail.com>
Subject: Re: USB transfer_buffer allocations on 64bit systems
From: Pedro Ribeiro <pedrib@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Daniel Mack <daniel@caiaq.de>, Robert Hancock <hancockrwd@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Greg KH <gregkh@suse.de>, alsa-devel@alsa-project.org,
       linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 April 2010 17:57, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 8 Apr 2010, Daniel Mack wrote:
>
>> > > AFAIK, the driver shouldn't have to worry about this at all. When the
>> > > buffer gets DMA-mapped for the controller, the DMA mapping code should
>> > > see that the device has a 32-bit DMA mask and either bounce or IOMMU-map
>> > > the memory so that it appears below 4GB.
>> >
>> > That's true.  It would of course be more efficient for the buffer to be
>> > allocated below 4 GB, but it should work okay either way.  Daniel, do
>> > you have any idea why it fails?
>>
>> No, and I can't do real tests as I lack a 64bit machine. I'll do some
>> more investigation later today, but for now the only explanation I have
>> is that not the remapped DMA buffer is used eventually by the EHCI code
>> but the physical address of the original buffer.
>>
>> It would of course be best to fix the whole problem at this level, if
>> possible.
>
> It definitely needs to be fixed at this level.  But I still think it's
> appropriate to have new USB core functions for allocating and
> deallocating I/O memory.  The additional price is small compared to
> constantly bouncing the buffers.
>
> Pedro, in the hope of tracking down the problem, can you apply this
> patch and see what output it produces in the system log when the
> "interference" happens?  (Warning: It will produce quite a lot of
> output whenever you send data to the audio device -- between 500 and
> 1000 lines per second.)
>
> Alan Stern
>
>
>
> Index: 2.6.33/drivers/usb/core/hcd.c
> ===================================================================
> --- 2.6.33.orig/drivers/usb/core/hcd.c
> +++ 2.6.33/drivers/usb/core/hcd.c
> @@ -1395,6 +1395,10 @@ int usb_hcd_submit_urb (struct urb *urb,
>                usbmon_urb_submit_error(&hcd->self, urb, status);
>                goto error;
>        }
> +       if (usb_endpoint_is_isoc_out(&urb->ep->desc))
> +               dev_info(&urb->dev->dev, "Iso xfer %p dma %llx\n",
> +                               urb->transfer_buffer,
> +                               (unsigned long long) urb->transfer_dma);
>
>        if (is_root_hub(urb->dev))
>                status = rh_urb_enqueue(hcd, urb);
>
>

I'll do it tonight and send you the results tomorrow morning. Do you
want CONFIG_USB_DEBUG enabled or disabled?

Pedro
