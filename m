Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab1IAIre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 04:47:34 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57126 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756452Ab1IAIrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 04:47:33 -0400
Date: Thu, 1 Sep 2011 09:45:57 +0100
From: Will Deacon <will.deacon@arm.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH 0/3] RFC: addition to DMA API
Message-ID: <20110901084557.GA30417@e102144-lin.cambridge.arm.com>
References: <CACVXFVPN7SCk8z=vatphyM=PhZDAwtyDidALYPeVkuJ_zxpBvA@mail.gmail.com>
 <Pine.LNX.4.44L0.1108312255060.27371-100000@netrider.rowland.org>
 <CACVXFVOYaxGDZrwkHYc+h=tFhpYp+g95KZrDjg+bPH_N-9BT_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACVXFVOYaxGDZrwkHYc+h=tFhpYp+g95KZrDjg+bPH_N-9BT_g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 04:41:46AM +0100, Ming Lei wrote:
> Hi,
> 
> On Thu, Sep 1, 2011 at 11:09 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> >
> > No, this is completely wrong.
> >
> > Firstly, you are forgetting about other architectures, ones in which
> > writes to coherent memory aren't buffered.  On those architectures
> > there's no way to prevent the DMA bus master from seeing an
> > intermediate state of the data structures.  Therefore the driver has to
> > be written so that even when this happens, everything will work
> > correctly.
> >
> > Secondly, even when write flushes are used, you can't guarantee that
> > the DMA bus master will see an atomic update.  It might turn out that
> > the hardware occasionally flushes some writes very quickly, before the
> > data-structure updates are complete.
> >
> > Thirdly, you are mixing up memory barriers with write flushes.  The
> > barriers are used to make sure that writes are done in the correct
> > order, whereas the flushes are used to make sure that writes are done
> > reasonably quickly.  One has nothing to do with the other, even if by
> > coincidence on ARM a memory barrier causes a write flush.  On other
> > architectures this might not be true.
> 
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
> 
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

I'm struggling to see what you're getting at here. The proposal has
*absolutely nothing* to do with memory barriers. All of the existing
barriers will remain - they are needed for correctness. What changes is the
addition of an /optional/ flush operation in order to guarantee some sort of
immediacy for writes to the coherent buffer.

> >> 3, The new DMA API for the purpose to be introduced is much easier to
> >> understand, and much easier to use than memory barrier, so it is very
> >> possible to make device driver guys misuse or abuse it instead of using
> >> memory barrier first to handle the case.
> >
> > That criticism could apply to almost any new feature.  We shouldn't be
> > afraid to adopt something new merely because it's so easy to use that
> > it might be misused.
> 
> This point depends on the #1 and #2.

Huh? I don't see the connection. If your worry is that people will start
littering their code with flush calls, I don't think that's especially
likely. The usual problem (from what I've seen) is that barriers tend to be
missing rather than overused so I don't see why this would be different for
a what has been proposed.

Will
