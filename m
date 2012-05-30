Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab2E3C43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 22:56:29 -0400
Received: from linux-sh.org ([111.68.239.195]:40240 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171Ab2E3C4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 22:56:17 -0400
Date: Wed, 30 May 2012 11:55:56 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Sundar Iyer <sundar.iyer@intel.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        arjan.van.de.ven@intel.com, german.monroy@intel.com
Subject: Re: [PATCH v1] x86/irq: handle chained interrupts during IRQ
 migration
Message-ID: <20120530025555.GC11445@linux-sh.org>
References: <1338298808-2265-1-git-send-email-sundar.iyer@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338298808-2265-1-git-send-email-sundar.iyer@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 07:10:08PM +0530, Sundar Iyer wrote:
> diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
> index 2d921b3..7880722 100644
> --- a/include/linux/irqdesc.h
> +++ b/include/linux/irqdesc.h
> @@ -120,6 +120,16 @@ static inline int irq_has_action(unsigned int irq)
>  	return desc->action != NULL;
>  }
>  
> +/*
> + * Test to see if the IRQ is chained; it would not be requested and hence
> + * _IRQ_NOREQUEST would be set
> + */
> +static inline int irq_is_chained(unsigned int irq)
> +{
> +	struct irq_desc *desc = irq_to_desc(irq);
> +	return !(desc->status_use_accessors & IRQ_NOREQUEST);
> +}
> +

This approach looks highly suspect. There are many non-chained cases that
are also NOREQUEST. Chained IRQs are at the very least NOREQUEST,
NOPROBE, and NOTHREAD. You could test a mask of those and at least have a
vague change of not catching other unrelated IRQs. It would still be a
hack though, given that none of those status flags in and of themselves
require an IRQ to be chained.
