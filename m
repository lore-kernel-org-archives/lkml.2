Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab1IGRcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:32:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:44039 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab1IGRcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:32:02 -0400
Date: Wed, 7 Sep 2011 19:31:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Miller <davem@davemloft.net>
cc: yong.zhang0@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        joe@perches.com, sparclinux@vger.kernel.org
Subject: Re: [PATCH 20/62] sparc: irq: Remove IRQF_DISABLED
In-Reply-To: <20110907.131217.2301665763990232637.davem@davemloft.net>
Message-ID: <alpine.LFD.2.02.1109071924510.2723@ionos>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com> <1315383059-3673-21-git-send-email-yong.zhang0@gmail.com> <20110907.131217.2301665763990232637.davem@davemloft.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Sep 2011, David Miller wrote:

> From: Yong Zhang <yong.zhang0@gmail.com>
> Date: Wed,  7 Sep 2011 16:10:17 +0800
> 
> > This flag is a NOOP and can be removed now.
> > 
> > Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> 
> How are things working now, if that is the case?
> 
> Specifically in the ldc_bind() case, we're passing iRQF_DISABLED here
> so that the IRQ is not turned on when we request the IRQ, we later do
> enable_irq() on these after we've take the spinlock in this function.
> 
> The IRQ cannot be allowed to be delivered between the request_irq()
> call and the enable_irq() calls.
> 
> This sequence is necessary to deal with some lock ordering issues.

IRQF_DISABLED was telling the core code that the interrupt must run
with interrupts disabled. As we enforced running all handlers with
interrupts disabled the flag is meaningless. It was defined as 0
anyway.

What you need to prevent that request_irq() enables the interrupt
unconditionally, is to set IRQ_NOAUTOEN on the interrupt, which can't
be handed in to request_irq(). You want to call

   irq_set_status_flags(irq, IRQ_NOAUTOEN);

for that irq. That tells request_irq() to leave the interrupt disabled
and you have to explicitely enable it. That has not changed since we
generalized the irq core code back in 2006.

Thanks,

	tglx
