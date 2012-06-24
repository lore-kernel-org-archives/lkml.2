Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab2FXIY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 04:24:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab2FXIYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 04:24:51 -0400
Date: Sun, 24 Jun 2012 11:24:51 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH 4/4][RFC] kvm: eoi_eventfd
Message-ID: <20120624082451.GA1712@redhat.com>
References: <20120622220040.9858.43665.stgit@bling.home>
 <20120622221626.9858.33817.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120622221626.9858.33817.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 04:16:53PM -0600, Alex Williamson wrote:
> I think we're probably also going to need something like this.
> When running in non-accelerated qemu, we're going to have to
> create some kind of EOI notifier for drivers.  VFIO can make
> additional improvements when running on KVM so it will probably
> make use of the KVM_IRQFD_LEVEL_EOI interface, but we don't
> want to have a generic EOI notifier in qemu that just stops
> working when kvm-ioapic is enabled.  This is just a simple way
> to register an eventfd using the existing KVM ack notifier.
> I tried combining the ack notifier of the LEVEL_EOI interface
> into this one, but it didn't work out well.  The code complexity
> goes up a lot.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
>  Documentation/virtual/kvm/api.txt |   14 ++++++
>  arch/x86/kvm/x86.c                |    1 
>  include/linux/kvm.h               |   12 +++++
>  include/linux/kvm_host.h          |    7 +++
>  virt/kvm/eventfd.c                |   89 +++++++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c               |    9 ++++
>  6 files changed, 132 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 2f8a0aa..69b1747 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -1998,6 +1998,20 @@ matched using kvm_irqfd.fd, kvm_irqfd.gsi, and kvm_irqfd.fd2.
>  De-assigning automatically de-asserts the interrupt line setup through
>  this interface.
>  
> +4.77 KVM_EOI_EVENTFD
> +
> +Capability: KVM_CAP_EOI_EVENTFD
> +Architectures: x86
> +Type: vm ioctl
> +Parameters: struct kvm_eoi_eventfd (in)
> +Returns: 0 on success, -1 on error
> +
> +This interface allows userspace to be notified through an eventfd for
> +EOI writes to the in-kernel irqchip.  kvm_eoi_eventfd.fd specifies
> +the eventfd to signal on EOI to kvm_eoi_eventfd.gsi.  To disable,
> +use KVM_EOI_EVENTFD_FLAG_DEASSIGN and specify both the original fd
> +and gsi.
> +
>  5. The kvm_run structure
>  ------------------------
>  

The patch looks like it only works for ioapic IRQs.  I think it's a good
idea to explicitly limit this to level interrupts, straight away:
there's no reason for userspace to need an exit on an edge interrupt.

I also suggest we put LEVEL somewhere in the name.

With this eventfd, do we also need the fd2 parameter in the irqfd
structure? It seems to be used for the same thing ...

-- 
MST
