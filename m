Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab0KXN4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 08:56:15 -0500
Received: from www.tglx.de ([62.245.132.106]:41262 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279Ab0KXN4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 08:56:14 -0500
Date: Wed, 24 Nov 2010 14:56:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paul Mundt <lethal@linux-sh.org>
cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [question] NR_IRQS in genirq
In-Reply-To: <20101124084653.GG2212@linux-sh.org>
Message-ID: <alpine.LFD.2.00.1011241455130.2900@localhost6.localdomain6>
References: <AANLkTimoBdFyQ6GfS2DKiF0wdRox0x7MfM0_keD9Z1D0@mail.gmail.com> <20101124084653.GG2212@linux-sh.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010, Paul Mundt wrote:

> On Wed, Nov 24, 2010 at 03:28:37PM +0800, Haojian Zhuang wrote:
> > Hi all,
> > 
> > I'm using the latest kernel 2.6.37-rc1. Now I met some issues on genirq.
> > 
> > 1. While SPARSE IRQ is enabled, nr_irqs may be larger than NR_IRQS.
> > But the allocated_irqs bitmap (kernel/irq/irqdesc.c) is restricted in
> > NR_IRQS. Is it an issue?
> > 
> > 2. irqs_resend bitmap of kernel/irq/resend.c is also restricted in
> > NR_IRQS. Is it an issue, too?
> > 
> Perhaps something like:
> 
> diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
> index 9988d03..11bd76c 100644
> --- a/kernel/irq/irqdesc.c
> +++ b/kernel/irq/irqdesc.c
> @@ -215,6 +215,11 @@ int __init early_irq_init(void)
>  	initcnt = arch_probe_nr_irqs();
>  	printk(KERN_INFO "NR_IRQS:%d nr_irqs:%d %d\n", NR_IRQS, nr_irqs, initcnt);
>  
> +	if (unlikely(nr_irqs > NR_IRQS)) {
> +		WARN(1, "Probed more than NR_IRQS, chomping.\n");
> +		nr_irqs = NR_IRQS;
> +	}

Yep, we need that sanity check, but the WARN() is overkill as we
already know the call chain :)

Thanks,

	tglx
