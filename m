Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab1IAQsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 12:48:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55140 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751131Ab1IAQsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 12:48:20 -0400
Date: Thu, 1 Sep 2011 12:48:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <ming.lei@canonical.com>
cc: linux-kernel@vger.kernel.org, <linux-arm-kernel@lists.infradead.org>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH 0/3] RFC: addition to DMA API
In-Reply-To: <CACVXFVOSCS-J8iXcRpCN9TD41pWqcJOiPahtGjBmPpXBLozZyA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1109011244340.1896-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Sep 2011, Ming Lei wrote:

> > Suppose A and B are _both_ part of the dma descriptor.  The device
> > might see A==1 and B==0, if the memory accesses occur like this:
> >
> >        CPU             device
> >        ---             ------
> >        A = 1;
> >        wmb();
> >                        read B
> >                        read A
> >        B = 2;
> >
> > When this happens, the device will observe a non-atomic update of the
> > descriptor.  There's no way to prevent this.
> 
> If device doesn't find that B is 2, it will not fetch descriptor of A,
> and will observe
> a atomic update, which is just EHCI does for many cases(such as 4.10.2).

You didn't read what I wrote above.  Suppose A and B are _both_ part of 
the same descriptor, like hw_token and hw_qtd_next.


> > The memory barrier in your qh_link_async() example can make sure that
> > the device always sees consistent data.  It doesn't guarantee that the
> > write to head->hw->hw_next will be flushed to memory in a reasonably
> > short time, which is the problem you are trying to solve.
> 
> Yes, up to now, it is the only case in which the flush can address to,
> and in which kind of cases device will poll DMA coherent memory contiguously,
> I am not sure if there are other devices except for EHCI(maybe have uhci/ohci).

Yes: UHCI, OHCI, EHCI, and XHCI all poll memory constantly.

> If there are many such kind of devices, the flush operation introduced will
> make sense.
> 
> As far as I know, for most of devices, dma operation of bus master is triggered
> by writing into mmio register instead of writing into coherent memory, and the
> flush is not required in this case surely.

That's right.  It is needed only when the device polls automatically.

Alan Stern

