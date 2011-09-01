Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab1IAPWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 11:22:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38978 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932346Ab1IAPWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 11:22:51 -0400
Date: Thu, 1 Sep 2011 11:22:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <ming.lei@canonical.com>
cc: linux-kernel@vger.kernel.org, <linux-arm-kernel@lists.infradead.org>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH 0/3] RFC: addition to DMA API
In-Reply-To: <CACVXFVOYaxGDZrwkHYc+h=tFhpYp+g95KZrDjg+bPH_N-9BT_g@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1109011113210.1896-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Sep 2011, Ming Lei wrote:

> I agree all about above, but what I described is from another view.
> I post out the example before explaining my idea further:
> 
> 
> 	CPU			device	
> 	A=1;
> 	wmb
> 	B=2;
> 					read B
> 					read A
> 
> one wmb is used to order 'A=1' and 'B=2', which will make the two write
> operations reach to physical memory as the order: 'A=1' first, 'B=2' second.
> Then the device can observe the two write events as the order above,
> so if device has seen 'B==2', then device will surely see 'A==1'.
> 
> Suppose writing to A is operation to update dma descriptor, the above example
> can make device always see a atomic update of descriptor, can't it?

Suppose A and B are _both_ part of the dma descriptor.  The device 
might see A==1 and B==0, if the memory accesses occur like this:

	CPU		device
	---		------
	A = 1;
	wmb();
			read B
			read A
	B = 2;

When this happens, the device will observe a non-atomic update of the 
descriptor.  There's no way to prevent this.

> My idea is that the memory access patterns are to be considered for
> writer of device driver. For example, many memory access patterns on
> EHCI hardware are described in detail.  Of course, device driver should
> make full use of the background info, below is a example from ehci driver:
> 
> qh_link_async():
> 
> 	/*prepare qh descriptor*/
> 	qh->qh_next = head->qh_next;
> 	qh->hw->hw_next = head->hw->hw_next;
> 	wmb ();
> 
> 	/*link the qh descriptor into hardware queue*/
> 	head->qh_next.qh = qh;
> 	head->hw->hw_next = dma;
> 
> so once EHCI fetches a qh with the address of 'dma', it will always see
> consistent content of qh descriptor, which could not be updated partially.

Yes, of course.  That's what memory barriers are intended for, to make 
sure that writes occur in the correct order.  Without the wmb(), the 
CPU might decide to write out the value of head->hw->hw_next before 
writing out the value of qh->hw->hw_next.  Then the device might see an 
inconsistent set of values.

None of this has anything to do with the write flushes you want to add.

> >> 2, most of such cases can be handled correctly by mb/wmb/rmb barriers.
> >
> > No, they can't.  See the third point above.
> 
> The example above has demoed that barriers can do it, hasn't it?

The memory barrier in your qh_link_async() example can make sure that
the device always sees consistent data.  It doesn't guarantee that the
write to head->hw->hw_next will be flushed to memory in a reasonably 
short time, which is the problem you are trying to solve.

Alan Stern

