Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab1IAPmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 11:42:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39733 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932439Ab1IAPmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 11:42:24 -0400
Date: Thu, 1 Sep 2011 11:42:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <ming.lei@canonical.com>
cc: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH 0/3] RFC: addition to DMA API
In-Reply-To: <CACVXFVOT9FZexiZhuJtvyFP8qOPYUKg0JqGarBJgT4R8SN7p5Q@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1109011127080.1896-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Sep 2011, Ming Lei wrote:

> First, most of barriers have made this kind of flush not necessary, as
> explained int the example above.

You don't seem to understand the difference between memory barriers and 
write flushes.  Neither makes the other unnecessary -- they do 
different things.

Now, there is good reason to question why write flushes should be 
needed at all.  According to the definition in 
Documentation/DMA-API.txt (the document doesn't distinguish between 
coherent memory and consistent memory):

  Consistent memory is memory for which a write by either the device or
  the processor can immediately be read by the processor or device
  without having to worry about caching effects.  (You may however need
  to make sure to flush the processor's write buffers before telling
  devices to read that memory.)

As far as I can tell, we are talking about a cache flush rather than a 
processor write buffer flush.  If that's so, it would appear that the 
memory in question is not truly coherent.

>  Even for ehci driver, the flush to be
> added is only __one__ special case, so could you list other cases in
> which the flush operation is a must and memory barrier can't do it?

There are other places in ehci-hcd where write flushes would help
improve performance or correctness, although the one in qh_append_tds()  
is probably the most critical.  One such place is in qh_link_async();
others are in qh_link_periodic(), qh_unlink_periodic(), itd_link_urb(),
and sitd_link_urb().

And there are similar places in the other USB host controller drivers.

> If one can understand dma master access order on shared memory
> in the context, it is not difficult to use memory barrier to avoid the
> flush operation.

That simply is not true.  If it were, you would not have needed to 
submit your original patch.

> Second, as I said before, the flush operation is very easy to cause dma
> descriptor updated in partial, as qtd descriptor updated in the ehci case.

No, not if memory barriers are used correctly.

> It is one of the side effects of the flush to be introduced.  Fortunately, EHCI
> can handle this correctly, but can other hardwares always handle this correctly?

If they can't, they are already broken.  Adding write flushes won't 
make them any worse.

Alan Stern

