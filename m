Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab2GOQpI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 12:45:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab2GOQpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 12:45:01 -0400
Date: Sun, 15 Jul 2012 19:45:17 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH v4 0/3] kvm: level irqfd and new eoifd
Message-ID: <20120715164517.GC17995@redhat.com>
References: <20120713192625.5474.60777.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120713192625.5474.60777.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 01:40:48PM -0600, Alex Williamson wrote:
> v4:
>  - KVM_IRQFD_FLAG_LEVEL flag now documented and coded to only be
>    necessary on assign.
>  - Lock added to struct _irq_source to maintain the source ID assertion
>    state to avoid repeat assertions or spurious EOIs.  I couldn't figure
>    out a way to make this work w/o races using atomics and don't see any
>    way to make use of kvm_irq_line_state.

Well not kvm_irq_line_state specifically but what's the problem
with looking at irq_state in the correct pic? That is already
done atomically. We'll need new APIs for this of course.
See specific patch for suggestion.

>  - GSI support in KVM_EOIFD is dropped since it's not immediately used
>    and I don't seem to be able to explain why it's useful.  It makes it
>    optional though, which may be a good thing if other archs try to use
>    this interface.
>  - eoifd switch to mutex from spinlock (all tested as lockdep safe)
>  - _irqfd_fdget_lock/_irqfd_put_unlock replaces _irqfd_fdget/_irqfd_put
>    so we hold the lock for the irqfds ensuring the one we're binding to
>    doesn't go away while we get a reference to the _irq_source.
>  - We also pull the GSI off the irqfd rather than specifying it for eoifd.
>  - eoifd_deactivate renamed to eoifd_destroy to make it blindingly
>    obvious what it does.

Overall looks ok to me.
Looks like as written userspace can create any # of eoifds
with same irqfd leading to unlimited kernel memory use.
See specific patch for suggestion on how to fix.

> Patch 3/3 is not for commit and not meant to be ready for commit, it's
> just an FYI on what adding back support for a GSI based, non-de-asserting
> eoifd will look like.  Thanks,
> 
> Alex
> 
> ---
> 
> Alex Williamson (3):
>       kvm: Add a GSI specification for KVM_EOIFD
>       kvm: KVM_EOIFD, an eventfd for EOIs
>       kvm: Extend irqfd to support level interrupts
> 
> 
>  Documentation/virtual/kvm/api.txt |   27 +++
>  arch/x86/kvm/x86.c                |    3 
>  include/linux/kvm.h               |   24 +++
>  include/linux/kvm_host.h          |   13 +
>  virt/kvm/eventfd.c                |  349 +++++++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c               |   11 +
>  6 files changed, 423 insertions(+), 4 deletions(-)
