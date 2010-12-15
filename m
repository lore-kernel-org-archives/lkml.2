Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab0LOIFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 03:05:25 -0500
Received: from www.tglx.de ([62.245.132.106]:36535 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab0LOIFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 03:05:24 -0500
Date: Wed, 15 Dec 2010 09:05:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kiszka <jan.kiszka@web.de>
cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v3 2/4] genirq: Inform handler about line sharing state
In-Reply-To: <4D07F738.8080204@web.de>
Message-ID: <alpine.LFD.2.00.1012150903560.12146@localhost6.localdomain6>
References: <cover.1292281184.git.jan.kiszka@web.de> <a59c76552ebeaa128022ba9bcc7ea0753b312447.1292281184.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012142243540.12146@localhost6.localdomain6> <4D07F738.8080204@web.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010, Jan Kiszka wrote:

> Am 14.12.2010 22:46, Thomas Gleixner wrote:
> > On Mon, 13 Dec 2010, Jan Kiszka wrote:
> >> From: Jan Kiszka <jan.kiszka@siemens.com>
> >>  	chip_bus_lock(desc);
> >>  	retval = __setup_irq(irq, desc, action);
> >>  	chip_bus_sync_unlock(desc);
> >>  
> >> -	if (retval)
> >> +	if (retval) {
> >> +		if (desc->action && !desc->action->next)
> >> +			desc->irq_data.drv_status &= ~IRQS_SHARED;
> > 
> > This is redundant. IRQS_SHARED gets set in a code path where all
> > checks are done already.
> 
> Nope, it's also set before entry of __setup_irq in case we call an
> IRQF_ADAPTIVE handler.
> 
> We need to set it that early as we may race with IRQ events for the
> already registered handler happening between the sharing notification
> and the actual registration of the second handler.

Hmm, ok. Though the MAKE_SHAREABLE flag should be sufficient to do the
notification.

Thanks,

	tglx
