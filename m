Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab0IVCXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 22:23:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64411 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab0IVCXV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 22:23:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DzIusNx5tr3JmGhG6af2wm1JZyKfUpFmrIACZEZv9e2SSfCNlS5QOnUYIRB762mIj/
         0wvWkTpP7Gt+TSUKvnwdH1OnQhiw0L/YvMEjztts8qNRot9hgMWW2tnpYNAiRCLYiXek
         vk9/SEnzhokAYUiadzkBndM9leYasBiiRGTu8=
MIME-Version: 1.0
In-Reply-To: <201009191943.21021.wolfgang@iksw-muees.de>
References: <711BBECDEF81BA439A6038E213C1DF140957B9F8@ism-mail03.corp.ad.wrs.com>
	<201009180954.52965.wolfgang@iksw-muees.de>
	<AANLkTikj01UhkiVrGJg4jgoOtXZ6dJjnwTsskDUVLD_H@mail.gmail.com>
	<201009191943.21021.wolfgang@iksw-muees.de>
Date: Wed, 22 Sep 2010 10:23:19 +0800
Message-ID: <AANLkTikQQOB43UkQKhtm8qL_UvBRFCDSMFUKhjLvswzH@mail.gmail.com>
Subject: Re: USB: free coherent buffer into atomic context
From: Ming Lei <tom.leiming@gmail.com>
To: =?ISO-8859-1?Q?Wolfgang_M=FCes?= <wolfgang@iksw-muees.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/20 Wolfgang Mües <wolfgang@iksw-muees.de>:
> Hi Ming,
>
> Am Samstag, 18. September 2010 10:50:20 schrieb Ming Lei:
>> IMO, it is not necessary for a coherent buffer to be kept for
>> the whole time a driver operates on a device.
>
> From DMA-mapping.txt:
>>There are two types of DMA mappings:
>>
>>- Consistent DMA mappings which are usually mapped at driver
>>  initialization, unmapped at the end and for which the hardware should
>>  guarantee that the device and the CPU can access the data
>>  in parallel and will see updates made by each other without any
>>  explicit software flushing.
>
>>- Streaming DMA mappings which are usually mapped for one DMA transfer,
>>  unmapped right after it (unless you use pci_dma_sync_* below) and for which
>>  hardware can optimize for sequential accesses.
>
> You wrote:
>> Also, coherent buffer
>> is very limited in some arch(such as ARM), maybe we should use it
>> more dynamically, instead of keeping it for long time.
>
> No, this is against the design (see above).
>
> If you want to be dynamic, please use streaming DMA mapping.

The dynamic here is that allocate and free dynamically, not map and unmap
dynamically. As I said, some arch may have very limited coherent buffer
space, so allocate and free coherent memory for one driver does make sense.

>
> If a DMA buffer is needed often and you want to avoid the overhead of streaming
> dma mapping, use a coherent buffer.

This is nothing to do with the topic.

>
>> irqs_disabled() doesn't mean the buffer is freed in an interrupt context.
>
> I am very sure that the writer of this code has used irqs_disabled() as an
> indication of interrupt context. Maybe in_interrupt() will be more precise.

You mean WARN_ON(irqs_disables) is wrong?  Anyway, irqs_disabled is very
different with in_interrupt, isn't it?

You still not reply the root cause of WARN_ON(irqs_disables) is added
into dma_free_coherent. I want to know there is any catastrophic or
side effect if dma_free_coherent is called with irq disabled, seems
you just said it is against the initial design.

>
>> If it is only a misuse, seems WARN_ON can be removed.
>
> How on earth will you detect the misuse if there is no visible indication at
> runtime?

In fact, some usb host controller only can DMA data using its internal sram,
which is generally declared as coherent memory using
dma_declare_coherent_memory. When submiting urb to usbcore, the
internal coherent buffer is allocated as bounce buffer to do dma transfer
, and after the transfer is over the bounce buffer will be deallocated using
dma_free_coherent, which can cause the warning since urb->complete always
run in irq context.

So I want to know the root cause of the warning.  If there is very little side
effect to call dma_free_coherent in irq context, we can keep the current usb
implementation in this case and just remove the WARN_ON from
dma_free_coherent.


thanks,
-- 
Lei Ming
