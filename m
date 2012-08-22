Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab2HVKKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 06:10:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063Ab2HVKJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 06:09:56 -0400
Date: Wed, 22 Aug 2012 13:10:59 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 0/2] kvm: level irqfd support
Message-ID: <20120822101059.GA11937@redhat.com>
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

Kid wouldn't let me sleep in the night so I've been thinking of better
names :).

I think a non abbreviated deassert_on_ack is a better name.
Yes e.g. irqfd is an abbreviation too, but it is
actually just a composition of irq and fd which are
both standard, familiar abbreviations.

If you have really set your heart on using an abbreviation,
it is better to not put two vowels together.
ADN (ack deasserts and notifies or auto deassert and notify)
is a bit better in that respect, though it does look a bit like
a miss-spelled AND which is unfortunate.

But obviously, it's all not terribly important.

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
> and de-asserting the GSI could lead to breakage.  Instead each OADN
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
> 
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
