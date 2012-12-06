Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422642Ab2LFJLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:11:46 -0500
Received: from mx3.cyfra.ua ([62.80.160.182]:48061 "EHLO mx3.cyfra.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1160995Ab2LFJLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:11:43 -0500
From: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Organization: Factor-SPE
To: "Hans J. Koch" <hjk@hansjkoch.de>
Subject: Re: [PATCH v2] drivers/uio/uio_pdrv_genirq.c: Fix memory freeing issues
Date: Thu, 6 Dec 2012 11:11:38 +0200
User-Agent: KMail/1.9.10
Cc: Cong Ding <dinggnu@gmail.com>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <201211271929.32315.vitas@nppfactor.kiev.ua> <201212051122.57724.vitas@nppfactor.kiev.ua> <20121206024101.GB7175@local>
In-Reply-To: <20121206024101.GB7175@local>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212061111.39057.vitas@nppfactor.kiev.ua>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 December 2012 04:41:01 Hans J. Koch wrote:
> > @@ -63,7 +68,7 @@ static irqreturn_t uio_pdrv_genirq_handler(int irq, 
struct uio_info *dev_info)
> >  	 * remember the state so we can allow user space to enable it later.
> >  	 */
> >  
> > -	if (!test_and_set_bit(0, &priv->flags))
> > +	if (!test_and_set_bit(UIO_IRQ_DISABLED, &priv->flags))
> >  		disable_irq_nosync(irq);
> 
> That is not safe. That flag can only be changed by userspace, and if the
> userspace part is not running, the CPU on which the irq is pending will
> hang. 
> The handler has to disable the interrupt in any case.
> (The original version had the same problem, I know...)
> 

Perhaps I'm missing something here, but I don't see your point. If userspace 
is not (implicitly) calling uio_pdrv_genirq_irqcontrol() by writing to the 
device file, then on the first invocation of interrupt handler that IRQ is 
disabled by disable_irq_nosync() and that's the end of story - no more irqs, 
no problems. Until userspace writes non-zero to the device file, of course.

> >  	priv->uioinfo = uioinfo;
> >  	spin_lock_init(&priv->lock);
> > -	priv->flags = 0; /* interrupt is enabled to begin with */
> > +	/* interrupt is enabled to begin with */
> > +	priv->flags = uioinfo_alloced ? (1 << UIO_INFO_ALLOCED) : 0;
> 
> The comment doesn't describe the line it's supposed to comment.
> 

The comment draws attention to the fact that UIO_IRQ_DISABLED is not set 
initially, and this is done on purpose. Particularly it is done because of 
the potential problem you noted earlier - if userspace is never setting this 
flag, the interrupt handler will disable irq on the first invocation thanks 
to the absence of the flag (if(!test_and_set_bit(UIO_IRQ_DISABLED,...) will 
succeed).
So, I think we really need some comment explaining how the things are arranged 
here; after all even you haven't got the whole picture on the first glance.
Maybe the current wording of the comment is not the best. I've just left what 
was there before.
