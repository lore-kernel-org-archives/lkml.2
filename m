Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab0JLIkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 04:40:23 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59511 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010Ab0JLIkV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 04:40:21 -0400
MIME-Version: 1.0
X-Originating-IP: [87.194.181.195]
In-Reply-To: <20101012002715.fd0e3371.akpm@linux-foundation.org>
References: <201010120022.13171.james@albanarts.com>
	<20101011163440.072e0227.akpm@linux-foundation.org>
	<201010120808.05713.james@albanarts.com>
	<20101012002715.fd0e3371.akpm@linux-foundation.org>
Date: Tue, 12 Oct 2010 09:40:20 +0100
Message-ID: <AANLkTimdasN2xF71DbueQyv0sWNQicu79==VfuW6BTKM@mail.gmail.com>
Subject: Re: [PATCH] b44: fix resume, request_irq after hw reset
From: James Hogan <james@albanarts.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gary Zambrano <zambrano@broadcom.com>, Jiri Pirko <jpirko@redhat.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Larry Finger <Larry.Finger@lwfinger.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 October 2010 08:27, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 12 Oct 2010 08:08:05 +0100 James Hogan <james@albanarts.com> wrote:
>
>> > > @@ -2309,6 +2303,12 @@ static int b44_resume(struct ssb_device *sdev)
>> > >
>> > >   netif_device_attach(bp->dev);
>> > >   spin_unlock_irq(&bp->lock);
>> > >
>> > > + rc = request_irq(dev->irq, b44_interrupt, IRQF_SHARED, dev->name,
>> dev);
>> > > + if (rc) {
>> > > +         netdev_err(dev, "request_irq failed\n");
>> > > +         return rc;
>> > > + }
>> > > +
>> > >
>> > >   b44_enable_ints(bp);
>> > >   netif_wake_queue(dev);
>> >
>> > OK, running the interrupt handler before b44_init_hw() is presumably
>> > the problem here.
>> >
>> > The hardware surely won't be generating interrupts until we've run
>> > b44_init_hw() and b44_enable_ints(), so this patch really is only to
>> > keep CONFIG_DEBUG_SHIRQ happy.
>>
>> For me it's mainly to keep CONFIG_DEBUG_SHIRQ happy (Fedora has this switched
>> on), but since it's a shared IRQ, there is still a chance it could be
>> called before enabling it's own interrupts by a different device on the same
>> IRQ.
>
> ooh, yes, you're right, I forgot about that.  It's indeed a bug.
>
>> It makes sense to me why it's disabling the IRQ now, in case another device
>> triggers it when it cannot handle it safely.
>
> What code are you referring to here?  There's no disable_irq() in that area?

Sorry, I meant freeing the irq (free_irq() in b44_suspend).

Thinking about it this should also go in stable too.

Cheers
James

>
>> I also tried calling the
>> interrupt directly before the free_irq in the suspend function to check that
>> it wasn't being done too late, and it didn't fail, so possibly it is the core
>> suspension that makes it start failing until it is brought back up properly.
>
