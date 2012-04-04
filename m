Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab2DDKCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 06:02:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab2DDKCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 06:02:07 -0400
Date: Wed, 4 Apr 2012 12:01:45 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Yevgeny Petrilin <yevgenyp@mellanox.com>, Jiang Liu <liuj97@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yael Shenhav <yaeli@mellanox.com>
Subject: Re: IRQ affinity enforced only after first interrupt.
Message-ID: <20120404100143.GH28177@dhcp-26-207.brq.redhat.com>
References: <4F7031A4.70601@mellanox.co.il>
 <CAErSpo7ciBYG1-jCL3F6bFcktmJj4H-SXn_1NcRnhc-gPDsHUw@mail.gmail.com>
 <4F707E39.50502@gmail.com>
 <953B660C027164448AE903364AC447D2618E1A8B@MTLDAG02.mtl.com>
 <alpine.LFD.2.02.1203262059070.2542@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1203262059070.2542@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 09:04:20PM +0200, Thomas Gleixner wrote:
> On Mon, 26 Mar 2012, Yevgeny Petrilin wrote:
> 
> > > 
> > > The architecture specific code will determine whether the IRQ could be migrated
> > > in process context. For example, the IRQ_MOVE_PCNTXT flag will be set on x86
> > > systems if interrupt remapping is enabled.
> >
> > Actually I am encountering this issue with x86, and see different
> > behavior with different HW devices (NICs). On same machine I have
> > one device that responds immediately to affinity changes while the
> > other one changes the affinity only after first interrupt.
> 
> That simply depends on the underlying hardware. On certain hardware we
> can change the affinity only in hard interrupt context, that means
> right when a interrupt of that device is delivered.
> 
> On the other devices we can change it right away and the corresponding
> interrupt chips set IRQ_MOVE_PCNTXT to indicate that.

Actually, even with IRQ_MOVE_PCNTXT capable chips, a hardware handler still
might be called on a core that belongs to old affinity, after the successful
write of new affinity. Threaded handlers are also racy with irq affinity
updates.

If that is inconsistency, bug or design?

> There is nothing we can do about this. It's dictated by hardware.

May be we could wait for desc->pending_mask to be cleared before returning from
irq_set_affinity()?

> Thanks,
> 
> 	tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
