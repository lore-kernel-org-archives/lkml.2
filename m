Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab1JMPTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:19:30 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61452 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1JMPT3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:19:29 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1110131032400.2026-100000@iolanthe.rowland.org>
References: <CA+O4pCL-QDUJNyfGueb163wNgO4dE+bn5ykmOxfHsoHaaH3oyA@mail.gmail.com>
	<Pine.LNX.4.44L0.1110131032400.2026-100000@iolanthe.rowland.org>
Date: Thu, 13 Oct 2011 17:19:28 +0200
Message-ID: <CA+O4pC+kRXvGYpnHD7bocuL_t+YWLbChKg8kVAtxmMkd+60+CA@mail.gmail.com>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
From: Markus Rechberger <mrechberger@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 4:58 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 13 Oct 2011, Markus Rechberger wrote:
>
>> And for those who are curious about the logfiles:
>> Not working one as proposed by Alan that the full buffer size should
>> be split into 2 requests:
>>
>> ffff8800b38d9f00 1231540351 S Bi:2:013:1 -115 12288 <
>> ffff8800b38d96c0 1231540404 S Bi:2:013:1 -115 11776 <
>> ffff8800b38d9cc0 1231540440 S Bi:2:013:1 -115 12288 <
>> ffff880002ede600 1231540496 S Bi:2:013:1 -115 11776 <
>> ffff8800b38d9f00 1231545491 C Bi:2:013:1 0 12288 = 7a1a0840 1ca8353c
>> 004b80ec 4de08401 2f0227f8 34005e7e 80181dfd 1a8f700a
>> ffff88007d51fb40 1231545875 S Bi:2:013:1 -115 12288 <
>> ffff8800b38d96c0 1231551861 C Bi:2:013:1 0 11776 = 5244e386 a7800000
>> 010642ea 35bfbba5 373e738b cc035a73 c328a1ff 4da728ce
>> ffff880002ede0c0 1231556173 S Bi:2:013:1 -115 11776 <
>> ffff8800b38d9cc0 1231558618 C Bi:2:013:1 0 12288 = db91aae9 2d2532f3
>> 2e37448a fb36c213 55dda2ad 243122b2 261edb06 875848ac
>>
>>
>> 12288 = 7a1a0840 every Line with 12288 should start with 47 (MPEG-TS Sync byte)
>>
>> The working one which allocate 7000 bytes more (oh really big memory
>> pressure now!)  than this castrated USBFS interface allows.
>
> Sarcasm won't help convince anybody to do anything.
>
>> ffff88003ac37240 992178919 S Bi:2:013:1 -115 24064 <
>> ffff88003ac37000 992178953 S Bi:2:013:1 -115 24064 <
>> ffff88003ac37c00 992178980 S Bi:2:013:1 -115 24064 <
>> ffff88003ac37e40 992179003 S Bi:2:013:1 -115 24064 <
>> ffff88003ac37240 992190198 C Bi:2:013:1 0 24064 = 471fff10 00000000
>> 00000000 00000000 00000000 00000000 00000000 00000000
>> ffff88000601f480 992194368 S Bi:2:013:1 -115 24064 <
>> ffff88003ac37000 992203209 C Bi:2:013:1 0 24064 = 4701b114 43867ee6
>> 40790660 e898681c 9b1c7dca 08980d43 73181369 9be1bc67
>> ffff880067e38a80 992204642 S Bi:2:013:1 -115 24064 <
>> ffff88003ac37c00 992216318 C Bi:2:013:1 0 24064 = 4740001c 0000b01d
>> 0305d500 000000e0 104015e1 504016e1 60401be1 b04022e2
>> ffff880067e383c0 992219978 S Bi:2:013:1 -115 24064 <
>> ffff88003ac37e40 992229340 C Bi:2:013:1 0 24064 = 471fff10 00000000
>> 00000000 00000000 00000000 00000000 00000000 00000000
>>
>> everything starts nicely with 0x47
>
> This is very interesting.  There are only two things that could be
> happening: Either the device sends different data during the two tests,
> or there's a bug in the kernel.
>
> Now, it is possible the device is sending bad data.  The initial parts
> of the two logs do not agree exactly; there are numerous small
> differences in the control data sent by the device and by the program.
> I don't know whether they are significant, but if they aren't, there's
> no reason for the device to send different bulk data.  The transfer
> size certainly cannot account for it.  Indeed, even if the transfer
> size were only 512 bytes, the first data packet should still be the
> same.
>
> You said you don't want to spend any more time working on this problem.
> But I'd still like to track it down.  Is it possible for you to loan me
> a device for testing?  I've got a USB bus analyzer, which could help to
> pin down what's going wrong.
>

The same issues happen with MacOSX and AGAIN windows is also using the same
buffer size.
Currently there's only one sample available, the production should be
ready by the end of this month.
I can certainly give you one device for playing around as soon as it
is ready but for that

Before that I insist that this patch will go into the kernel (I know
that sounds ridiculous but so far I did everything
you requested me to do), I clearly pointed out that we even have hardware
specs which can influence the transfer buffer. The patch does not hurt
and makes the device work.

Now it turns out that this issue suddenly is interesting because
there's no idea why that can happen.
First priority is to get this device work, second priority is
everything else if Linux support is wanted.

BR,
Markus
