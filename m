Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab1JLJZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 05:25:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:59223 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab1JLJZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 05:25:33 -0400
Date: Wed, 12 Oct 2011 11:25:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
cc: linux-kernel@vger.kernel.org, mingo@kernel.org
Subject: Re: [PATCH] irq: Add EXPORT_SYMBOL to function of irq generic-chip
In-Reply-To: <1318403810-21860-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
Message-ID: <alpine.LFD.2.02.1110121036170.3240@ionos>
References: <1318403810-21860-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Oct 2011, Nobuhiro Iwamatsu wrote:

> Although some functions of of irq generic-chip can be used,
> since EXPORT_SYMBOL is not specified, it cannot use.

This does not make sense. In which context they can't be used?

> This is revised that EXPORT_SYMBOL can be added and referred
> to in functions.

EXPORT_SYMBOL_GPL if at all please.

And I'd rather avoid the exports, except those
 
> +EXPORT_SYMBOL(irq_alloc_generic_chip);
> +EXPORT_SYMBOL(irq_setup_generic_chip);
> +EXPORT_SYMBOL(irq_setup_alt_chip);
> +EXPORT_SYMBOL(irq_remove_generic_chip);

which are really necessary. To gain access to the various helper
functions we're better off to create a data structure with function
pointers.

struct irq_gc_functions {
       void (* irq_gc_noop)(...);
       ...
};

Instantiate this structure in kernel/irq/generic-chip.c, statically
initialize it with pointers to those helper functions and export that
data structure. That's way more efficient than having the overhead of
the symbol export for each of the functions.

Thanks,

	tglx
