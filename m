Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab2GRVaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 17:30:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754Ab2GRVaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 17:30:11 -0400
Date: Thu, 19 Jul 2012 00:30:43 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, avi@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH v5 1/4] kvm: Extend irqfd to support level interrupts
Message-ID: <20120718213043.GB11738@redhat.com>
References: <20120718120705.GB5184@redhat.com>
 <1342622843.2229.200.camel@bling.home>
 <20120718153822.GC1777@redhat.com>
 <1342626481.2229.205.camel@bling.home>
 <20120718155823.GG1777@redhat.com>
 <20120718184209.GA14053@amt.cnet>
 <1342638437.2229.213.camel@bling.home>
 <1342638786.2229.216.camel@bling.home>
 <1342643314.2229.217.camel@bling.home>
 <20120718212334.GA20327@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120718212334.GA20327@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 06:23:34PM -0300, Marcelo Tosatti wrote:
> On Wed, Jul 18, 2012 at 02:28:34PM -0600, Alex Williamson wrote:
> > > turn on lockdep to remember why I couldn't sleep there.
> > 
> > switching to a mutex results in:
> > 
> > BUG: sleeping function called from invalid context at kernel/mutex.c:269
> > in_atomic(): 1, irqs_disabled(): 0, pid: 30025, name: qemu-system-x86
> > INFO: lockdep is turned off.
> > Pid: 30025, comm: qemu-system-x86 Not tainted 3.5.0-rc4+ #109
> > Call Trace:
> >  [<ffffffff81088425>] __might_sleep+0xf5/0x130
> >  [<ffffffff81564c6f>] mutex_lock_nested+0x2f/0x60
> >  [<ffffffffa07db7d5>] eoifd_event+0x25/0x70 [kvm]
> >  [<ffffffffa07daea4>] kvm_notify_acked_irq+0xa4/0x140 [kvm]
> >  [<ffffffffa07dae2a>] ? kvm_notify_acked_irq+0x2a/0x140 [kvm]
> >  [<ffffffffa07d9bb4>] kvm_ioapic_update_eoi+0x84/0xf0 [kvm]
> >  [<ffffffffa0806c43>] apic_set_eoi+0x123/0x130 [kvm]
> >  [<ffffffffa0806fd8>] apic_reg_write+0x388/0x670 [kvm]
> >  [<ffffffffa07eb03c>] ? vcpu_enter_guest+0x32c/0x740 [kvm]
> >  [<ffffffffa0807481>] kvm_lapic_set_eoi+0x21/0x30 [kvm]
> >  [<ffffffffa04ba3f9>] handle_apic_access+0x69/0x80 [kvm_intel]
> >  [<ffffffffa04ba02a>] vmx_handle_exit+0xaa/0x260 [kvm_intel]
> 
> Its RCU from ack notifiers, OK. 

I'm testing a patch that moves all bitmap handling to under
pic/ioapic lock. After this we can teach kvm_set_irq to report
when a bit that is cleared/set is already clear/set, without
races.

And then no tracking will be necessary in irqfd - we can just
call kvm_set_irq(..., 0) and look at the return status.

-- 
MST
