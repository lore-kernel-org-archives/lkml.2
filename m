Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab2DEIrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 04:47:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:34099 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab2DEIrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 04:47:07 -0400
Date: Thu, 5 Apr 2012 10:47:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexander Gordeev <agordeev@redhat.com>
cc: Yevgeny Petrilin <yevgenyp@mellanox.com>, Jiang Liu <liuj97@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yael Shenhav <yaeli@mellanox.com>
Subject: Re: IRQ affinity enforced only after first interrupt.
In-Reply-To: <20120404100143.GH28177@dhcp-26-207.brq.redhat.com>
Message-ID: <alpine.LFD.2.02.1204051043360.2542@ionos>
References: <4F7031A4.70601@mellanox.co.il> <CAErSpo7ciBYG1-jCL3F6bFcktmJj4H-SXn_1NcRnhc-gPDsHUw@mail.gmail.com> <4F707E39.50502@gmail.com> <953B660C027164448AE903364AC447D2618E1A8B@MTLDAG02.mtl.com> <alpine.LFD.2.02.1203262059070.2542@ionos>
 <20120404100143.GH28177@dhcp-26-207.brq.redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2012, Alexander Gordeev wrote:

> On Mon, Mar 26, 2012 at 09:04:20PM +0200, Thomas Gleixner wrote:
> > On Mon, 26 Mar 2012, Yevgeny Petrilin wrote:
> > 
> > > > 
> > > > The architecture specific code will determine whether the IRQ could be migrated
> > > > in process context. For example, the IRQ_MOVE_PCNTXT flag will be set on x86
> > > > systems if interrupt remapping is enabled.
> > >
> > > Actually I am encountering this issue with x86, and see different
> > > behavior with different HW devices (NICs). On same machine I have
> > > one device that responds immediately to affinity changes while the
> > > other one changes the affinity only after first interrupt.
> > 
> > That simply depends on the underlying hardware. On certain hardware we
> > can change the affinity only in hard interrupt context, that means
> > right when a interrupt of that device is delivered.
> > 
> > On the other devices we can change it right away and the corresponding
> > interrupt chips set IRQ_MOVE_PCNTXT to indicate that.
> 
> Actually, even with IRQ_MOVE_PCNTXT capable chips, a hardware handler still
> might be called on a core that belongs to old affinity, after the successful
> write of new affinity. Threaded handlers are also racy with irq affinity
> updates.
> 
> If that is inconsistency, bug or design?

Well, irq affinity updates are not designed to be immediate. There is
no point in doing so.
 
> > There is nothing we can do about this. It's dictated by hardware.
> 
> May be we could wait for desc->pending_mask to be cleared before returning from
> irq_set_affinity()?

If that device does not issue an interrupt for a long time,
e.g. because the interface is down, then you are stuck there forever.

What's the point of this? One interrupt on the wrong core is nothing
we need to worry about.

Thanks,

	tglx
