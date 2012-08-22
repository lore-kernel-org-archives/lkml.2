Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab2HVAa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 20:30:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab2HVAa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 20:30:26 -0400
Date: Wed, 22 Aug 2012 03:31:29 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 0/2] kvm: level irqfd support
Message-ID: <20120822003129.GK9027@redhat.com>
References: <20120821190800.24958.74812.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821190800.24958.74812.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 01:28:57PM -0600, Alex Williamson wrote:
> Here's the much anticipated re-write of support for level irqfds.  As
> Michael suggested, I've rolled the eoi/ack notification fd into
> KVM_IRQFD as a new mode.  For lack of a better name, as there seems to
> be objections to associating this specifically with an EOI or an ACK,
> I've name this OADN or "On Ack, De-assert & Notify".
> 
> Patch 1of2 switches current KVM_IRQFDs to use their own IRQ source ID
> since we're potentially stepping on KVM_USERSPACE_IRQ_SOURCE_ID.
> Unfurtunately I was not able to make 2of2 use a single IRQ source ID,
> the reason is it's racy.  Objects to track OADNs are made dynamically,
> we look through existing ones for a match under spinlock and setup a
> new one if there's no match.  On teardown, we can remove the OADN from
> the list under lock, but that same lock prevents us from de-assigning
> the IRQ ACK notifier or waiting for an RCU grace period.  We must make
> sure that any unused GSI is de-asserted, but the above means it's
> possible that another OADN has been created for this source ID/GSI
> and de-asserting the GSI could lead to breakage.

I do not see it. What breakage? Could you give an example please?


I think what you are saying is last deassign must clear
since otherwise we never will clear.
I agree it is either that or delay deassign until ack.

Can it be as simple as this (after all rcu etc dances)?
	lock irqfds
	if no oadns
		set level to 0
	unlock irqfds
?



>  Instead each OADN
> object gets it's own source ID, but these are all shared by users
> of the same GSI.  So for PCI devices, we might have up to 4 IRQ
> source IDs allocated.
> 
> Michael had also suggested avoiding reference counting and using
> list_empty for this OADN object.  Unfortunately, that doesn't work
> for similar reasons.  We want to release the OADN object underlock,
> preventing others from re-using it on the free path, but in order
> to have lock-less de-assert & notify we use RCU, meaning we can't
> trust list_empty until after an RCU grace period, which must be
> done outside of spinlocks.

confused. list empty on assign/deassing would be under lock
so no need for grace periods to trust it.
what am I missing?

But if you like kref more that is OK too.

> If there are suggestions how we can handle these better, please
> make them, but I think this compromise is race-free and still
> manages to make allocation of IRQ source IDs mostly a non-issue
> for device assignment limits.  Thanks,
> 
> Alex
> 
> ---
> 
> Alex Williamson (2):
>       kvm: On Ack, De-assert & Notify KVM_IRQFD extension
>       kvm: Use a reserved IRQ source ID for irqfd
> 
> 
>  Documentation/virtual/kvm/api.txt |   13 ++
>  arch/x86/kvm/x86.c                |    4 +
>  include/linux/kvm.h               |    7 +
>  include/linux/kvm_host.h          |    2 
>  virt/kvm/eventfd.c                |  199 ++++++++++++++++++++++++++++++++++++-
>  5 files changed, 218 insertions(+), 7 deletions(-)
