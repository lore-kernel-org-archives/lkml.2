Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab1IADJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 23:09:21 -0400
Received: from netrider.rowland.org ([192.131.102.5]:50075 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757503Ab1IADJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 23:09:20 -0400
Date: Wed, 31 Aug 2011 23:09:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Ming Lei <ming.lei@canonical.com>
cc: Mark Salter <msalter@redhat.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/3] RFC: addition to DMA API
In-Reply-To: <CACVXFVPN7SCk8z=vatphyM=PhZDAwtyDidALYPeVkuJ_zxpBvA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1108312255060.27371-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Sep 2011, Ming Lei wrote:

> Hi,
> 
> On Thu, Sep 1, 2011 at 5:30 AM, Mark Salter <msalter@redhat.com> wrote:
> > This patch set arose out of a discussion on linux-arm concerning a
> > performance problem with USB on some ARMv7 based platforms. The
> > problem was tracked down by ming.lei@canonical.com and found to be
> > the result of CPU writes to DMA-coherent memory being delayed in a
> > write buffer between the CPU and memory. One proposed patch fixed
> > only the immediate problem with the USB EHCI driver, but several
> > folks thought a more general approach was needed, so I put this series
> > of patches together as a starting point for wider discussion outside
> > the ARM specific list.
> 
> After some further thoughts, I think it is not a good idea to introduce a
> general DMA API to handle this case, see below:
> 
> 1. The side-effect of new API is that it will make descriptors of dma in a
> partial update, such as qtd in the ehci case, even ehci can handle this
> successful, but it is really not good to make DMA bus master see a
> partial update of descriptor, and I am not  sure that other kind of bus masters
> can handle this correctly, which may introduce other problems. A proper memory
> barrier will always make dma master see a atomic update of dma descriptors,
> which should be the preferred way to take by device driver.

No, this is completely wrong.

Firstly, you are forgetting about other architectures, ones in which
writes to coherent memory aren't buffered.  On those architectures
there's no way to prevent the DMA bus master from seeing an
intermediate state of the data structures.  Therefore the driver has to
be written so that even when this happens, everything will work
correctly.

Secondly, even when write flushes are used, you can't guarantee that
the DMA bus master will see an atomic update.  It might turn out that
the hardware occasionally flushes some writes very quickly, before the
data-structure updates are complete.

Thirdly, you are mixing up memory barriers with write flushes.  The
barriers are used to make sure that writes are done in the correct
order, whereas the flushes are used to make sure that writes are done
reasonably quickly.  One has nothing to do with the other, even if by
coincidence on ARM a memory barrier causes a write flush.  On other
architectures this might not be true.

> 2, most of such cases can be handled correctly by mb/wmb/rmb barriers.

No, they can't.  See the third point above.

> The ehci case I reported is in the one of the most tricky code path in
> ehci driver,
> and it should be a special case, and up to now, we only have found this case
> can't be handled by memory barriers. Is there other cases which can't be handled
> correctly by mb/wmb/rmb? If so, please point it out.
> 
> 3, The new DMA API for the purpose to be introduced is much easier to
> understand, and much easier to use than memory barrier, so it is very
> possible to make device driver guys misuse or abuse it instead of using
> memory barrier first to handle the case.

That criticism could apply to almost any new feature.  We shouldn't be 
afraid to adopt something new merely because it's so easy to use that 
it might be misused.

Alan Stern

