Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab2GRU2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 16:28:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab2GRU2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 16:28:37 -0400
Message-ID: <1342643314.2229.217.camel@bling.home>
Subject: Re: [PATCH v5 1/4] kvm: Extend irqfd to support level interrupts
From: Alex Williamson <alex.williamson@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Date: Wed, 18 Jul 2012 14:28:34 -0600
In-Reply-To: <1342638786.2229.216.camel@bling.home>
References: <20120718105311.GH4700@redhat.com>
	 <20120718105530.GG26120@redhat.com> <20120718112219.GJ4700@redhat.com>
	 <20120718113910.GA5135@redhat.com> <20120718114844.GH26120@redhat.com>
	 <20120718120705.GB5184@redhat.com> <1342622843.2229.200.camel@bling.home>
	 <20120718153822.GC1777@redhat.com> <1342626481.2229.205.camel@bling.home>
	 <20120718155823.GG1777@redhat.com> <20120718184209.GA14053@amt.cnet>
	 <1342638437.2229.213.camel@bling.home>
	 <1342638786.2229.216.camel@bling.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-18 at 13:13 -0600, Alex Williamson wrote:
> On Wed, 2012-07-18 at 13:07 -0600, Alex Williamson wrote:
> > On Wed, 2012-07-18 at 15:42 -0300, Marcelo Tosatti wrote:
> > > On Wed, Jul 18, 2012 at 06:58:24PM +0300, Michael S. Tsirkin wrote:
> > > > > > > > > Back to original point though current
> > > > > > > > > situation is that calling kvm_set_irq() under spinlock is not worse for
> > > > > > > > > scalability than calling it not under one.
> > > > > > > > 
> > > > > > > > Yes. Still the specific use can just use an atomic flag,
> > > > > > > > lock+bool is not needed, and we won't need to undo it later.
> > > > > > > 
> > > > > > > 
> > > > > > > Actually, no, replacing it with an atomic is racy.
> > > > > > > 
> > > > > > > CPU0 (inject)                       CPU1 (EOI)
> > > > > > > atomic_cmpxchg(&asserted, 0, 1)
> > > > > > >                                     atomic_cmpxchg(&asserted, 1, 0)
> > > > > > >                                     kvm_set_irq(0)
> > > > > > > kvm_set_irq(1)
> > > > > > >                                     eventfd_signal
> > > > > > > 
> > > > > > > The interrupt is now stuck on until another interrupt is injected.
> > > > > > > 
> > > > > > 
> > > > > > Well EOI somehow happened here before interrupt so it's a bug somewhere
> > > > > > else?
> > > > > 
> > > > > Interrupts can be shared.  We also can't guarantee that the guest won't
> > > > > write a bogus EOI to the ioapic.  The irq ack notifier doesn't filter on
> > > > > irq source id... I'm not sure it can.
> > > > 
> > > > I guess if Avi OKs adding another kvm_set_irq under spinlock that's
> > > > the best we can do for now.
> > > 
> > > Why can't a mutex be used instead of a spinlock again?
> > 
> > eventfd_signal calls the inject function from atomic context.
> 
> Actually, that's called from a workq.  I'll have to switch it back and
> turn on lockdep to remember why I couldn't sleep there.

switching to a mutex results in:

BUG: sleeping function called from invalid context at kernel/mutex.c:269
in_atomic(): 1, irqs_disabled(): 0, pid: 30025, name: qemu-system-x86
INFO: lockdep is turned off.
Pid: 30025, comm: qemu-system-x86 Not tainted 3.5.0-rc4+ #109
Call Trace:
 [<ffffffff81088425>] __might_sleep+0xf5/0x130
 [<ffffffff81564c6f>] mutex_lock_nested+0x2f/0x60
 [<ffffffffa07db7d5>] eoifd_event+0x25/0x70 [kvm]
 [<ffffffffa07daea4>] kvm_notify_acked_irq+0xa4/0x140 [kvm]
 [<ffffffffa07dae2a>] ? kvm_notify_acked_irq+0x2a/0x140 [kvm]
 [<ffffffffa07d9bb4>] kvm_ioapic_update_eoi+0x84/0xf0 [kvm]
 [<ffffffffa0806c43>] apic_set_eoi+0x123/0x130 [kvm]
 [<ffffffffa0806fd8>] apic_reg_write+0x388/0x670 [kvm]
 [<ffffffffa07eb03c>] ? vcpu_enter_guest+0x32c/0x740 [kvm]
 [<ffffffffa0807481>] kvm_lapic_set_eoi+0x21/0x30 [kvm]
 [<ffffffffa04ba3f9>] handle_apic_access+0x69/0x80 [kvm_intel]
 [<ffffffffa04ba02a>] vmx_handle_exit+0xaa/0x260 [kvm_intel]


