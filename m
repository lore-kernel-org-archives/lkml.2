Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030502Ab2LGNvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 08:51:09 -0500
Received: from mx3.cyfra.ua ([62.80.160.182]:56746 "EHLO mx3.cyfra.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030489Ab2LGNvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 08:51:07 -0500
From: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Organization: Factor-SPE
To: "Hans J. Koch" <hjk@hansjkoch.de>
Subject: Re: [PATCH v2] drivers/uio/uio_pdrv_genirq.c: Fix memory freeing issues
Date: Fri, 7 Dec 2012 15:51:02 +0200
User-Agent: KMail/1.9.10
Cc: Cong Ding <dinggnu@gmail.com>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <201211271929.32315.vitas@nppfactor.kiev.ua> <20121206221559.GB2611@local> <201212071141.45231.vitas@nppfactor.kiev.ua>
In-Reply-To: <201212071141.45231.vitas@nppfactor.kiev.ua>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201212071551.02974.vitas@nppfactor.kiev.ua>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 December 2012 11:41:45 Vitalii Demianets wrote:
> On Friday 07 December 2012 00:15:59 Hans J. Koch wrote:
> > On Thu, Dec 06, 2012 at 11:11:38AM +0200, Vitalii Demianets wrote:
> > > On Thursday 06 December 2012 04:41:01 Hans J. Koch wrote:
> > > > > @@ -63,7 +68,7 @@ static irqreturn_t uio_pdrv_genirq_handler(int
> > > > > irq,
> > >
> > > struct uio_info *dev_info)
> > >
> > > > >  	 * remember the state so we can allow user space to enable it
> > > > > later. */
> > > > >
> > > > > -	if (!test_and_set_bit(0, &priv->flags))
> > > > > +	if (!test_and_set_bit(UIO_IRQ_DISABLED, &priv->flags))
> > > > >  		disable_irq_nosync(irq);
> > > >
> > > > That is not safe. That flag can only be changed by userspace, and if
> > > > the userspace part is not running, the CPU on which the irq is
> > > > pending will hang.
> > > > The handler has to disable the interrupt in any case.
> > > > (The original version had the same problem, I know...)
> > >
> > > Perhaps I'm missing something here, but I don't see your point. If
> > > userspace is not (implicitly) calling uio_pdrv_genirq_irqcontrol() by
> > > writing to the device file, then on the first invocation of interrupt
> > > handler that IRQ is disabled by disable_irq_nosync() and that's the end
> > > of story - no more irqs, no problems. Until userspace writes non-zero
> > > to the device file, of course.
> >
> > If you run into the irq handler, the interrupt was obviously enabled.
> > Since irq sharing is not supported by this driver, you ALWAYS have to
> > disable it because it IS your interrupt. Storing the enabled/disabled
> > status in a variable is not needed at all here. Or am I missing
> > something?
>
> Good point. I agree that having UIO_IRQ_DISABLED flag is redundant. Inside
> the irq handler we know for sure that irq is enabled. In
> uio_pdrv_genirq_irqcontrol() this knowledge is not mandatory, we could
> enable/disable irq unconditionally.
>

On second thought, we can't call enable_irq()/disable_irq() unconditionally 
because of the potential disable counter (irq_desc->depth) disbalance. That's 
why we need UIO_IRQ_DISABLED flag, and that's why we should check it in 
uio_pdrv_genirq_irqcontrol().
On the other hand, you are right in that we don't need to check it inside irq 
handler. Inside irq handler we can disable irq and set the flag 
unconditionally, because:
a) We know for sure that irqs are enabled, because we are inside (not-shared) 
irq handler;
 and
b) We are guarded from potential race conditions by spin_lock_irqsave() call 
in uio_pdrv_genirq_irqcontrol().

So,yes, we can get rid of costly atomic call to 
test_and_set_bit(UIO_IRQ_DISABLED,..) inside irq handler. But I still don't 
like the idea of mixing this optimization with bug fixes in a single patch.
