Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab0LNVrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:47:08 -0500
Received: from www.tglx.de ([62.245.132.106]:44475 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821Ab0LNVrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:47:06 -0500
Date: Tue, 14 Dec 2010 22:46:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kiszka <jan.kiszka@web.de>
cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v3 2/4] genirq: Inform handler about line sharing state
In-Reply-To: <a59c76552ebeaa128022ba9bcc7ea0753b312447.1292281184.git.jan.kiszka@web.de>
Message-ID: <alpine.LFD.2.00.1012142243540.12146@localhost6.localdomain6>
References: <cover.1292281184.git.jan.kiszka@web.de> <a59c76552ebeaa128022ba9bcc7ea0753b312447.1292281184.git.jan.kiszka@web.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Dec 2010, Jan Kiszka wrote:
> From: Jan Kiszka <jan.kiszka@siemens.com>
>  	chip_bus_lock(desc);
>  	retval = __setup_irq(irq, desc, action);
>  	chip_bus_sync_unlock(desc);
>  
> -	if (retval)
> +	if (retval) {
> +		if (desc->action && !desc->action->next)
> +			desc->irq_data.drv_status &= ~IRQS_SHARED;

This is redundant. IRQS_SHARED gets set in a code path where all
checks are done already.

To make that more obvious we can set it right before

   raw_spin_unlock_irqrestore(&desc->lock, flags);

conditionally on (shared).

That way we can also move the kfree out of the mutex locked section.

Thanks,

	tglx
