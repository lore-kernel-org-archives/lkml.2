Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541Ab1IAP4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 11:56:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39256 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932493Ab1IAP4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 11:56:19 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1109011113210.1896-100000@iolanthe.rowland.org>
References: <CACVXFVOYaxGDZrwkHYc+h=tFhpYp+g95KZrDjg+bPH_N-9BT_g@mail.gmail.com>
	<Pine.LNX.4.44L0.1109011113210.1896-100000@iolanthe.rowland.org>
Date: Thu, 1 Sep 2011 23:56:16 +0800
Message-ID: <CACVXFVOSCS-J8iXcRpCN9TD41pWqcJOiPahtGjBmPpXBLozZyA@mail.gmail.com>
Subject: Re: [PATCH 0/3] RFC: addition to DMA API
From: Ming Lei <ming.lei@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Salter <msalter@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 1, 2011 at 11:22 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 1 Sep 2011, Ming Lei wrote:
>
>> I agree all about above, but what I described is from another view.
>> I post out the example before explaining my idea further:
>>
>>
>>       CPU                     device
>>       A=1;
>>       wmb
>>       B=2;
>>                                       read B
>>                                       read A
>>
>> one wmb is used to order 'A=1' and 'B=2', which will make the two write
>> operations reach to physical memory as the order: 'A=1' first, 'B=2' second.
>> Then the device can observe the two write events as the order above,
>> so if device has seen 'B==2', then device will surely see 'A==1'.
>>
>> Suppose writing to A is operation to update dma descriptor, the above example
>> can make device always see a atomic update of descriptor, can't it?
>
> Suppose A and B are _both_ part of the dma descriptor.  The device
> might see A==1 and B==0, if the memory accesses occur like this:
>
>        CPU             device
>        ---             ------
>        A = 1;
>        wmb();
>                        read B
>                        read A
>        B = 2;
>
> When this happens, the device will observe a non-atomic update of the
> descriptor.  There's no way to prevent this.

If device doesn't find that B is 2, it will not fetch descriptor of A,
and will observe
a atomic update, which is just EHCI does for many cases(such as 4.10.2).

>
>> My idea is that the memory access patterns are to be considered for
>> writer of device driver. For example, many memory access patterns on
>> EHCI hardware are described in detail.  Of course, device driver should
>> make full use of the background info, below is a example from ehci driver:
>>
>> qh_link_async():
>>
>>       /*prepare qh descriptor*/
>>       qh->qh_next = head->qh_next;
>>       qh->hw->hw_next = head->hw->hw_next;
>>       wmb ();
>>
>>       /*link the qh descriptor into hardware queue*/
>>       head->qh_next.qh = qh;
>>       head->hw->hw_next = dma;
>>
>> so once EHCI fetches a qh with the address of 'dma', it will always see
>> consistent content of qh descriptor, which could not be updated partially.
>
> Yes, of course.  That's what memory barriers are intended for, to make
> sure that writes occur in the correct order.  Without the wmb(), the
> CPU might decide to write out the value of head->hw->hw_next before
> writing out the value of qh->hw->hw_next.  Then the device might see an
> inconsistent set of values.
>
> None of this has anything to do with the write flushes you want to add.
>
>> >> 2, most of such cases can be handled correctly by mb/wmb/rmb barriers.
>> >
>> > No, they can't.  See the third point above.
>>
>> The example above has demoed that barriers can do it, hasn't it?
>
> The memory barrier in your qh_link_async() example can make sure that
> the device always sees consistent data.  It doesn't guarantee that the
> write to head->hw->hw_next will be flushed to memory in a reasonably
> short time, which is the problem you are trying to solve.

Yes, up to now, it is the only case in which the flush can address to,
and in which kind of cases device will poll DMA coherent memory contiguously,
I am not sure if there are other devices except for EHCI(maybe have uhci/ohci).
If there are many such kind of devices, the flush operation introduced will
make sense.

As far as I know, for most of devices, dma operation of bus master is triggered
by writing into mmio register instead of writing into coherent memory, and the
flush is not required in this case surely.


thanks,
--
Ming Lei
