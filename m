Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab1IADlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 23:41:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56000 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757544Ab1IADlt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 23:41:49 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1108312255060.27371-100000@netrider.rowland.org>
References: <CACVXFVPN7SCk8z=vatphyM=PhZDAwtyDidALYPeVkuJ_zxpBvA@mail.gmail.com>
	<Pine.LNX.4.44L0.1108312255060.27371-100000@netrider.rowland.org>
Date: Thu, 1 Sep 2011 11:41:46 +0800
Message-ID: <CACVXFVOYaxGDZrwkHYc+h=tFhpYp+g95KZrDjg+bPH_N-9BT_g@mail.gmail.com>
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

Hi,

On Thu, Sep 1, 2011 at 11:09 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 1 Sep 2011, Ming Lei wrote:
>
>> Hi,
>>
>> On Thu, Sep 1, 2011 at 5:30 AM, Mark Salter <msalter@redhat.com> wrote:
>> > This patch set arose out of a discussion on linux-arm concerning a
>> > performance problem with USB on some ARMv7 based platforms. The
>> > problem was tracked down by ming.lei@canonical.com and found to be
>> > the result of CPU writes to DMA-coherent memory being delayed in a
>> > write buffer between the CPU and memory. One proposed patch fixed
>> > only the immediate problem with the USB EHCI driver, but several
>> > folks thought a more general approach was needed, so I put this series
>> > of patches together as a starting point for wider discussion outside
>> > the ARM specific list.
>>
>> After some further thoughts, I think it is not a good idea to introduce a
>> general DMA API to handle this case, see below:
>>
>> 1. The side-effect of new API is that it will make descriptors of dma in a
>> partial update, such as qtd in the ehci case, even ehci can handle this
>> successful, but it is really not good to make DMA bus master see a
>> partial update of descriptor, and I am not  sure that other kind of bus masters
>> can handle this correctly, which may introduce other problems. A proper memory
>> barrier will always make dma master see a atomic update of dma descriptors,
>> which should be the preferred way to take by device driver.
>
> No, this is completely wrong.
>
> Firstly, you are forgetting about other architectures, ones in which
> writes to coherent memory aren't buffered.  On those architectures
> there's no way to prevent the DMA bus master from seeing an
> intermediate state of the data structures.  Therefore the driver has to
> be written so that even when this happens, everything will work
> correctly.
>
> Secondly, even when write flushes are used, you can't guarantee that
> the DMA bus master will see an atomic update.  It might turn out that
> the hardware occasionally flushes some writes very quickly, before the
> data-structure updates are complete.
>
> Thirdly, you are mixing up memory barriers with write flushes.  The
> barriers are used to make sure that writes are done in the correct
> order, whereas the flushes are used to make sure that writes are done
> reasonably quickly.  One has nothing to do with the other, even if by
> coincidence on ARM a memory barrier causes a write flush.  On other
> architectures this might not be true.

I agree all about above, but what I described is from another view.
I post out the example before explaining my idea further:


	CPU			device	
	A=1;
	wmb
	B=2;
					read B
					read A

one wmb is used to order 'A=1' and 'B=2', which will make the two write
operations reach to physical memory as the order: 'A=1' first, 'B=2' second.
Then the device can observe the two write events as the order above,
so if device has seen 'B==2', then device will surely see 'A==1'.

Suppose writing to A is operation to update dma descriptor, the above example
can make device always see a atomic update of descriptor, can't it?

My idea is that the memory access patterns are to be considered for
writer of device driver. For example, many memory access patterns on
EHCI hardware are described in detail.  Of course, device driver should
make full use of the background info, below is a example from ehci driver:

qh_link_async():

	/*prepare qh descriptor*/
	qh->qh_next = head->qh_next;
	qh->hw->hw_next = head->hw->hw_next;
	wmb ();

	/*link the qh descriptor into hardware queue*/
	head->qh_next.qh = qh;
	head->hw->hw_next = dma;

so once EHCI fetches a qh with the address of 'dma', it will always see
consistent content of qh descriptor, which could not be updated partially.

>
>> 2, most of such cases can be handled correctly by mb/wmb/rmb barriers.
>
> No, they can't.  See the third point above.

The example above has demoed that barriers can do it, hasn't it?

>
>> The ehci case I reported is in the one of the most tricky code path in
>> ehci driver,
>> and it should be a special case, and up to now, we only have found this case
>> can't be handled by memory barriers. Is there other cases which can't be handled
>> correctly by mb/wmb/rmb? If so, please point it out.
>>
>> 3, The new DMA API for the purpose to be introduced is much easier to
>> understand, and much easier to use than memory barrier, so it is very
>> possible to make device driver guys misuse or abuse it instead of using
>> memory barrier first to handle the case.
>
> That criticism could apply to almost any new feature.  We shouldn't be
> afraid to adopt something new merely because it's so easy to use that
> it might be misused.

This point depends on the #1 and #2.

thanks,
--
Ming Lei
