Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab0LQKXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 05:23:49 -0500
Received: from www.tglx.de ([62.245.132.106]:50938 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495Ab0LQKXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 05:23:47 -0500
Date: Fri, 17 Dec 2010 11:23:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kiszka <jan.kiszka@web.de>
cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v3 2/4] genirq: Inform handler about line sharing state
In-Reply-To: <4D0B1CD9.5060601@web.de>
Message-ID: <alpine.LFD.2.00.1012171116480.12146@localhost6.localdomain6>
References: <cover.1292281184.git.jan.kiszka@web.de> <a59c76552ebeaa128022ba9bcc7ea0753b312447.1292281184.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012161410440.12146@localhost6.localdomain6> <4D0A75E3.3090900@web.de> <4D0B1CD9.5060601@web.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010, Jan Kiszka wrote:
> Am 16.12.2010 21:26, Jan Kiszka wrote:
> > Am 16.12.2010 14:13, Thomas Gleixner wrote:
> >> On Mon, 13 Dec 2010, Jan Kiszka wrote:
> >>> +	if (old_action && (old_action->flags & IRQF_ADAPTIVE) &&
> >>> +	    !(desc->irq_data.drv_status & IRQS_SHARED)) {
> >>> +		/*
> >>> +		 * Signal the old handler that is has to switch to shareable
> >>> +		 * handling mode. Disable the line to avoid any conflict with
> >>> +		 * a real IRQ.
> >>> +		 */
> >>> +		disable_irq(irq);
> >>
> >> This is weird, really. I thought you wanted to avoid waiting for the
> >> threaded handler to finish if it's on the fly. So this should be
> >> disable_irq_nosync() or did you change your mind ?
> > 
> > No, I did not. I wanted to avoid that we set MAKE_SHAREABLE while there
> > might be another IRQ in flight. The handler that is called due to a real
> > IRQ might misinterpret MAKE_SHAREABLE as "there is no real event" and
> > perform the wrong steps (at least the current implementation for KVM would).
> 
> Actually, the requirement we have to fulfill here is to avoid that the
> hardirq handler sees !SHARED while the threaded one reads "SHARED". To
> achieve this without disabling the line, I'm still searching for a way
> to couple the sharing state of associated hard and threaded handler runs
> - but I think there is no reliable association, is there?

Unfortunately not. So the only way to solve that is disabling the
interrupt which makes sure that all handlers have completed.

OTOH, if we have to disable anyway, then we could simply keep it
disabled across the installation of a new handler. That would make the
notification business go away, wouldn't it ?

Thanks,

	tglx


