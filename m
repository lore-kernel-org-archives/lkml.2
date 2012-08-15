Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab2HOO1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:27:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab2HOO07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:26:59 -0400
Date: Wed, 15 Aug 2012 17:28:03 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 0/6] kvm: level irqfd support
Message-ID: <20120815142803.GF3068@redhat.com>
References: <20120810223633.809.44188.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120810223633.809.44188.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 04:37:08PM -0600, Alex Williamson wrote:
> v8:
> 
> Trying a new approach.  Nobody seems to like the internal IRQ
> source ID object and the interactions it implies between irqfd
> and eoifd, so let's get rid of it.  Instead, simply expose
> IRQ source IDs to userspace.  This lets the user be in charge
> of freeing them or hanging onto a source ID for later use.

In the end it turns out source ID is an optimization for shared
interrupts, isn't it?  Can't we apply the optimization transparently to
the user?  E.g. if we have some spare source IDs, allocate them, if we
run out, use a shared source ID?

> They
> can also detach and re-attach components at will.  It also opens
> up the possibility that userspace might want to use each IRQ
> source ID for more than one GSI (and avoids the kernel needing
> to manage that).  Per suggestions, EOIFD is now IRQ_ACKFD.
> 
> I really wanted to add a de-assert-only option to irqfd so the
> irq_ackfd could be fed directly into an irqfd, but I'm dependent
> on the ordering of de-assert _then_ signal an eventfd.  Keeping
> that ordering doesn't seem to be possible, especially since irqfd
> uses a workqueue, if I attempt to make that connection.  Thanks,
> 
> Alex
> ---
> 
> Alex Williamson (6):
>       kvm: Add de-assert option to KVM_IRQ_ACKFD
>       kvm: KVM_IRQ_ACKFD
>       kvm: Add assert-only option to KVM_IRQFD
>       kvm: Add IRQ source ID option to KVM_IRQFD
>       kvm: Expose IRQ source IDs to userspace
>       kvm: Allow filtering of acked irqs
> 
> 
>  Documentation/virtual/kvm/api.txt |   53 ++++++
>  arch/x86/kvm/Kconfig              |    1 
>  arch/x86/kvm/i8254.c              |    1 
>  arch/x86/kvm/i8259.c              |    8 +
>  arch/x86/kvm/x86.c                |    8 +
>  include/linux/kvm.h               |   39 ++++-
>  include/linux/kvm_host.h          |   18 ++
>  virt/kvm/Kconfig                  |    3 
>  virt/kvm/assigned-dev.c           |    1 
>  virt/kvm/eventfd.c                |  315 +++++++++++++++++++++++++++++++++++++
>  virt/kvm/ioapic.c                 |    5 -
>  virt/kvm/irq_comm.c               |   28 +++
>  virt/kvm/kvm_main.c               |   26 +++
>  13 files changed, 496 insertions(+), 10 deletions(-)
