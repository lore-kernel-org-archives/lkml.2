Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab1JQJAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 05:00:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:53412 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab1JQJAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 05:00:16 -0400
Date: Mon, 17 Oct 2011 11:00:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
cc: linux-kernel@vger.kernel.org, mingo@kernel.org
Subject: Re: [PATCH 2/2] irq: Add function pointer table for generic-chip
In-Reply-To: <1318817327-4589-2-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
Message-ID: <alpine.LFD.2.02.1110171055570.3240@ionos>
References: <1318817327-4589-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com> <1318817327-4589-2-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011, Nobuhiro Iwamatsu wrote:

> This adds the function table to access it with function pointer
> by some functions providedd in generic-chip.
> The driver who uses the function offered in generic-chip can use
> this via this function table.
>  
> -/* Generic chip callback functions */
> -void irq_gc_noop(struct irq_data *d);
> -void irq_gc_mask_disable_reg(struct irq_data *d);
> -void irq_gc_mask_set_bit(struct irq_data *d);
> -void irq_gc_mask_clr_bit(struct irq_data *d);
> -void irq_gc_unmask_enable_reg(struct irq_data *d);
> -void irq_gc_ack_set_bit(struct irq_data *d);
> -void irq_gc_ack_clr_bit(struct irq_data *d);
> -void irq_gc_mask_disable_reg_and_ack(struct irq_data *d);
> -void irq_gc_eoi(struct irq_data *d);
> -int irq_gc_set_wake(struct irq_data *d, unsigned int on);

This breaks the world and some more. We have code which references
those functions directly.
  
> +		gc->functions.gc_noop = irq_gc_noop;
> +		gc->functions.gc_mask_disable_reg = irq_gc_mask_disable_reg;
> +		gc->functions.gc_mask_set_bit = irq_gc_mask_set_bit;
> +		gc->functions.gc_mask_clr_bit = irq_gc_mask_clr_bit;
> +		gc->functions.gc_unmask_enable_reg = irq_gc_unmask_enable_reg;
> +		gc->functions.gc_ack_set_bit = irq_gc_ack_set_bit;
> +		gc->functions.gc_ack_clr_bit = irq_gc_ack_clr_bit;
> +		gc->functions.gc_mask_disable_reg_and_ack = irq_gc_mask_disable_reg_and_ack;
> +		gc->functions.gc_eoi = irq_gc_eoi;
> +		gc->functions.gc_set_wake = irq_gc_set_wake;

Why do you want to add that to every instance of generic irq chip?
What I asked for is:

struct bla {
       .noop = irq_gc_noop,
       ...
};
EXPORT_SYMBOL_GPL(bla);

Now when we have this, we can run a coccinelle script over the tree
and convert all current users to use bla.fun instead of the direct
functions and then make those static.

Thanks,

	tglx

